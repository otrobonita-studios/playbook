# Implementation Tasks: [Feature name]

> Each task must be reviewable, leave the repository in a known state, and name the evidence required for completion.

## Preparation

- [ ] Confirm the specification and technical plan are approved and current.
- [ ] Confirm project instructions, working tree, branch, and baseline checks.
- [ ] Resolve or explicitly assign every open architectural and policy decision.
- [ ] Prepare fixtures, evaluation cases, migrations, and rollback prerequisites.

## Task template

- [ ] **[Task number · Outcome, not activity]**
  - Scope: [Files/components and observable result]
  - Boundaries: [What must not change]
  - [ ] Add or update failing evidence first when objectively verifiable.
  - [ ] Implement the smallest coherent change.
  - [ ] Update specifications, ADRs, `AGENTS.md`, policies, and handover state affected by the change.
  - Verification: `[exact commands and cases]`
  - Completion evidence: [Expected output, trace, screenshot, report, or reviewer]
  - Rollback: [How this unit can be reversed]

## Required delivery tasks

- [ ] Implement data and interface contracts.
- [ ] Implement deterministic authorization and guardrail changes.
- [ ] Add unit, integration, contract, end-to-end, and migration tests as applicable.
- [ ] Add behavioural evals and judge calibration where interpretation is required.
- [ ] Inspect representative and failed traces.
- [ ] Run formatter, lint, typecheck, tests, build, dependency and secret checks.
- [ ] Verify production-like deployment, monitoring, fallback, and rollback.
- [ ] Review the final diff for scope, generated noise, debug code, secrets, and stale documentation.
- [ ] Record exact release evidence and unresolved limitations.

## Final release gate

- [ ] Every acceptance criterion has evidence.
- [ ] No critical failure or unresolved blocker remains.
- [ ] Required approvals are recorded.
- [ ] The repository context describes the implemented system.
- [ ] The release and rollback paths were verified.
