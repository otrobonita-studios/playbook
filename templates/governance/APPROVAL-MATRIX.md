# Human Approval Matrix

> Approval is valid only when the approver sees the concrete action, destination, data, and consequence immediately before execution.

| Action | Risk/consequence | Approval timing | Authorized approver | Batch exception allowed | Evidence |
|---|---|---|---|---|---|
| Production deployment | [Impact] | Immediately before push/deploy | [Role] | [Yes/no and limit] | [Location] |
| External communication | [Audience/representation] | Before send/publish | [Role] | [Rule] | [Location] |
| Data transmission | [Data and destination] | Before transmission | [Role/data owner] | [Rule] | [Location] |
| Destructive operation | [Recovery/irreversibility] | Before execution | [Role] | [Rule] | [Location] |
| Financial action | [Amount/commitment] | Before confirmation | [Role] | [Threshold] | [Location] |
| Permission change | [Expanded access] | Before change | [Security/owner] | [Rule] | [Location] |

## Completion checklist

- [ ] Every consequential capability appears in the matrix.
- [ ] Approval is enforced by the harness or application, not only requested in prompt text.
- [ ] Approvers can inspect the exact parameters and affected resources.
- [ ] Expired, reused, or mismatched approval is rejected.
- [ ] Emergency and rollback actions have named authority.
- [ ] Approval events are auditable without exposing secrets.
