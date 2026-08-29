#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR=""
STACK="generic"
INCLUDE=""
FORCE=0
ALLOW_NON_GIT=0

usage() {
  cat <<'EOF'
Usage: ./setup.sh TARGET [options]

Options:
  --stack NAME                 Record the project stack (default: generic).
  --include LIST               Optional modules: evals,infrastructure,nemoclaw,mcp.
  --force                      Back up conflicting files, then replace them.
  --allow-non-git              Permit installation outside a Git repository.
  --help                       Show this help.

Example:
  ./setup.sh ../my-project --stack web --include evals,infrastructure,mcp
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stack) STACK="${2:?--stack requires a value}"; shift 2 ;;
    --include) INCLUDE="${2:?--include requires a value}"; shift 2 ;;
    --force) FORCE=1; shift ;;
    --allow-non-git) ALLOW_NON_GIT=1; shift ;;
    --help|-h) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    *) if [[ -n "$TARGET_DIR" ]]; then echo "Only one TARGET may be supplied." >&2; exit 2; fi; TARGET_DIR="$1"; shift ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then usage >&2; exit 2; fi
case "$STACK" in generic|web|node) ;; *) echo "Unsupported stack: $STACK (use generic, web, or node)" >&2; exit 2 ;; esac
if [[ ! -d "$TARGET_DIR" ]]; then echo "Target directory does not exist: $TARGET_DIR" >&2; exit 1; fi
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
if [[ $ALLOW_NON_GIT -eq 0 && ! -d "$TARGET_DIR/.git" ]]; then
  echo "Target is not a Git repository. Initialize Git first or pass --allow-non-git." >&2
  exit 1
fi

declare -a MODULES=()
if [[ -n "$INCLUDE" ]]; then IFS=',' read -r -a MODULES <<< "$INCLUDE"; fi
has_module() { local wanted="$1"; local item; for item in "${MODULES[@]}"; do [[ "$item" == "$wanted" ]] && return 0; done; return 1; }
for module in "${MODULES[@]}"; do
  case "$module" in evals|infrastructure|nemoclaw|mcp|'') ;; *) echo "Unknown module: $module" >&2; exit 2 ;; esac
done

declare -a SOURCES=(
  "templates/ai-instructions/AGENTS.md" "templates/ai-instructions/CLAUDE.md"
  "templates/ai-instructions/CONTINUE.md" "CONSTITUTION.md"
  "templates/governance/GUARDRAILS.md" "templates/governance/TOOL-POLICY.md"
  "templates/governance/APPROVAL-MATRIX.md" "templates/governance/SKILLS-POLICY.md"
  "templates/sdd/1-spec-template.md" "templates/sdd/2-tech-plan-template.md"
  "templates/sdd/3-tasks-template.md"
)
declare -a DESTINATIONS=(
  "AGENTS.md" "CLAUDE.md" "CONTINUE.md" "CONSTITUTION.md"
  "governance/GUARDRAILS.md" "governance/TOOL-POLICY.md"
  "governance/APPROVAL-MATRIX.md" "governance/SKILLS-POLICY.md"
  "specs/template/1-spec.md" "specs/template/2-technical-plan.md" "specs/template/3-tasks.md"
)

if [[ "$STACK" == "web" || "$STACK" == "node" ]]; then SOURCES+=("templates/github-workflows/dependency-audit.yml"); DESTINATIONS+=(".github/workflows/dependency-audit.yml"); fi

if has_module evals; then SOURCES+=("templates/sdd/4-evaluation-plan.md"); DESTINATIONS+=("evals/template/evaluation.md"); fi
if has_module infrastructure; then SOURCES+=("templates/optional/INFRASTRUCTURE.md"); DESTINATIONS+=("INFRASTRUCTURE.md"); fi
if has_module nemoclaw; then SOURCES+=("templates/optional/NEMOCLAW.md"); DESTINATIONS+=("NEMOCLAW.md"); fi
if has_module mcp; then
  SOURCES+=("mcp-server/index.js" "mcp-server/package.json" "mcp-server/README.md")
  DESTINATIONS+=(".engineering-playbook/mcp-server/index.js" ".engineering-playbook/mcp-server/package.json" ".engineering-playbook/mcp-server/README.md")
fi

declare -a CONFLICTS=()
for destination in "${DESTINATIONS[@]}"; do [[ -e "$TARGET_DIR/$destination" ]] && CONFLICTS+=("$destination"); done
if [[ ${#CONFLICTS[@]} -gt 0 && $FORCE -eq 0 ]]; then
  echo "Installation stopped: these files already exist:" >&2
  printf '  - %s\n' "${CONFLICTS[@]}" >&2
  echo "Review them first. Re-run with --force to create a timestamped backup and replace them." >&2
  exit 1
fi

BACKUP_DIR=""
if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  BACKUP_DIR="$TARGET_DIR/.engineering-playbook-backup/$(date -u +%Y%m%dT%H%M%SZ)"
  for destination in "${CONFLICTS[@]}"; do
    mkdir -p "$BACKUP_DIR/$(dirname "$destination")"
    cp -R "$TARGET_DIR/$destination" "$BACKUP_DIR/$destination"
  done
  echo "Backed up existing files to $BACKUP_DIR"
fi

for index in "${!SOURCES[@]}"; do
  source_path="$SCRIPT_DIR/${SOURCES[$index]}"
  destination_path="$TARGET_DIR/${DESTINATIONS[$index]}"
  [[ -f "$source_path" ]] || { echo "Missing source artifact: $source_path" >&2; exit 1; }
  mkdir -p "$(dirname "$destination_path")"
  cp "$source_path" "$destination_path"
done

mkdir -p "$TARGET_DIR/.engineering-playbook"
cat > "$TARGET_DIR/.engineering-playbook/install.env" <<EOF
PLAYBOOK_VERSION=1.0.0
STACK=$STACK
MODULES=${INCLUDE:-core}
EOF

if has_module mcp; then
  if ! command -v npm >/dev/null 2>&1; then echo "MCP selected, but npm is not available." >&2; exit 1; fi
  if command -v node >/dev/null 2>&1; then NODE_COMMAND="node"; elif command -v node.exe >/dev/null 2>&1; then NODE_COMMAND="node.exe"; else echo "MCP selected, but Node.js is not available." >&2; exit 1; fi
  npm_prefix="$TARGET_DIR/.engineering-playbook/mcp-server"
  npm_command="$(command -v npm)"
  if [[ "$npm_command" == /mnt/* && -n "$(command -v wslpath 2>/dev/null || true)" ]]; then
    npm_prefix="$(wslpath -w "$npm_prefix")"
  fi
  npm install --omit=dev --ignore-scripts --prefix "$npm_prefix"
fi

missing=0
for destination in "${DESTINATIONS[@]}"; do
  if [[ ! -s "$TARGET_DIR/$destination" ]]; then echo "Verification failed: $destination is missing or empty." >&2; missing=1; fi
done
[[ -s "$TARGET_DIR/.engineering-playbook/install.env" ]] || missing=1
[[ $missing -eq 0 ]] || exit 1

echo ""
echo "Engineering Playbook 1.0.0 installed and verified."
echo "Target: $TARGET_DIR"
echo "Stack: $STACK"
echo "Modules: ${INCLUDE:-core}"
echo "Installed files: ${#DESTINATIONS[@]}"
[[ -n "$BACKUP_DIR" ]] && echo "Backup: $BACKUP_DIR"
echo "Next: customize the Project-specific additions section in AGENTS.md."
