# Phase 2: Implementation - Android Emulator Browser Automation Service

> **YOU ARE THE TEAM LEAD. CREATE AN AGENT TEAM FOR IMPLEMENTATION.**
> **Team structure -> Install deps -> Build & verify -> Monitor -> Coordinate fixes -> Deliver production-ready service**
> **Enable delegate mode (Shift+Tab) to focus on orchestration only.**

---

## APPLICATION VISION

This is a **Node.js service for automating browser interactions on Android emulators**. It reads structured JSON instruction files and executes them as native actions (scroll, click, type) on a Chrome browser running inside an Android emulator. The architecture has **4 layers**:

```
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 1: CLI ENTRY + INSTRUCTION PARSER                            │
│  CLI argument parsing, instruction file loading, Zod validation     │
│  JSON schema enforcement, action normalization                      │
├─────────────────────────────────────────────────────────────────────┤
│  LAYER 2: ACTION EXECUTOR                                           │
│  Step sequencer with retry/timeout, event emission                  │
│  Action dispatch to Device Controller or CDP Controller             │
│  Structured logging of each step result                             │
├─────────────────────────────────────────────────────────────────────┤
│  LAYER 3: DEVICE CONTROLLER (ADB + CDP)                             │
│  ADB: tap, swipe, text input, screencap, key events                │
│  CDP: DOM queries, click by selector, navigate, evaluate JS        │
│  Input sanitization on all ADB shell commands                       │
├─────────────────────────────────────────────────────────────────────┤
│  LAYER 4: EMULATOR MANAGER                                          │
│  AVD lifecycle: detect, start, stop, create                        │
│  Port management: adb forward for CDP                               │
│  Health checks: device ready, boot complete, Chrome launched        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## INSTRUCTION SCHEMA (TypeScript Interface)

```typescript
interface InstructionFile {
  name: string;
  description?: string;
  device?: { avd?: string; serial?: string };
  timeout?: number; // global timeout in ms
  actions: Action[];
}

type Action =
  | { type: 'navigate'; url: string }
  | { type: 'scroll'; direction: 'up' | 'down' | 'left' | 'right'; amount?: number }
  | { type: 'click'; selector?: string; x?: number; y?: number }
  | { type: 'type'; text: string; selector?: string }
  | { type: 'wait'; ms: number }
  | { type: 'wait_for'; selector: string; timeout?: number }
  | { type: 'screenshot'; path?: string }
  | { type: 'assert'; selector: string; contains?: string; visible?: boolean };
```

---

## CRITICAL RULES

1. **ADB SAFETY** - Sanitize ALL inputs before passing to `adb shell`. Never use string interpolation for shell commands. Use allowlisted command patterns only.
2. **TIMEOUT EVERYTHING** - Every ADB command and CDP call must have a timeout. Default: 30s per action, 5min per instruction file.
3. **STRUCTURED LOGGING** - Use pino for all logging. Every action execution must log: action type, start time, duration, result (success/failure), error details.
4. **NO ARBITRARY SHELL EXEC** - Never expose raw shell execution. All ADB interactions go through typed wrapper functions.
5. **Context Limits**: Use Sonnet model for teammates, keep file reads minimal.

---

## Step 1: Create Implementation Team

Create an agent team for implementing the complete automation service:

```
Create an agent team called "implementation-phase" with 10 teammates to build the Android Emulator Browser Automation Service:

**Core Infrastructure Team:**
1. backend-core (backend-dev, Sonnet): Build project structure and CLI entry point
   - Task: Create package.json, tsconfig.json, tsup.config.ts, src/index.ts (CLI with commander)
   - Implement config loading, argument parsing, pino logger setup
   - Include health check command: `node dist/index.js --help`

2. instruction-parser (backend-dev, Sonnet): Build instruction file parser
   - Task: Create src/parser/ with Zod schemas matching the InstructionFile interface
   - Implement validation, normalization, error messages for invalid instructions
   - Support loading from file path or stdin

3. action-executor (backend-dev, Sonnet): Build action step sequencer
   - Task: Create src/executor/ with sequential action runner
   - Implement retry logic (configurable retries per action), per-action timeout
   - Event emission for progress tracking, structured result logging

4. device-controller (automation-engineer, Sonnet): Build ADB wrapper layer
   - Task: Create src/device/ with typed ADB commands
   - Implement: tap(x,y), swipe(x1,y1,x2,y2), inputText(text), screencap(path), keyEvent(code)
   - ALL inputs must be sanitized - no shell injection possible
   - Every command has a timeout

5. cdp-controller (automation-engineer, Sonnet): Build Chrome DevTools Protocol client
   - Task: Create src/cdp/ with chrome-remote-interface wrapper
   - Implement: navigate(url), querySelector(sel), click(sel), type(sel, text), evaluate(js)
   - Manage CDP connection lifecycle (connect/disconnect/reconnect)

6. emulator-manager (devops-engineer, Sonnet): Build emulator lifecycle management
   - Task: Create src/emulator/ with AVD detection, start, stop, port forwarding
   - Implement boot-complete detection, Chrome launch verification
   - Handle multiple emulator instances with port management

