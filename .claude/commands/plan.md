# Plan Command

Analyze the request and create a step-by-step implementation plan before writing any code.

## Execution Flow

1. Restate the requirements clearly
2. Identify which layers are affected (Parser, Executor, Device Controller, CDP, Emulator Manager)
3. List the files that need to change with specific descriptions
4. Surface risks: security (shell injection), breaking changes, timeout implications
5. Estimate complexity and present the plan
6. **WAIT for explicit user confirmation before writing any code**

## Critical Constraint

Do NOT write code until the user says "yes", "proceed", or "go ahead".
