# Engineering Playbook MCP server

This optional local server exposes the installed constitution and specification templates to MCP clients. The bootstrapper installs its production dependency locally under `.engineering-playbook/mcp-server/`.

Add a server entry to the MCP client used by the project:

```json
{
  "mcpServers": {
    "engineering-playbook": {
      "command": "node",
      "args": ["ABSOLUTE_PROJECT_PATH/.engineering-playbook/mcp-server/index.js"],
      "env": {
        "ENGINEERING_PLAYBOOK_ROOT": "ABSOLUTE_PROJECT_PATH"
      }
    }
  }
}
```

Replace `ABSOLUTE_PROJECT_PATH`; do not commit credentials in this configuration. Restart the MCP client, list the server tools, then call `get_constitution` as the connection check.
