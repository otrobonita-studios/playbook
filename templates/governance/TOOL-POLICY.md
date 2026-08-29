# Agent Tool Policy

> Define capabilities by consequence, not by tool name alone. A read tool with network access may be more consequential than a narrowly bounded write tool.

## Tool inventory

| Tool/capability | Purpose | Allowed inputs | Forbidden inputs | Side effects | Approval | Logging |
|---|---|---|---|---|---|---|
| [Tool] | [Purpose] | [Schema/scope] | [Secrets/paths/actions] | [Effects] | [Rule] | [Evidence] |

## Required decisions

- [ ] Default to no capability until a task requires it.
- [ ] Restrict filesystem access to named project paths.
- [ ] Restrict network access to named destinations and methods.
- [ ] Keep production credentials unavailable to ordinary development tasks.
- [ ] Validate tool arguments outside the model.
- [ ] Require approval for actions identified in `APPROVAL-MATRIX.md`.
- [ ] Make side-effecting calls idempotent where possible.
- [ ] Record sufficient evidence to reconstruct what was proposed and executed.
- [ ] Define rate, spend, token, duration, and retry limits.
- [ ] Test denied arguments and permission escalation—not only successful calls.

## Unattended execution

- [ ] Run in a sandbox or isolated environment.
- [ ] Deny network by default.
- [ ] Mount only required paths, read-only where possible.
- [ ] Set a maximum runtime and resource budget.
- [ ] Define stop conditions and an accountable observer.

## Change record

**Policy owner:** [Role]

**Last verified:** [Date and evidence]

**Reverification triggers:** [Model, harness, permission, schema, dependency, or environment changes]
