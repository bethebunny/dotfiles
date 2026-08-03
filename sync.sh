#!/usr/bin/env bash
# Sync live ~/.claude agent config into this branch for review.
# Published copies are SCRUBBED: no internal PR/ticket refs, no internal
# links, no roadmap-flavored example prompts. The sed + guard below are a
# backstop, not the whole scrub — review the diff before committing.
set -euo pipefail
cd "$(dirname "$0")"

cp ~/.claude/CLAUDE.md claude/CLAUDE.md
cp ~/.claude/agents/max-framework-researcher.md \
   ~/.claude/agents/max-framework-implementer.md claude/agents/

# Drop internal PR-number refs like "(#12345)".
sed -i -E 's/ ?\(#[0-9]{4,}\)//g' claude/CLAUDE.md claude/agents/*.md

# Guard: internal link/ticket patterns must never be published.
if grep -rniE 'linear\.app|notion\.so|slack\.com|docs\.google|#[0-9]{5}|[A-Z]{2,}-[0-9]{3,}' claude/; then
  echo 'guard: internal references found above — scrub before committing' >&2
  exit 1
fi

git add claude/
git --no-pager diff --cached --stat
echo 'Review: git diff --cached   Then: git commit && git push'
