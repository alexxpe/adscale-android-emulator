#!/bin/bash
# Debug script for agent team "prompt too large" issues
# Usage: ./debug-agents.sh

PROJECT_PATH="-Users-alex-Desktop-code-outreach-create-account"

echo "=== Agent Teams Active ==="
ls -ld ~/.claude/teams/* 2>/dev/null | awk '{print $NF}'
echo ""

echo "=== Teammate Transcript Sizes (largest first) ==="
# Check both subagents (old) and team transcripts (new)
{
  ls -lhS ~/.claude/projects/${PROJECT_PATH}/*/subagents/*.jsonl 2>/dev/null
  find ~/.claude/projects/${PROJECT_PATH}/*/teammates/ -name "*.jsonl" -exec ls -lh {} \; 2>/dev/null
} | head -15

echo ""
echo "=== Read Tool Calls Per Teammate ==="
for f in ~/.claude/projects/${PROJECT_PATH}/*/teammates/*.jsonl 2>/dev/null; do
  teammate=$(basename "$f" .jsonl)
  reads=$(grep -c '"name":"Read"' "$f" 2>/dev/null || echo 0)
  size=$(ls -lh "$f" 2>/dev/null | awk '{print $5}')
  echo "$size | $teammate | $reads reads"
done | sort -t'|' -k1 -rh | head -15

# Also check old subagent format
for f in ~/.claude/projects/${PROJECT_PATH}/*/subagents/*.jsonl 2>/dev/null; do
  agent=$(basename "$f" .jsonl)
  reads=$(grep -c '"name":"Read"' "$f" 2>/dev/null || echo 0)
  size=$(ls -lh "$f" 2>/dev/null | awk '{print $5}')
  echo "$size | $agent (subagent) | $reads reads"
done | sort -t'|' -k1 -rh | head -15

echo ""
echo "=== MCP Tool Usage Per Teammate ==="
for f in ~/.claude/projects/${PROJECT_PATH}/*/teammates/*.jsonl 2>/dev/null; do
  teammate=$(basename "$f" .jsonl)
  mcps=$(grep -o 'mcp__[a-z_]*__[a-z_]*' "$f" 2>/dev/null | sort | uniq -c | tr '\n' ', ')
  if [ -n "$mcps" ]; then
    echo "$teammate: $mcps"
  fi
done

echo ""
echo "=== Teammates Over 100KB (POTENTIAL ISSUES) ==="
find ~/.claude/projects/${PROJECT_PATH}/*/teammates/ -name "*.jsonl" -size +100k -exec ls -lh {} \; 2>/dev/null
find ~/.claude/projects/${PROJECT_PATH}/*/subagents/ -name "*.jsonl" -size +100k -exec ls -lh {} \; 2>/dev/null

echo ""
echo "=== Files Read by Largest Teammate ==="
largest=$(find ~/.claude/projects/${PROJECT_PATH}/*/teammates/ -name "*.jsonl" -exec ls -S {} \; 2>/dev/null | head -1)
if [ -z "$largest" ]; then
  largest=$(ls -S ~/.claude/projects/${PROJECT_PATH}/*/subagents/*.jsonl 2>/dev/null | head -1)
fi
if [ -n "$largest" ]; then
  echo "Largest teammate/agent: $largest"
  echo "Files it read:"
  grep -o '"file_path":"[^"]*"' "$largest" 2>/dev/null | sort | uniq | head -20
fi

echo ""
echo "=== Shared Task Lists ==="
for team_dir in ~/.claude/tasks/*/ 2>/dev/null; do
  team=$(basename "$team_dir")
  task_count=$(find "$team_dir" -name "*.json" 2>/dev/null | wc -l)
  echo "Team: $team - $task_count tasks"
done
