---
name: emulator-management
description: Android emulator and AVD lifecycle management. Use when starting, stopping, creating, or configuring Android emulators and virtual devices. Triggers on emulator, AVD, avdmanager, start emulator, stop emulator, boot complete, port forward.
---

# Emulator Management Patterns

## List Available AVDs

```bash
emulator -list-avds
```

## Start Emulator

```bash
# Headless (CI/server)
emulator -avd Pixel_6_API_34 -no-window -no-audio -gpu swiftshader_indirect -port 5554

# With display (development)
emulator -avd Pixel_6_API_34 -gpu host
```

## Wait for Boot Complete

```typescript
// Poll until sys.boot_completed = 1
async function waitForBoot(serial: string, timeoutMs = 120_000): Promise<void> {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    const result = await execAsync(`adb -s ${serial} shell getprop sys.boot_completed`);
    if (result.stdout.trim() === '1') return;
    await sleep(1000);
  }
  throw new Error(`Boot timeout after ${timeoutMs}ms`);
}
```

## Port Forwarding for CDP

```bash
# Forward Chrome DevTools port
adb -s emulator-5554 forward tcp:9222 localabstract:chrome_devtools_remote
```

## Stop Emulator

```bash
adb -s emulator-5554 emu kill
```

## Create AVD

```bash
echo "no" | avdmanager create avd \
  --name "Pixel_6_API_34" \
  --package "system-images;android-34;google_apis;x86_64" \
  --device "pixel_6" \
  --force
```

## Port Management

- Default emulator ports: 5554, 5556, 5558, ... (console ports)
- ADB ports: 5555, 5557, 5559, ...
- CDP forward ports: choose from 9222+ range, check availability first

## CI Setup (GitHub Actions)

```yaml
- uses: reactivecircus/android-emulator-runner@v2
  with:
    api-level: 34
    target: google_apis
    arch: x86_64
    script: pnpm test
```
