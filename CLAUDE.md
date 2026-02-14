# CLAUDE.md

This file provides guidance for AI assistants working with this repository.

## Repository Overview

- **Repository**: `-`
- **Status**: Newly initialized — no source code, build system, or dependencies configured yet.
- **Remote**: Hosted on a Git remote (origin).

## Development Setup

No build tools, package managers, or dependencies are configured at this time. As the project evolves, update this section with:

- Language and runtime versions
- How to install dependencies
- Environment variables or secrets required

## Build & Run

No build or run commands are configured yet. Document them here as they are added.

## Testing

No test framework is configured yet. When one is added, document:

- How to run the full test suite
- How to run a single test file
- Any test naming conventions

## Linting & Formatting

No linters or formatters are configured yet. When added, document:

- How to run the linter
- How to auto-fix formatting issues
- Any pre-commit hooks

## Code Style & Conventions

As the codebase grows, document project-specific conventions here (naming, file organization, patterns, etc.).

## Project Structure

```
./
├── CLAUDE.md        # AI assistant guidance (this file)
├── README.md        # Project readme
└── .git/            # Git repository metadata
```

Update this tree as the project structure develops.

## Git Workflow

- **Default branch**: `master`
- Feature branches use the `claude/` prefix (e.g., `claude/<description>-<session-id>`).
- Commit messages should be clear and descriptive.
- Keep commits focused on a single logical change.
- GPG commit signing is enabled — do not disable it.

## Notes for AI Assistants

- Always read this file at the start of a session for up-to-date guidance.
- When adding new tooling or major structural changes, update this file to reflect the current state.
- Prefer editing existing files over creating new ones.
- Do not introduce unnecessary complexity or over-engineer solutions.
- There is no `.gitignore` yet — create one when adding language-specific tooling or generated files.
