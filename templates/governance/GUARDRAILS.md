# Guardrails Design and Verification

> Guardrails are enforceable controls around model and agent behaviour. Complete this alongside the constitution, tool policy, threat model, and evaluation plan.

## 1. Native baseline before extension

- [ ] Record the model, harness, and runtime versions.
- [ ] Inventory native filesystem, network, credential, approval, logging, and spend controls.
- [ ] Distinguish enforced controls from instructions and conventions.
- [ ] Test the combined model-and-harness baseline before adding custom policy.
- [ ] Re-run the baseline when a model, harness, tool, or permission changes.

| Control area | Native protection | Custom extension | Verification case | Owner |
|---|---|---|---|---|
| Filesystem | [What is enforced] | [What is added] | [Case/evidence] | [Role] |
| Network | [What is enforced] | [What is added] | [Case/evidence] | [Role] |
| Credentials | [What is enforced] | [What is added] | [Case/evidence] | [Role] |
| Tool execution | [What is enforced] | [What is added] | [Case/evidence] | [Role] |

## 2. Instruction authority and injection

- [ ] List every channel that may contain instructions or executable content.
- [ ] Define which sources are authoritative and their precedence.
- [ ] Treat users, repositories, tickets, web pages, email, retrieved documents, skills, and tool output as untrusted unless explicitly trusted.
- [ ] Prevent untrusted text from granting authority or expanding permissions.
- [ ] Add direct, indirect, stored, and cross-tool injection cases to the eval suite.

**Authoritative instruction sources:** [List and precedence]

**Untrusted channels:** [List]

## 3. Data and secrets

- [ ] Classify data the agent may read, transform, retain, or transmit.
- [ ] Make credentials task-scoped, environment-scoped, and time-bounded.
- [ ] Prevent `.env*`, tokens, private keys, personal data, and private URLs from entering Git or logs.
- [ ] Test redaction, cross-tenant isolation, and prohibited disclosure.
- [ ] Define rotation and incident response.

## 4. Consequential actions

- [ ] List irreversible, external, financial, privacy-sensitive, and production actions.
- [ ] Require deterministic authorization immediately before execution.
- [ ] Use idempotency and explicit uncertain states for retriable side effects.
- [ ] Cap scope, spend, rate, duration, and repetition.
- [ ] Record proposals, validations, approvals, execution, and recovery state.

## 5. Failure and degradation

- [ ] Define safe behaviour when model, retrieval, policy, tool, or approval is unavailable.
- [ ] Prevent fallback to a weaker model or harness from silently reducing protection.
- [ ] Define timeout, partial-success, replay, and duplicate-action handling.
- [ ] Test fallback and rollback under production-like conditions.

## 6. Verification record

| Risk | Test or eval | Expected safe behaviour | Result/evidence | Re-run trigger |
|---|---|---|---|---|
| [Risk] | [Case/command] | [Observable outcome] | [Link] | [Change type] |
