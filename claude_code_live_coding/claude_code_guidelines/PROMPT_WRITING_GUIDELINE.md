# Claude Code Prompt Writing Guideline

## Overview

This guideline defines the structure and best practices for writing multi-agent collaboration prompts in the `.claude/prompts/` directory. These prompts orchestrate specialized AI agents to perform complex research, analysis, design, and implementation tasks.

---

## Prompt Categories

| Category | Purpose | Complexity | Example |
|----------|---------|------------|---------|
| **Deep Research** | Multi-phase investigation with academic/industry research | High | `geelark_ai_agent_architecture_research.md` |
| **Crisis Response** | Critical issue resolution with parallel workstreams | High | `conversation_conversion_crisis_program.md` |
| **Feature Improvement** | Systematic enhancement of existing systems | Medium | `improve_chatbot_dashboard.md` |
| **Investigation** | Root cause analysis and data exploration | Medium | `affiliate_funnel_deep_research.md` |
| **Implementation** | Focused code changes with clear requirements | Low-Medium | `stealth_media_blocking_implementation.md` |

---

## Required Sections Schema

### Section 1: Header & Mission Statement

**Purpose**: Define the goal, context, and expected outcomes.

```markdown
# [Task Type]: [Task Name]

## Mission Statement / Mission / Executive Summary

**GOAL**: [One sentence describing the ultimate objective]

[Optional: 2-3 sentences expanding on the mission]

### Primary Objectives
1. **[Objective 1]**: [Description]
2. **[Objective 2]**: [Description]
3. **[Objective 3]**: [Description]

### Current Crisis / Current Issues (if applicable)
```
┌─────────────────────────────────────────────────────────────────────┐
│  ISSUE VISUALIZATION                                                 │
│  - ASCII art diagrams for visual impact                              │
│  - Current vs target metrics                                         │
└─────────────────────────────────────────────────────────────────────┘
```
```

**Schema**:
```yaml
mission_section:
  title: string  # "Mission Statement" | "Mission" | "Executive Summary"
  goal: string  # Single sentence goal (REQUIRED)
  primary_objectives: list[objective]  # 2-6 numbered objectives
  current_issues: optional[ascii_diagram]  # Visual problem statement
  outcome: optional[string]  # Expected outcome description

objective:
  name: string  # Bold keyword
  description: string  # What this objective achieves
```

---

### Section 2: Required Reading & References

**Purpose**: List internal and external documentation agents must read before starting.

```markdown
## Required Reading & Reference Documents

### Internal Guideline (MUST READ FIRST)
📖 **[docs/relevant_guide.md](docs/relevant_guide.md)** - Description of what it covers

### Official Documentation
- 📚 **[Topic]**: https://docs.example.com/path
- 📚 **[Topic]**: https://docs.example.com/path

### Additional Resources (Optional)
- Industry research papers
- Blog posts
- Academic papers
```

**Schema**:
```yaml
references_section:
  internal_docs: list[internal_reference]  # REQUIRED - internal project docs
  official_docs: list[external_reference]  # Framework/API documentation
  additional_resources: optional[list[external_reference]]

internal_reference:
  path: string  # Relative path from project root
  description: string  # What sections/topics it covers
  priority: "MUST READ FIRST" | "recommended" | "reference"

external_reference:
  title: string
  url: string
  description: optional[string]
```

---

### Section 3: Research Context (for Research Prompts)

**Purpose**: Provide background knowledge, prior research insights, and key concepts.

```markdown
## Research Context

### [Key Insight Source] (e.g., "The Vercel Insight")
> "Key quote from the research"

| Configuration | Metric | Notes |
|---------------|--------|-------|
| Baseline | X% | Description |
| Approach A | Y% | Improvement |
| **Best Approach** | **Z%** | **Why it's best** |

**Key Insight**: [Summary of the most important finding]

### Core Concepts (from reference docs)

| Concept | Definition | Key Mechanism |
|---------|------------|---------------|
| **Term 1** | What it is | How it works |
| **Term 2** | What it is | How it works |
```

