# Otrobonita Engineering Playbook

An installable starting point for safer AI-assisted engineering. It adds editable governance, guardrails, agent instructions, specification templates, session handover, and stack-appropriate dependency auditing to an existing project. Evaluation, deterministic verification, concurrent-agent guidance, infrastructure context, NemoClaw isolation guidance, and a local MCP server are optional modules.

This repository does not make an AI system safe by itself. It provides an executable starting point that each team must adapt to its architecture, risks, commands, owners, and release process.

Current release: [v1.0.0](https://github.com/otrobonita-studios/playbook/releases/tag/v1.0.0). That GitHub Release is a **source tag**. There are no attached installer archives; run `setup.sh` or `setup.ps1` from the tagged tree. The 1.0.0 bootstrap smokes were recorded against `@modelcontextprotocol/sdk` 1.30.0 and `zod` 4.4.3.

## Who this Playbook is for

This Playbook is designed for individuals, small teams, and AI-native product teams that want a fast, practical way to introduce specification, deterministic verification, and essential security controls into a software repository.

It is not an enterprise development framework, compliance program, or organization-wide rollout specification. Enterprises typically have established engineering standards, security programs, approval structures, and platform tooling that this Playbook should complement rather than replace.

Our goal is not to prescribe how enterprises must operate. It is to provide a lightweight, adaptable starting point for teams that would otherwise begin without durable specifications, agent instructions, verification gates, or security boundaries. The baseline should be fast to adopt, inexpensive to operate, and useful before a team has dedicated platform, security, or verification-engineering functions.

## What gets installed

Core installation:

| Artifact | Purpose |
|---|---|
| `CONSTITUTION.md` | Editable project principles, boundaries, evidence, and accountability |
| `AGENTS.md` | Agent workflow plus project-specific operating instructions |
| `CLAUDE.md` | Claude-specific repository guidance |
| `CONTINUE.md` | Temporary handover between sessions or context windows |
| `governance/` | Guardrails, tool policy, approval matrix, and skills security policy |
| `specs/template/` | Feature specification, technical plan, and task templates |
| `.engineering-playbook/install.env` | Installed version, selected stack, and modules |

For `web` and `node` stacks, a read-only monthly `npm audit` workflow is also installed. It reports evidence; it never applies fixes or pushes changes automatically.

Optional modules:

| Module | Installed artifact | Purpose |
|---|---|---|
| `evals` | `evals/template/evaluation.md` | Defines risks, cases, deterministic checks, LLM-judge calibration, thresholds, and release evidence |
| `verification` | `VERIFICATION.md`, `governance/CONCURRENT-AGENTS.md` | Defines layered evidence, risk-based checks, isolated parallel work, and integration verification |
| `infrastructure` | `INFRASTRUCTURE.md` | Maps environments, services, secrets, deployment, ownership, and rollback |
| `nemoclaw` | `NEMOCLAW.md` | Defines an isolation contract and verification checklist; it does not create a sandbox |
| `mcp` | `.engineering-playbook/mcp-server/` | Installs a local MCP server exposing selected playbook artifacts |

## Prerequisites

- An extracted ZIP or Git clone of this repository.
- An existing target directory. It must be a Git repository unless the explicit non-Git override is used.
- Bash on macOS, Linux, or WSL; or PowerShell 7+ on Windows.
- Node.js and npm only when selecting the `mcp` module.

## Install with Bash

```bash
./setup.sh /absolute/path/to/project --stack generic

./setup.sh /absolute/path/to/project \
  --stack web \
  --include evals,verification,infrastructure,nemoclaw,mcp
```

## Install with PowerShell

```powershell
./setup.ps1 -TargetDir 'E:\development\my-project' -Stack generic

./setup.ps1 `
  -TargetDir 'E:\development\my-project' `
  -Stack web `
  -Include evals,verification,infrastructure,nemoclaw,mcp
```

If script execution is disabled for the current PowerShell process:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

## Existing files are protected

The installer checks every destination before copying. If any destination exists, installation stops and lists all conflicts; nothing is partially replaced.

After review, `--force` or `-Force` creates a timestamped backup under `.engineering-playbook-backup/` and replaces only installer-managed files. The installer never stages, commits, or pushes the target repository.

## Verification and adoption

Both installers verify that every selected artifact exists and is non-empty. MCP installation must also complete its dependency installation. Then:

1. Inspect every added file with `git status --short`.
2. Confirm stack and modules in `.engineering-playbook/install.env`.
3. Replace the project-specific placeholders in `AGENTS.md`.
4. Adapt the constitution, governance policies, specs, evals, and optional context documents.
5. If verification is selected, define fast, full, security, and release commands plus the evidence required for the project's real risks.
6. If agents work concurrently, partition ownership across branches or worktrees and define integration verification before parallel work begins.
7. Confirm that tool permissions and approval boundaries match the real environment.
8. For MCP, follow `.engineering-playbook/mcp-server/README.md` and call `get_constitution` from the client.
9. Run the target project's formatter, linter, type checker, tests, build, security checks, and release verification.

Installation is complete when the files are present. Adoption is complete only when they truthfully describe the project and its checks pass.

## Command reference

```text
./setup.sh TARGET [--stack generic|web|node]
                  [--include evals,verification,infrastructure,nemoclaw,mcp]
                  [--force]
                  [--allow-non-git]

./setup.ps1 -TargetDir PATH
            [-Stack generic|web|node]
            [-Include evals,verification,infrastructure,nemoclaw,mcp]
            [-Force]
            [-AllowNonGit]
```

The non-Git override is intended for controlled generation and testing. A real project should initialize Git first so every installed change can be reviewed.

## Concurrent agents in one repository

Multiple agents may work in the same repository, but they should not write concurrently to the same working tree. Give each independent task a branch or worktree, bounded file ownership, settled dependencies, exact checks, and an integration owner.

Worker claims are not evidence. The orchestrator or reviewer executes the declared checks, inspects the diff, and preserves failures and retry context. After accepted contributions are combined, run the complete relevant verification suite again against the integrated candidate. A task that passes alone can still fail in combination.

The optional verification module documents a harness-neutral pattern. [Ringer](https://github.com/NateBJones-Projects/ringer) is one example of isolated workers, manifest-defined tasks, executable checks, and attempt logs; it is not a required dependency.

## Repository structure

```text
playbook/
├── AGENTS.md
├── CONSTITUTION.md
├── setup.sh
├── setup.ps1
├── docs/                 # Optional GitHub Pages site; safe to delete
├── mcp-server/
└── templates/
    ├── ai-instructions/
    ├── github-workflows/
    ├── governance/
    ├── optional/
    └── sdd/
```

`docs/` is not used by the installers. It exists only to publish [playbook.otrobonita.com](https://playbook.otrobonita.com/) through GitHub Pages. In a derived project, the directory can be safely deleted, retained as-is, or redesigned as the project's own documentation or landing page without affecting the installable playbook.

## Skills are executable dependencies

A `SKILL.md` can influence an agent and may reference scripts, tools, networks, or additional instructions. Treat a skill like a code dependency: inspect the full package, verify its provenance and permissions, pin an accepted revision, test it with restricted access, and review updates before adoption. The installed `governance/SKILLS-POLICY.md` turns that approach into a project checklist and links to recognized starting sources.

## Common foundation

Our Engineering Playbook synthesizes public guidance from [OpenAI Codex](https://openai.com/index/introducing-codex/), [Anthropic Engineering](https://www.anthropic.com/engineering/claude-code-best-practices), [GitHub Copilot custom instructions](https://docs.github.com/en/copilot/tutorials/customize-code-review), [Google Engineering Practices](https://google.github.io/eng-practices/review/developer/small-cls.html), the [NIST Secure Software Development Framework](https://csrc.nist.gov/projects/ssdf), and [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html).

SpaceX does not publish a comparable public agent handbook. We use the production-representative verification principle documented in the [SpaceX Falcon User's Guide](https://www.spacex.com/media/falcon-users-guide-2025-05-09.pdf): test in conditions resembling operation, retain evidence, and document meaningful deviations.

This is our maintained foundation, not a universal law. Technology and project risks change; installed material must change with them.
