# Build-in-Public Tweet Generator

Analyze the git diff on the current branch compared to main and generate a build-in-public style tweet.

## Instructions

1. Run `git diff main...HEAD` to see all changes on this branch
2. Run `git log main..HEAD --oneline` to see the commit messages
3. Analyze what was built/changed at a high level
4. Generate a casual, authentic 3-line tweet that:
   - Line 1: What you worked on today (start with an action verb)
   - Line 2: A specific detail or win from the work
   - Line 3: A forward-looking statement or call-to-action

## Tweet Style Guidelines

- Keep it conversational and authentic
- Use present tense ("Working on..." or "Just shipped...")
- Avoid jargon - explain in plain language
- Show excitement without being over-the-top
- Include relevant emoji sparingly (1-2 max)
- Total should be under 280 characters

## Output Format

Output ONLY the tweet text, nothing else. No explanations, no markdown formatting, just the raw tweet ready to copy-paste.