**Schema**:
```yaml
research_context_section:
  key_insights: list[insight]
  core_concepts: optional[table]
  current_architecture: optional[code_block | diagram]

insight:
  source: string  # Where the insight comes from
  quote: optional[string]  # Direct quote
  data_table: optional[table]  # Supporting data
  key_finding: string  # Summary
```

---

### Section 4: System Context / System Overview

**Purpose**: Document the current system architecture, file structure, and data flow.

```markdown
## System Context / System Overview

### Current Architecture
```
app/path/to/relevant/code/
├── file1.py           # Purpose
├── file2.py           # Purpose
└── subdirectory/
    └── file3.py       # Purpose
```

### Key Files Reference
| File | Purpose | Issues (if applicable) |
|------|---------|------------------------|
| `path/to/file.py` | What it does | Known problems |

### Data Flow (Current)
```
Source A
    │
    ├── Transformation ──► Output X
    │
    └── Transformation ──► Output Y ✗ (problem marker)
```

### Data Flow (Target)
```
[Improved flow diagram]
```
```

**Schema**:
```yaml
system_context_section:
  architecture: code_block  # Directory tree with annotations
  key_files_table: table  # File | Purpose | Issues columns
  data_flow_current: optional[diagram]
  data_flow_target: optional[diagram]
  database_schema: optional[diagram | table]
```

---

### Section 5: Team Organization

**Purpose**: Define phases, agent assignments, and deliverables.

```markdown
## Team Organization

### Phase 1: [Phase Name] (PARALLEL | SEQUENTIAL)

| Agent | Focus Area | Deliverable |
|-------|------------|-------------|
| @AgentType | What they investigate/build | `output_file.json` |
| @AgentType | What they investigate/build | `output_file.json` |

### Phase 2: [Phase Name] (PARALLEL | SEQUENTIAL)

| Agent | Focus Area | Deliverable |
|-------|------------|-------------|
| @AgentType | What they investigate/build | Code changes |
```

**Schema**:
```yaml
team_organization_section:
  phases: list[phase]

phase:
  number: int
  name: string  # Descriptive name
  execution_mode: "PARALLEL" | "SEQUENTIAL"
  description: optional[string]  # What this phase accomplishes
  agent_assignments: list[assignment]

assignment:
  agent: string  # @AgentType format (see Agent Types below)
  focus_area: string  # What they're responsible for
  deliverable: string  # Output file or "Code changes"
```

**Available Agent Types**:
```yaml
research_agents:
  - @AIEngineer  # Multi-agent frameworks, AI/ML systems
  - @NLPResearcher  # Prompt engineering, language models
  - @SystemArchitect  # System design, architecture patterns
  - @DataScientist  # Data analysis, metrics, SQL queries
  - @DataAnalyst  # Database queries, data exploration

engineering_agents:
  - @BackendDev  # Python implementation, API development
  - @DevOpsEngineer  # Infrastructure, monitoring, deployment
  - @AutomationEngineer  # Browser automation, ADB, mobile
  - @StreamlitReporter  # Dashboard/UI implementation
  - @QAEngineer  # Testing, validation, quality assurance

strategy_agents:
  - @ProductManager  # Requirements, PRD, success metrics
  - @ConversationUX  # User experience, psychology, flow
  - @AffiliateExpert  # Affiliate marketing, link tracking
  - @Architect  # Solution design, consolidation
  - @TechLead  # Code review, best practices
```

---

### Section 6: Phase Details (Agent Tasks)

**Purpose**: Define specific tasks, queries, and expected outputs for each agent.

