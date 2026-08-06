---
name: tailor
description: Create an ATS-safe tailored resume and cover letter from an existing job analysis, pulling facts from log.exe then trimming in LaTeX. Use when the user asks to tailor an application for a company.
---

Create a tailored resume and cover letter for the company named in the user's message.
(If no company name is given, use the most recent folder in `applications/`.)

**Ownership:** log.exe = facts SoT. Pitch = PDF layout + per-job trim.
Follow every rule in `AGENTS.md` (including page policy and MCP wiring).

Requirements:

0. **Refresh facts from log.exe (do this first — do not invent from stale TeX)**
   - Prefer MCP tools on the `log-exe` / `log-exe-dev` server:
     - `get_site_meta` — summary / contact
     - `get_experience` — certifications + experience groups
     - `list_projects` — then `get_project` for slugs you will keep
     - `list_clients` — client/internal context when relevant
     - `list_articles` — only if writing samples help this job
     - `ask_kb` — optional, when a fact is hard to locate
   - Skills: MCP `get_experience` does **not** include skill areas. Use CLI
     `logexe experience` (add `--prod` for production) or REST
     `GET /api/experience` for the `skills` array.
   - If MCP is down: same via `logexe` / REST using `~/.log-exe-creds`.
   - Optionally refresh `master-resume.tex` so the cache matches log.exe
     before trimming. Never treat `master-resume.example.tex` as the candidate.

1. Read `applications/<company>/job-analysis.md` and the refreshed facts
   (and `master-resume.tex` as layout/cache).

2. Build `resume.tex` in the company folder:
   - Select ONLY the most relevant experience, projects, and skills for the
     top-priority requirements. Cut low-relevance content to fit one page
     when possible (hard max: two pages; never three+).
   - Reorder so the strongest match appears in the top third of the page.
   - Rewrite bullets to mirror the job's exact keywords, but ONLY where
     truthful. Follow every rule in AGENTS.md (ATS-safe, no invention).
   - Apply the design rules from AGENTS.md: titlesec section styling so
     rules never clamp titles; " | " separators; NO em dashes anywhere.
   - Do not duplicate a project or role in two sections. Bootcamps go under
     Education; their capstone projects go under Projects.

3. Build `cover-letter.tex`: maximum 250 words, 3 short paragraphs:
   (a) why this company specifically (use the company research),
   (b) my 2-3 strongest matching achievements with real numbers,
   (c) short, confident closing. Avoid clichés. No em dashes.

4. Compile both to PDF with tectonic (or pdflatex). Fix any compile errors yourself.
   Then run the page-count gate:
   `scripts/check-pages.sh applications/<company>/resume.pdf`
   Confirm pages ≤ 2; prefer 1. If the check fails (Pages > 2), trim
   lowest-relevance content and recompile until it passes. Never ship >2.

5. Write `changelog.md`: every meaningful change vs. the master/cache
   (and note if facts were refreshed from log.exe), each with a one-line reason.

6. Show me: the changelog summary and any PARTIAL/GAP items you had to
   handle, so I can verify nothing is exaggerated.
