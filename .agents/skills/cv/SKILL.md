---
name: cv
description: Build or refresh the full professional CV (cv.tex / cv.pdf) — the comprehensive, non-tailored document, pulled fresh from log.exe. Use when the user asks to generate, update, or refresh their CV, or when a recruiter has asked for a "full CV" rather than a one-page resume.
---

Build or refresh `cv.tex` and compile it to `cv.pdf` in the repo root.

**Ownership:** log.exe = facts SoT. Pitch = PDF layout.
Follow every rule in `AGENTS.md`.

## What a CV is here, and what it is not

| Document | Length | Tailored? | Sent? |
|---|---|---|---|
| `master-resume.tex` | any | no | never — staging cache |
| `applications/<company>/resume.tex` | 1 page (max 2) | yes, per job | yes |
| `cv.tex` | 3 to 5 pages | **no** | yes, on request |

The CV is the comprehensive document: every role, every substantial project,
the full skill inventory, all education and certifications. It is **exempt
from the one-page resume gate** in AGENTS.md, but not from the honesty rules,
the ATS formatting rules, or the confidentiality rules. Do not run
`scripts/check-pages.sh` against it.

Requirements:

0. **Refresh facts from log.exe first (do not invent from stale TeX)**
   - MCP tools on `log-exe` / `log-exe-dev`:
     - `get_site_meta` — summary, location, contact
     - `get_experience` — certifications + experience groups
     - `list_projects` — the full corpus; `get_project` for anything unclear
     - `list_clients` — client and internal engagements
   - Skills areas are NOT in MCP `get_experience`. Use CLI
     `logexe experience --prod` (or REST `GET /api/experience`) and read the
     `skills` array.
   - Some facts still live only in `master-resume.tex` or in an already
     honesty-passed `applications/*/resume.tex`: employer names, job titles,
     employment dates, education, phone. Carry those forward. Never invent
     them.

1. If `cv.tex` does not exist, start from `cv.example.tex`
   (`cp cv.example.tex cv.tex`). Never treat the fictional Jordan Ruiz
   persona as the candidate.

2. Build the document in this order:
   Profile, Skills, Work Experience, Selected Client Engagements, Projects,
   Education, Certifications.
   - **Work Experience:** every role, reverse-chronological. Where one role
     covers distinct kinds of work, group bullets with `\grp{}`.
   - **Client Engagements:** describe by sector, not by name — this repo is
     public and the tailored resumes never name clients. Note in your report
     that the names can be given verbally.
   - **Projects:** group by theme (AI and agentic systems, developer tooling,
     web and product, hardware, infrastructure). Give substantial projects a
     full `\job{}` entry. Sweep thin one-liners into an `\textit{Also built:}`
     paragraph per group, and the pre-professional tail into an
     "Earlier work" paragraph. Thirty near-empty entries is not
     comprehensiveness, it is padding.
   - **Education:** degrees AND bootcamps/academies, reverse-chronological.
     Their capstone projects go under Projects, never in both.

3. Carry every honesty guard listed in the header comment of `cv.tex` (and
   in `master-resume.tex`). At minimum: no claims the candidate did not own,
   no GitHub URLs for private repos, no `exe.amrhnshh.com` as a contact, no
   headshot, and never list the same artefact under both Work Experience and
   Projects.

4. Compile with `tectonic cv.tex`. Fix any compile errors yourself.
   Then verify:
   - `pdfinfo cv.pdf | grep Pages` — expect 3 to 5. If it exceeds 5, compact
     more of the long tail into "Also built" paragraphs rather than deleting
     real work.
   - `pdftotext -layout cv.pdf -` — confirm the text reads top to bottom in
     the correct order.

5. Report back: the page count, anything you had to leave as `[[FILL: ...]]`,
   and any fact you could not source from log.exe. Collect every question you
   have into ONE batched, numbered list.