```markdown
### @AgentType - [Task Title]

**Priority**: P0 - CRITICAL | P1 - HIGH | P2 - MEDIUM
**Output**: `chatbot_reports/OUTPUT_FILE.json`

**Required Reading Before Starting** (for research phases):
1. 📖 `docs/relevant_guide.md` - Section X
2. 📚 https://docs.example.com/path

#### Task 1: [Task Name]

**Research Questions** (for research tasks):
1. Question to answer?
2. Question to answer?

**SQL Queries to Execute** (for data tasks):
```sql
-- Description of what this query does
SELECT column FROM table WHERE condition;
```

**Files to Review** (for code tasks):
- `path/to/file.py` - What to look for
- `path/to/file2.py` - What to look for

**Code Pattern** (for implementation):
```python
def example_function():
    """What this demonstrates."""
    pass
```

#### Task 2: [Task Name]
[Additional tasks...]

**Output Schema**:
```json
{
  "analysis_id": "AGENT-001",
  "timestamp": "ISO datetime",
  "section_name": {
    "field": "description",
    "nested": {
      "subfield": "value"
    }
  },
  "recommendations": [
    {
      "priority": "P0 | P1 | P2",
      "issue": "What's wrong",
      "fix": "How to fix it"
    }
  ]
}
```

---
```

**Schema**:
```yaml
agent_task_section:
  agent: string  # @AgentType
  title: string  # Descriptive title
  priority: "P0 - CRITICAL" | "P1 - HIGH" | "P2 - MEDIUM"
  output: string  # Output file path
  required_reading: optional[list[reference]]
  tasks: list[task]
  output_schema: json_schema

task:
  number: int
  name: string
  description: optional[string]
  research_questions: optional[list[string]]
  sql_queries: optional[list[sql_block]]
  files_to_review: optional[list[file_reference]]
  code_patterns: optional[list[code_block]]
  implementation_notes: optional[string]

sql_block:
  comment: string  # What the query does
  query: string  # SQL code

code_block:
  language: string  # python, bash, etc.
  content: string
  description: optional[string]
```

---

### Section 7: Handoff Protocol

**Purpose**: Define how agents communicate results between phases.

```markdown
## Handoff Protocol

### Data Flow Between Agents

```
Phase 1: [Name] (Parallel)
┌─────────────────────────────────────────────────────────────────────┐
│  @Agent1 ─────────────────┐                                          │
│  (Focus area)             │                                          │
│                           │                                          │
│  @Agent2 ──────────────────┼──► Phase Complete                       │
│  (Focus area)             │                                          │
│                           │                                          │
│  @Agent3 ─────────────────┘                                          │
└─────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
Phase 2: [Name] (Sequential)
┌─────────────────────────────────────────────────────────────────────┐
│  @Agent4 ──────────► Output                                          │
│        │                                                             │
│        ▼                                                             │
│  @Agent5 ──────────► Final Output                                    │
└─────────────────────────────────────────────────────────────────────┘
```

### Communication Format

When handing off work, use this format:

```json
{
  "from": "@AgentName",
  "to": "@TargetAgent",
  "handoff_type": "research | analysis | design | implementation | testing",
  "artifacts": [
    {
      "name": "artifact_name",
      "type": "json | code | markdown",
      "location": "path/to/file or inline"
    }
  ],
  "summary": "Brief summary of what was done",
  "key_findings": ["Critical findings list"],
  "blockers": ["Any blockers for next phase"],
  "questions": ["Questions needing answers"]
}
```
```

**Schema**:
```yaml
handoff_protocol_section:
  data_flow_diagram: ascii_diagram  # Visual flow between phases
  communication_format: json_schema  # Handoff message structure
  phase_dependencies: optional[list[dependency]]

dependency:
  from_phase: int
  to_phase: int
  outputs_required: list[string]
```

---

### Section 8: Success Criteria

**Purpose**: Define measurable outcomes and acceptance criteria.

