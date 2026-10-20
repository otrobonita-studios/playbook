# Changelog

## 1.1.0 — 2026-10-20

- Removed the `CLAUDE.md` template. `AGENTS.md` is now the single, tool-agnostic instruction file; its useful guidance (explicit assumptions, spec-first task tracking, style matching, orphan cleanup) moved into `AGENTS.md`.

## 1.0.0 — 2026-08-29

- Added equivalent Bash and PowerShell installers.
- Added preflight conflict detection and timestamped backups for forced replacement.
- Added selectable evaluation, infrastructure, NemoClaw, and MCP modules.
- Added an installation state record and post-copy verification.
- Made the MCP server self-contained and verified it against installed project artifacts.
- Replaced automatic dependency mutation with a read-only dependency audit workflow.
- Added Linux and Windows bootstrap smoke tests.
- Added a complete installation and adoption guide.
