# Contributing

Contributions should improve the playbook as a reusable foundation without embedding organization-specific infrastructure, credentials, private URLs, or assumptions.

Before opening a pull request:

1. Explain the problem and the intended user.
2. Keep templates actionable and editable; prefer prompts and checklists over unexplained terminology.
3. Update both Bash and PowerShell installers when installed artifacts change.
4. Run `npm ci --ignore-scripts`, both bootstrap smoke tests, and `npm audit --audit-level=moderate`.
5. Inspect the complete diff and confirm that no `.env`, credential, personal data, or internal path is included.

Security concerns should follow [SECURITY.md](SECURITY.md), not a public issue.
