# Concurrent Agent Work

> Multiple agents may work in the same repository, but they should not write concurrently to the same working tree. Parallelism is safe only when ownership, dependencies, isolation, and integration are explicit.

Use this with `VERIFICATION.md`, the feature specification, technical plan, and task list.

## 1. Decide whether to parallelize

Parallelize only tasks that have:

- independent or deliberately partitioned file ownership;
- stable interfaces and settled decisions;
- explicit dependencies;
- executable completion checks;
- no shared irreversible side effect.

Keep work sequential when agents would edit the same files, depend on unresolved architecture, share mutable external state, or need answers from the same evolving context.

## 2. Isolate every contribution

Prefer one branch and worktree per task:

```text
repository
|- worktree/task-a -> branch agent/task-a
|- worktree/task-b -> branch agent/task-b
|- worktree/task-c -> branch agent/task-c
`- integration      -> reviewed combined candidate
```

- [ ] No agent writes to another agent's worktree.
- [ ] No agent overwrites unrelated user or agent changes.
- [ ] Shared generated files and lockfiles have one owner or are updated during integration.
- [ ] Credentials, ports, databases, queues, and external environments are isolated or explicitly coordinated.

## 3. Give each worker a verification packet

```yaml
outcome: Observable result, not an activity
base_revision: Commit or accepted integration revision
scope: Files, components, and services the worker may change
boundaries: Behavior and files that must not change
depends_on: Accepted decisions or predecessor tasks
expected_artifacts: Files, commits, reports, or migrations
checks:
  - Exact deterministic command with diagnostic failure output
evidence: What the checks prove and where results are recorded
handoff: Assumptions, unresolved risks, and integration notes
```

Checks should explain failures. Silent exit codes waste retries and produce poor evidence.

## 4. Do not trust completion claims

The orchestrator, reviewer, or integration owner executes the declared checks. A worker's summary is context, not proof.

- [ ] Expected artifacts exist and are non-empty.
- [ ] The diff stays within assigned scope.
- [ ] Mandatory checks pass in the stated environment.
- [ ] Failed checks and retries remain visible.
- [ ] The worker did not weaken tests, policies, or verification configuration.

Tools such as [Ringer](https://github.com/NateBJones-Projects/ringer) demonstrate this pattern with isolated workers, manifest-defined tasks, executable checks, retry context, and attempt logs. Ringer is an example, not a required dependency; worktrees, CI jobs, Codex subagents, or another orchestrator can implement the same contract.

## 5. Integrate independently

Per-task success is necessary but insufficient. After combining accepted contributions:

1. Confirm every contribution's base revision and identify intervening changes.
2. Resolve conflicts according to the current specification, not whichever patch arrived first.
3. Run affected checks after each integration step.
4. Run the complete repository verification suite against the combined candidate.
5. Re-run security, migration, end-to-end, and release checks when the combined risk requires them.
6. Obtain required human approval before merge or deployment.

Do not allow a worker to be the sole reviewer or merger of its own contribution.

## 6. Preserve provenance

For each contribution record:

- task and specification revision;
- base and resulting commits;
- agent, model, harness, and material permissions;
- changed files and external side effects;
- commands, environment, raw results, and skipped checks;
- retries and injected failure context;
- accepted exceptions, owner, and expiry or review trigger.

The useful audit unit is the engineering decision and its evidence, not an indiscriminate transcript of every token.

## 7. Stop conditions

Pause parallel work when:

- task scopes begin to overlap;
- an earlier decision is invalidated;
- a shared interface changes;
- checks disagree across environments;
- integration repeatedly reopens completed tasks;
- agents begin coordinating through undocumented assumptions.

Return to the specification or decision process, update dependencies, and repartition the remaining work before continuing.