```markdown
## Success Criteria

### Research/Phase Completion (MUST ALL BE MET)
- [ ] Checklist item 1
- [ ] Checklist item 2
- [ ] Checklist item 3

### Performance Targets
| Metric | Current | Target | Red Line |
|--------|---------|--------|----------|
| Metric 1 | X% | Y% | < Z% |
| Metric 2 | X | Y | < Z |

### Key Metrics (Priority Order)

1. **Metric Name** ⭐ PRIMARY
   - Current: X%
   - Target: Y%
   - Measurement: How to measure

2. **Metric Name**
   - Target: X
   - Measurement: How to measure
```

**Schema**:
```yaml
success_criteria_section:
  phase_completion: list[checkbox_item]  # Must all be met
  performance_targets: optional[table]  # Current | Target | Red Line
  key_metrics: list[metric]

metric:
  name: string
  priority: "PRIMARY" | "secondary"
  current: optional[string]
  target: string
  measurement: string  # How to verify
```

---

### Section 9: Guardrails & Anti-Goals

**Purpose**: Define constraints and what NOT to do.

```markdown
## Guardrails
- [ ] Constraint 1
- [ ] Constraint 2
- [ ] Constraint 3

## Anti-Goals (What NOT to Do)
- ❌ Don't do X
- ❌ Don't do Y
- ❌ Don't do Z
```

**Schema**:
```yaml
constraints_section:
  guardrails: list[checkbox_item]  # Constraints to maintain
  anti_goals: list[anti_goal]  # What to avoid

anti_goal:
  description: string  # What not to do
  reason: optional[string]  # Why it's bad
```

---

### Section 10: Execution Timeline

**Purpose**: Visual representation of the work schedule.

```markdown
## Execution Timeline

```
DAY 1 (PARALLEL - Research):
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 1: RESEARCH & ANALYSIS                                         │
├─────────────────────────────────────────────────────────────────────┤
│ @Agent1: Task description                                            │
│ @Agent2: Task description                                            │
└─────────────────────────────────────────────────────────────────────┘

DAY 2 (SEQUENTIAL - Design):
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 2: DESIGN & SPECIFICATION                                      │
├─────────────────────────────────────────────────────────────────────┤
│ @Agent3: Task description                                            │
│ @Agent4: Task description                                            │
└─────────────────────────────────────────────────────────────────────┘

DAY 3-5 (Implementation):
[Continue pattern...]
```
```

**Schema**:
```yaml
timeline_section:
  timeline_blocks: list[timeline_block]

timeline_block:
  time_range: string  # "DAY 1" | "WEEK 1" | "Day 3-5"
  execution_mode: "PARALLEL" | "SEQUENTIAL"
  phase_name: string
  agent_tasks: list[agent_task_summary]

agent_task_summary:
  agent: string
  task: string  # Brief description
```

---

### Section 11: Files Reference

**Purpose**: List all files to read, modify, or create.

```markdown
## Files to Research / Key Files Reference

| File | Purpose | Phase |
|------|---------|-------|
| `path/to/file.py` | What it does | 1 |

## Files to Create

| File | Purpose | Owner |
|------|---------|-------|
| `path/to/new_file.py` | What it will do | @Agent |

## Files to Modify

| File | Changes | Owner |
|------|---------|-------|
| `path/to/existing.py` | What to change | @Agent |
```

**Schema**:
```yaml
files_section:
  files_to_research: optional[table]  # File | Purpose | Phase
  files_to_create: optional[table]  # File | Purpose | Owner
  files_to_modify: optional[table]  # File | Changes | Owner
  database_models: optional[table]  # Model | Key Fields | Used For
```

---

### Section 12: Usage / Quick Start

**Purpose**: Provide instructions for running the collaboration.

```markdown
## Usage

To start the collaboration, run this prompt and execute agents in this order:

### Step 1: [Phase Name] (Run in Parallel)
```
@Agent1: [Specific instructions for this agent]

@Agent2: [Specific instructions for this agent]
```

### Step 2: [Phase Name] (Run in Parallel)
```
@Agent3: [Specific instructions for this agent]
```

### Step 3: [Phase Name] (Sequential)
```
@Agent4 + @Agent5: [Combined instructions]
```

---

## Running Commands (if applicable)

```bash
# How to run related code/tools
command --options
```
```

