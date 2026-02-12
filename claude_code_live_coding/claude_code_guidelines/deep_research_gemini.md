Here is the comprehensive prompt you requested, followed by the generated slide deck content based on the "Zero to Hero" research.

### The "Zero to Hero" Lecture Prompt

You can use this prompt to generate the presentation. It is engineered to force the AI to clarify the confusing terminology (Skills vs. Agents vs. Plugins) and use the roleplay format you requested.

**Role:** You are a Staff Engineer and Technical Lead at a top-tier tech company in January 2026. You are an expert in "Agentic Engineering" using Anthropic's Claude Code 2.1.

**Task:** Create a lecture slide deck for your team to take them from "Zero" (just installing the CLI) to "Hero" (building custom MCP servers and plugins).

**Requirements:**

1. **Structure:** 6-8 High-Impact Slides. For each slide, provide the *Visual* (what is on screen) and the *Speaker Notes* (what to say).
2. **The "Confusion Matrix":** Explicitly differentiate between **Skills**, **Agents**, **Plugins**, **Hooks**, and **Tasks**. Use a metaphor (e.g., "The RPG Character Sheet").
3. **The "Zero to Hero" Arc:** Start with basic setup/config, move to "Plan Mode" workflows, and end with MCP/Architecture.
4. **Interactive Roleplay Script:** The final section must be a script of a team meeting involving three characters:
* **Junior (Alex):** Uses Claude like a basic chatbot.
* **Senior (Sam):** Uses Plan Mode and Skills.
* **Architect (Jo):** Uses custom MCP servers, Plugins, and Teleportation.
* *Action:* They discuss a feature implementation where Jo shows them how to automate the boring parts using the latest 2026 features.



**Context:**

* Current Date: Jan 26, 2026.
* Tool Version: Claude Code 2.1.x / Opus 4.5.
* Key Features to Mention: Session Teleportation, Hot-reloadable Skills, Plan Mode (Shift+Tab), "Vibe Coding," and Enterprise SSO.

---

### Generated Slide Deck: "Architecting with Agents"

#### Slide 1: The Paradigm Shift

**Visual:**

* **Left Side (Old Way - 2024):** A browser window with ChatGPT. User copies code -> pastes to IDE -> fixes errors -> copies error back. Label: "The Copy-Paste Loop."
* **Right Side (New Way - 2026):** A terminal window running `claude`. The agent edits files, runs `npm test`, reads logs, and iterates. Label: "The Loop of Autonomy."
* **Headline:** Stop Chatting. Start Architecting.

**Speaker Notes:**
"Welcome, everyone. Most of you are still using AI as a 'Chatbot'—a smart search engine that lives in your browser. Today, we move to 'Agentic Coding.' With Claude Code 2.1, the AI lives in our terminal. It has hands. It can edit files, run shell commands, and fix its own mistakes. Your job is no longer to type code; your job is to review the *plans* for the code."

#### Slide 2: The "Confusion Matrix" (Terminology)

**Visual:**

* A table comparing the core components.
* **Metaphor:** "The RPG Character"

| Component | Metaphor | Technical Definition | Example |
| --- | --- | --- | --- |
| **Skill** | **The Spellbook** | A `SKILL.md` file in a folder. Teaches Claude *how* to do a specific task (procedure). | "How to create a database migration" |
| **Agent** | **The Specialist** | A sub-process with a specific persona and toolset. Consumes its own token budget. | "Security Auditor" or "Explore Agent" |
| **Plugin** | **The Equipment Pack** | A distributable zip/package containing Skills, Agents, and Rules. | "Onboarding-Pack-v2" (contains team linters & docs) |
| **MCP** | **The Senses** | A protocol connecting Claude to external data/tools (DBs, JIRA, Slack). | Connect to Postgres to run SQL queries safely. |
| **Tasks** | **The Quest Log** | A list of to-dos tracked in `tasks.md` or via `/tasks`. | "Refactor Auth" (broken down into 5 steps) |

**Speaker Notes:**
"This is where everyone gets stuck.

* **Skills** are passive instructions. If you want Claude to follow our commit message format, that's a Skill. 


* **Agents** are active workers. If you need to search the entire codebase for a bug, Claude spawns an 'Explore Agent' so it doesn't clutter your main context. 


