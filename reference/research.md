# Research rules for `context/`

`context/` is reference material for the agent. It is never served by the app and never pasted verbatim into UI copy.

## Layout

```
context/
├── clone.sh          # tracked — shallow-clones into repos/
├── README.md         # tracked — catalog: folder, upstream, license, use for
├── repos/            # gitignored — git clones
├── toc/              # tracked — original outlines of books / courses, one file per source
└── notes/            # tracked — agent-written expert notes per unit
```

`.gitignore` in the app: `/context/repos/`. Everything else under `context/` is committed.

## Source priority

1. **Open repos** (GitHub / GitLab): open textbooks, course notes, problem sets, reference implementations, datasheets collections. Clone with `--depth 1` via `clone.sh`. Record license in the catalog.
2. **Public course syllabi** (MIT OCW, university course pages, vendor training outlines): write the outline to `toc/`.
3. **Book tables of contents** (publisher pages, Open Library, Google Books "contents" view): write the outline to `toc/`. Multiple books' TOCs per topic is the normal case; the union is the syllabus candidate list.
4. **Official docs and standards** (datasheets, RFCs, codes): link in the catalog; outline the relevant sections in `toc/`.
5. **Encyclopedic outlines** (Wikipedia "Outline of X"): last resort for ordering, never for copy.

Prefer sources with worked examples and exercises; the Drill and Case loops will need them as idea seeds.

## How to fetch

- Repos: `git clone --depth 1 <url> context/repos/<folder>` through `clone.sh` only, so the clone is reproducible.
- Web pages: use the available fetch/search tool. Extract headings and chapter titles only. Write `toc/<source-slug>.md` as:

```markdown
# <Book / Course title> — outline
Source: <url>  ·  Fetched: <date>  ·  Use for: <which tracks / units>

1. Chapter title
   1.1 Section title
...
```

- If a fetch returns a paywall, login wall, or empty body: note it in the catalog under "Could not fetch" and move on. Do not retry more than once.

## `context/README.md` catalog

| Folder / file | Upstream | License | Use for |
|---------------|----------|---------|---------|
| `repos/<name>` | link | MIT / CC-BY-SA / … | guides for track A units 1–6; drill seeds |
| `toc/<slug>.md` | link | n/a (outline only) | syllabus ordering |

Add a short "Could not fetch" list and a "Suggested additions for the human" list (repos you would like cloned but could not verify the license for).

## When to stop and ask the human

Only in Phase 1, and only for:

- A source you believe is essential is paywalled or blocks fetching (say what it is and why it matters)
- A repo you want to clone has no license or a restrictive one
- The topic is too broad to pick one persona and a Beginner path (offer two or three concrete framings)
- The human's goal implies live data, credentials, or hardware access the app cannot have as educational / non-live practice content

Everything else: decide, record the decision in `.agents/state.json → decisions`, continue.

## Licensing and attribution

- Clones stay local; the app never redistributes them (gitignored).
- Guides and coach copy are original. Cite a source by name in a guide only when it helps the learner go deeper, not as a quotation.
- Keep each `toc/` file to structure (titles, order). Titles are facts, not prose.
