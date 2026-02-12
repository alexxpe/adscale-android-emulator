# The complete guide to Claude Code: from installation to mastery

Claude Code is Anthropic's agentic coding tool that lives in your terminal and takes real actions in your development environment—not just suggesting code, but directly editing files, running commands, and managing git workflows through natural language. This guide covers everything from first installation to advanced workflows, giving you the knowledge to leverage Claude Code's full potential as a capable AI pair programmer.

The tool represents a fundamental shift from traditional AI coding assistants. Where GitHub Copilot offers autocomplete suggestions and Cursor provides an AI-embedded editor, Claude Code operates as an autonomous agent with full codebase awareness, executing multi-file changes, debugging loops, and deployment tasks with minimal hand-holding. At **$3/$15 per million tokens** (input/output) via API or included with Claude Pro/Max subscriptions, it delivers enterprise-grade capabilities for individual developers and teams.

---

## What makes Claude Code different from other AI coding tools

Claude Code operates on a fundamentally different paradigm than traditional AI coding assistants. The core design philosophy gives Claude the same tools developers use daily: file editing, code running, debugging, and iterating until tasks succeed. Rather than suggesting snippets in an IDE sidebar, Claude Code executes an **agentic loop**—gathering context, taking action, verifying results, and repeating until the task completes.

The tool maintains awareness of your **entire project structure**, understanding inter-file relationships and coding patterns without requiring you to manually paste code or explain architecture. It automatically reads your `CLAUDE.md` files for project-specific context, explores directories using bash commands, and makes coordinated changes across multiple files simultaneously. This makes it particularly powerful for large refactoring tasks, repository-wide migrations, and complex debugging scenarios.

Three primary use cases stand out. First, **codebase exploration and onboarding**—asking questions like "How does authentication work?" and receiving answers grounded in actual code. Second, **implementation tasks** from feature development to bug fixes, where Claude reads requirements, writes code, runs tests, and iterates. Third, **git workflow automation** including commits, PRs, branch management, and merge conflict resolution through natural language commands.

---

## Installation across all platforms

The native installer is now the recommended approach for all platforms, eliminating the previous Node.js dependency and providing automatic background updates.

**macOS and Linux installation:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```
Alternatively, use Homebrew: `brew install --cask claude-code`

**Windows installation via PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```
Or through WinGet: `winget install Anthropic.ClaudeCode`

**System requirements** are modest: macOS 10.15+, Windows 10+, or modern Linux distributions (Ubuntu 18.04+, Debian 10+). Hardware needs include **4GB RAM minimum** (8-16GB recommended), 500MB-2GB disk space, and an active internet connection. Node.js is only required for the legacy npm installation method, which is now deprecated.

After installation, verify everything works:
```bash
claude --version
claude doctor   # Diagnose any issues
```

### Initial authentication and configuration

Navigate to your project directory and run `claude` to start your first session. On first launch, you'll authenticate through your browser using either **Claude.ai** (subscription plans) or **Claude Console** (API with pre-paid credits). Credentials are stored at `~/.claude/` and persist across sessions.

For API key authentication, set the environment variable:
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

