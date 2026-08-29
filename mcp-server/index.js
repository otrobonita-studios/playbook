#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const packagedParent = path.resolve(__dirname, '..');
const inferredRoot = path.basename(packagedParent) === '.engineering-playbook'
  ? path.resolve(packagedParent, '..')
  : packagedParent;
const rootDir = process.env.ENGINEERING_PLAYBOOK_ROOT
  ? path.resolve(process.env.ENGINEERING_PLAYBOOK_ROOT)
  : inferredRoot;

const server = new Server(
  {
    name: 'otrobonita-playbook-mcp',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available MCP tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'get_constitution',
        description: 'Get the master engineering governance, negative constraints, and 3-tier testing rules.',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'get_sdd_templates',
        description: 'Get the installed Spec-Driven Development templates (spec, technical plan, and tasks).',
        inputSchema: {
          type: 'object',
          properties: {
            templateType: {
              type: 'string',
              description: 'Optional template type: spec, plan, tasks, adr, or all (default: all)',
            },
          },
        },
      },
      {
        name: 'validate_spec_quality',
        description: 'Validate and score an SDD specification Markdown document (0-100%) against quality guardrails.',
        inputSchema: {
          type: 'object',
          properties: {
            specMarkdown: {
              type: 'string',
              description: 'The Markdown content of the specification to evaluate.',
            },
          },
          required: ['specMarkdown'],
        },
      },
    ],
  };
});

// Handle MCP tool execution
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'get_constitution') {
    const constitutionPath = path.join(rootDir, 'CONSTITUTION.md');
    const content = fs.existsSync(constitutionPath)
      ? fs.readFileSync(constitutionPath, 'utf8')
      : 'CONSTITUTION.md not found.';
    return {
      content: [{ type: 'text', text: content }],
    };
  }

  if (name === 'get_sdd_templates') {
    const type = args?.templateType || 'all';
    let text = '';

    const readFirst = (...relativePaths) => {
      const selected = relativePaths
        .map((relativePath) => path.join(rootDir, relativePath))
        .find((candidate) => fs.existsSync(candidate));
      return selected ? fs.readFileSync(selected, 'utf8') : '';
    };

    if (type === 'spec' || type === 'all') {
      text += `=== 1-spec.md ===\n${readFirst('specs/template/1-spec.md', 'templates/sdd/1-spec-template.md')}\n\n`;
    }
    if (type === 'plan' || type === 'all') {
      text += `=== 2-technical-plan.md ===\n${readFirst('specs/template/2-technical-plan.md', 'templates/sdd/2-tech-plan-template.md')}\n\n`;
    }
    if (type === 'tasks' || type === 'all') {
      text += `=== 3-tasks.md ===\n${readFirst('specs/template/3-tasks.md', 'templates/sdd/3-tasks-template.md')}\n\n`;
    }

    return {
      content: [{ type: 'text', text: text.trim() }],
    };
  }

  if (name === 'validate_spec_quality') {
    const markdown = args?.specMarkdown || '';
    let score = 0;
    const checks = [];

    const hasEARS = /GIVEN|WHEN|THEN|NÄR|SKALL|SHALL/i.test(markdown);
    if (hasEARS) {
      score += 25;
      checks.push('✓ EARS Criteria Present (+25)');
    } else {
      checks.push('✗ Missing EARS syntax (GIVEN/WHEN/THEN)');
    }

    const hasNonGoals = /Out of Scope|Icke-mål|Begränsningar|Constraints|Forbidden/i.test(markdown);
    if (hasNonGoals) {
      score += 25;
      checks.push('✓ Negative Constraints / Non-Goals Specified (+25)');
    } else {
      checks.push('✗ Missing Out of Scope / Non-Goals');
    }

    const hasVerification = /npm run|npm test|check-types|build|Verification|Verifiering/i.test(markdown);
    if (hasVerification) {
      score += 25;
      checks.push('✓ Explicit Verification Commands (+25)');
    } else {
      checks.push('✗ Missing Verification Commands');
    }

    if (markdown.length > 250) {
      score += 25;
      checks.push('✓ Complete Structure & Depth (+25)');
    } else {
      checks.push('✗ Under-specified (< 250 characters)');
    }

    const result = {
      score: `${score}%`,
      status: score >= 75 ? 'PASSED' : 'NEEDS_IMPROVEMENT',
      breakdown: checks,
    };

    return {
      content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});

// Start STDIO transport for MCP server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err) => {
  console.error('Fatal MCP Server error:', err);
  process.exit(1);
});
