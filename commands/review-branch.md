# Review Branch

Review a git branch for code review, generating actionable feedback comments.

## Arguments

`$ARGUMENTS` - The branch name to review (e.g., `feature/add-login`, `origin/fix-bug-123`)

## Steps

1. **Fetch and checkout the branch**
   ```bash
   git fetch origin
   git checkout $ARGUMENTS
   ```

2. **Identify the base branch and get the diff**
   - Determine the base branch (usually `main` or `master`)
   - Get the list of changed files: `git diff main...$ARGUMENTS --name-only`
   - Get the full diff: `git diff main...$ARGUMENTS`
   - Get commit history: `git log main...$ARGUMENTS --oneline`

3. **Analyze the changes**
   For each changed file, review for:

   **Code Quality**
   - Logic errors or bugs
   - Edge cases not handled
   - Error handling gaps
   - Performance issues
   - Memory leaks or resource cleanup

   **Security**
   - SQL injection, XSS, or other OWASP vulnerabilities
   - Hardcoded secrets or credentials
   - Improper input validation
   - Authentication/authorization issues

   **Best Practices**
   - Code duplication
   - Overly complex functions
   - Missing type safety
   - Inconsistent naming conventions
   - Dead code or unused imports

   **Testing**
   - Missing test coverage for new functionality
   - Edge cases not tested
   - Test quality issues

   **Documentation**
   - Complex logic lacking comments
   - Missing or outdated documentation
   - Unclear function/variable names

4. **Generate review comments**

## Output Format

Generate a structured code review with the following format:

```markdown
# Code Review: $ARGUMENTS

## Summary
[2-3 sentence overview of what this branch does]

## Changes Reviewed
- `path/to/file1.ts` - [brief description]
- `path/to/file2.ts` - [brief description]

## Review Comments

### Critical (Must Fix)
Issues that should be addressed before merging.

#### [File: path/to/file.ts, Line: XX]
**Issue:** [Description of the problem]
**Suggestion:** [How to fix it]
```suggestion
// Suggested code fix
```

### Important (Should Fix)
Issues that are strongly recommended to address.

#### [File: path/to/file.ts, Line: XX]
**Issue:** [Description]
**Suggestion:** [How to fix]

### Minor (Nice to Have)
Style improvements or minor suggestions.

#### [File: path/to/file.ts, Line: XX]
**Suggestion:** [Description]

### Questions
Things that need clarification from the author.

- [Question about specific implementation choice]

## What's Good
[Highlight positive aspects of the code - good patterns, clean implementation, etc.]

## Testing Checklist
- [ ] Unit tests added/updated
- [ ] Edge cases covered
- [ ] Manual testing performed
- [ ] No regressions introduced
```

## Guidelines

- Be constructive and specific - explain *why* something is an issue
- Provide code suggestions when possible
- Acknowledge good work, not just problems
- Prioritize comments by severity
- Consider the context and project conventions
- Don't nitpick on style if there's a formatter/linter
- Ask questions rather than assume intent when unclear
- Focus on the code, not the author

## After Review

Return to the original branch:
```bash
git checkout -
```
