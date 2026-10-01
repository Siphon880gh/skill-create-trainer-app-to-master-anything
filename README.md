# new-trainer-app

A Cursor agent skill that turns a topic ("electrical circuits for devices and smart homes") into a new sibling trainer app in this workspace, built the same way `stocks-trainer`, `leetcode-coach`, and `mental-math` were built:

1. **Plan** (interactive): syllabus catalog with a join key, tracks, Beginner path, resource types chosen from a pedagogy map, computable coverage floors, reference material under `context/`
2. **Runtime** (autonomous `/loop`): `AGENTS_LOOP-Continue-Milestone.md` builds the app one story per tick until MVP freeze
3. **Content** (autonomous `/loop`): `LOOPS/LOOP-Graph.md` picks a section loop each tick and fills guides, coach trees, drills, cases, labs, simulations, games until every floor is met

The skill writes planning docs and loop prompts. It does not write runtime code; the loops do.

## Where it lives

```
trainer/
├── index.php                      # root launcher (one card per app)
├── stocks-trainer/                # own git repo
├── leetcode-coach/                # own git repo
├── mental-math/                   # own git repo
└── .agents/skills/new-trainer-app/   # this skill — own git repo, outside every app
```

`trainer/` itself is not a git repo. Each app is. This skill folder is too, so it can be versioned and reused in another workspace without pulling in any app.

## Install elsewhere

```bash
git clone <this-repo-url> .agents/skills/new-trainer-app
```

Cursor discovers skills under `.agents/skills/` in the workspace root. The skill is `disable-model-invocation: true`, so invoke it by name.

## Use

In Cursor, from the `trainer/` workspace:

```text
Use the new-trainer-app skill to create a trainer for electrical circuits, for a maker who wants to build devices and smart-home automations.
```

The agent will:

- run `scripts/scaffold.sh` to create `<app-slug>/` with every artifact pre-filled with tokens
- act as a subject expert and research sources (open repos, book TOCs, course syllabi) into `<app>/context/`
- choose resource types with a justification table
- fill `EPIC_MAP.md`, `IMPLEMENTATION_STORIES.md`, `RESOURCES.md`, `.agents/state.json`, `.impeccable.md`, the milestone loop, the content graph, and one section loop per type
- add a card to `trainer/index.php`
- hand you the Phase 2 command

Then, in a **new** session inside the app folder:

```text
/loop continue milestones using AGENTS_LOOP-Continue-Milestone.md
```

After MVP freeze, in another new session:

```text
/loop content graph using LOOPS/LOOP-Graph.md
```

## Manual scaffold

```bash
cd trainer
bash .agents/skills/new-trainer-app/scripts/scaffold.sh circuits-trainer "Circuits Trainer" CIRCUIT_CORE \
  "electrical circuits for devices and smart homes" --stack php
```

Options: `--stack php|vite` (default `php`), `--join-key <name>` (default `familyId`), `--dest <dir>` (default cwd). The script refuses to overwrite an existing folder, substitutes `{{TOKENS}}`, writes `.gitignore`, and makes the first commit. Every `<!-- agent: -->` / `AGENT:` marker left in the output must be filled by the agent in Phase 1.

## Layout

```
new-trainer-app/
├── SKILL.md                     # the workflow (Phase 1 checklist, constraints, handoff)
├── README.md                    # this file
├── reference/
│   ├── conventions.md           # artifact inventory + hard constraints from the three apps
│   ├── pedagogy-map.md          # domain kind → resource types; mastery ladder; floors
│   └── research.md              # context/ sourcing rules, licensing, when to ask the human
├── templates/
│   ├── EPIC_MAP.md
│   ├── IMPLEMENTATION_STORIES.md
│   ├── RESOURCES.md
│   ├── state.json               # → <app>/.agents/state.json
│   ├── AGENTS_LOOP-Continue-Milestone.md
│   ├── LOOPS/{README,LOOP-Graph,LOOP-Section}.md
│   ├── context/{clone.sh,README.md}
│   ├── agents-skills/add-unit/SKILL.md   # seed for <app>/.agents/skills/add-*
│   ├── impeccable.md            # → <app>/.impeccable.md
│   ├── README.md                # → <app>/README.md
│   ├── gitignore                # → <app>/.gitignore
│   └── index-php-card.php       # snippet for trainer/index.php
└── scripts/
    └── scaffold.sh
```

## Design decisions

- **Phases are separate sessions.** Research may ask questions; loops never do except via stop conditions. Running the milestone loop and the content graph in one session is forbidden, matching the existing apps.
- **"Mastered" is a number.** Done(graph) is computed from the family catalog × per-type floors × declared mastery rungs. No loop runs "until it feels complete".
- **`context/repos/` is gitignored; `context/toc/` and `context/notes/` are tracked.** Clones are reproducible via `clone.sh`; the agent's own outlines and notes are small and worth keeping.
- **Guides and Coach are mandatory.** Every other type is chosen per topic from `reference/pedagogy-map.md` with a one-line justification. Simulations are allowed but scoped as their own epic with a tiny deterministic model.
- **Shared constraints are inherited verbatim:** deterministic coaching trees, no runtime LLM, SAMPLE data, `localStorage` progress, rewrite never paste, one join key, one unit per tick, 10-round error budget.

## Updating the skill

When an app built with this skill settles on a better pattern (a cleaner state shape, a better section loop), fold it back into `templates/` and commit here, so the next app starts from it.
