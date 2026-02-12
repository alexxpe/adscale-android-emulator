# Test Command

Run the project test suite and analyze results.

## Execution Flow

1. Run `pnpm test` to execute the full Vitest suite
2. If tests fail, analyze the failure output
3. Categorize failures: parsing errors, mock issues, timeout flakes, real bugs
4. For real bugs, identify the root cause and propose a fix
5. Report: total tests, passed, failed, coverage percentage
