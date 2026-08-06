---
name: log
description: Add a real achievement, measurement, skill, or project update to log.exe (facts SoT) and refresh the master-resume.tex layout cache. Use when the user wants to record new factual experience.
---

Add the factual update in my message to **log.exe first**, then mirror it into
`master-resume.tex` (layout/cache only). See `AGENTS.md`.

This is my "log as you go" habit — I tell you what I shipped, learned, or
measured, and you file the facts where they belong.

Steps:
1. Prefer writing facts via log.exe MCP (or `logexe` CLI) into the right
   surface: experience groups / certifications / skill areas / projects /
   clients. Ask me which surface if unclear. Do not invent numbers.
2. Then update `master-resume.tex` so the LaTeX cache matches:
   - New achievement on an existing project/job → new or improved bullet
   - New number for an existing bullet → strengthen that bullet
   - New skill/tool → add to the right Skills category
   - Brand new project → new project entry (ask for stack, dates, what it does)
3. Rewrite my raw note into a proper resume bullet: action verb + what +
   tool/method + measurable result. Keep MY facts exactly — do not inflate
   the numbers or the claim. If my note is vague, ask one or two
   short questions to get a concrete number or outcome before writing.
4. If the update replaces a weaker bullet in TeX, keep the old one as a
   LaTeX comment (%) instead of deleting — the TeX file is a cache, not SoT.
5. Use precise, truthful industry keywords where they fit — they help when
   this content is later matched against job postings.
6. Compile master-resume.tex to confirm it still builds, then show me
   exactly what changed (log.exe + TeX before/after).
7. Remind me at the end: is this also worth a LinkedIn post or a line in
   my LinkedIn headline? One sentence, only if genuinely worth it.
