# Feature Specification: [Feature name]

> Describe observable behaviour before implementation. Replace bracketed prompts and remove examples that do not apply.

## 1. Frame the work

- [ ] Select one mode: bootstrap, feature, maintenance, migration, incident remediation, or technical debt.
- [ ] Name the problem, affected users, and current evidence.
- [ ] Define the desired outcome and how it will be measured.
- [ ] List non-goals and prohibited changes.
- [ ] Link relevant constitution rules, ADRs, policies, incidents, and existing specifications.

**Mode:** [Mode]

**Problem:** [Current behaviour and evidence]

**Outcome:** [Observable result]

**Non-goals:** [What must not be built or changed]

## 2. Actors, data, and authority

- [ ] Identify human, service, model, agent, and external-system actors.
- [ ] Identify data read, created, changed, retained, or transmitted.
- [ ] State identity, tenant, authorization, and approval requirements.
- [ ] Mark untrusted inputs and authoritative sources.
- [ ] Identify consequential and irreversible actions.

## 3. Scenarios and acceptance criteria

- [ ] Cover ordinary success.
- [ ] Cover ambiguity and missing information.
- [ ] Cover invalid, unauthorized, hostile, stale, and conflicting input.
- [ ] Cover dependency failure, timeout, retry, partial success, and rollback.
- [ ] Make every criterion observable and testable.

```text
GIVEN [precondition and authority]
WHEN [trigger]
THEN [observable result]
AND [evidence, side effect, or safe failure]
```

## 4. AI-specific behaviour

- [ ] Separate model judgments from code-enforced decisions.
- [ ] Define allowed tools, arguments, permissions, and approval gates.
- [ ] Define required citations, provenance, structured output, refusal, clarification, or escalation.
- [ ] Define behaviour under prompt injection and conflicting instructions.
- [ ] Define model/harness fallback and the protection that must remain intact.

## 5. Quality and operational constraints

- [ ] Define security and privacy requirements.
- [ ] Define latency, throughput, cost, and resource budgets.
- [ ] Define accessibility, localization, and compatibility requirements.
- [ ] Define observability, audit, retention, and incident requirements.
- [ ] Define deployment, migration, fallback, and rollback expectations.

## 6. Proof and release

- [ ] Link deterministic tests and evaluation cases to acceptance criteria.
- [ ] Define critical failures that block release regardless of aggregate score.
- [ ] Define production-representative verification and known deviations.
- [ ] Name reviewer, approver, release evidence, and unresolved assumptions.

**Definition of done:** [Evidence required before release]
