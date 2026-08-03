# User-global guidance

## Working style (all repos, all tasks)

Stef has very little time and can see almost nothing of what you do,
think, or run. These rules exist so his inner-loop time goes to judgment
calls, never to waiting or guessing. (Established 2026-07-30 after a
session that started badly and ended well.)

- **Plan in 30 seconds, then split into three lanes** and say the split
  out loud:
  1. *Stef-only actions* (approvals, review stamps, decisions) — a short
     explicit list so he can act immediately;
  2. *judgment work* you do inline (design discussion, tricky diffs,
     review, root-cause calls);
  3. *mechanical work* — builds, test runs, stub regen, CI babysitting,
     flake-history digging, log paging — farmed to background subagents
     launched immediately and in parallel. Never crank through
     mechanical steps serially in the main loop.
- **Narrate the lanes.** Every message states what's running in the
  background, what you're doing now, and what's blocked on whom. Report
  interim findings the moment they matter (a CI failure, a flake
  confirmation) rather than batching them.
- **Esc/interrupt means "new info incoming," not a veto.** Don't treat
  an interrupted tool call as rejected; if Stef explicitly doesn't want
  something, he'll say so.
- **Wide, shallow PR stacks.** CI latency is the main blocker to landing
  code. Base every PR on main unless it has a *hard code dependency* on
  another unmerged PR — never inherit stack depth from how the work
  happened to be developed. Remember the footgun: squash-merging a
  stacked PR lands it into its **base branch**, not main.
  Express a two-parent dependency as a jj merge commit; it collapses
  when either parent lands.
- **Explaining designs: artifacts first, then prose.** Lead with the
  function signatures, the concrete types, and the state transitions,
  then plain full sentences — no compressed reasoning chains, no
  unlabeled pronouns doing load-bearing work. If Stef asks to restate,
  the failure was structure, not length.
- **Deliver reports in-channel, in full.** A file path on the dev box is
  not a report — Stef would have to do work to read it. Paste the
  substance (numbers, tables, findings) into the conversation and/or his
  Slack DM; the file is the archive, not the delivery.
- **Report text goes LAST in the turn, after every tool call.** Message
  text written between tool calls may never render for Stef — on
  2026-07-31 three full reports were "delivered" mid-turn and he saw
  none of them. Do the tool calls first (Slack mirror, file writes),
  then end the turn with the complete report as the final text.

## Multi-agent workflow for MAX framework changes (`max-framework-*`)

Applies only in modular monorepo checkouts. Trial setup — agents live in
`~/.claude/agents/`, not the repo; don't commit references to them.

For non-trivial changes to MAX framework Python (`max/python/max/`), the
main conversation owns reasoning; fast sub-agents own legwork. The loop:
discuss → design → implementation plan → orchestrated execution →
whole-picture review. Short-circuit back to plan iteration on blockers.

- **Research**: during discuss/design/plan, fan out parallel
  `max-framework-researcher` agents with crisp, independent questions.
  Digests locate ground truth (file:line + verbatim excerpts); read the
  load-bearing lines yourself before deciding. Also use for CI-failure
  triage instead of paging logs inline.
- **Plan artifact**: write the approved plan to
  `.agentwork/max-framework/plans/<name>.md` with these sections:
  - **Decisions** — immutable choices (API names, ownership, routing
    semantics, error contracts). Implementers stop on contradiction.
  - **Discretion** — choices explicitly left to implementers.
  - **Slices** — each with its file surface, an acceptance test command,
    and whether it is independent of other slices. Pin shared interfaces
    verbatim when slices are parallel.
- **Execution**: the main conversation orchestrates directly — sub-agents
  cannot dispatch sub-agents (verified harness limit, 2026-06). Before
  dispatching, verify the plan's load-bearing references against the live
  tree (API names, line refs, test targets). Dispatch one
  `max-framework-implementer` per slice in the background (parallel
  worktrees only when slices are independent), prompt = plan path + slice
  ID, nothing else. Supervise for trajectory, not correctness:
  short-circuit on same-error-twice, plan-Decision drift, fabricated APIs,
  weakened tests, or out-of-surface edits — never for slow-but-changing
  errors or style taste. Blockers come back as plan amendments — iterate
  the plan and redispatch; don't patch in-flight work. Check in on
  long-running agents every few minutes; a silently dead agent is
  detectable in seconds once you look.
- **Verification is proportional and cached.** Plans specify two
  commands: an inner loop (single target, `--test_arg=-k` filter,
  `--config=disable-mypy`) and one final full gate. Never
  `--nocache_test_results` (flake-hunting only) — bazel reruns exactly
  what changed. mypy runs alone via `./bazelw build <target>` (~40s);
  comment/docstring edits need only ruff. Never pipe verification
  through `grep|tail` — it eats exit codes and aspect failures; tee to a
  file and check `$?`.
- **Review**: whole-picture, after all slices land — combined diff, test
  evidence, discretion choices. If multiple slices share one wrong
  assumption, that's a design gap: drop back to design/plan, regenerate
  rather than patch. Include a comment pass: comments only where the
  obvious approach would be wrong (and say why); docstrings state the
  contract, never implementation. Delete narration.
- The main conversation owns all jj/git operations and the final review.
  Don't run file-writing sub-agents on the shared tree outside this
  flow — the user edits it live between turns.
