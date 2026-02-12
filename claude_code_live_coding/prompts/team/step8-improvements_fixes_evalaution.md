# Phase 3: QA, Fixes & Deployment - Team Lead Orchestrator

> **YOU ARE THE TEAM LEAD. CREATE AN AGENT TEAM FOR QA AND DEPLOYMENT.**
> **YOUR JOB: Create team -> Monitor quality gates -> Coordinate fixes -> Deploy**
> **Enable delegate mode (Shift+Tab) to prevent doing work yourself.**

---

## CRITICAL: Context Size Management

**TO PREVENT CONTEXT OVERFLOW:**
- Use Sonnet model for all teammates
- Quality teammates analyze with Grep/Glob, minimal file reads
- Deployment teammates generate from knowledge
- All outputs: JSON files under 3KB
- Keep spawn prompts concise

**WHY:** Keeping context small prevents "prompt too large" errors.

---

## Pre-Flight (Team Lead Does This)

1. Verify Phase 2 artifacts exist (src/ modules, package.json, tsconfig.json)
2. Quick check that `pnpm build && node dist/index.js --help` works
3. Enable delegate mode (Shift+Tab)

---

## Step 1: Create Quality Team

Create an agent team for quality assurance and bug fixing:

```
Create an agent team called "quality-phase" with teammates to perform QA and fix issues:

**Quality Team:**
1. qa-engineer (qa-engineer, Sonnet): Run Vitest test suite
   - Task: Execute 'pnpm test' and report pass/fail counts
   - Output: automation_reports/QA-FINAL.json (<3KB)
   - ZERO FILE READS - use Bash only

2. tech-lead (tech-lead, Sonnet): Final code review
   - Task: Use Grep to scan for: `any` types, `exec()` without sanitization, unhandled promises, missing ADB timeouts
   - Output: automation_reports/TL-FINAL.json (<3KB)
   - Status: APPROVED/REJECTED with max 5 issues
   - READ MAX 2 FILES from src/

3. bug-hunter (bug-hunter, Sonnet): Final bug check
   - Task: Use Grep to find: missing error handling on ADB calls, unhandled CDP disconnects, race conditions in executor
   - Output: automation_reports/BUG-FINAL.json (<3KB)
   - Report max 5 bugs with P0/P1/P2 severity
   - READ MAX 2 FILES

4. security-reviewer (security-reviewer, Sonnet): Final security audit
   - Task: Use Grep for: shell injection patterns (string interpolation in exec/spawn args), unsanitized user input in ADB commands, missing input validation
   - Output: automation_reports/SEC-AUDIT.json (<3KB)
   - Pass/Fail for: shell injection, input sanitization, command allowlist, timeout enforcement, error exposure
   - READ MAX 2 FILES from src/device/ and src/cdp/

**CONSTRAINTS for all teammates:**
- Keep context small with minimal file reads
- Output concise JSON reports under 3KB
- After completing tasks, check shared task list for additional work
```

---

## Step 2: Monitor Quality Gates

Check the shared task list (Ctrl+T) and wait for all quality teammates to complete.

### Quality Gates (ALL must pass to proceed)
- [ ] QA: Tests run without crash
- [ ] Bug Hunter: Zero P0 bugs
- [ ] Security Reviewer: No shell injection vulnerabilities
- [ ] Tech Lead: APPROVED status

If any teammate reports issues, proceed to Step 3 for fixes.

---

## Step 3: Bug Fix Loop (ON-DEMAND)

If bugs are found, create tasks in the shared task list for fixes:

1. **For core/parser bugs:**
   ```
   Create a task: Fix bug in {file_path}: {bug_description}
   Assign to: backend-dev teammate
   ```

2. **For ADB/CDP bugs:**
   ```
   Create a task: Fix device controller bug in {file_path}: {bug_description}
   Assign to: automation-eng teammate
   ```

3. **Spawn fix teammates if needed:**
   ```
   Spawn backend-dev-fix (backend-dev, Sonnet) to fix: {bug_description}
   - Task: READ ONLY the affected file, fix the bug, verify

   OR

   Spawn automation-eng-fix (automation-engineer, Sonnet) to fix: {bug_description}
   - Task: READ ONLY the affected file, fix the bug, verify
   ```

