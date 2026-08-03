# agents

Public copy of my Claude Code user config. The branch root mirrors
`~/.claude` so it can be checked out directly as that directory:

- `CLAUDE.md` — user-global guidance (working style + multi-agent workflow
  for MAX framework changes).
- `agents/` — subagent charters dispatched by that workflow.
- `.gitignore` — whitelist: everything in the live config dir (settings,
  history, memory, sessions) is ignored; only the files above are tracked.

This branch is deliberately orphaned from the dotfiles master branch so the
Coder dotfiles bootstrap (which applies the default branch) never touches it.

## Fresh machine / cloud environment (no ~/.claude yet)

```sh
git clone --branch agents https://github.com/bethebunny/dotfiles "$HOME/.claude"
```

## Existing ~/.claude

```sh
cd ~/.claude
git init -b agents
git remote add origin https://github.com/bethebunny/dotfiles
git fetch origin agents
git reset --hard origin/agents   # only touches tracked files; live state is untouched
git branch -u origin/agents
```

Update with `git pull`. Publish by editing the live files, then commit and
push.
