# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a **Claude Code live coding workshop/playbook** — a collection of structured prompts, reference guidelines, and orchestration templates for building a **Node.js Android Emulator Browser Automation Service** using multi-agent Claude Code teams.

There is no application source code in this repo. The contents are prompt engineering assets and Claude Code feature documentation used to drive a multi-phase build process.

## Repository Structure

```
claude_code_live_coding/
├── claude_code_guidelines/   # Reference docs for Claude Code features
│   ├── PROMPT_WRITING_GUIDELINE.md  # Schema for writing multi-agent prompts
│   ├── claude_code_hooks.md         # Hooks lifecycle & usage
│   ├── claude_code_mcp.md           # MCP server configuration
│   ├── claude_code_memory.md        # Memory hierarchy (CLAUDE.md, rules, etc.)
│   ├── claude_code_plugin.md        # Plugin system
│   ├── claude_code_settings.md      # Settings reference
│   ├── claude_code_skills.md        # Skills (slash commands)
│   ├── claude_code_subagents.md     # Subagent architecture
│   ├── claude_code_teams.md         # Agent teams & teammates
│   ├── claude_code_progrematic.md   # Programmatic/SDK usage
│   └── deep_research_*.md           # Deep research prompts (Claude/Gemini/GPT)
├── links/                    # External resource links
└── prompts/                  # Sequential build prompts
    ├── step1  → Initialize repo, tech stack, .claude config
    ├── step2  → Enrich skills, agents, MCPs from external repos
    ├── step3  → MCP server setup (Playwright, Memory, Fetch, Filesystem, Shell)
    ├── step4  → Test MCP connections (Shell/ADB, Filesystem, Memory, Fetch, Playwright)
    ├── step5  → Define 8-agent team roster and interaction protocols
    └── team/  → Multi-phase agent team orchestration
        ├── step6  → Phase 1: Planning & Architecture (8 teammates)
        ├── step7  → Phase 2: Implementation (10 teammates)
        ├── step8  → Phase 3: QA, Fixes & Deployment
        ├── debug-agents.sh    → Debug script for agent context overflow
        └── TEAM_PROTOCOL.md   → Agent team coordination guide
```

## Target Application (Built by Prompts)

The prompts orchestrate building a **Node.js Android Emulator Browser Automation Service** with:
- **Tech stack**: Node.js v22 (LTS), TypeScript 5.7+ strict, tsup, pnpm, adbkit, chrome-remote-interface, Zod, Vitest, pino
- **Automation**: ADB shell commands for native input (scroll, click, type) + Chrome DevTools Protocol for browser-level actions
- **4-layer architecture**: CLI Entry + Instruction Parser → Action Executor → Device Controller (ADB + CDP) → Emulator Manager
- **Instruction engine**: JSON instruction files validated with Zod schemas, supporting 8 action types: `navigate`, `scroll`, `click`, `type`, `wait`, `wait_for`, `screenshot`, `assert`

## Key Constraints

- **ADB Safety** — sanitize ALL inputs before passing to `adb shell`, no arbitrary shell execution, timeout all commands (30s per action, 5min per instruction file)
- **No database, no frontend** — this is a CLI-driven Node.js service
- **Agent context limits**: teammates should read max 3 files, keep JSON outputs under 10KB (5KB for review agents)

## Multi-Phase Workflow

The prompts follow a strict sequential workflow:
1. **Deep Research** → Analyze requirements, verify tool compatibility
2. **PaLM (Plan/Architecture/Logic/Mode)** → Draft plan before any code
3. **Implementation** → Execute via agent teams with shared task lists

Agent teams use delegate mode (Shift+Tab) where the team lead coordinates but does not implement. Teammates self-claim tasks from shared task lists, communicate via messages, and produce JSON artifact reports to `automation_reports/`.

## MCP Servers (Configured in .mcp.json)

The project uses: `playwright`, `memory`, `fetch`, `filesystem`, `shell`

## Prompt Writing Convention

Multi-agent prompts follow the schema in `PROMPT_WRITING_GUIDELINE.md`: Header/Mission → Agent Roster (table format) → Constraints → Phased Steps → Discord Milestones → Completion Criteria → Handoff JSON.