**Schema**:
```yaml
usage_section:
  execution_steps: list[step]
  running_commands: optional[list[command_block]]

step:
  number: int
  name: string
  execution_mode: "PARALLEL" | "SEQUENTIAL"
  agent_instructions: list[agent_instruction]

agent_instruction:
  agent: string  # Can be single or combined "@Agent1 + @Agent2"
  instruction: string  # What to do
```

---

### Section 13: Call to Action (Footer)

**Purpose**: Emphasize urgency and critical reminders.

```markdown
---

**START PHASE 1 IMMEDIATELY. REPORT FINDINGS WITHIN [TIMEFRAME].**

**⚠️ CRITICAL**: Before implementing any pattern, read:
1. `docs/relevant_guide.md` (internal)
2. [External doc] (links)

**This is our #1 priority until [goal is achieved].**
```

**Schema**:
```yaml
call_to_action:
  urgency_statement: string
  critical_reminders: list[string]
  priority_statement: optional[string]
```

---

## Complete Prompt Template

```markdown
# [Category]: [Task Name]

## Mission Statement

**GOAL**: [Single sentence goal]

### Primary Objectives
1. **[Objective 1]**: [Description]
2. **[Objective 2]**: [Description]
3. **[Objective 3]**: [Description]

### Current Issues (if applicable)
```
[ASCII diagram visualizing the problem]
```

---

## Required Reading & Reference Documents

### Internal Guideline (MUST READ FIRST)
📖 **[docs/guide.md](docs/guide.md)** - Covers: [topics]

### Official Documentation
- 📚 **[Topic]**: [URL]

---

## Research Context (for research prompts)

### Key Insight: [Source]
> "Quote"

| Config | Metric | Notes |
|--------|--------|-------|
| ... | ... | ... |

---

## System Context

### Current Architecture
```
[Directory tree]
```

### Key Files Reference
| File | Purpose | Issues |
|------|---------|--------|
| ... | ... | ... |

### Data Flow
```
[Flow diagram]
```

---

## Team Organization

### Phase 1: [Name] (PARALLEL)

| Agent | Focus Area | Deliverable |
|-------|------------|-------------|
| @Agent | Focus | `output.json` |

### Phase 2: [Name] (SEQUENTIAL)

| Agent | Focus Area | Deliverable |
|-------|------------|-------------|
| @Agent | Focus | Code changes |

---

## PHASE 1: [Phase Name]

### @AgentType - [Task Title]

**Priority**: P0 - CRITICAL
**Output**: `chatbot_reports/FILE.json`

**Required Reading Before Starting**:
1. 📖 `docs/guide.md` - Section X
2. 📚 [URL]

#### Task 1: [Name]

[Task details, queries, code patterns]

**Output Schema:**
```json
{
  "analysis_id": "ID",
  "findings": []
}
```

---

[Additional agent sections...]

---

## Handoff Protocol

### Data Flow Between Agents
```
[ASCII flow diagram]
```

### Communication Format
```json
{
  "from": "@Agent",
  "to": "@Agent",
  "summary": "..."
}
```

---

## Success Criteria

### Phase Completion (MUST ALL BE MET)
- [ ] Item 1
- [ ] Item 2

### Performance Targets
| Metric | Current | Target | Red Line |
|--------|---------|--------|----------|
| ... | ... | ... | ... |

---

## Guardrails
- [ ] Constraint 1
- [ ] Constraint 2

## Anti-Goals (What NOT to Do)
- ❌ Don't do X
- ❌ Don't do Y

---

## Execution Timeline

```
[ASCII timeline]
```

---

## Files Reference

### Files to Research
| File | Purpose | Phase |
|------|---------|-------|
| ... | ... | ... |

### Files to Create
| File | Purpose | Owner |
|------|---------|-------|
| ... | ... | ... |

---

## Usage

### Step 1: [Phase] (Run in Parallel)
```
@Agent1: Instructions