**IDE integrations** extend Claude Code into your editor. For VS Code, install the official "Claude Code" extension by Anthropic from the marketplace. The extension provides a native graphical interface, inline diffs, @-mention file references, and conversation history. For JetBrains IDEs (IntelliJ, PyCharm, WebStorm), search for "Claude Code [Beta]" in Settings → Plugins → Marketplace. Quick launch with `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows/Linux).

---

## Core commands and basic usage patterns

Claude Code offers three execution modes. **Interactive mode** (`claude`) starts a multi-turn conversation session. **Print mode** (`claude -p "query"`) runs a single prompt non-interactively and exits—ideal for scripts. **SDK mode** provides programmatic control through the `@anthropic-ai/claude-agent-sdk` package.

**Essential CLI commands:**

| Command | Purpose |
|---------|---------|
| `claude` | Start interactive session |
| `claude "task"` | Run one-time task |
| `claude -p "query"` | Print mode—query once and exit |
| `claude -c` | Continue most recent conversation |
| `claude -r` | Resume with conversation selection |
| `claude commit` | Create a Git commit |
| `/clear` | Clear conversation history |
| `/compact` | Summarize to free context space |
| `/permissions` | Manage tool allowlist |

The context window holds approximately **200,000 tokens** (about 150,000 words), and Claude sees your new prompt plus the entire conversation history. Performance degrades as context fills, so aggressive use of `/clear` between unrelated tasks is critical. Auto-compaction triggers at ~95% context usage in CLI, summarizing the conversation to reduce size.

### Working with files and projects

Claude Code reads files as needed without manual context addition. Reference files using @-mentions with tab-completion: `@src/auth.ts explain this file`. For file operations, Claude uses built-in tools: `Read` for viewing contents, `Write` for creating files, `Edit` for modifications, `Glob` for pattern searches, and `Grep` for content searches.

Permission patterns use gitignore-style syntax: `Read(src/**)` allows reading all files in src recursively, while `Write(*.py)` restricts Python file creation. Configure these in `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Read", "Write(src/**)", "Bash(git *)"],
    "deny": ["Read(.env*)", "Bash(rm *)"]
  }
}
```

---

## Understanding agents and agentic coding

Claude Code operates through an **agent loop**: gather context → take action → verify work → repeat. The agent uses tools including `Bash` for shell commands, `Edit/MultiEdit` for file modifications, `Write` for file creation, `Read` for viewing contents, `Glob` and `Grep` for searches, and `Task` for launching subagents.

By default, Claude Code is **read-only** and asks permission before file writes, bash commands, and MCP tool usage. Cycle through permission modes using **Shift+Tab**: Normal mode (asks permission), Auto-Accept mode (automatically approves edits), and Plan mode (read-only research only).

**Safety mechanisms** include multiple layers. Permission-based operations require explicit approval for modifications. **Sandboxing** (activated with `/sandbox`) provides filesystem isolation restricting Claude to specific directories and network isolation preventing data exfiltration—reducing permission prompts by **84%** while increasing security. **Checkpoints** automatically save state before each change, enabling instant rollback with `Esc+Esc` or `/rewind`.

For autonomous operation in CI/CD or containers, use `--dangerously-skip-permissions` but only in isolated environments without internet access. This bypasses all safety prompts.

### Subagents enable parallel specialized work

Subagents are specialized subprocesses with isolated context windows that Claude can launch for parallel tasks. Use them for exploration to preserve your main context, for security reviews after implementation, or for splitting complex problems across multiple specialized agents. Configure custom subagents in `.claude/agents/` with specific tool restrictions and instructions.

---

## Plan mode for complex tasks

Plan mode instructs Claude to analyze the codebase with **read-only operations only**, creating structured implementation plans without making changes until explicitly approved. This dramatically improves one-shot success rates for complex multi-file tasks.

**Activate plan mode** by pressing Shift+Tab twice, starting a session with `claude --permission-mode plan`, or configuring it as default in settings. In plan mode, Claude can use Read, LS, Glob, Grep, WebFetch, and WebSearch tools but cannot access Edit, Write, Bash, or any state-modifying operations.

**When to use plan mode:**
- Multi-step implementations requiring many file edits
- Code exploration before making changes
- Dependency analysis to assess change impact
- Architecture decisions needing deep analysis
- Onboarding to understand new codebases

The workflow proceeds: enter plan mode → present your task → Claude researches using read-only tools → Claude creates a structured plan → you review and provide feedback → iterate until satisfied → exit plan mode → Claude executes the approved plan. When exiting, Claude provides extra confirmation about what it's about to execute as an additional safety mechanism.

**Extended thinking** triggers deeper analysis. Include these keywords in prompts to allocate progressively more thinking budget: "think" < "think hard" < "think harder" < "ultrathink". Use higher levels for complex architectural decisions.

---

## MCP servers connect Claude to external systems

The **Model Context Protocol (MCP)** is an open-source standard for connecting AI applications to external data sources, tools, and workflows. Think of it as a "USB-C port for AI"—a universal protocol replacing fragmented custom integrations.

Claude Code connects to MCP servers to access databases, cloud services, developer tools, and custom APIs. The architecture includes **hosts** (Claude Code), **clients** (protocol handlers), and **servers** (programs exposing capabilities). Three core primitives define what servers can offer: **Tools** (executable functions), **Resources** (data sources), and **Prompts** (reusable templates).

### Configuring MCP servers

Add servers via CLI:
```bash
# HTTP transport for remote servers
claude mcp add --transport http notion https://mcp.notion.com/mcp

# STDIO transport for local servers
claude mcp add github --scope user -- npx -y @modelcontextprotocol/server-github
```

Or configure directly in `~/.claude.json`:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost/db"
      }
    }
  }
}
```

**Popular MCP integrations** include databases (PostgreSQL, SQLite, Redis, ClickHouse), cloud services (AWS, Azure, Google Cloud, Cloudflare), and developer tools (GitHub, GitLab, Jira, Slack, Notion, Linear). Find more at the MCP Registry: registry.modelcontextprotocol.io.

### Creating custom MCP servers

SDKs are available for TypeScript, Python, Java, Kotlin, C#, Rust, Go, Ruby, Swift, and PHP. A minimal TypeScript server:

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "my-server", version: "1.0.0" });

server.registerTool(
  "calculate",
  {
    description: "Perform a calculation",
    inputSchema: {
      operation: z.enum(["add", "subtract", "multiply", "divide"]),
      a: z.number(),
      b: z.number(),
    },
  },
  async ({ operation, a, b }) => {
    // Implementation here
    return { content: [{ type: "text", text: `Result: ${result}` }] };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
```

**Critical rule**: STDIO servers must log to stderr, not stdout. Stdout corrupts JSON-RPC messages.

---

## Skills extend Claude's capabilities

**Agent Skills** are modular instruction packages that teach Claude how to complete specialized tasks. Unlike MCP servers (external integrations), Skills are internal instruction sets that Claude loads when relevant.

Skills provide **progressive disclosure**—Claude scans skill descriptions (~100 tokens each) to determine relevance, then loads full content (~5k tokens) only when needed. This keeps context efficient while enabling specialized capabilities.

**Built-in skills** include PowerPoint, Excel, Word, and PDF manipulation. Store custom skills at `~/.claude/skills/` (personal, all projects) or `.claude/skills/` (project-specific, shared via git).

**Skill file structure:**
```markdown
---
name: code-reviewer
description: Review code for best practices and issues. Use when reviewing PRs or analyzing quality.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

## Review checklist
1. Code organization and structure
2. Error handling
3. Performance considerations
4. Security concerns
5. Test coverage
```

Optional frontmatter includes `disable-model-invocation: true` (require explicit `/skill-name`), `context: fork` (run in separate subagent), and `agent: Explore` (specify agent type).

---

## Rules and configuration files shape Claude's behavior

Claude Code uses a hierarchical configuration system with multiple file types serving different purposes.

**CLAUDE.md files** provide persistent memory loaded at every session start:
- `~/.claude/CLAUDE.md` — Global, applies to all projects
- `./CLAUDE.md` — Project-level, commit to git
- `./CLAUDE.local.md` — Personal project settings, gitignore

A well-structured CLAUDE.md includes bash commands (build, test, lint), code style preferences, key directories, and architectural context:

```markdown
# Project: My App

## Commands
- npm run build: Build the project
- npm run test: Run tests

## Code Style
- Use TypeScript strict mode
- Prefer interfaces over types
- No `any` types—use `unknown`

## Key Directories
- src/components/ - React components
- src/services/ - Business logic
```

**Rules files** in `.claude/rules/` organize instructions into focused areas with optional path-based conditions:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules
- All endpoints must include input validation
- Use standard error response format
```

**Settings hierarchy** (highest to lowest priority): enterprise managed policies → command line arguments → local project settings (`.claude/settings.local.json`) → shared project settings (`.claude/settings.json`) → user settings (`~/.claude/settings.json`).

**Hooks** run custom commands at specific events:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write(*.py)",
      "hooks": [{"type": "command", "command": "python -m black \"$file\""}]
    }]
  }
}
```

---

## Effective prompting strategies

Prompting Claude Code differs from regular Claude because it automatically gathers context by reading files, running commands, and exploring the codebase. The key constraint: **context fills fast, and performance degrades as it fills**.

**Be specific rather than vague:**

| Poor prompt | Good prompt |
|-------------|-------------|
| "add tests for foo.py" | "write a new test case for foo.py, covering the edge case where user is logged out. avoid mocks" |
| "add a calendar widget" | "look at how existing widgets are implemented in HotDogWidget.php, then follow that pattern to implement a calendar widget with month selection and year pagination" |

**The explore-plan-code-commit workflow:**
1. "Read the files in /src/auth and understand how we handle sessions"
2. "I want to add Google OAuth. What files need to change? Think hard about this."
3. "Implement the solution. Verify reasonableness as you go."
4. "Commit the result and create a pull request"

**Custom slash commands** create reusable prompt templates. Store as markdown in `.claude/commands/`:

```markdown
# .claude/commands/fix-issue.md
---
description: Fix a GitHub issue
---

Analyze and fix GitHub issue: $ARGUMENTS

1. Use `gh issue view` to get details
2. Search codebase for relevant files
3. Implement changes
4. Write and run tests
5. Create PR
```

Usage: `/project:fix-issue 1234`

**System prompt customization** works through multiple methods: CLAUDE.md files (recommended, persistent), `--append-system-prompt` flag (session only), output styles stored in `~/.claude/output-styles/`, or programmatically via the Agent SDK.

---

## Plugins expand Claude Code's capabilities

Plugins bundle commands, agents, skills, hooks, and MCP servers into shareable packages. The standard structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required metadata
├── commands/                 # Custom slash commands
├── agents/                   # Custom agents
├── skills/                   # Agent Skills
├── hooks/hooks.json          # Event handlers
└── .mcp.json                 # MCP config
```

**Install plugins** via the interactive menu (`/plugin`) or directly: `/plugin install formatter@your-org`. Enable/disable with `/plugin enable plugin-name@marketplace-name`.

**Popular plugins** include code-review (automated PR review with confidence scoring), pr-review-toolkit (comprehensive review agents), frontend-design (production-grade UI generation), and security-guidance (vulnerability reminder hooks). Community directories like claudemarketplaces.com aggregate available plugins.

---

## Advanced workflows and integrations

### Multi-file editing and refactoring

Claude Code excels at coordinated changes across multiple files. For complex refactoring, start with exploration ("read the authentication module and understand how sessions work"), then plan ("think hard about how to refactor this for OAuth2"), then implement incrementally with verification at each step.

**Git integration** handles commits, branches, PRs, and conflict resolution:
```bash
claude "What files have I changed?"
claude "Commit with a descriptive message"
claude "Create a PR for my changes"
claude "Help me resolve merge conflicts"
```

### Testing integration

Test-driven development works exceptionally well—have Claude write tests first, confirm they fail, then implement code to pass:
```bash
claude "Write tests for the payment processor based on these requirements"
# Run tests, confirm failures
claude "Make the tests pass"
```

### CI/CD and headless mode

Headless mode (`-p` flag) enables non-interactive automation:

```yaml
# GitHub Actions example
- name: AI Code Review
  run: |
    claude -p "Review changes for security issues" \
      --allowedTools "Read,Grep" \
      --output-format json > review.json
```

Key flags: `--output-format` (text, json, stream-json), `--allowedTools`, `--max-turns`, `--continue` (resume conversation), `--mcp-config` (load MCP servers).

### Claude Agent SDK for programmatic control

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Fix the bug in auth.py",
  options: {
    allowedTools: ["Read", "Write", "Edit", "Bash"],
    permissionMode: "bypassPermissions",
    maxTurns: 250
  }
})) {
  if (message.type === "text") console.log(message.content);
}
```

---

## Security best practices and common pitfalls

**Never commit API keys**—use environment variables and add `.env` to `.gitignore`. Configure Claude to deny access to sensitive files:

```json
{
  "permissions": {
    "deny": ["Read(.env*)", "Read(./secrets/**)", "Bash(curl:*)", "Bash(wget:*)"]
  }
}
```

**Use sandboxing** for sensitive work—activate with `/sandbox` for filesystem and network isolation. For enterprise deployments, use Amazon Bedrock or Google Vertex AI to process within existing cloud security boundaries.

**Common pitfalls to avoid:**
- Skipping planning—always ask for a plan before complex tasks
- Vague prompts—"make this better" fails; "refactor to improve readability and add inline comments" succeeds
- Ignoring context limits—use `/clear` between unrelated tasks
- Over-reliance without review—always verify security-critical changes

---

## Troubleshooting common issues

**Installation problems:**

| Issue | Solution |
|-------|----------|
| Permission denied | Use native installer: `curl -fsSL https://claude.ai/install.sh \| bash` |
| Command not found | Add npm global bin to PATH |
| WSL detection errors | Run `npm config set os linux` before install |

**Runtime errors:**

| Error | Solution |
|-------|----------|
| `overloaded_error` | Switch to Sonnet model or wait briefly |
| `Context window exceeded` | Use `/clear` or `/compact` |
| `Rate limit exceeded` | Wait for specified time |

**Quick diagnostics:**
```bash
claude --version          # Check installation
claude doctor             # Health check
/clear                    # Reset context (inside Claude Code)
```

**Getting help:** Use `/bug` to report issues directly to Anthropic with full context. Check GitHub Issues at github.com/anthropics/claude-code. Community resources include r/ClaudeAI (430k+ members) and ClaudeLog.com.

---

## Conclusion

Claude Code transforms AI-assisted development from suggestion-based autocomplete into genuine autonomous coding capability. The key to mastery lies in understanding its agentic nature—plan before coding, manage context aggressively, leverage CLAUDE.md for persistent project knowledge, and use the appropriate permission mode for each task.

Start with interactive mode to learn Claude's capabilities, graduate to auto-accept for trusted workflows, and eventually integrate headless mode into CI/CD pipelines. The combination of MCP servers for external integrations, Skills for specialized tasks, and plugins for team workflows creates an extensible system that adapts to virtually any development environment.

The most effective users treat Claude Code as a capable junior engineer with excellent pattern recognition but short-term memory—give clear instructions, verify outputs through tests, and commit frequently to create natural checkpoints. With this mental model and the techniques covered in this guide, you're equipped to leverage Claude Code's full potential across your development workflow.