# POSLife Chat 00 - Project Cleanup and Baseline

## Step 1: Review

| Field | Value |
|-------|-------|
| Chat | 00 - Project cleanup and baseline |
| Step | 1 - Review |
| Date | 2026-11-11 |
| Status | In Progress (waiting for owner decisions) |
| Project Owner | Roberto Urbina |

## Purpose

Leave the project with one clean, consistent baseline (documents, repository structure, no duplicates or empty files) before Chat 01 onward builds on it.

## Scope

Included:

- Duplicate and empty files
- Documents with wrong or placeholder content
- File naming consistency
- Consistency between README and roadmap

Not included (assigned to later chats):

| Item | Assigned To |
|------|-------------|
| Data dictionary duplicates | Chat 03 - Data dictionary |
| Standards conflicts (`status` vs `is_`, primary key rule, constraint naming) | Chat 02 - Standards and conventions |
| Unrunnable `.sql` file (text outside the comment block) | Chat 06 - PostgreSQL schema, part 1 |

## Findings

| # | Finding | Proposed Action | Affected Files |
|---|---------|-----------------|----------------|
| 1 | Five `README.MD` / `README.md` files; three are empty. The two with content differ (Spanish status list vs. English project status). | Keep one `README.md` in English, merge the useful status content, delete the rest. | `README.md`, `README.MD` (x4) |
| 2 | `roadmap.md` exists twice; one copy is empty. | Keep the copy with content. | `roadmap.md` (x2) |
| 3 | Empty files with no content. | Fill `architecture-decisions.md` with decisions already made (stack, layers, no physical deletes, BIGSERIAL keys). Delete `05-business-rules.md` and `04-v2-roadmap.md` for now (business rules = Chat 05; V2 comes after V1). | `architecture-decisions.md`, `05-business-rules.md`, `04-v2-roadmap.md` |
| 4 | `01-project-vision.md` contains a commit message instead of content. | Rewrite as a real vision document. | `01-project-vision.md` |
| 5 | `functional-scope-v1.md` has the real freeze date (2026-10-20) and a `YYYY-MM-DD` placeholder. | Remove the placeholder. | `02-functional-scope-v1.md` |
| 6 | Numeric prefixes (`01-`, `02-`, `03-`) repeat across unrelated documents and do not match the roadmap chat numbers. The roadmap already refers to files without prefixes. | Drop the prefixes (e.g. `data-dictionary.md`, `naming-conventions.md`). Names stay kebab-case. | All documents with numeric prefixes |
| 7 | README status is out of sync with the roadmap (README: Standards and Data Dictionary 100%; roadmap: Needs Cleanup). | Make `roadmap.md` the single source of truth; the README points to it. | `README.md`, `roadmap.md` |
| 8 | Roadmap progress log shows creation on 2026-11-12, but the date was 2026-11-11. | Confirm the correct date and fix the log. | `roadmap.md` |

## Open Points

| # | Question | Recommendation | Decision |
|---|----------|----------------|----------|
| 1 | Approve dropping the numeric file prefixes (finding 6)? | Yes. Prefixes repeat and do not match roadmap chat numbers. | Pending |
| 2 | Keep `backups/` in the repository structure but exclude it from Git through `.gitignore`? | Yes. Backups should not be committed. | Pending |
| 3 | What is the correct date for the roadmap creation entry (finding 8)? | 2026-11-11. | Pending |

## Next Step

Step 2 - Develop: prepare the clean `README.md`, the vision document, the first architecture decisions, the `.gitignore`, and the repository cleanup checklist, once the open points are decided.

## Suggested Commit Message

```text
Chat 00 Step 1: cleanup review document
```

## Suggested Location

```text
POSLife/docs/chat-00-cleanup-review.md
```
