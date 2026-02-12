# Security Audit Command

Perform a security audit focused on shell injection and process safety.

## Execution Flow

1. Grep for all `exec(`, `spawn(`, `execFile(` calls in src/
2. For each call, trace input sources to check for user-controlled data
3. Verify src/device/sanitize.ts is used before all ADB shell commands
4. Check for string interpolation in any shell command construction
5. Verify all child_process calls have timeouts
6. Check that command allowlists are enforced
7. Report findings as P0 (critical) / P1 (high) / P2 (medium)
