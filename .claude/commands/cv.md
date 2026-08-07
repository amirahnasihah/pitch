Build or refresh the full professional CV: `cv.tex` + `cv.pdf` in the repo root.
$ARGUMENTS

**Ownership:** log.exe = facts SoT. Pitch = PDF layout.
Follow every rule in `AGENTS.md`.

This is the COMPREHENSIVE, NON-TAILORED document — 3 to 5 pages, sent when
someone asks for a "full CV" rather than a one-page resume. It is exempt from
the one-page resume gate (do not run `scripts/check-pages.sh` on it), but not
from the honesty, ATS-formatting, or confidentiality rules.

Requirements:

0. **Refresh facts from log.exe first** (do not invent from stale TeX alone):
   - MCP: `get_site_meta`, `get_experience`, `list_projects` (+ `get_project`
     where unclear), `list_clients`.
   - Skills: CLI `logexe experience --prod` or REST `GET /api/experience`
     (MCP `get_experience` omits skill areas).
   - Employer names, titles, dates, education, and phone still live only in
     `master-resume.tex` / honesty-passed `applications/*/resume.tex`. Carry
     them forward; never invent them.

1. If `cv.tex` is missing, `cp cv.example.tex cv.tex`. Never treat the
   fictional Jordan Ruiz persona as the candidate.

2. Sections, in order: Profile, Skills, Work Experience, Selected Client
   Engagements, Projects, Education, Certifications.
   - Group bullets within a role using `\grp{}` when the role spans distinct
     kinds of work.
   - Clients: describe by sector, never by name (this repo is public).
   - Projects: group by theme; full `\job{}` entries for substantial work,
     an `\textit{Also built:}` paragraph for the thin tail, and an
     "Earlier work" paragraph for pre-professional projects.
   - Bootcamps go under Education; their capstones under Projects, not both.

3. Apply every honesty guard in the `cv.tex` header comment: no unowned
   claims, no GitHub URLs for private repos, no `exe.amrhnshh.com` contact,
   no headshot, no artefact listed under two sections.

4. Compile with `tectonic cv.tex`. Then check
   `pdfinfo cv.pdf | grep Pages` (expect 3 to 5) and
   `pdftotext -layout cv.pdf -` (text reads in the right order).
   Over 5 pages: compact the tail, do not delete real work.

5. Report the page count, any remaining `[[FILL: ...]]`, and any fact log.exe
   could not supply — as ONE batched, numbered list.
