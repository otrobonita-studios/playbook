# Technical Plan: [Feature name]

> Explain how the approved specification will be implemented without silently changing its scope.

## 1. Existing system

- [ ] Identify current components, data flows, contracts, and owners.
- [ ] Cite the files, tests, ADRs, and runtime evidence inspected.
- [ ] Identify constraints imposed by `AGENTS.md`, constitution, infrastructure, and guardrails.
- [ ] Record assumptions that still require verification.

## 2. Proposed change

- [ ] Describe the smallest coherent architecture change.
- [ ] List files/components to add, modify, generate, migrate, or remove.
- [ ] Define interfaces, schemas, state transitions, and error contracts.
- [ ] Explain model, harness, retrieval, tool, and permission choices where applicable.
- [ ] Explain compatibility and migration strategy.

| Component/path | Change | Responsibility | Risk/owner |
|---|---|---|---|
| `[path]` | [Add/modify/remove] | [Purpose] | [Risk/owner] |

## 3. Security and failure design

- [ ] Map relevant threats to deterministic controls.
- [ ] Define authorization, approval, validation, idempotency, and audit boundaries.
- [ ] Define timeout, retry, partial-success, fallback, and rollback behaviour.
- [ ] Confirm secrets and sensitive data remain outside model and client contexts where required.
- [ ] Update guardrails, tool policy, and approval matrix when capabilities change.

## 4. Verification plan

- [ ] Map every acceptance criterion to a test, eval, trace review, or human decision.
- [ ] List exact formatter, lint, typecheck, test, build, audit, and deployment commands.
- [ ] Define representative environments, datasets, fixtures, and known deviations.
- [ ] Define baseline comparison and regression thresholds.
- [ ] Define post-release health checks and rollback rehearsal.

| Requirement/risk | Evidence | Command/case | Pass condition |
|---|---|---|---|
| [Item] | [Test/eval/review] | `[command or case]` | [Threshold] |

## 5. Delivery sequence

- [ ] Order changes into reviewable, reversible units.
- [ ] Identify dependencies and safe intermediate states.
- [ ] Define data migration and backfill sequencing.
- [ ] Define rollout, monitoring, stop conditions, and ownership.
- [ ] Link the task breakdown and ADRs created by this plan.
