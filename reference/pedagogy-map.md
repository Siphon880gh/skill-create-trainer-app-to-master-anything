# Pedagogy map — which resource types fit which topic

Pick the **domain kind(s)** first, then take the recommended types. Justify every type in `EPIC_MAP.md`; drop any you cannot justify in one line.

## Resource types

| Type | Learner does | Builds (rung) | Runtime cost | Include when |
|------|--------------|---------------|--------------|--------------|
| **Guide** | Reads one unit: rule, why it works, **concrete** worked example (values/structures/steps), when to use / refuse | recognize | low | Always |
| **Coach** (step-by-step) | Walks a deterministic choice tree; wrong → explain → rewind; success node | explain | low–medium (nav engine once) | Always; one per guide, same slug |
| **Drill** | Answers a timed bank (typed or MCQ) with a thought-chain reveal | apply | low | Unit has a fast closed-form answer |
| **Quiz** | Untimed MCQ/multi-select with explanation per option | recognize → apply | low | Conceptual units with common misconceptions |
| **Case** | Reads a scenario, commits a decision/number, reveals consequences + grade | diagnose → design | medium | Unit is a decision with consequences or tradeoffs |
| **Lab** | Follows a procedure with checkpoints and a "what you should observe" at each | apply → diagnose | medium | Hands-on craft: wiring, cooking, deploying, dissection |
| **Simulation** | Changes parameters in a tiny deterministic model and watches output; optional target to hit | diagnose → design | high (own epic) | Learner must *see the system respond*; keep the model minimal |
| **Game** | Plays one mechanic that embodies one unit | apply | medium per game | The unit has exactly one distinct mechanic; otherwise skip |
| **Navigator / TOC** | Browses the syllabus by track → unit → resources; deep links | (sequencing) | low | Always, usually as the Guides hub + path |
| **Cheatsheet / summary** | Scans a one-screen recap per unit or track | recognize (retention) | low | Recall-heavy domains; print/offline value |
| **Path + dashboard** | Sees next action, unlocks, gate status | (sequencing) | low | Always |

Every rung the plan declares for a track must be provable by at least one included type.

## Domain kinds → recommended types

| Domain kind | Examples | Core types (P0) | Later types | Notes |
|-------------|----------|-----------------|-------------|-------|
| **Procedural / computational** | mental math, algorithms, unit conversion, music theory drills | Guide, Coach, Drill | Game, Quiz | Timed gate before harder cases works well |
| **Decision under uncertainty** | stocks, poker, triage, negotiation | Guide, Coach, Case (decide-and-reveal) | Quiz, Navigator by market/scenario | Cases carry the aftermath; drills are literacy only |
| **Physical systems / engineering** | circuits, mechanics, thermodynamics, chemistry, control | Guide, Coach, Drill (formula), Case (diagnose the fault) | Simulation (parametric), Lab (build procedure), Quiz | Safety-critical units get Case + Coach before Lab; simulation model must be tiny (e.g. Ohm/KVL on ≤5 components) |
| **Recall-heavy** | anatomy, law, vocabulary, taxonomy, protocols | Guide, Quiz, Cheatsheet, Drill (spaced) | Coach (for application), Case | Spaced repetition schedule stored with progress |
| **Craft / design** | writing, UI, cooking, woodworking | Guide, Coach, Lab, Case (critique / compare) | Checklist cheatsheet, Game | Cases compare two artifacts and reveal the judgment |
| **Systems / strategy** | system design, business ops, architecture | Guide, Coach, Case (tradeoff) | Simulation (capacity/queue), Quiz | Tradeoff matrices inside guides; cases reveal second-order effects |
| **Language / communication** | second language, public speaking, sales calls | Guide, Drill (recall), Case (conversation → commit → reveal) | Coach, Quiz | Conversation cases mirror mental-math's Track B |

Topics usually span two kinds. Example — *electrical circuits for devices and smart homes*:

- Track A (bench fundamentals) = physical systems → Guide, Coach, Drill, Case(diagnose), later Simulation
- Track B (microcontrollers + sensors) = physical + procedural → Guide, Coach, Lab, Case
- Track C (smart home + mains safety) = decision under uncertainty + safety → Guide, Coach, Case first; Lab only after cases; no drills on mains

## Mastery ladder (declare per track)

| Rung | Learner can… | Proven by |
|------|--------------|-----------|
| recognize | name the unit and when it applies | Guide read + Quiz |
| explain | reconstruct the reasoning unaided | Coach success node reached without a wrong-rewind on second pass |
| apply | produce the answer under time or in procedure | Drill accuracy + latency, Lab checkpoints |
| diagnose | find what is wrong in a given scenario | Case grade, Simulation fault-finding |
| design | combine units to hit a goal | Design case pack, Simulation target, capstone Lab |

Floors turn rungs into counts: e.g. `guides_per_family 1`, `coach_per_guide 1`, `drills_per_family 8`, `cases_per_track 6`, `labs_per_track 3`, `simulations_total 2`. Gates (unlock conditions) reference rungs: "Track C cases unlock after Track A drill accuracy ≥ 0.8 and median latency ≤ N ms."

## Anti-patterns

- Every type thin "for completeness" → pick four to six and set real floors
- Simulation as a general engine → one model per family, deterministic, educational (non-live) values, no external physics library in P0
- Games for every unit → the Games loop should record skips most ticks
- Coach trees that are quizzes with buttons → teach *which method to pick*, with wrong branches that explain and rewind
- Pasting textbook prose into guides → outline in `context/toc/`, rewrite in original words
- **Guides:** SAMPLE / "SAMPLE example" / "SAMPLE lesson" labels in prose; "Recall checkpoint" or identical-paragraph padding; batch Stage-0 authorship of dozens of guides; slogan pads to hit 300 words; abstract paraphrase sold as a worked example (must have concrete values/structures/steps)
