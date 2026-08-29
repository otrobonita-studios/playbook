# Skills: Trusted Sources and Review Policy

> A skill is an agent dependency. Its `SKILL.md` changes operating instructions and its package may contain executable scripts, references, assets, hooks, or tool integrations. Source reputation reduces uncertainty; it does not replace review.

## Before installation

- [ ] Record the source repository, publisher, license, version, and commit SHA.
- [ ] Prefer a platform vendor or another identifiable, accountable maintainer.
- [ ] Read the complete `SKILL.md` and every bundled script, reference, asset, manifest, and hook.
- [ ] Identify requested tools, filesystem access, network access, credentials, dependencies, and external destinations.
- [ ] Look for instructions that override project policy, conceal actions, download further instructions, transmit data, weaken verification, or expand permissions.
- [ ] Confirm compatibility with the project constitution, `AGENTS.md`, tool policy, and approval matrix.
- [ ] Run dependency, secret, license, and static-analysis checks appropriate to bundled code.

## First use

- [ ] Pin the reviewed version or commit; never install an unreviewed moving branch in production.
- [ ] Use an isolated workspace with least privilege and restricted network access.
- [ ] Do not expose production credentials or sensitive project data.
- [ ] Test representative tasks, non-trigger cases, hostile inputs, failure behaviour, and requested side effects.
- [ ] Inspect the resulting commands, file changes, network calls, and logs.
- [ ] Record reviewer, evidence, limitations, and approval decision.

## Updates and removal

- [ ] Review an update as new code by diffing it against the pinned version.
- [ ] Re-run behavioural and security checks after any instruction, script, dependency, or permission change.
- [ ] Define an owner and review cadence.
- [ ] Remove unused skills and revoke credentials or permissions they required.

## Review record

| Skill | Source and commit | Capabilities | Reviewer | Evidence | Decision/expiry |
|---|---|---|---|---|---|
| [Name] | [URL + SHA] | [Tools/network/files] | [Person] | [Report] | [Approved/rejected + date] |

## Sources we inspect first

- [OpenAI Plugins](https://github.com/openai/plugins) — current official source for Codex plugins and bundled skills.
- [OpenAI: Using skills](https://openai.com/academy/skills/) — official explanation of `SKILL.md` as a reusable workflow instruction set.
- [Anthropic Skills](https://github.com/anthropics/skills) — official examples and production-oriented skill patterns.
- [Anthropic Claude Security](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/claude-security) — an example of explicit capability limits, treating repository content as data, and recommending sandboxing for untrusted code.
- [OpenAI Codex system card](https://cdn.openai.com/pdf/8df7697b-c1b2-4222-be00-1fd3298f351d/codex_system_card.pdf) — background on prompt-injection risk and execution/network mitigations.

These links are starting points for provenance review, not an allowlist. Official publication does not prove that a skill fits this project, its current version is safe, or its permissions are appropriate.
