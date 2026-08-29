# Evaluation Plan

Use this checklist to define how an AI-assisted feature will be evaluated before release. Replace every placeholder; delete sections that genuinely do not apply and record why.

## 1. Scope and baseline

- [ ] **Feature or system:** [name and link to specification]
- [ ] **Owner:** [person or team]
- [ ] **Model, harness, prompt, retrieval, and tool versions:** [identifiers]
- [ ] **Current baseline:** [production version or previous accepted result]
- [ ] **Representative environments:** [local, staging, production-like]
- [ ] **Known limitations:** [what this plan does not evaluate]

## 2. Define acceptable behaviour

For each important task, describe observable behaviour rather than one canonical paragraph.

- [ ] Required output schema, fields, citations, or evidence are explicit.
- [ ] Clarification, refusal, escalation, and abstention conditions are explicit.
- [ ] Allowed tools, arguments, side effects, budgets, and approval boundaries are explicit.
- [ ] Critical failures that block release are named.

| Case | Input or setup | Expected behaviour | Unacceptable behaviour | Severity |
|---|---|---|---|---|
| Happy path | [representative task] | [structured success] | [failure] | [level] |
| Ambiguity | [underspecified request] | [clarify, bound assumptions, or abstain] | [silent invention] | [level] |
| Injection | [hostile instruction in user or retrieved content] | [ignore and report] | [follow hostile instruction] | Critical |
| Sensitive data | [PII, credential, secret, or tenant boundary] | [protect, redact, refuse, or escalate] | [disclose or retain] | Critical |
| Stale knowledge | [conflicting or superseded sources] | [prefer current provenance and surface conflict] | [confident stale answer] | [level] |
| Tool abuse | [unauthorized or costly action] | [block or request approval] | [side effect or approval bypass] | Critical |
| Regression | [stable prior case] | [meet or exceed baseline] | [material degradation] | [level] |

## 3. Run deterministic checks first

- [ ] Formatters, linters, and type checkers pass.
- [ ] Unit, integration, contract, and end-to-end tests pass.
- [ ] Schema, citation, permission, cost, latency, and tool-call constraints are checked mechanically where possible.
- [ ] Dependency, secret, and build checks pass.
- [ ] Failures are reproducible and linked to logs or traces.

## 4. When using an LLM judge

An LLM judge is a separate model, usually called through a purpose-built Python evaluation script, that reviews another model's response against explicit criteria. Its judgment is supporting evidence, not unquestionable truth.

- [ ] The rubric contains concrete pass, fail, and borderline examples.
- [ ] Judge model, prompt, parameters, and script revision are recorded.
- [ ] A representative sample is scored independently by humans.
- [ ] Agreement, disagreement, false-pass, and false-fail rates are reviewed.
- [ ] Sensitive or high-impact failures still require human review.
- [ ] Judge drift is checked after model, prompt, rubric, or dataset changes.
- [ ] The judged model cannot influence the rubric or hidden reference material.

## 5. Dataset and provenance

- [ ] Cases represent real usage, edge cases, abuse, and prior incidents.
- [ ] Sources, collection date, consent, licensing, and owners are recorded.
- [ ] Personal data and secrets are removed or handled under an approved policy.
- [ ] Training, tuning, development, and final evaluation sets are separated where needed.
- [ ] Dataset versions are immutable and traceable.

## 6. Release thresholds

| Measure | Baseline | Required threshold | Result | Evidence |
|---|---:|---:|---:|---|
| [task success] | [value] | [value] | [value] | [link] |
| [critical failure rate] | [value] | [value] | [value] | [link] |
| [latency/cost] | [value] | [value] | [value] | [link] |
| [human/judge agreement] | [value] | [value] | [value] | [link] |

- [ ] No critical safety, privacy, authorization, or cross-tenant failure remains open.
- [ ] Material regressions are resolved or explicitly accepted by an accountable owner.
- [ ] Representative traces have been inspected, including failures and borderline passes.
- [ ] Fallback and rollback behaviour has been exercised.

## 7. Decision record

- [ ] **Decision:** [release, hold, limited rollout, or experiment]
- [ ] **Reviewer(s):** [names or roles]
- [ ] **Evidence bundle:** [dataset, report, traces, logs, and commit]
- [ ] **Accepted limitations:** [owner and expiry date]
- [ ] **Next review trigger:** [date, model change, prompt change, incident, or threshold]
