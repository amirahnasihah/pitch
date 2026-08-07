# Shortlist - A Resume Tailor

Turn one master resume into a job-specific, ATS-safe resume and cover letter
in minutes using a target-compatible AI agent harness and LaTeX.

For Amirah’s setup, **log.exe** is the source of truth for career facts
(MCP / CLI / API). This repo owns **LaTeX layout and per-job trim**;
`master-resume.tex` is a local layout cache (gitignored), not a second
database. See `AGENTS.md` for MCP wiring.

For each job, you paste the posting and run a few skills. Your agent pulls
facts from log.exe, picks the most relevant experience, and generates a
tailored one-page resume and cover letter as PDFs — then stress-tests them
like a real recruiter and an ATS robot.

## Why this exists

Applying to jobs one by one is slow, and most people either send the same
generic resume everywhere or spend an hour rewriting it per job. This kit
makes each tailored application take about 15 minutes, while keeping two
rules that actually matter:

1. **Never invent anything.** The agent is instructed to never fabricate
   experience, skills, or numbers. Gaps are reported honestly, not papered
   over. What you send is something you can defend in an interview.
2. **Pass the robots, please the humans.** The template is ATS-safe (single
   column, standard headings, no tables or graphics) *and* clean-looking for
   the human who reads it after the software filter.

## How it works

```
log      write facts to log.exe, refresh master-resume.tex cache (anytime)
  |
analyze  paste a job posting -> match vs log.exe (strong / partial / gap)
  |
tailor   pull log.exe facts -> trim in LaTeX -> resume + cover PDFs
  |
review   stress-test: skeptical recruiter + ATS robot, scored out of 10
  |
prep     before the interview: likely questions, STAR answers, mock round

cv       (any time, off to the side) pull log.exe facts -> the full
         multi-page CV, not tailored to any job
```

## Requirements