**Quality Team:**
7. qa-engineer (qa-engineer, Sonnet): Test suite with Vitest
   - Task: Create tests/ with unit tests for parser, executor, device controller
   - Mock ADB responses for testing without real device
   - Output: automation_reports/QA-PHASE2.json (<3KB)

8. tech-lead (tech-lead, Sonnet): Code review
   - Task: Review TypeScript strict mode compliance, async/await patterns, error handling
   - Verify pino logging is consistent across all modules
   - Output: automation_reports/TL-PHASE2.json (<3KB)

9. security-reviewer (security-reviewer, Sonnet): Security audit
   - Task: Audit all ADB command construction for shell injection
   - Verify input sanitization on device-controller and cdp-controller
   - Flag any use of exec() without sanitization, any string interpolation in shell commands
   - Output: automation_reports/SEC-PHASE2.json (<3KB)

10. bug-hunter (bug-hunter, Sonnet): Bug detection
    - Task: Find unhandled promise rejections, missing timeouts, race conditions
    - Check for missing error handling on ADB disconnects, CDP connection drops
    - Output: automation_reports/BUG-PHASE2.json (<3KB)

**CRITICAL CONSTRAINTS for all teammates:**
- ADB safety: sanitize all inputs, timeout all commands
- Keep context small - minimal file reads
- Structured logging with pino for all operations
- No arbitrary shell execution - typed wrappers only

After completing initial tasks, teammates should check shared task list for additional work.
```

---

## Step 2: Install and Build

After teammates complete setup files, install and build the application:

```bash
# Wait for package.json
while [ ! -f "package.json" ]; do
  sleep 30
done

# Install, build, and verify
pnpm install && pnpm build && node dist/index.js --help && adb devices
```

---

## Step 3: Monitor Progress Through Team Coordination

### Check Shared Task List
Press Ctrl+T to view the team's shared task list and see:
- Which tasks are in progress
- Which teammates are working on what
- Which tasks are completed
- Any blocked tasks waiting on dependencies

### Message Teammates Directly
If you need status updates or want to redirect work:
- Use Shift+Up/Down (in-process mode) or click panes (split mode) to message teammates
- Teammates send messages automatically when they complete work or need help
- Messages are delivered automatically - no polling needed

### Verify All 4 Layers Work

Check each layer is functional:
```bash
# Layer 1: Parser validates instruction files
node dist/index.js validate instructions/examples/test.json

# Layer 2: Executor runs a simple instruction (with emulator running)
node dist/index.js run instructions/examples/test.json --dry-run

# Layer 3: Device controller can reach ADB
node dist/index.js devices

# Layer 4: Emulator manager can list AVDs
node dist/index.js avds
```

---

## Step 4: Coordinate Bug Fixes

If teammates report bugs or tests fail:

1. **Assign fix tasks** through the shared task list
2. **Message specific teammates** to handle their domain's issues
3. **Re-run QA** after fixes are applied
4. **Don't fix bugs yourself** - you're the coordinator

---

## Step 5: Completion Checklist

### Layer 1 - Instruction Parser:
- [ ] Zod schema validates all 8 action types
- [ ] Invalid instructions produce clear error messages
- [ ] File loading works from path argument

### Layer 2 - Action Executor:
- [ ] Sequential execution of action list
- [ ] Retry logic works (configurable per action)
- [ ] Per-action timeout triggers on slow commands
- [ ] Structured logging for each step

### Layer 3 - Device Controller:
- [ ] ADB tap/swipe/text/screencap work on emulator
- [ ] CDP navigate/click/type work in Chrome
- [ ] All inputs sanitized (no shell injection)
- [ ] All commands have timeouts

### Layer 4 - Emulator Manager:
- [ ] AVD detection lists available devices
- [ ] Emulator start/stop lifecycle works
- [ ] Port forwarding for CDP established
- [ ] Boot-complete detection works

### Quality Gates:
- [ ] All 10 teammates completed their tasks
- [ ] Zero P0 bugs
- [ ] Security audit passed (no shell injection)
- [ ] All Vitest tests pass

---

## Step 6: Team Cleanup

When all work is complete:

1. **Shut down all teammates gracefully:**
   ```
   Ask each teammate to shut down: backend-core, instruction-parser, action-executor,
   device-controller, cdp-controller, emulator-manager, qa-engineer, tech-lead,
   security-reviewer, bug-hunter
   ```

2. **Clean up team resources:**
   ```
   Clean up the implementation-phase team
   ```

---

## Final Discord Notification

```
Send Discord embed:
Title: "ANDROID AUTOMATION SERVICE BUILT"
Description: "Node.js Android Emulator Browser Automation Service implemented"
Fields:
  - Layer 1: Instruction Parser with Zod validation
  - Layer 2: Action Executor with retry/timeout
  - Layer 3: ADB + CDP Device Controllers
  - Layer 4: Emulator Manager with AVD lifecycle
  - Actions: navigate, scroll, click, type, wait, wait_for, screenshot, assert
Color: green
```

---

**START NOW:**
1. Create the implementation-phase agent team with 10 teammates
2. Enable delegate mode (Shift+Tab) to prevent doing implementation work yourself
3. Monitor team progress through shared task list and teammate messages
4. Coordinate fixes if needed
5. Verify all 4 layers work
6. Shut down team when complete
