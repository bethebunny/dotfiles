# agents

Scrubbed public copies of my Claude Code agent configuration:

- `claude/CLAUDE.md` — user-global guidance (working style + multi-agent
  workflow for MAX framework changes).
- `claude/agents/` — subagent charters dispatched by that workflow.

These are sanitized exports of live files in `~/.claude/` — internal
ticket/PR references and in-flight feature names are removed before
publishing. `sync.sh` refreshes the copies from the live files and runs a
scrub + guard pass; review the diff before committing.

This branch is deliberately orphaned from the dotfiles master branch so the
Coder dotfiles bootstrap (which applies the default branch) never touches it.
To restore on a new machine:

```sh
git fetch origin agents
git checkout origin/agents -- claude/
cp -r claude/CLAUDE.md ~/.claude/CLAUDE.md
cp -r claude/agents ~/.claude/
```
