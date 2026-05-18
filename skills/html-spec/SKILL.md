---
name: html-spec
description: Write plans, specs, brainstorms, design systems, mockups, and status reports as standalone HTML files instead of Markdown. Use when the user asks to brainstorm, plan, spec, mock up, compare options, document a design system, or produce a status report — and the output is long, visual, or contains multiple alternatives. Skip for short answers, commit messages, READMEs, or anything destined for a Markdown-only surface.
---

# html-spec

You are writing for a human who will *actually read* the artifact. HTML beats Markdown when the document is long, visual, or branches into options — because the human can scroll, scan, and engage instead of skimming a 1000-line markdown file.

## When to use HTML (default for these)

- Plans / specs / PRDs longer than one screen
- Brainstorm output with 3+ options to compare
- Anything that benefits from a mockup, diagram, mood board, or component preview
- Design systems and component galleries
- Weekly status reports, code review summaries, incident timelines
- Custom editing UIs for a specific decision (a "throwaway micro-app" the user fills in and exports back)

## When to stick with Markdown

- Short answers, chat-style replies, one-paragraph summaries
- Commit messages, PR descriptions, READMEs, CHANGELOG entries
- Files that *must* live as `.md` (release notes, blog posts, doc sites)
- Anything the user explicitly asked for as Markdown

If unsure, ask: "Do you want this as HTML you can open, or Markdown?"

## File hygiene

- Write to `./plans/<slug>.html` by default (create the dir if missing). Use `./design-system.html` for design systems.
- Single self-contained file: inline CSS, inline JS, no external deps except CDN Tailwind if helpful.
- After writing, tell the user the path and offer to open it: `open ./plans/<slug>.html`
- Never commit unless asked. These are working artifacts, not source-of-truth docs.

## Style baseline (so every artifact looks deliberate, not generic)

- Light theme, generous whitespace, system font stack or Inter via CDN
- Max content width ~880px, centered. Section headers with a thin bottom border.
- Use real HTML semantics: `<section>`, `<article>`, `<details>`, `<table>`. Not just `<div>` soup.
- Code excerpts in `<pre><code>` with a subtle gray background. Syntax highlight only if it's load-bearing.
- Mockups as inline SVG or styled HTML — not ASCII art.
- No emojis unless the user used them first.

## Templates (pick one based on the task)

### 1. Brainstorm fan-out
Grid of 4–8 cards, each one: title, one-line pitch, small mockup/SVG, "why this", "risk". User picks one. Include an "Export choice" button that copies a Markdown summary of the picked option to clipboard.

### 2. Plan / spec
Top: one-paragraph summary + success criteria. Then sections for: data model / types, file changes, key code excerpts, mockups, test/verification plan, open questions. Use `<details>` for deep dives so the top scan stays short.

### 3. Design system
Sections: colors (swatches with hex + role), typography (live samples), spacing scale, radius/shadow, core components rendered live. Make it copyable — every token has a click-to-copy.

### 4. Custom editor (the "micro-app" pattern)
When the user dislikes a specific structured section (rules table, mapping, config), build a focused HTML page with form inputs for *just that section* and a "Copy as Markdown" button at the bottom. They fill it in, copy out, paste back.

### 5. Status report
Top: TL;DR. Then: shipped this week, in flight, blocked, next week. Each item links to its PR/issue if known. Make it skimmable in 30 seconds.

## The export-back pattern (important)

Every interactive artifact must include a way to get structured output *back into the agent*. Add a button like "Copy as Markdown" that serializes the user's choices/edits to a clipboard-ready block. Without this, the artifact is a dead end.

## Prompt patterns that work

- "Fan out 6 directions in a grid, not a numbered list."
- "Render the mockup inline as SVG, don't describe it."
- "Use `<details>` for anything over 200 words so the top stays scannable."
- "Include a clipboard-export button at the bottom."

## What not to do

- Don't build a multi-file React app. One HTML file, inline everything.
- Don't add a build step, package.json, or node_modules.
- Don't replicate the entire CLAUDE.md or paste in giant code dumps — link or excerpt.
- Don't write Markdown *and* HTML "just in case." Pick one.
- Don't add trackers, analytics, or external font CDNs beyond one (Tailwind or Inter, not both).
