# NemoClaw Isolation Profile

Use this module only when the project intentionally runs agents through NemoClaw/OpenShell. Customize it after installation; no sandbox is created automatically.

## Intended workload

- Agent or harness: [Name and version]
- Task types: [Allowed workloads]
- Model/provider: [Provider and model]
- Project data allowed inside the sandbox: [Scope]

## Prerequisites

- Supported host and shell: [For example WSL2 Ubuntu]
- Container runtime: [Docker/other and required version]
- NemoClaw/OpenShell version: [Pinned version]
- Credential source: [Secret manager; never paste credentials here]

## Isolation contract

- Filesystem mounts: [Read-only/read-write paths]
- Network egress: [Denied by default; approved destinations]
- Available tools: [Allowlist]
- Resource and spend limits: [CPU, memory, duration, tokens/cost]
- Human approval gates: [Consequential actions]
- Logs and retention: [Destination and retention]

## Create and verify the sandbox

Document the exact, version-pinned commands used by this project:

```bash
# create/onboard command
[command]

# verify runtime and server connectivity
[command]

# show sandbox status
[command]
```

Verification is incomplete until the container/runtime is healthy, the intended model can answer, forbidden filesystem and network access are rejected, and logs contain no secrets.

## Everyday use

```bash
# start
[command]

# connect
[command]

# stop
[command]
```

## Recovery and removal

- Recover a failed session: [Procedure]
- Export non-sensitive evidence: [Procedure]
- Remove the sandbox and credentials: [Procedure]
