# Conventions shared by the existing trainer apps

Derived from `stocks-trainer/`, `leetcode-coach/`, and `mental-math/` (siblings of this skill's parent folder). When a template here is unclear, open the matching file in one of those apps.

## Artifact inventory

| Artifact | Role | Best example |
|----------|------|--------------|
| `EPIC_MAP.md` | Living product map: status table, scope (MVP / post-MVP / constraints), learning order, flows, state table, epic list + details, implementation order, coverage check, agent notes | `mental-math/EPIC_MAP.md` |
| `IMPLEMENTATION_STORIES.md` | Global conventions, build-order tables per queue, then per-milestone story tables with `ID / Story / Acceptance` | `mental-math/IMPLEMENTATION_STORIES.md` |
| `.agents/state.json` | State of record: current epic/milestone, story statuses, app, decisions (platform, join key, progress key, floors, execution rules), milestone queues, epic list, `next_action` | `mental-math/.agents/state.json` |
| `RESOURCES.md` | Resource-type taxonomy, tracks, catalog table (type → learner action → route → registry), per-type contracts | `mental-math/RESOURCES.md` |
| `AGENTS_LOOP-Continue-Milestone.md` | Runtime loop: how to run, queue table, loop prompt (objective, context, cadence, rubric, stop conditions, tick output) | `stocks-trainer/AGENTS_LOOP-Continue-Milestone.md` |
| `LOOPS/README.md` | Run-line table for graph + each section loop, shared rules | `mental-math/LOOPS/README.md` |
| `LOOPS/LOOP-Graph.md` | Orchestrator: policies, nodes, drain order, echo families, stage machine, per-tick algorithm, loop prompt | `mental-math/LOOPS/LOOP-Graph.md` |
| `LOOPS/LOOP-<Section>.md` | One per resource type: product intent, coverage queue (strict order), Done(section), loop prompt | `mental-math/LOOPS/LOOP-Guides.md` |
| `PROMPTS/*.md` + `*.track.json` | leetcode-coach's variant: queue walker over `context/` repos with an explicit JSON cursor (`next`, `completed`, `skipped`, `exhausted`) | `leetcode-coach/PROMPTS/README.md` |
| `context/clone.sh` + `context/README.md` | Shallow-clone script + catalog with upstream, license note, "use for" | `leetcode-coach/context/` |
| `.gitignore` | Ignores clones but keeps script + catalog | `leetcode-coach/.gitignore` |
| `.agents/skills/*/SKILL.md` | Repeated authoring workflows (add coaching session, add pack, harness) | `mental-math/.agents/skills/add-coaching-session/SKILL.md` |
| `.impeccable.md` | Design context: users, brand personality, aesthetic direction, references, anti-references | `mental-math/.impeccable.md` |
| `README.md` | Learner-facing: what it trains, start here, how to run | `stocks-trainer/README.md` |
| `../index.php` | Root launcher; one card per app in `$apps` | `trainer/index.php` |

## Loop prompt anatomy (both loop kinds)

Every loop prompt body uses the same headings so `/loop` ticks are predictable:

```
# OBJECTIVE          Done(global) + Done(per tick)
# CONTEXT            files of record, auto-verify command, constraints
# STEP-BY-STEP CADENCE  Orient → Implement/Author one unit → Verify → On PASS → On FAIL → Skills
# VERIFICATION RUBRIC   checkbox list; PASS only if all true
# STOP CONDITIONS    Done, error budget (10 rounds → Error Handoff Summary), human verification, abort
# TICK OUTPUT        4–6 short lines
```

Error Handoff Summary fields: epic/milestone/story (or stage/family/unit), chronological errors, files touched + approaches, last command output excerpts, suspected root cause, whether a skill was involved.

## Content graph policies

| Policy | Rule |
|--------|------|
| `FOUNDATION_THEN_ECHO` (default) | Stage 0 drain Guides · Stage 1 pair Coach per guide · Stage 2 echo remaining hops per family · Stage 3 drain leftover floors |
| `DRAIN` | Stay on one section until Done(section), then next in drain order |
| `ECHO` | After each PASS, follow the family's next unfilled hop |

Park a node (treat as Done for graph purposes, note `parked: <epic>_missing`) when its runtime epic has not shipped. Never scaffold runtime inside a content tick.

## Milestone queue names

`implementation_order` (P0 → MVP freeze) → `post_mvp_order` → `later_order` → `advanced_order` (+ topic-specific queues such as stocks' `market_types_order`). Never skip a queue; never enter `post_mvp_order` until the MVP freeze checklist is green or a human GO is recorded.

## Stacks in use

| Stack | Apps | Verify | Root card `href` |
|-------|------|--------|------------------|
| PHP 8.2 server-rendered + vanilla JS, content as JSON / directory scan, PHPUnit | leetcode-coach, mental-math | `./vendor/bin/phpunit` | `<slug>/` |
| React 19 + Vite + TypeScript, Vitest, ESLint, build to `dist/` | stocks-trainer | `npm run lint && npm run build` (+ `npm run test`) | `<slug>/dist/` |

## Hard constraints (repeat in every emitted doc)

- Deterministic coaching = decision graphs with `wrong` nodes that `rewind_to` a prior layer and ≥1 `success`; no runtime LLM
- SAMPLE data; no LIVE / REAL_TIME theater
- `localStorage` progress key, versioned (`<codename>_progress_v1`); corrupt → reset with recovery flag
- Join key everywhere; resource type is a separate field/route
- Rewrite context, never paste
- One unit per tick; auto-verify before PASS
- Create or adapt `.agents/skills/*` when a workflow repeats; new purpose → new skill, do not overload
