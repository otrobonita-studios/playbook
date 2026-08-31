#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_BASE="$REPO_DIR/.bootstrap-test"
mkdir -p "$TEST_BASE"
TEST_DIR="$(mktemp -d "$TEST_BASE/bash.XXXXXX")"
cleanup() {
  case "$TEST_DIR" in "$TEST_BASE"/bash.*) rm -rf -- "$TEST_DIR" ;; esac
}
trap cleanup EXIT

git -C "$TEST_DIR" init -q
test -x "$REPO_DIR/setup.sh"
"$REPO_DIR/setup.sh" "$TEST_DIR" --stack web --include evals,verification,infrastructure,nemoclaw,mcp

test -s "$TEST_DIR/AGENTS.md"
test -s "$TEST_DIR/evals/template/evaluation.md"
test -s "$TEST_DIR/VERIFICATION.md"
test -s "$TEST_DIR/governance/CONCURRENT-AGENTS.md"
test -s "$TEST_DIR/INFRASTRUCTURE.md"
test -s "$TEST_DIR/NEMOCLAW.md"
test -s "$TEST_DIR/.engineering-playbook/mcp-server/node_modules/@modelcontextprotocol/sdk/package.json"
test -s "$TEST_DIR/.github/workflows/dependency-audit.yml"
if command -v node >/dev/null 2>&1; then
  node "$REPO_DIR/tests/mcp-smoke.mjs" "$TEST_DIR/.engineering-playbook/mcp-server/index.js" "$TEST_DIR"
else
  node.exe "$(wslpath -w "$REPO_DIR/tests/mcp-smoke.mjs")" "$(wslpath -w "$TEST_DIR/.engineering-playbook/mcp-server/index.js")" "$(wslpath -w "$TEST_DIR")"
fi

if "$REPO_DIR/setup.sh" "$TEST_DIR" --stack web >"$TEST_DIR/conflict.log" 2>&1; then
  echo "Expected the second installation to stop on conflicts." >&2
  exit 1
fi
grep -q "Installation stopped" "$TEST_DIR/conflict.log"

printf 'original marker\n' > "$TEST_DIR/AGENTS.md"
"$REPO_DIR/setup.sh" "$TEST_DIR" --stack web --include evals,verification,infrastructure,nemoclaw,mcp --force
backup_file="$(find "$TEST_DIR/.engineering-playbook-backup" -path '*/AGENTS.md' -type f | head -n 1)"
grep -q "original marker" "$backup_file"

echo "Bash bootstrap smoke test passed."
