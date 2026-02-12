## Test All MCP Connections

Test each MCP server to verify it is connected and working correctly.

### 1. Shell MCP
Run `adb devices` via the shell MCP to verify ADB is accessible and list connected emulators/devices.

### 2. Filesystem MCP
List files in `./instructions` directory and read any existing instruction file to verify filesystem access.

### 3. Memory MCP
Store a test emulator session state (e.g., `{"device": "emulator-5554", "status": "running", "avd": "Pixel_6_API_34"}`) and then retrieve it to verify memory persistence works.

### 4. Fetch MCP
Fetch the ADB command reference page at https://developer.android.com/tools/adb to verify web fetching works.

### 5. Playwright MCP
Open a new browser and navigate to `chrome://inspect/#devices`, wait until the page finishes loading, to verify Playwright can launch and control a browser instance.
