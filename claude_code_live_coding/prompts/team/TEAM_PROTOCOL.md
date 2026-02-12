# Agent Team Protocol

> Guide for coordinating Claude Code agent teams. Teams consist of independent Claude Code instances with shared task lists and inter-agent messaging.

## When to Use Agent Teams vs Subagents

| Scenario | Use |
|----------|-----|
| Parallel code review (security + quality + tests) | **Agent Team** |
| Debugging with competing hypotheses | **Agent Team** |
| Cross-layer feature (device controller + executor + tests) | **Agent Team** |
| Research from multiple angles | **Agent Team** |
| Quick focused task (run tests, search code) | **Subagent** |
| Single-domain work with summary back | **Subagent** |

## Team Composition Templates

### Feature Development (3-4 teammates)

Best for new features spanning multiple layers of the automation service.

```
Create an agent team for implementing [feature]:
- Backend teammate: owns src/ application files. Implements CLI entry, config, instruction parsing, and action execution using Node.js + TypeScript.
- Automation teammate: owns src/device/ and src/cdp/ files. Implements ADB wrappers and Chrome DevTools Protocol client. All shell inputs must be sanitized.
- Test teammate: owns test files only. Writes unit tests (Vitest) with mock ADB responses and integration tests for the feature.
Require plan approval before any teammate makes changes.
```

### Code Review (3 teammates)

Best for thorough parallel review of a PR or feature.

```
Create an agent team to review [PR/feature]:
- Quality reviewer: checks code quality, TypeScript strict mode, patterns, and readability.
- Security reviewer: checks for shell injection in ADB commands, input validation, and command sanitization.
- Test reviewer: validates test coverage, edge cases, and mock ADB scenarios.
Have them share findings and challenge each other's assessments.
```

### Debugging (3-5 teammates)

Best when root cause is unclear and multiple hypotheses exist.

```
Create an agent team to investigate [bug/issue]:
- Spawn 3-5 teammates, each investigating a different hypothesis.
- Have them discuss findings and try to disprove each other's theories.
- Update findings with whatever consensus emerges.
```

### Research & Analysis (2-3 teammates)

Best for exploring a problem from different angles.

```
Create an agent team to research [topic]:
- Technical researcher: explores implementation options, evaluates libraries, and checks feasibility.
- Domain researcher: investigates best practices, documentation, and prior art.
Have them share findings and synthesize recommendations.
```

## File Ownership Rules

Two teammates editing the same file causes overwrites. Follow these boundaries:

| Teammate Role | Owns | Does NOT Touch |
|---------------|------|----------------|
| Backend dev | `src/index.ts`, `src/parser/**`, `src/executor/**` | device/cdp/emulator files |
| Automation eng | `src/device/**`, `src/cdp/**` | parser/executor files |
| DevOps eng | `src/emulator/**`, `.github/**`, CI configs | application logic |
| Test writer | `tests/**/*.test.ts`, `tests/**/*.spec.ts` | source files |
| Schema/types | `src/types/**`, `src/schemas/**` | implementation files |

If two teammates need the same file, have one finish first using task dependencies.

## Task Sizing

- **5-6 tasks per teammate** keeps everyone productive
- Each task should produce a **clear deliverable** (a function, a test file, an ADB wrapper)
- Tasks should be **self-contained** - completable without waiting on other teammates
- Use **task dependencies** when ordering matters (e.g., "ADB tap wrapper" must finish before "integration test for tap")

### Good task examples:
- "Implement ADB tap/swipe wrapper with input sanitization in src/device/adb.ts"
- "Create Zod schema for instruction file validation in src/parser/schema.ts"
- "Write unit tests for action executor retry logic"

### Bad task examples (too vague or too large):
- "Build the automation service" (too large)
- "Fix things" (too vague)
- "Implement the feature" (no clear deliverable)

## Quality Gates

### Require Plan Approval for Risky Work

Tell the lead to require plan approval for teammates doing:
- ADB command construction changes
- Shell execution patterns
- Emulator lifecycle modifications
- Instruction schema changes

```
Spawn an architect teammate to redesign the device controller layer.
Require plan approval before they make any changes.
Only approve plans that sanitize all ADB inputs and enforce timeouts.
```

### TaskCompleted Hook

The `TaskCompleted` hook in `settings.json` runs when any task is marked complete. It logs completion for audit. Extend `.claude/scripts/validate-task-completion.sh` to add stricter validation (exit code 2 blocks completion).

### TeammateIdle Hook

The `TeammateIdle` hook runs when a teammate finishes and is about to go idle. It logs via `notify-completion.sh`. Exit code 2 sends feedback and keeps the teammate working.

## Team Lead Guidelines

### Use Delegate Mode

Press **Shift+Tab** to enable delegate mode, which restricts the lead to coordination-only: spawning teammates, messaging, managing tasks. This prevents the lead from implementing tasks itself.

### Steer Actively

- Check in on teammate progress regularly
- Redirect approaches that aren't working
- Synthesize findings as they come in
- Don't let a team run unattended too long

### Handle Conflicts

When teammates disagree:
1. Have them document their positions via messages
2. The lead reviews both positions
3. The lead makes a binding decision with rationale
4. Domain authority: architecture decisions > security review > code quality > feature preferences

### Clean Up

When done:
1. Ask all teammates to shut down
2. Wait for each to confirm shutdown
3. Run cleanup: "Clean up the team"

## Project-Specific Constraints

All teammates automatically load CLAUDE.md and inherit these constraints:

- **ADB safety** - sanitize all inputs, no arbitrary shell execution, timeout all commands
- **TypeScript strict mode** - no `any` types
- **Zod validation** for all runtime validation (instruction files, config)
- **Biome** for linting and formatting
- **pino** for structured JSON logging

## Model Selection for Teammates

| Role | Recommended Model | Rationale |
|------|-------------------|-----------|
| Architecture/design decisions | Opus | Complex reasoning needed |
| Implementation (backend/automation) | Sonnet | Balanced capability and speed |
| Code review / quick feedback | Haiku | Fast iterations, lower cost |
| Research / analysis | Sonnet | Good reasoning at moderate cost |
| Test writing | Sonnet | Needs to understand code patterns |
