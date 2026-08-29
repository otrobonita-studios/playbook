import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';
import path from 'node:path';

const [serverPath, projectRoot] = process.argv.slice(2);
if (!serverPath || !projectRoot) {
  throw new Error('Usage: node tests/mcp-smoke.mjs SERVER_PATH PROJECT_ROOT');
}

const transport = new StdioClientTransport({
  command: process.execPath,
  args: [path.resolve(serverPath)],
  env: { ...process.env, ENGINEERING_PLAYBOOK_ROOT: path.resolve(projectRoot) },
});
const client = new Client({ name: 'playbook-smoke-test', version: '1.0.0' });

try {
  await client.connect(transport);
  const tools = await client.listTools();
  const toolNames = tools.tools.map((tool) => tool.name);
  for (const required of ['get_constitution', 'get_sdd_templates', 'validate_spec_quality']) {
    if (!toolNames.includes(required)) throw new Error(`Missing MCP tool: ${required}`);
  }

  const constitution = await client.callTool({ name: 'get_constitution', arguments: {} });
  const specs = await client.callTool({ name: 'get_sdd_templates', arguments: { templateType: 'all' } });
  const constitutionText = constitution.content?.map((item) => item.text ?? '').join('') ?? '';
  const specsText = specs.content?.map((item) => item.text ?? '').join('') ?? '';
  if (constitutionText.length < 100) throw new Error('MCP constitution response is unexpectedly short.');
  if (!specsText.includes('1-spec.md') || !specsText.includes('3-tasks.md')) {
    throw new Error('MCP did not read the installed specification templates.');
  }
  console.log('MCP server smoke test passed.');
} finally {
  await client.close();
}