After fixes, message the quality team to re-run their checks.

---

## Step 4: Create Deployment Team (AFTER Quality Gates Pass)

Once all quality gates pass, create a deployment team:

```
Create an agent team called "deployment-phase" with teammates to prepare for deployment:

**Deployment Team:**
1. devops-engineer (devops-engineer, Sonnet): CI/CD setup with Android SDK
   - Task: Create .github/workflows/ci.yml with: pnpm install, pnpm build, pnpm test, Android SDK setup for integration tests
   - Output: automation_reports/DEPLOY-001.json (<3KB)
   - ZERO FILE READS - generate from knowledge

2. product-manager (product-manager, Sonnet): User documentation
   - Task: Create docs/README.md and docs/INSTRUCTION-FORMAT.md
   - docs/README.md: Getting started, prerequisites (Node.js, Android SDK, ADB), installation, usage
   - docs/INSTRUCTION-FORMAT.md: Complete action type reference with examples for all 8 action types
   - Max 2 files, each under 2KB
   - ZERO FILE READS - generate from knowledge of the automation service

3. automation-eng (automation-engineer, Sonnet): Example instruction files
   - Task: Create example instruction files in instructions/examples/
   - Create: basic-navigation.json, form-fill.json, scroll-and-screenshot.json
   - Each example demonstrates different action types
   - ZERO FILE READS - generate from knowledge

4. system-architect (system-architect, Sonnet): Final architecture diagram
   - Task: Create docs/architecture.md with Mermaid diagram
   - Show: CLI -> Instruction Parser -> Action Executor -> ADB Controller / CDP Controller -> Emulator Manager
   - Max 50 lines, ZERO FILE READS - generate from knowledge

**CONSTRAINTS for all teammates:**
- Generate documentation from expertise, not file reads
- Keep outputs concise
- After completing tasks, check shared task list
```

---

## Step 5: Monitor Deployment Progress

Check shared task list (Ctrl+T) and monitor teammate messages.

Send Discord updates at milestones:
```
At 20%: Send Discord embed "PHASE 3: 20%" with progress fields
At 40%: "PHASE 3: 40%"
At 60%: "PHASE 3: 60%"
At 80%: "PHASE 3: 80%"
At 100%: "PHASE 3: 100% - Ready for Launch"
```

---

## Step 6: Launch Sequence

When all teammates complete:

1. **Verify completion criteria:**
   - [ ] All quality gates passed
   - [ ] All deployment teammates completed
   - [ ] Zero P0/P1 bugs in BUG-FINAL.json
   - [ ] SEC-AUDIT.json shows all Pass (no shell injection)
   - [ ] CI/CD workflow exists at .github/workflows/ci.yml
   - [ ] Documentation complete (README + INSTRUCTION-FORMAT)
   - [ ] Example instruction files in instructions/examples/

2. **Send launch notification:**
   ```
   Send Discord embed:
   Title: "LAUNCHED"
   Description: "Android Emulator Browser Automation Service is ready!"
   Fields:
     - Status: Production Ready
     - Quality: All gates passed
     - Security: Shell injection audit complete
     - Documentation: Complete
     - Examples: Instruction files ready
   Color: green (65280)
   ```

---

## Step 7: Team Cleanup

When launch is complete:

1. **Shut down quality team:**
   ```
   Ask each teammate to shut down: qa-engineer, tech-lead, bug-hunter, security-reviewer
   ```

2. **Shut down deployment team:**
   ```
   Ask each teammate to shut down: devops-engineer, product-manager, automation-eng, system-architect
   ```

3. **Clean up team resources:**
   ```
   Clean up the quality-phase team
   Clean up the deployment-phase team
   ```

---

## Handoff Complete
```json
{"from": "Team Lead", "to": "Stakeholders", "status": "LAUNCHED", "quality": "verified", "security": "audited"}
```

---

**START NOW:**
1. Create the quality-phase agent team (4 teammates)
2. Enable delegate mode (Shift+Tab)
3. Monitor shared task list and teammate messages
4. After quality gates pass, create deployment-phase team (4 teammates)
5. Coordinate through messaging and task assignment
6. Shut down teams when complete
