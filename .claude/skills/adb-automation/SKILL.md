---
name: adb-automation
description: ADB shell commands for Android device automation. Use when implementing tap, swipe, text input, screencap, key events, or any adb shell interaction. Triggers on ADB, adb shell, input tap, input swipe, input text, screencap, keyevent.
---

# ADB Automation Patterns

## Safety Rules

- ALWAYS sanitize inputs before passing to `adb shell`
- Use `spawn` with argument arrays, NEVER `exec` with string interpolation
- Every command must have a timeout (default 30s)
- Validate coordinates are integers, text is escaped, keycodes are allowlisted

## Core Commands

### Tap
```typescript
// Safe: argument array, no interpolation
spawn('adb', ['shell', 'input', 'tap', String(x), String(y)]);
```

### Swipe (Scroll)
```typescript
// direction-based swipe with duration
spawn('adb', ['shell', 'input', 'swipe', String(x1), String(y1), String(x2), String(y2), String(durationMs)]);
```

### Text Input
```typescript
// Escape special characters for adb shell
const escaped = text.replace(/([&|;<>$`\\!"'()\s])/g, '\\$1');
spawn('adb', ['shell', 'input', 'text', escaped]);
```

### Screenshot
```typescript
// Pipe output, no shell redirect
const proc = spawn('adb', ['exec-out', 'screencap', '-p']);
proc.stdout.pipe(fs.createWriteStream(outputPath));
```

### Key Event
```typescript
const ALLOWED_KEYS = ['KEYCODE_HOME', 'KEYCODE_BACK', 'KEYCODE_ENTER', ...];
if (!ALLOWED_KEYS.includes(keycode)) throw new Error('Disallowed keycode');
spawn('adb', ['shell', 'input', 'keyevent', keycode]);
```

## Device Targeting

```typescript
// Target specific device with -s flag
spawn('adb', ['-s', serial, 'shell', 'input', 'tap', String(x), String(y)]);
```

## References

- https://developer.android.com/tools/adb
- `adb shell input` accepts: tap, swipe, text, keyevent, draganddrop
