# Verification Contract

> Use this document to define the reproducible evidence required before a change may be accepted. Keep the baseline fast and inexpensive; add deeper controls only where the repository and its risks justify them.

## 1. Intended scope

This baseline is designed for individuals, small teams, and AI-native product teams that need practical verification and essential security controls without adopting an enterprise rollout framework.

It does not replace an enterprise engineering system, compliance program, security organization, or platform-governance model. Established organizations should integrate the useful parts into their existing controls rather than create a competing process.

- [ ] **Repository or system:** [name]
- [ ] **Verification owner:** [person or role]
- [ ] **Supported stacks and environments:** [list]
- [ ] **Known gaps:** [controls not yet present]

## 2. Canonical commands

Prefer one project-native command for each verification level. Reuse existing formatters, linters, type checkers, test runners, and build tools instead of installing competing alternatives.

| Level | Command | Intended use | Maximum useful duration |
|---|---|---|---:|
| Fast | `[npm run verify:fast or equivalent]` | Repeated during implementation | [target] |
| Full | `[npm run verify or equivalent]` | Before handoff or merge | [target] |
| Security | `[project command]` | Risk-triggered or scheduled | [target] |
| Release | `[project command]` | Before consequential deployment | [target] |

Every command must:

- return a non-zero exit code on failure;
- avoid modifying source files;
- print enough context to diagnose failures;
- work locally and in CI where the required dependencies exist;
- identify skipped or unavailable checks instead of silently passing.

## 3. Verification levels

### Fast - while working

- [ ] Formatting check for changed files.
- [ ] Targeted lint and strict type checking.
- [ ] Tests closest to the changed behavior.
- [ ] Relevant schema, contract, or architecture checks.

### Full - before merge

- [ ] Complete formatting, lint, and type checks.
- [ ] Applicable unit, integration, contract, and end-to-end tests.
- [ ] Production build.
- [ ] Dependency and secret checks.
- [ ] Changed acceptance criteria mapped to evidence.

### Deep - scheduled or risk-triggered

- [ ] Static security analysis appropriate to the language and hosting platform.
- [ ] Targeted architecture analysis for deliberately chosen boundaries.
- [ ] Critical-journey end-to-end tests.
- [ ] Targeted mutation testing for high-risk domain logic where useful.
- [ ] Coverage trends for changed critical code, not a universal percentage target.

### Release - before consequential deployment

- [ ] Production-like smoke tests.
- [ ] Migration, rollback, and recovery paths exercised.
- [ ] Monitoring and alert evidence reviewed.
- [ ] Required human approvals and accepted limitations recorded.

## 4. Risk-based evidence

| Change type | Minimum evidence |
|---|---|
| Documentation or copy | Format, links, and rendered-output checks as applicable |
| Ordinary application code | Lint, types, affected tests, integration checks, and build |
| Authentication or authorization | Negative permission tests, tenant isolation, security analysis, and human review |
| Data model or migration | Migration test, representative data, integrity checks, backup, and rollback |
| External or irreversible side effect | Contract tests, authorization, idempotency, timeout, replay, and uncertain-state handling |
| AI behavior | Deterministic constraints plus dataset-based evaluations and representative trace review |
| Build, deployment, or policy configuration | Dry run or preview, least-privilege review, failure behavior, and rollback |

## 5. Tool selection

Choose capabilities first and products second.

- Use the repository's existing formatter, linter, type checker, and test runner.
- Use one high-signal static-security path before layering overlapping scanners.
- Add architecture tooling only to enforce boundaries the project has intentionally adopted.
- Use end-to-end tests for critical journeys, not every presentation detail.
- Use mutation testing selectively for authorization, calculations, validation, state transitions, routing decisions, and other critical domain logic.
- Treat SonarQube, Semgrep, CodeQL, dependency analyzers, architecture tools, Playwright, and mutation frameworks as options, not universal requirements.

Document each added tool's purpose, owner, update policy, runtime cost, and removal path.

## 6. Baseline and ratchet

Do not hide an unhealthy repository by weakening checks or adding broad suppressions.

- [ ] Record pre-existing failures separately from failures introduced by the current change.
- [ ] Prevent new violations while the historical backlog is addressed deliberately.
- [ ] Keep suppressions narrow, documented, owned, and time-bounded.
- [ ] Establish an observed baseline before enforcing an aggressive threshold.
- [ ] Tighten gates when the evidence shows they are stable and useful.

## 7. Merge authority

- A worker or coding agent may implement, test, and submit evidence.
- An agent may not waive a mandatory failure, redefine acceptance criteria after seeing results, or approve its own security exception.
- LLM review may supplement but never replace deterministic verification.
- Required checks must run against the integrated candidate, not only isolated contributions.
- Consequential residual risk requires acceptance by a named accountable person or role.

## 8. Verification record

| Candidate | Base revision | Commands and environment | Result | Evidence | Reviewer |
|---|---|---|---|---|---|
| [commit or PR] | [revision] | [commands] | [pass/fail/partial] | [logs, report, trace] | [name/role] |

Record checks that could not run, why they could not run, and the safest remaining verification step.
