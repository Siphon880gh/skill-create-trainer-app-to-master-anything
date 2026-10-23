# Guide quality bar (non-negotiable)

Every guide unit must teach a human, not game a word-count floor.

## Required shape

1. **Rule** — one clear statement of the technique or decision rule.
2. **Why** — interview / real failure mode that makes the rule matter.
3. **Worked example** — **concrete**: numbers, small structures, or named steps a learner can rehearse. Not an abstract restatement of the rule. Prefer a lead like `Worked example.`
4. **When to use** — triggers and shapes that fit.
5. **When to refuse** — unsorted input, broken invariants, wrong predicate, etc.

Prefer **~400–600** real teaching words inside the **300–800** band. If under 300, expand the worked example with more concrete steps — **never** append filler.

## Forbidden

- `SAMPLE`, `SAMPLE example`, `SAMPLE lesson` (or similar) in learner-facing prose
- `Recall checkpoint` lines or identical repeated paragraphs to pad length
- Slogan / append loops to hit 300 words
- Batch-authoring dozens of guides in one Stage-0 tick
- Top-level or `meta.sample: true` stamps meant as UI chrome
- Declaring Done(guides) from file count + word count alone

## Tests / rubrics must reject

Word-count + paste checks are necessary but **not sufficient**. Section loops and PHPUnit (or stack equivalent) MUST also fail on SAMPLE-in-prose, recall-checkpoint / identical-paragraph padding, missing concrete example (no digit in `parts.example` / worked-example section), and obsolete `sample` stamp keys.
