# Android Emulator Browser Automation Service

## Overview

Node.js CLI service that connects to Android emulators to perform native browser automation — scrolling, clicking, and typing — driven by structured JSON instruction files.

## Architecture (4 Layers)

```
CLI Entry (commander)
  → Instruction Parser (Zod validation)
    → Action Executor (sequencer with retry/timeout)
      → Device Controller
        ├── ADB Controller (adb shell input tap/swipe/text/screencap)
        └── CDP Controller (chrome-remote-interface for DOM-level actions)
      → Emulator Manager (AVD lifecycle, port forwarding, health checks)
```

## Tech Stack

| Category | Tool | Version |
|----------|------|---------|
| Runtime | Node.js | v22 LTS |
| Language | TypeScript | 5.7+ strict |
| Build | tsup | 8.x |
| Package Manager | pnpm | latest |
| ADB Interface | @devicefarmer/adbkit | 3.x |
| Browser Automation | chrome-remote-interface | 0.34.x |
| Validation | zod | 4.x |
| CLI Framework | commander | 14.x |
| Testing | vitest | 4.x |
| Logging | pino | 10.x |
| Linting | biome | latest |

## Action Types

The instruction engine supports 8 action types:
- `navigate` — open a URL in Chrome
- `scroll` — native ADB swipe (up/down/left/right)
- `click` — ADB tap by coordinates or CDP click by selector
- `type` — ADB text input or CDP type into element
- `wait` — static delay (ms)
- `wait_for` — wait for a CSS selector to appear (CDP)
- `screenshot` — ADB screencap to file
- `assert` — verify element exists, contains text, or is visible (CDP)

## Critical Safety Rules

1. **SANITIZE ALL ADB INPUTS** — Never use string interpolation for `adb shell` commands. Use allowlisted command patterns and validate all arguments (coordinates must be integers, text must be escaped).
2. **TIMEOUT EVERYTHING** — Every ADB command: 30s default. Every CDP call: 30s default. Every instruction file: 5min default. No operation runs unbounded.
3. **NO ARBITRARY SHELL EXEC** — All ADB interactions go through typed wrapper functions in `src/device/`. Never expose raw `child_process.exec()` with user input.
4. **STRUCTURED LOGGING** — Use pino for all logging. Every action logs: type, start time, duration, success/failure, error details.
5. **GRACEFUL SHUTDOWN** — Handle SIGINT/SIGTERM: disconnect CDP, stop emulators if started by us, flush logs.

## Project Structure

```
src/
├── index.ts              # CLI entry point (commander)
├── config.ts             # Configuration loading
├── types/                # Shared TypeScript types
│   └── index.ts
├── parser/               # Layer 1: Instruction Parser
│   ├── schema.ts         # Zod schemas for InstructionFile & Action
│   └── index.ts          # Parse, validate, normalize
├── executor/             # Layer 2: Action Executor
│   ├── sequencer.ts      # Step-by-step runner with retry/timeout
│   └── index.ts          # Action dispatch
├── device/               # Layer 3a: ADB Device Controller
│   ├── adb.ts            # Typed ADB wrappers (tap, swipe, text, screencap)
│   ├── sanitize.ts       # Input sanitization for shell commands
│   └── index.ts
├── cdp/                  # Layer 3b: CDP Browser Controller
│   ├── client.ts         # chrome-remote-interface wrapper
│   └── index.ts
└── emulator/             # Layer 4: Emulator Manager
    ├── avd.ts            # AVD detection, create, start, stop
    ├── ports.ts          # Port management for adb forward
    └── index.ts
tests/
├── parser/               # Unit tests for instruction parsing
├── executor/             # Unit tests for action sequencer
├── device/               # Unit tests with mock ADB
└── fixtures/             # Test instruction files
instructions/
└── examples/             # Example instruction files
output/                   # Screenshots, reports (gitignored)
automation_reports/       # Agent team artifacts (gitignored)
```

## ADB Connection to Chrome

```bash
# Forward Chrome DevTools on emulator to local port
adb -s emulator-5554 forward tcp:9222 localabstract:chrome_devtools_remote

# Connect via chrome-remote-interface
CDP({ host: '127.0.0.1', port: 9222 })
```

**Important:** Chrome on Android does not expose its own protocol descriptor. Use a local version of the protocol descriptor rather than fetching from the remote instance.

## MCP Servers

| Server | Purpose |
|--------|---------|
| shell | Run ADB commands, emulator management (allowlisted: adb, emulator, avdmanager, node, npx, pnpm) |
| filesystem | Read instruction files, write reports/screenshots |
| memory | Track emulator session state and execution progress |
| fetch | Retrieve ADB/CDP documentation |
| playwright | Verify browser automation results |

## Agent Context Limits

- Teammates read max 3 files per session
- JSON outputs under 10KB (5KB for review agents)
- Use Sonnet model for implementation teammates
- Use Opus for architecture decisions
- All outputs go to `automation_reports/`
