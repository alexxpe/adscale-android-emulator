# Validate Instruction Command

Validate an instruction JSON file against the Zod schema.

## Execution Flow

1. Read the instruction file provided as argument (or prompt for path)
2. Parse against the Zod schema in src/parser/schema.ts
3. Report validation results: valid actions, invalid actions with error details
4. For invalid files, suggest fixes based on the schema
5. If the build exists, run `node dist/index.js validate <file>` for runtime verification
