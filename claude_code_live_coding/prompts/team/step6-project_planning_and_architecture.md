# Phase 1: Planning & Architecture - Team Lead Orchestrator

> **YOU ARE THE TEAM LEAD. CREATE AN AGENT TEAM AND COORDINATE WORK THROUGH SHARED TASKS.**

## Pre-Flight
1. Read `.claude/CLAUDE.md` (ADB safety constraints, 4-layer architecture)
2. Confirm MCPs: `mcp__shell__*`, `mcp__filesystem__*`, `mcp__memory__*`
3. Enable delegate mode (press Shift+Tab) to prevent doing implementation work yourself

---

## Agent Team Roster (8 TEAMMATES)

| Teammate | Agent Type | Output |
|----------|------------|--------|
| architect | system-architect | `ARCH-001.json` |
| backend-dev | backend-dev | `BD-001.json` |
| automation-eng | automation-engineer | `AE-001.json` |
| devops-eng | devops-engineer | `DEVOPS-001.json` |
| product-mgr | product-manager | `PM-001.json` |
| tech-lead | tech-lead | `TL-001.json` |
| bug-hunter | bug-hunter | `BUG-001.json` |
| security-reviewer | security-reviewer | `SEC-001.json` |

**All outputs -> `automation_reports/`**

---

## CRITICAL: Output Size Limits

**ALL AGENTS MUST:**
- Keep JSON output files under 10KB
- **READ MAX 3 FILES TOTAL** - entire agent session should read no more than 3 files
- **DO NOT read CLAUDE.md** - use your knowledge instead
- **DO NOT read .mcp.json** - just use the MCP tools directly
- Summarize findings instead of including raw data
- Focus on actionable insights, not exhaustive lists
- Generate outputs from KNOWLEDGE, not by reading files

---

## Orchestration Steps

### 1. Create Agent Team

Create an agent team with 8 teammates working on planning and architecture in parallel:

```
Create an agent team called "planning-phase" with 8 teammates to handle project planning and architecture:

**Team Structure:**
- architect (system-architect, Opus): Design 4-layer architecture (CLI -> Parser -> Executor -> Device Controller -> Emulator Manager) from knowledge. Output: ARCH-001.json <10KB
- backend-dev (backend-dev, Sonnet): Define project structure, CLI entry point, config management, TypeScript build setup. Output: BD-001.json <10KB
- automation-eng (automation-engineer, Sonnet): Define ADB action primitives (tap, swipe, text, screencap) and CDP browser actions. Output: AE-001.json <10KB
- devops-eng (devops-engineer, Sonnet): Define emulator lifecycle management (AVD create/start/stop/delete, port forwarding). Output: DEVOPS-001.json <10KB
- product-mgr (product-manager, Sonnet): Define instruction file JSON schema, action catalog, and error reporting format. Output: PM-001.json <5KB
- tech-lead (tech-lead, Opus): Define TypeScript standards, async patterns, error handling, and structured logging guidelines. Output: TL-001.json <5KB
- bug-hunter (bug-hunter, Sonnet): Document common ADB automation bug patterns (timing, device disconnects, stale selectors). Output: BUG-001.json <5KB
- security-reviewer (security-reviewer, Sonnet): Create shell injection prevention checklist, input sanitization rules, ADB command allowlist. Output: SEC-001.json <5KB

**CRITICAL CONSTRAINTS for all teammates:**
- Output JSON files MUST be under 10KB (5KB for review agents)
- READ MAX 3 FILES TOTAL per teammate session
- DO NOT read CLAUDE.md or .mcp.json - use your knowledge
- Generate content from EXPERTISE, not file reads
- Use MCP tools DIRECTLY without reading config files

**Working Directory:** All outputs go to automation_reports/

Each teammate should check the shared task list after completion to find their next task.
```

### 2. Monitor Team Progress

After creating the team, enable delegate mode (Shift+Tab) to prevent doing work yourself. Monitor teammates through:
- Check task list progress periodically (Ctrl+T)
- Teammates will send messages when they complete tasks or need help
- Messages are delivered automatically - no need to poll

### 3. Coordinate Through Shared Task List

The team has a shared task list at `~/.claude/tasks/planning-phase/`. Teammates will:
- Self-claim unassigned tasks in ID order
- Mark tasks completed when done
- Create new tasks if they discover additional work
- Message each other if they need collaboration

You can assign specific tasks to teammates if needed using TaskUpdate.

### 4. Handle Teammate Issues

If a teammate goes idle without completing their task:
1. Message them directly to check status
2. If blocked, help resolve the blocker or reassign the task
3. If stuck, spawn a replacement teammate

If you see "prompt too large" errors:
1. Check which teammate's context is overflowing
2. Message them to use fewer file reads
3. Consider shutting them down and spawning a replacement with stricter constraints

---

## Teammate Spawn Guidance

When the team is created, Claude will spawn teammates with prompts similar to these:

### Creation Teammates (architect, backend-dev, automation-eng, devops-eng, product-mgr)

**Spawn prompt format:**
```
You are {teammate-name} on the planning-phase team. Your task: {specific task}.

CRITICAL CONSTRAINTS:
- Output JSON file MUST be under 10KB
- READ MAX 3 FILES TOTAL - your entire session should read no more than 3 files
- DO NOT read CLAUDE.md or .mcp.json - use your knowledge
- Use MCP tools DIRECTLY without reading config files first
- Generate content from your EXPERTISE, not file reads
- After completing your task, check the shared task list for next work

OUTPUT: automation_reports/{ARTIFACT-ID}.json

When done, mark your task completed and check for next available task on the shared list.
```

### Review Teammates (tech-lead, bug-hunter, security-reviewer)

**Spawn prompt format:**
```
You are {teammate-name} on the planning-phase team. Your task: {specific task}.

CRITICAL CONSTRAINTS:
- READ ZERO FILES - generate entirely from knowledge
- DO NOT read automation_reports/*.json files
- DO NOT read source files
- DO NOT read CLAUDE.md or config files
- Define your standards/checklists from EXPERTISE
- Output JSON file MUST be under 5KB
- After completing your task, check the shared task list for next work

OUTPUT: automation_reports/{ARTIFACT-ID}.json

When done, mark your task completed and check for next available task on the shared list.
```

---

## Discord Milestone
```json
{"title": "PHASE 1: {pct}%", "fields": [{"name": "architect", "value": "██████░░░░ 60%", "inline": true}, {"name": "Tasks", "value": "5/8 completed"}]}
```

---

## Completion Criteria
- [ ] All 8 JSON artifacts in `automation_reports/` (each <10KB)
- [ ] Discord updates at 20/40/60/80/100%
- [ ] All tasks in shared task list marked completed

## Team Cleanup

When all work is complete:

1. **Shut down all teammates gracefully:**
   ```
   Ask each teammate to shut down: architect, backend-dev, automation-eng, devops-eng,
   product-mgr, tech-lead, bug-hunter, security-reviewer
   ```

2. **Clean up team resources:**
   ```
   Clean up the planning-phase team
   ```

## Handoff
```json
{"from": "Team Lead", "to": "Phase 2", "team": "planning-phase", "artifacts": ["ARCH-001", "BD-001", "AE-001", "DEVOPS-001", "PM-001", "TL-001", "BUG-001", "SEC-001"], "ready": true}
```

---

**START: Create the agent team with the structure above. Enable delegate mode (Shift+Tab) to focus on coordination only.**