@Agent2: Instructions
```

---

**START PHASE 1 IMMEDIATELY. REPORT FINDINGS WITHIN [TIME].**

**⚠️ CRITICAL**: Before implementing, read [docs].
```

---

## Best Practices

### 1. Visual Hierarchy
- Use ASCII diagrams for complex systems
- Use tables for structured data
- Use code blocks for SQL/Python examples
- Use checkboxes for actionable items

### 2. Agent Instructions
- Be specific about what each agent should investigate
- Include exact SQL queries when data analysis is needed
- Define output schemas in JSON format
- Include "Required Reading" for complex tasks

### 3. Output Schemas
- Always define JSON output schemas for deliverables
- Include `analysis_id` and `timestamp` fields
- Structure findings as arrays with `priority`, `issue`, `fix`
- Use consistent field naming across prompts

### 4. Phasing
- **PARALLEL** for independent research tasks
- **SEQUENTIAL** for tasks with dependencies
- Maximum 4-5 agents per parallel phase
- Clear handoff points between phases

### 5. Success Criteria
- Make criteria measurable (percentages, counts)
- Include "Red Line" thresholds for critical metrics
- Use checkboxes for phase completion verification

### 6. File References
- Always include relative paths from project root
- Specify what to look for in each file
- Identify files to create vs modify vs research

### 7. Urgency Communication
- Use emoji markers (🚨, ⭐, ⚠️, ❌, ✅)
- Include timeframes for deliverables
- Highlight critical constraints prominently

---

## Quick Reference: Common Patterns

### SQL Query Block
```markdown
**SQL Queries to Execute:**
```sql
-- [Description of what this query answers]
SELECT
    field,
    COUNT(*) as count
FROM table
WHERE condition
GROUP BY field;
```
```

### Code Pattern Block
```markdown
**Code Pattern:**
```python
from module import Class

def function_name(param: Type) -> ReturnType:
    """What this demonstrates."""
    # Implementation
    pass
```
```

### Output Schema Block
```markdown
**Output Schema:**
```json
{
  "analysis_id": "AGENT-001",
  "timestamp": "2026-01-31T00:00:00Z",
  "section_name": {
    "metric": 0,
    "findings": []
  },
  "recommendations": [
    {
      "priority": "P0",
      "issue": "Description",
      "fix": "Solution"
    }
  ]
}
```
```

### Agent Task Header
```markdown
### @AgentType - Task Title

**Priority**: P0 - CRITICAL
**Output**: `chatbot_reports/OUTPUT.json`

**Required Reading Before Starting**:
1. 📖 `docs/guide.md` - Section X
2. 📚 https://docs.example.com/

#### Task 1: Task Name

[Details]

---
```

### Phase Separator
```markdown
---

## PHASE 2: Phase Name

> **Objective**: What this phase accomplishes

### @Agent - Task Title
```

---

## Validation Checklist

Before finalizing a prompt, verify:

- [ ] **Mission is clear**: Goal stated in one sentence
- [ ] **Objectives are numbered**: 2-6 primary objectives
- [ ] **References included**: Internal docs + external docs
- [ ] **System context provided**: Architecture diagram + key files
- [ ] **Team organized**: Phases defined with PARALLEL/SEQUENTIAL
- [ ] **Agent tasks detailed**: Priority, output, tasks, schema
- [ ] **Handoff protocol defined**: Communication format specified
- [ ] **Success criteria measurable**: Targets with measurements
- [ ] **Guardrails set**: Constraints and anti-goals listed
- [ ] **Timeline visualized**: ASCII diagram of execution
- [ ] **Files referenced**: Research, create, modify tables
- [ ] **Usage instructions clear**: Step-by-step execution guide
- [ ] **Call to action present**: Urgency statement at end
