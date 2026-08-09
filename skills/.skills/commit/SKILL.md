---
name: commit
description: Construct Conventional Commits without AI disclosure
---

# Commit Message Constructor

You are helping to create a git commit message following Conventional Commits specification.

## Instructions

1. **Analyze the changes**: Run `git status` and `git diff` to understand what has been modified
2. **Review commit history**: Run `git log --oneline -10` to understand the commit message style of this repository
3. **Draft the commit message** following Conventional Commits format:
   - **Header**: `<type>[optional scope]: <description>`
     - Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
     - Keep under 50 characters
     - Use imperative mood (e.g., "add" not "added")
   - Add a blank line after the header
   - **Body** (optional but recommended): Explain the "why" and "what"
     - Wrap at 72 characters
     - Focus on motivation and context
     - Use bullet points for multiple changes
   - **Footer** (if applicable): Breaking changes and issue references
     - Breaking changes: `BREAKING CHANGE: <description>`
     - Issues: `Fixes #123` or `Closes #456`

4. **Present the commit message** to the user for review before committing

## Example Output Format

```
feat(auth): add JWT token authentication

Replace session-based auth with JWT tokens for better scalability
and stateless authentication across distributed services.

- Add JWT token generation and validation utilities
- Update login endpoint to issue tokens
- Create auth middleware for protected routes
- Implement token refresh mechanism
```

## Conventional Commit Types

- **feat**: New feature for the user
- **fix**: Bug fix for the user
- **docs**: Documentation only changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **build**: Changes to build system or dependencies
- **ci**: CI configuration changes
- **chore**: Other changes that don't modify src or test files

## Important Notes

- DO NOT automatically commit - present the message for user approval first
- Choose the most appropriate type based on the primary nature of changes
- Include scope when changes affect a specific component/module
- Keep the message focused on "why" rather than "what" in the body
- Do not add a `Co-Authored-By` trailer or any other AI-attribution
  footer unless the user explicitly asks for one in this conversation
