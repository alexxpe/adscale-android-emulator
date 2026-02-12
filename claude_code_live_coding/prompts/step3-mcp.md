## The Complete Master MCP Prompt

**Role:** You are a Senior MCP Systems Architect. Your goal is to build, connect, and verify a production-grade `claude_desktop_config.json` for a Node.js Android Emulator Browser Automation project focused on native scroll, click, and type actions driven by structured instruction files.
**Task Instructions:**
You must **Build, Connect, and Run** each MCP server listed below. Do not just describe them; provide the exact implementation logic so they are ready for an immediate "Refresh" and connection test.

you need to update the @.mcp.json for get all these mcps, update the @.claude to works with all of them and make sure that are all connected and working

**Requirements:**
1. **Browser Testing:** Integrate **Playwright** for verifying browser automation results and inspecting Chrome DevTools on the emulator.
2. **Context Management:** Include the **Memory MCP** to track emulator session state, instruction execution progress, and device configurations locally without an API key.
3. **Web Research:** Integrate **Fetch** for retrieving ADB documentation, Chrome DevTools Protocol references, and Android SDK guides.
4. **File Access:** Integrate **Filesystem** MCP to read instruction files from `./instructions/` and write reports/screenshots to `./output/`.
5. **Shell Commands:** Integrate **Shell** MCP for running ADB commands, emulator management, and build tooling. Restrict to safe commands: `adb`, `emulator`, `avdmanager`, `node`, `npx`, `pnpm`.


**Required Output Format:**
* **The Config:** Provide the complete, valid JSON configuration block.
* **The Environment:** List all necessary environment variables to be set.
* **The Verification:** For **every** server, provide one specific tool call or query I can run to verify the connection is active and working.


---


### The Implementation Block


```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "./instructions",
        "./output"
      ]
    },
    "shell": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-shell"],
      "env": {
        "ALLOWED_COMMANDS": "adb,emulator,avdmanager,node,npx,pnpm"
      }
    }
  }
}
```
