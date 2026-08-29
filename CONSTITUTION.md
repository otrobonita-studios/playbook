# Project Engineering Constitution

> Complete this document before agents make consequential changes. Replace every bracketed prompt. A checked box means the decision has been made and recorded—not merely discussed.

## 1. Purpose and accountability

- [ ] Describe the system, its users, and the consequences of failure.
- [ ] Name the human or team accountable for the system.
- [ ] Name who may approve production releases and policy exceptions.
- [ ] Record where approvals, exceptions, and evidence are retained.

**System purpose:** [What this system does]

**Accountable owner:** [Role or team]

**Release authority:** [Role or team]

## 2. Non-negotiable boundaries

- [ ] Identify data the model or agent must never receive.
- [ ] Identify actions an agent must never execute directly.
- [ ] Define identity, tenant, authorization, and data-residency boundaries.
- [ ] Define prohibited infrastructure, models, tools, and dependencies.
- [ ] Define which constraints cannot be overridden by a feature request.

**Prohibited data:** [List and reason]

**Prohibited actions:** [List and reason]

**Required boundaries:** [List]

## 3. Human approval

- [ ] Define actions that always require approval immediately before execution.
- [ ] Define monetary, privacy, legal, security, and operational thresholds.
- [ ] Define what may be approved as a named batch or time-bounded exception.
- [ ] Ensure approval is represented by an enforceable control, not prompt text alone.

| Action or consequence | Approval required | Approver | Evidence retained |
|---|---|---|---|
| [Example: production deployment] | [Always/threshold] | [Role] | [Location] |

## 4. Evidence and release

- [ ] List deterministic checks required for every change.
- [ ] Define when behavioural evaluations and representative trace review are required.
- [ ] Define critical failures that block release regardless of aggregate score.
- [ ] Define production-representative verification and known deviations.
- [ ] Define monitoring, fallback, rollback, and post-release checks.

**Required commands:** `[formatter, lint, typecheck, test, build, security checks]`

**Critical release blockers:** [List]

**Rollback evidence:** [Procedure and location]

## 5. Security and supply chain

- [ ] Define how secrets are stored, scoped, rotated, and kept out of Git.
- [ ] Define dependency approval and vulnerability-response policy.
- [ ] Define how external content is treated as untrusted data.
- [ ] Define the review policy for skills, plugins, MCP servers, hooks, and agent tooling.
- [ ] Require least privilege and isolation for unattended work.

**Secret manager:** [System]

**Approved dependency sources:** [Sources and review owner]

**Agent extension policy:** [Link to policy or record decision]

## 6. Durable project context

- [ ] Identify the authoritative location for product requirements.
- [ ] Identify the authoritative location for architecture decisions.
- [ ] Require `AGENTS.md` to change with repository commands and boundaries.
- [ ] Require specifications, tests, evals, and Git history to remain consistent.
- [ ] Define how unfinished work is handed over between sessions.

| Context | Authoritative location | Owner |
|---|---|---|
| Product requirements | [Path/system] | [Role] |
| Architecture decisions | [Path/system] | [Role] |
| Agent operating instructions | `AGENTS.md` | [Role] |
| Active handover | `CONTINUE.md` | [Role] |

## 7. Amendment process

- [ ] Define who may propose and approve constitutional changes.
- [ ] Require an explanation, migration impact, and verification evidence.
- [ ] Record the effective date and superseded version.
- [ ] Re-evaluate affected guardrails, tools, evals, and release controls.

**Approved by:** [Name/role]

**Effective date:** [YYYY-MM-DD]

**Version:** [Semantic or date-based version]
