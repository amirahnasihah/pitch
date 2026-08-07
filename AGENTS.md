# Project rules for this job-search workspace

These rules apply to every agent, every skill, and every generated document.

## Sources of truth (split ownership)

| Concern | Source of truth | Notes |
|---|---|---|
| **Facts** (roles, bullets, skills, projects, certs, clients, metrics) | **log.exe** | Via MCP (preferred), `logexe` CLI, or REST. Do not invent from stale TeX alone. |
| **PDF layout + per-job trim** | **this repo (pitch)** | LaTeX templates, ATS rules, page budget, `applications/<company>/`, and the full CV (`cv.tex`). |
| **Application trail** | deferred | See below — folders today; no tracker product yet. |

### Facts: log.exe

Amirah’s career corpus lives in log.exe (`https://exe.amrhnshh.com`, local
`:4500`). Pitch does **not** own that data. Before analyze/tailor/log, **pull
fresh facts** from log.exe (MCP first). Never fabricate jobs, titles, dates,
skills, tools, metrics, or achievements. If information is missing after a
pull, ASK the user. Honest gaps beat invention.

### Layout cache: `master-resume.tex`

`master-resume.tex` is a **LaTeX layout + local cache** of facts already
confirmed in log.exe. It is gitignored. Keep it; do **not** delete it.

- Prefer refreshing its content from log.exe when it drifts or before a
  tailor session that will edit it.
- If it is missing, `cp master-resume.example.tex master-resume.tex` and
  fill from log.exe — NEVER treat the fictional example persona as the
  candidate.
- If a job requirement is not covered by log.exe (and thus not in the
  refreshed master), report it as a gap. Do not paper over it.

### The three documents (do not confuse them)

| File | Length | Tailored? | Sent to anyone? |
|---|---|---|---|
| `master-resume.tex` | any | no | **never** — staging cache |
| `applications/<company>/resume.tex` | 1 page (hard max 2) | yes, per job | yes |
| `cv.tex` | 3 to 5 pages | **no** | yes, on request |

`cv.tex` is the **full professional CV**: every role, every substantial
project, the whole skill inventory, all education and certifications. Send it
when someone asks for a "full CV" rather than a one-page resume (common in the
EU, the UK, and Japan). Built by the `cv` skill.

- Gitignored, same reason as `master-resume.tex`. Tracked counterpart:
  `cv.example.tex` (fictional persona).
- **Exempt from the page budget below** — do not run
  `scripts/check-pages.sh` against it. It is NOT exempt from the honesty,
  ATS-formatting, or confidentiality rules.
- Keeps the page count honest by compacting thin projects into an
  `\textit{Also built:}` paragraph per group, rather than padding with
  near-empty entries.

### Application trail (deferred)

Not built yet. When it exists, a trail row should be enough: **company**,
**role**, **date**, **folder** (`applications/<company>/`), **status**
(e.g. drafted / submitted / interviewing / closed). Until then, the folder
plus `changelog.md` / `review.md` is the trail. Do not build a tracker in
this pass.

## log.exe MCP / CLI wiring

Credentials: `~/.log-exe-creds` (`chmod 600`), shared by CLI and MCP setup.
See log.exe `web/README.md` (`bun run mcp:setup`).

### Claude Code

From the log.exe `web/` directory:

```bash
bun run mcp:setup          # production → user-scope server `log-exe`
bun run mcp:setup --local  # localhost:4500 → project-scope `log-exe-dev`
```

Restart Claude Code after setup. Pitch sessions then call the `log-exe`
(or `log-exe-dev`) tools directly.

### OpenCode

Add a remote MCP entry (headers from `~/.log-exe-creds`, never commit
secrets). Production example shape:

```jsonc
"mcp": {
  "log-exe": {
    "type": "remote",
    "url": "https://exe.amrhnshh.com/api/mcp",
    "enabled": true,
    "oauth": false,
    "headers": {
      "Authorization": "Bearer <LOGEXE_WRITE_TOKEN>",
      "CF-Access-Client-Id": "<CF_ACCESS_CLIENT_ID>",
      "CF-Access-Client-Secret": "<CF_ACCESS_CLIENT_SECRET>"
    }
  }
}
```

Local: `http://localhost:4500/api/mcp` with only the Bearer write token
(Access is not in front of localhost).

### Fact-pull tools (call these first)