- One target-compatible agent harness and its normal account or API access:
  [Claude Code](https://code.claude.com/docs/en/setup),
  [Codex CLI](https://developers.openai.com/codex/cli/), or
  [OpenCode](https://opencode.ai/docs/)
- A LaTeX distribution (for compiling PDFs):
  - Windows: [MiKTeX](https://miktex.org)
  - macOS: [MacTeX](https://tug.org/mactex/) (or `brew install --cask mactex-no-gui`)
  - Linux: `sudo apt install texlive-latex-recommended texlive-latex-extra`

> **Validation status (July 21, 2026):** Codex CLI 0.144.5 and OpenCode 1.18.4
> discovered all five skills; Codex and OpenCode loaded `analyze` explicitly.
> Claude Code 2.1.206 is installed but needs `claude auth login`. The master
> template compiled with `tectonic` and extracted correctly with `pdftotext`;
> exact `pdflatex` validation is pending because BasicTeX installation needs
> an interactive macOS admin password. The legacy
> `.claude/commands/` files remain temporarily until Claude skill runtime
> validation passes.

## Quick start

```bash
git clone https://github.com/amirahnasihah/shortlist.git
cd shortlist
cp master-resume.example.tex master-resume.tex
```

That last step matters: `master-resume.tex` is gitignored, so your real
details never reach GitHub. The tracked `master-resume.example.tex` holds a
fictional persona showing the expected structure.

Start your chosen agent and invoke skills using its native syntax:

| Tool | Start | Analyze a job |
|---|---|---|
| Claude Code | `claude` | `/analyze [paste the job description]` |
| Codex CLI | `codex` | `$analyze [paste the job description]` or choose it from `/skills` |
| OpenCode | `opencode` | `Use the analyze skill for this job description: ...` |

Then, inside the agent:

1. **Build your master resume.** Copy your current resume (PDF or Word) into
   this folder, then tell the agent:
   > Read my resume file and expand it into master-resume.tex. Then ask me
   > for any missing numbers and details — collect all your questions and
   > ask them together as one batched list, not one at a time.

   Your master resume should hold *more* than a normal resume — every
   project, every number, every skill. It can be several pages; it is never
   sent anywhere. See `master-resume.example.tex` for the expected structure
   and formatting.

2. **Apply to a job.** Find a real posting, copy the text, then invoke the
   `analyze`, `tailor`, and `review` skills in that order. Use `/skill-name`
   in Claude Code, `$skill-name` in Codex, or ask OpenCode to use the named
   skill.
   Your PDFs land in `applications/<company>/`.

3. **Before the interview:**
   Invoke the `prep` skill with the company name.

4. **Keep it fresh.** Whenever you ship or learn something:
   Invoke the `log` skill with the factual update, for example: "finished
   an eval harness for my project; accuracy went from 70% to 91%."

## First run: what to expect

Two things surprise new users, and both are intentional — but we have
smoothed them out:

**Questions.** On your first session the agent interviews you to fill in
your master resume with real projects, numbers, and dates. This happens
because the kit refuses to invent anything — it can only work with facts
you give it. The interview happens **once**; after that, each application
takes only a few minutes. The project rules tell the agent to ask its
questions as one batched list, not one at a time.

**Permission prompts.** Claude Code asks before running commands on your
machine — that is its safety model, not a bug. This repo ships a
pre-approved list (`.claude/settings.json`) covering the routine commands
the skills use: compiling PDFs (`pdflatex`), checking how an ATS robot
reads them (`pdftotext`, `pdfinfo`), creating application folders, and
editing files inside `applications/`. Anything outside that list — deleting
files, installing software, fetching an unknown website — still asks you
first. That is the safety belt working as intended, and those prompts
should now be rare. (Codex CLI and OpenCode have their own approval
systems; check their docs for the equivalent setting.)

## The skills

| Skill | What it does |
|---|---|
| `analyze` | Studies a job posting and maps each requirement to your experience: strong match, partial match, or honest gap. |
| `tailor` | Pulls facts from log.exe MCP/CLI, then builds the tailored resume and cover letter as PDFs (prefer 1 page, max 2). Shows a changelog and flags any gap it refused to fake. |
| `review` | Two strict reviewers: a recruiter doing a 10-second scan, and an ATS robot checking keyword coverage and parse order. Scores each out of 10. |
| `prep` | Generates likely interview questions, STAR answers built from your real experience, honest ways to handle gaps, and smart questions to ask them. Can run a mock interview. |
| `log` | Files a new achievement into log.exe (facts SoT) and refreshes `master-resume.tex` as cache. |
| `cv` | Builds the full professional CV (`cv.tex` / `cv.pdf`) from log.exe: every role, every substantial project, the whole skill inventory. Comprehensive and *not* tailored, 3 to 5 pages. |

### Resume or CV?

They are different documents and this kit builds both:

| | Resume (`tailor`) | CV (`cv`) |
|---|---|---|
| Length | 1 page, hard max 2 | 3 to 5 pages |
| Content | only what matches this job | everything |
| Rebuilt | once per application | when your facts change |
| Lives in | `applications/<company>/` | repo root, `cv.tex` |

Use the resume for most applications, especially in the US. Use the CV when a
posting or recruiter explicitly asks for a "full CV", which is common in the
EU, the UK, and Japan. Both are gitignored; the tracked starting points are
`master-resume.example.tex` and `cv.example.tex`.

The skills are readable Markdown files mirrored in `.agents/skills/` and
`.claude/skills/`. Keep both copies identical when customizing them.

## The rules agents follow

Every target-compatible agent reads the shared project rules from `AGENTS.md`;
`CLAUDE.md` imports that file for Claude Code compatibility. In short:
**facts SoT = log.exe**, **layout SoT = pitch**, nothing is invented,
resumes stay ATS-safe (prefer 1 page, hard max 2 via `scripts/check-pages.sh`;
the full CV is exempt from that budget but not from the honesty rules),
and everything is organised per company under `applications/`. Wire log.exe
MCP once (`bun run mcp:setup` in log.exe `web/`, or OpenCode remote MCP —
creds in `~/.log-exe-creds`). Adjust `AGENTS.md` to fit your own standards.

## A note on honesty

This tool is deliberately built to *not* lie for you. If a job needs a skill
you do not have, the `analyze` and `review` skills will tell you plainly.
That is the point: a tailored resume gets you the interview, but only
truthful content gets you through it. Use the gaps as a study list, not
something to hide.

## Contributing

Issues and pull requests welcome — better LaTeX templates, new skills
(e.g. LinkedIn outreach, skill-gap planning), and language improvements
especially. Keep the two core rules intact: ATS-safe, and never invent.

## License

MIT — see [LICENSE](LICENSE). Free to use, fork, and share.

Shortlist began as a fork of [yapsancode/job-kit](https://github.com/yapsancode/job-kit)
by Muhammad Isyraf Afifi bin Ismail, whose original MIT copyright is retained
in [LICENSE](LICENSE).
