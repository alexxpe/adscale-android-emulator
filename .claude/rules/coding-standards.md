# Coding Standards

## TypeScript
- Strict mode enforced — zero `any` types
- Exhaustive switch/case for Action union types
- No floating promises — always await or handle
- Use `unknown` instead of `any` for external data, then validate with Zod

## Error Handling
- All external calls (ADB, CDP, filesystem) wrapped in try/catch
- Errors must include context: which action, which device, what was attempted
- Use custom error classes per layer: `ParseError`, `ExecutionError`, `DeviceError`, `EmulatorError`
- Graceful degradation: log and continue where possible, abort on critical failures

## Logging
- Use pino for all logging — no console.log
- Structured fields: `{ action, device, duration, result }`
- Log levels: error (failures), warn (retries), info (action start/complete), debug (ADB raw output)

## File Organization
- One module per directory under src/
- Each module has an index.ts that re-exports the public API
- Keep files under 400 lines, functions under 50 lines
- Types in src/types/, shared across modules

## Security
- No string interpolation in shell commands
- All ADB inputs go through src/device/sanitize.ts
- Command allowlists enforced — no arbitrary shell execution
- Timeouts on everything: 30s per action, 120s per boot, 5min per instruction file
