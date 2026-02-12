---
name: instruction-authoring
description: Author and validate JSON instruction files for the automation service. Use when creating new instruction files, defining action sequences, or troubleshooting instruction validation errors. Triggers on instruction file, action sequence, JSON schema, instruction format, write instruction.
---

# Instruction File Authoring

## Schema

```json
{
  "name": "required-string",
  "description": "optional description",
  "device": { "avd": "optional-avd-name", "serial": "optional-serial" },
  "timeout": 300000,
  "actions": [
    { "type": "action-type", ...params }
  ]
}
```

## Action Types

| Type | Required Fields | Optional Fields |
|------|----------------|-----------------|
| `navigate` | `url` | — |
| `scroll` | `direction` (up/down/left/right) | `amount` (pixels) |
| `click` | — | `selector`, `x`, `y` (need selector OR coordinates) |
| `type` | `text` | `selector` (if omitted, types via ADB) |
| `wait` | `ms` | — |
| `wait_for` | `selector` | `timeout` (ms) |
| `screenshot` | — | `path` (output file) |
| `assert` | `selector` | `contains`, `visible` |

## Example: Form Fill

```json
{
  "name": "login-form",
  "description": "Fill and submit a login form",
  "actions": [
    { "type": "navigate", "url": "https://example.com/login" },
    { "type": "wait_for", "selector": "#username", "timeout": 10000 },
    { "type": "click", "selector": "#username" },
    { "type": "type", "text": "testuser", "selector": "#username" },
    { "type": "click", "selector": "#password" },
    { "type": "type", "text": "pass123", "selector": "#password" },
    { "type": "click", "selector": "button[type=submit]" },
    { "type": "wait_for", "selector": ".dashboard", "timeout": 15000 },
    { "type": "assert", "selector": ".welcome", "contains": "Welcome" },
    { "type": "screenshot", "path": "output/login-success.png" }
  ]
}
```

## Validation

Run `node dist/index.js validate <file.json>` to check against the Zod schema.
