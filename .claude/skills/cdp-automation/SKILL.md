---
name: cdp-automation
description: Chrome DevTools Protocol automation via chrome-remote-interface for browser control on Android. Use when implementing navigate, DOM queries, click by selector, type into elements, evaluate JavaScript, or manage CDP connections. Triggers on CDP, DevTools, chrome-remote-interface, selector, DOM, evaluate, navigate.
---

# Chrome DevTools Protocol Patterns

## Connection Setup

```typescript
import CDP from 'chrome-remote-interface';

// First, forward the port via ADB
// adb forward tcp:9222 localabstract:chrome_devtools_remote

const client = await CDP({ host: '127.0.0.1', port: 9222 });
const { Page, Runtime, DOM, Input } = client;

await Page.enable();
await DOM.enable();
await Runtime.enable();
```

## Important: Android Chrome Caveat

Chrome on Android does NOT expose its own protocol descriptor. You must either:
- Use `local: true` option in chrome-remote-interface
- Or specify a local protocol JSON file

## Core Actions

### Navigate
```typescript
await Page.navigate({ url });
await Page.loadEventFired(); // wait for load
```

### Query Selector
```typescript
const { root } = await DOM.getDocument();
const { nodeId } = await DOM.querySelector({ nodeId: root.nodeId, selector });
```

### Click by Selector
```typescript
const { model } = await DOM.getBoxModel({ nodeId });
const x = (model.content[0] + model.content[2]) / 2;
const y = (model.content[1] + model.content[5]) / 2;
await Input.dispatchMouseEvent({ type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
await Input.dispatchMouseEvent({ type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
```

### Type Text
```typescript
for (const char of text) {
  await Input.dispatchKeyEvent({ type: 'keyDown', text: char });
  await Input.dispatchKeyEvent({ type: 'keyUp', text: char });
}
```

### Evaluate JavaScript
```typescript
const { result } = await Runtime.evaluate({ expression: 'document.title' });
```

## Connection Lifecycle

```typescript
// Always disconnect on cleanup
process.on('SIGINT', async () => {
  await client.close();
  process.exit();
});
```

## References

- https://chromedevtools.github.io/devtools-protocol/
- Domains used: Page, DOM, Input, Runtime, Network