Prefer MCP. Names below are real tools on the log-exe server:

| Tool | Use for resume |
|---|---|
| `get_site_meta` | Summary, location, GitHub, website (contact / headline) |
| `get_experience` | Certifications + experience groups (bullets / tech) |
| `list_projects` | Projects; filter by `kind` (`work` \| `personal`) |
| `get_project` | Full detail for a selected slug |
| `list_clients` | Client / internal engagements (generalized) |
| `list_articles` | Public writing samples when relevant |
| `ask_kb` | Optional: keyword Q&A with citations when unsure where a fact lives |

**Skills:** MCP `get_experience` returns certifications + groups only. Skill
areas come from REST `GET /api/experience` (includes `skills`) or CLI
`logexe experience` (same payload). Use that fallback for the Skills
section; do not invent a non-existent MCP skills tool.

### CLI fallback (`logexe`)

If MCP is unavailable:

```bash
logexe --prod experience    # or omit --prod for localhost:4500
logexe --prod projects list
logexe --prod clients
logexe --prod articles list
```

Creds: `~/.log-exe-creds`. KB ask is REST/MCP only (`ask_kb` /
`POST /api/kb/ask`), not a CLI subcommand.

### Section mapping (facts → LaTeX)

| Resume section | log.exe source |
|---|---|
| Header / Summary | `get_site_meta` (+ trim for the job) |
| Skills | REST/CLI experience `skills` |
| Work Experience | `get_experience` groups; deepen with `list_clients` when needed |
| Projects | `list_projects` / `get_project` (`kind` guides work vs personal) |
| Certifications | `get_experience` → `certifications` |
| Education | Still often only in `master-resume.tex` until seeded in log.exe — ask if missing |

## Asking the user questions
- Before asking anything, check log.exe (MCP/CLI) and then `master-resume.tex`.
- Collect every question you have FIRST, then ask them together as ONE
  batched, numbered list — never one question at a time across many turns.
- If a second round is truly needed, keep it short and explain why.

## ATS-safe formatting rules (apply to every generated resume)
- Single column only. No tables, no text boxes, no images, no icons.
  No headshot / profile photo of the candidate (takyah image).
- Contact info in the document body, not in a page header/footer.
- Standard section names only: Summary, Skills, Work Experience,
  Projects, Education, Certifications.
- Reverse-chronological order (most recent first).
- One consistent date format, e.g. "Jan 2023 - Present".
- Consistent section styling: section title, small gap, then a full-width
  rule below it (use the titlesec package so spacing never clamps the line).
- No em dashes. Use " | " as a separator in the contact line and between a
  role title and its organisation; inside sentences, restructure or use a
  colon or hyphen.
- Page budget, for **tailored resumes only** (`applications/<company>/`):
  prefer ONE page, hard maximum TWO, never ship three or more. After
  compiling, run `scripts/check-pages.sh <resume.pdf>` (uses pdfinfo). Exit
  non-zero / fail the tailor if Pages > 2; trim until it passes. Prefer
  trimming to 1 page when content allows.
  This budget does **not** apply to `cv.tex`, which is meant to run 3 to 5
  pages. Do not run the page check against it.
- Compile with tectonic (preferred) or pdflatex. After compiling, run a
  text-extraction check (pdftotext) to confirm the text reads top-to-bottom
  in the correct order.

## Writing style for bullets
- Start with an action verb. Include a real number where log.exe / the
  master cache provides one. Never fabricate numbers.
- Mirror the job description's exact wording ONLY when it truthfully
  describes the candidate's experience.

## Distinguishing education, work, and projects
- Bootcamps, academies, and training programmes are EDUCATION, not work
  experience — even if intensive or full-time. Place them under Education.
- Capstone or course projects belong under Projects, where strong technical
  work can still stand out. Do not duplicate the same project in two
  sections.

## File organization
Each application lives in `applications/<company-name>/`:
- `job-description.md` — the original posting text
- `job-analysis.md` — output of the analyze skill
- `resume.tex` + `resume.pdf`
- `cover-letter.tex` + `cover-letter.pdf`
- `changelog.md` — every change vs. master resume, with a one-line reason
- `review.md` — output of the review skill
- `interview-prep.md` — output of the prep skill

## Language
- Explain things in simple, clear language. Some users are not native
  English speakers. Avoid jargon, or explain it when unavoidable.