* **Plugins** are how we share this. I've packaged our team's skills into a plugin you can install with one command." 



#### Slide 3: The Workflow – Plan vs. Act

**Visual:**

* **Screenshot 1:** `Shift+Tab` pressed once. Text: `⏵⏵ accept edits on` (Yolo Mode).
* **Screenshot 2:** `Shift+Tab` pressed twice. Text: `⏸ plan mode on` (Architect Mode).
* **Diagram:**
1. **Explore:** `claude "Why is the build failing?"` (Read-only)
2. **Plan:** `claude --permission-mode plan` -> Generates `PLAN.md`.
3. **Review:** Human reads `PLAN.md`.
4. **Execute:** Switch to Auto-Accept. "Execute Phase 1."



**Speaker Notes:**
"Stop letting the AI write code immediately. That is how you get spaghetti code.
**Best Practice:** Use **Plan Mode** (`Shift+Tab` x2). Ask Claude to analyze the repo and write a `PLAN.md`. You review the English text. If the plan is wrong, the code will be wrong. Only when the plan is approved do you switch to 'Auto-Accept' (Yolo Mode) to let it write the code. This separates the *Architecture* from the *Labor*." 

#### Slide 4: Connectivity – The Model Context Protocol (MCP)

**Visual:**

* Diagram showing Claude connected to a Database icon and a GitHub icon via "MCP."
* **Code Snippet:**
```json
"mcpServers": {
  "local-db": {
    "command": "docker",
    "args": ["run", "-i", "mcp/postgres", "postgresql://user:pass@localhost/db"]
  }
}

```



**Speaker Notes:**
"In 2026, we don't paste schemas into chat. We use MCP. By running a local MCP server, Claude can 'see' our database tables directly. It runs `describe_schema` before writing a SQL query, which guarantees the code works. This is the difference between guessing and engineering." 

#### Slide 5: Zero to Hero – The Setup Hierarchy

**Visual:**

* **Level 1 (Zero):** `brew install claude-code`. Manual auth.
* **Level 2 (User):** `~/.claude/config.json` with `alwaysThinkingEnabled: true`. 


* **Level 3 (Project):** `CLAUDE.md` in repo root defining style guides. 


* **Level 4 (Hero):** Custom `tasks.md` workflow + Session Teleportation (Desktop to Mobile). 



**Speaker Notes:**
"To be a Hero, you need **Session Teleportation**. Start a coding session on your desktop. Type `/teleport`. Pick it up on your iPad at the coffee shop via the web interface. The context, the uncommitted file edits—everything moves with you."

---

#### Slide 6: The "Zero to Hero" Roleplay

**(Script for three team members to read aloud)**

**Scene:** *The team is looking at a Jira ticket: "Migrate User Auth from Legacy SQL to Supabase."*

**Alex (Junior - Zero):** "Okay, I'll copy the `auth.js` file, paste it into the Claude window, and ask it to rewrite it for Supabase. Then I'll paste it back and see if it works."

**Sam (Senior - Hero):** "Stop, Alex. That's the 2024 way. You'll miss the dependencies in `user_model.py`.
First, run `claude` in the terminal.
Then, press `Shift+Tab` twice to enter **Plan Mode**.
Prompt: *'Scan the entire `src/auth` folder and map out all dependencies. Create a migration plan to Supabase and save it to `PLAN.md`.'*
This way, the agent acts as an architect first. It won't write a single line of code until we agree on the strategy." 

**Jo (Architect - Superhero):** "Sam is right, but we can go faster.
I've already built a **Skill** for this.
Alex, just type: `/migrate-db source=legacy target=supabase`.
This triggers a custom **Agent** I wrote. It uses the **Postgres MCP** to connect to our actual legacy DB to read the schema, then uses the **Supabase MCP** to generate the new tables.
It creates a `tasks.md` file. You just just have to type 'Next' to execute each step." 

**Alex:** "Wait, it can connect to the DB directly?"

**Jo:** "Yes. And since I packaged this as a **Plugin**, you just need to run `/plugin install team-core-utils`. It installs the Skill, the Agent, and the MCP config instantly." 

**Sam:** "And if you need to leave early, just type `/teleport`. You can finish the migration review on your phone on the train home." 

**Alex:** "Okay... I'm installing the plugin now."