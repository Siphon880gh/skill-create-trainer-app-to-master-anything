---
name: add-<!-- agent: type, e.g. coaching-session -->
description: >-
  Add one {{APP_NAME}} <!-- agent: unit kind --> for a `{{JOIN_KEY}}`.
  Use when authoring or pairing <!-- agent: route --> with a guide / family.
---

# Add a <!-- agent: unit kind -->

One valid unit per family. Slug = `{{JOIN_KEY}}` = guide slug. No runtime LLM. Educational / non-live data.

## Files

<!-- agent: fill when the runtime lands (milestone loop updates this skill as part of the story that ships the runtime). -->

- New: `TODO path/<slug>.json` (source of truth; auto-loaded)
- Validate: `TODO command`

No register step if the runtime scans the directory. Otherwise list the registry file here.

## Shape

Match an existing file such as `TODO path/<first-slug>.json`. Required parts:

<!-- agent: per type. Coach minimum: `start` + two more continue layers, ≥2 `wrong` nodes with `rewind_to`, ≥1 `success` with empty choices; `meta.{{JOIN_KEY}}` = slug; first message is an educational setup; teach which method to pick. -->

**When this unit is a Guide**, also require:

- `rule`, `why`, `example`, `use`, `refuse` (parts and/or body sections)
- Worked example is **concrete** (digits, small structures, named steps) — not an abstract paraphrase of the rule
- Prefer ~400–600 teaching words inside the 300–800 band; if short, expand the example — never pad
- No `SAMPLE` / `SAMPLE example` / `SAMPLE lesson` / `Recall checkpoint` in body or parts
- No identical paragraph repeated ≥3 times; no `sample: true` / `meta.sample` stamp

## Verify

1. Validator passes
2. `{{VERIFY_CMD}}`
3. The unit is reachable from its guide / hub (not "not authored yet")
4. Guides: no SAMPLE/checkpoint; concrete example (digit in worked example); 300–800 without filler
