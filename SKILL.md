---
name: new-trainer-app
description: >-
  Plan and scaffold a new trainer app (guides, step-by-step coaching, drills,
  quizzes, cases, games, simulations) for any topic, in any folder, following
  the conventions proven by stocks-trainer, leetcode-coach, and mental-math:
  EPIC_MAP / IMPLEMENTATION_STORIES / .agents/state.json, a milestone loop that
  builds the runtime, and a LOOPS/ content graph that fills it to computable
  coverage floors. Use when the user asks for a new trainer, coach, study,
  practice, or mastery app for a subject (e.g. "electrical circuits for smart
  homes"), or asks to turn a syllabus / book TOCs into an interactive trainer.
disable-model-invocation: true
---

# New Trainer App

Produces a new app folder **anywhere the user chooses** (default: the current working directory), as its own git repo, with every planning and loop artifact the reference apps use. The app does not depend on the reference apps or on a launcher page; those are optional. The runtime is **not** written here; it is built later by the milestone loop this skill emits. Content is filled later by the content graph this skill emits.

Read [reference/conventions.md](reference/conventions.md) once before the first run. It lists the shared constraints and the artifact inventory copied from the three existing apps.

## Inputs

Collect before Phase 1 (ask only for what is missing; infer the rest):

| Input | Example |
|-------|---------|
| Topic | Electrical circuits |
| Learner goal (the "so that") | Build devices and wire smart-home automations without frying parts |
| Learner persona + session length | Maker at a bench, 10–20 min sessions |
| App slug / name / CODENAME | `circuits-trainer` / Circuits Trainer / `CIRCUIT_CORE` |
| Destination folder | Where `<app-slug>/` is created. Default: current directory. Any path works; it does not need to sit next to other trainers. |
| Launcher (optional) | A PHP launcher page like `trainer/index.php` with an `$apps` array, if the user has one and wants a card added |
| Stack | `php` (server-rendered, like leetcode-coach / mental-math) or `vite` (React + TS, like stocks-trainer). Default `php` unless the feature set needs heavy client state (simulations, charts). |

## Phases

The three phases run in **separate sessions**. Never run Phase 2 and Phase 3 loops in the same session. Only Phase 1 may ask the human questions; Phases 2–3 are autonomous loops with stop conditions.

```
Phase 1  Research & plan (interactive, this skill)     → scaffold + filled docs + context/
Phase 2  Runtime (AGENTS_LOOP-Continue-Milestone.md)   → MVP freeze
Phase 3  Content (LOOPS/LOOP-Graph.md)                 → Done(graph)
```

---

## Phase 1 — Research & plan

Copy this checklist and track it:

```
- [ ] 1.1 Scaffold the app folder
- [ ] 1.2 Syllabus catalog (join key + prerequisite order + tracks)
- [ ] 1.3 Source context (clone.sh, TOCs, notes, catalog with licenses)
- [ ] 1.4 Choose resource types from the pedagogy map (with justification)
- [ ] 1.5 Mastery ladder + coverage floors (make Done computable)
- [ ] 1.6 Fill EPIC_MAP, IMPLEMENTATION_STORIES, state.json, RESOURCES, .impeccable.md, README
- [ ] 1.7 Fill the milestone loop and the content graph + one section loop per resource type
- [ ] 1.8 Seed .agents/skills in the app
- [ ] 1.9 (optional) Register a card in the user's launcher page, if they have one
- [ ] 1.10 Commit, then hand off with the Phase 2 command
```

### 1.1 Scaffold

Run from anywhere. `<app-slug>/` is created inside `--dest` (default: current directory):

```bash
bash <path-to-this-skill>/scripts/scaffold.sh <app-slug> "<App Name>" <CODENAME> "<topic>" --stack php|vite [--dest <folder>]
```

The script refuses to overwrite an existing folder. It copies `templates/`, substitutes `{{TOKENS}}`, writes `.gitignore`, runs `git init`, and makes the first commit. If `--dest` contains a launcher `index.php` with an `$apps` array it says so; otherwise step 1.9 is skipped. Everything still containing `<!-- agent: ... -->` or a `{{...}}` token must be filled by hand in the following steps.

The three reference apps are public. When they are not available locally, add any you want as pattern references to the new app's `context/clone.sh` (the same way `mental-math/context/clone.sh` clones its siblings):

```
https://github.com/Siphon880gh/Stocks-Trainer.git    # React/Vite: paths, cases, coach sessions, progress store
https://github.com/Siphon880gh/leetcode-coach.git    # PHP: guides, mini games, coaching trees, harness skill
https://github.com/Siphon880gh/mental-math.git       # PHP: two-track Guides hub, drills, coach rewind, LOOPS graph
```

### 1.2 Syllabus catalog

Act as a subject expert first, then confirm against sources in 1.3.

- Define the **join key** (`familyId` in mental-math, `slug` in leetcode-coach). One id per teachable unit, kebab-case, stable forever. Every resource type joins on it.
- Order units by prerequisite, not by textbook chapter. The first 8–15 units form the **Beginner path**; the rest are later tracks.
- Group units into **tracks** (2–3) that match distinct learner conversations (mental-math: quick math vs stakeholder math). For circuits: `A` fundamentals-on-the-bench, `B` devices-and-microcontrollers, `C` smart-home-and-mains-safety.
- Flag units that are **safety-critical** or **irreversible in reality** (mains wiring, medication, trading). These get cases and coach trees before any free-form practice.
- Write the catalog into `RESOURCES.md` (families table) and `.agents/state.json` (`curriculum.families`).

### 1.3 Source context

Follow [reference/research.md](reference/research.md). Short form:

1. Prefer `git clone --depth 1` of open repos (textbooks, course material, problem sets, reference implementations). Add each to `context/clone.sh` and the catalog table in `context/README.md` with upstream URL, license, and "use for".
2. For books and courses that are not repos, fetch only the **table of contents** and write it as an original outline to `context/toc/<source-slug>.md`. Cite the source URL at the top. Do not copy prose.
3. Write your own expert notes to `context/notes/<unit>.md` when sources disagree or a unit needs a worked example the sources lack.
4. Clones live in `context/repos/` (gitignored). `clone.sh`, `README.md`, `toc/`, `notes/` are tracked.
5. **Stop and ask the human** only when: a source is paywalled or blocks fetching, licensing is unclear for something you want to clone, or the topic is too broad to pick a persona and Beginner path. Say exactly what you tried.

Run `bash context/clone.sh` once and confirm it succeeds before moving on.

### 1.4 Choose resource types

Read [reference/pedagogy-map.md](reference/pedagogy-map.md). Pick the domain kind(s), then the resource types. Write a **justification table** into `EPIC_MAP.md` → "Resource types for this topic": one row per type, one line on what mastery it builds here, and whether it is P0 or later.

Rules:

- Every app has **Guides** and **Coach** (deterministic step-by-step trees). Guide → Coach on the same slug.
- Add **Drills** when the unit has a fast closed-form answer. Add **Cases** when the unit is a decision with consequences. Add **Simulations** only when the learner must *see a system respond to a parameter*; scope them as their own epic with a tiny deterministic engine, never a general-purpose physics package. Add **Games** only for units with one distinct mechanic; otherwise the Games loop records skips.
- Fewer types done deeply beats every type thin. Four to six is normal.

### 1.5 Mastery ladder and coverage floors

"Mastered" must be computable. Declare, in `RESOURCES.md` and `state.json → decisions.content_floors`:

| Rung | Learner can… | Resource types that prove it |
|------|--------------|------------------------------|
| recognize | name the unit and when it applies | Guide |
| explain | walk the reasoning without help | Coach |
| apply | produce the answer under time | Drill / Quiz |
| diagnose | find what is wrong in a scenario | Case / Simulation |
| design | combine units to meet a goal | Case pack / Lab / Simulation target |

Then set floors per family per type (e.g. `guides_per_family: 1`, `coach_per_guide: 1`, `drills_per_family: 8`, `cases_per_track: 6`). **Done(graph)** = every family meets every floor on every rung the plan declared for its track. Write the echo-family table in `LOOPS/LOOP-Graph.md` from the catalog (one row per family, hops = types that apply).

### 1.6 Fill planning docs

Fill, in this order, removing every `<!-- agent: -->` comment: `RESOURCES.md` → `EPIC_MAP.md` → `IMPLEMENTATION_STORIES.md` → `.agents/state.json` → `.impeccable.md` → `README.md`.

- Epics: E0 planning (complete), then one epic per runtime surface (catalog, progress/unlocks, each resource type runtime, path/dashboard), then later/advanced epics. Keep P0 to the thinnest playable Beginner path: catalog + progress + Guides + one Coach tree + one practice type + path + dashboard.
- Every story has an Acceptance cell that lint/build/tests can check. If a story needs human taste, say so in the cell.
- `state.json → milestones.implementation_order` must end at the MVP freeze milestone; `post_mvp_order`, `later_order`, `advanced_order` follow.

### 1.7 Fill the loops

- `AGENTS_LOOP-Continue-Milestone.md`: set the queue table, the per-epic implementation notes under "Implement the current story only", and the verify commands.
- `LOOPS/LOOP-Graph.md`: nodes table (one per resource type), drain order, echo-family table, floors.
- Copy `LOOPS/LOOP-Section.md` once per resource type as `LOOP-<Type>.md` and fill its coverage queue, authoring cadence, and rubric. Delete the generic file afterwards.
- `LOOPS/README.md`: the run-line table.

### 1.8 Seed app skills

Copy `templates/agents-skills/add-unit/SKILL.md` into the app as `.agents/skills/add-<type>/SKILL.md` for each resource type whose authoring will repeat (at minimum Coach). Leave file paths as TODO where the runtime does not exist yet; the milestone loop fills them when the runtime lands.

### 1.9 Register the card (optional)

Only if the user has a launcher page (a PHP file with an `$apps` array, like `trainer/index.php` at wengindustries.com/trainer). Add an entry using the snippet the scaffold wrote to `docs/index-php-card.snippet.php`. `href` is relative to the launcher: `<slug>/` for `php`, `<slug>/dist/` for `vite`. Append after the last existing app; keep the array literal valid. If there is no launcher, skip this step and delete the snippet.

### 1.10 Hand off

Commit inside the app folder. Report:

1. App path, stack, join key, tracks, Beginner path units
2. Resource types chosen + one-line why each
3. Floors and the Done(graph) definition
4. Context sources added (and anything you could not fetch)
5. Exact next command:

```text
cd <app-slug> && /loop continue milestones using AGENTS_LOOP-Continue-Milestone.md
```

Do **not** start the loop in the same session.

---

## Phase 2 and Phase 3 (for reference)

These are driven by the files emitted in Phase 1, not by this skill:

```text
/loop continue milestones using AGENTS_LOOP-Continue-Milestone.md      # until MVP freeze + queues
/loop content graph using LOOPS/LOOP-Graph.md                          # after freeze, until Done(graph)
```

Both inherit: one unit per tick, auto-verify before PASS, 10-round error budget → Error Handoff Summary, hard stops for credentials / ambiguous UX / conflicting docs, create or adapt `.agents/skills/*` when authoring repeats.

## Shared constraints (inherit in every emitted doc)

- Deterministic coaching trees; **no runtime LLM**
- Educational / non-live practice data only (do not stamp SAMPLE on every page)
- Progress in `localStorage` under one versioned key; no auth in MVP
- Rewrite source material in original wording; never paste `context/` verbatim into the UI
- Join key is the only cross-surface id; do not invent a parallel enum
- Guide → Coach same slug; missing coach shows a "not authored yet" slot, never a 404
- Never mix the milestone loop and the content graph in one session
- One milestone `in_progress` at a time; never skip ahead without updating `state.json`

## Files in this skill

| Path | Purpose |
|------|---------|
| `scripts/scaffold.sh` | Creates the app folder from `templates/`, substitutes tokens, `git init` |
| `templates/` | Every artifact the app needs, with `{{TOKENS}}` and `<!-- agent: -->` prompts |
| `reference/conventions.md` | Shared constraints + artifact inventory from the three existing apps |
| `reference/pedagogy-map.md` | Domain kind → resource types, with definitions and runtime cost |
| `reference/research.md` | Sourcing rules for `context/` (repos, TOCs, notes, licensing, when to ask) |
