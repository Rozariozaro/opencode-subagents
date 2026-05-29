# Context Navigation

This directory contains project-wide standards and workflows used by agents (architect, conductor, builder) to ensure consistency across all implementations.

## Standards

| File | Purpose | Use when |
|------|---------|----------|
| [standards/code-quality.md](standards/code-quality.md) | Naming conventions, patterns, architecture rules | Writing or reviewing any source code |
| [standards/testing.md](standards/testing.md) | Test framework, coverage requirements, patterns | Writing or reviewing tests |
| [standards/documentation.md](standards/documentation.md) | Doc style, structure, tone, required sections | Writing READMEs, API docs, or inline docs |

## Workflows

| File | Purpose | Use when |
|------|---------|----------|
| [workflows/code-review.md](workflows/code-review.md) | Review checklist, approval criteria, feedback format | Performing code reviews |

## How to use

- **Architect**: Read navigation.md before grilling to understand existing project conventions
- **Conductor**: Read navigation.md in Phase 1 to pass relevant context file paths to builder
- **Builder**: Read the relevant standards file before implementing (code tasks → code-quality.md, test tasks → testing.md)
- **Auditor**: Reference standards when assessing convention compliance

## Session Context

Active session files live in `.opencode/session-context/`. Each session has a `{session-id}.md` file containing the confirmed plan, scout findings, and researcher findings for that session.
