# Infrastructure Context

Replace every placeholder before relying on this document. Its purpose is to stop humans and agents from inferring infrastructure from filenames, old configuration, or domain names.

## Environments

| Environment | Purpose | Hosting | Data store | Owner |
|---|---|---|---|---|
| Local | [Purpose] | [Runtime] | [Local services] | [Owner] |
| Staging | [Purpose] | [Provider/project] | [Provider/project] | [Owner] |
| Production | [Purpose] | [Provider/project] | [Provider/project] | [Owner] |

## Service boundaries

| Capability | Approved service | Authentication | Data classification | Notes |
|---|---|---|---|---|
| Application hosting | [Service] | [Method] | [Class] | [Boundary] |
| Database | [Service] | [Method] | [Class] | [Boundary] |
| Object storage | [Service] | [Method] | [Class] | [Boundary] |
| AI inference | [Provider/model gateway] | [Method] | [Class] | [Logging/retention] |
| Payments | [Service] | [Method] | [Class] | [Approval/idempotency] |
| Email | [Service] | [Method] | [Class] | [Allowed senders] |

## Secrets and configuration

- Secret manager: [System and project]
- Local configuration: [Approved mechanism; never commit `.env*`]
- Rotation owner and cadence: [Owner/cadence]
- Production access approval: [Process]

## Deployment and rollback

- Build command: `[command]`
- Deployment command or pipeline: `[pipeline]`
- Health evidence: [Checks, dashboards, alerts]
- Rollback procedure: [Exact procedure and owner]
- Production-representative verification: [Environment and known deviations]

## Forbidden or retired infrastructure

- [Technology or account that must not be introduced]
- [Legacy configuration that must not be recreated]

## Open questions

- [Unverified assumption and owner]
