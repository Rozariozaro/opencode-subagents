# Opencode Subagents

A production-grade **multi-agent system** for [OpenCode](https://opencode.ai) that brings structured, deterministic, high-quality AI-assisted software engineering to large-scale codebases.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Agents](#agents)
- [Skills](#skills)
- [Workflow](#workflow)
- [Permission Matrix](#permission-matrix)
- [Design Decisions](#design-decisions)
- [Benchmark Results](#benchmark-results)
- [Getting Started](#getting-started)
- [Project Status](#project-status)

## Overview

This project implements a **6-agent, 6-skill OpenCode system** with strict separation of concerns, deterministic delegation, and strong quality gates. It is designed for:

- 🍎 iOS / macOS development
- 🔀 Kotlin Multiplatform (KMP) projects
- 🖥️ Backend services
- 🐳 Docker / DevOps workflows
- 📦 Long-lived, modular codebases
- 🤖 AI-assisted development at scale

The system enforces a **read-before-write discipline**, routes all implementations through a dedicated reviewer, and restricts each agent to only the permissions it needs — preventing hallucination, scope creep, and accidental damage.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     ORCHESTRATOR                        │
│         (Plans · Delegates · Verifies · Reports)        │
└────────┬──────────┬──────────┬──────────┬──────────────┘
         │          │          │          │
    ┌────▼───┐ ┌────▼────┐ ┌──▼──────┐ ┌▼──────────┐
    │EXPLORE │ │IMPLEMENT│ │REVIEWER │ │DOC-WRITER │
    │        │ │   -ER   │ │         │ │           │
    │Read-   │ │Write ·  │ │Approve/ │ │Docs files │
    │only    │ │Edit ·   │ │Reject   │ │only       │
    │analyst │ │Build ·  │ │         │ │           │
    │        │ │Test     │ │         │ │           │
    └────────┘ └─────────┘ └─────────┘ └───────────┘
         │
    ┌────▼──────┐
    │WEBSEARCH  │
    │           │
    │Web-fetch  │
    │only       │
    │(no local  │
    │file read) │
    └───────────┘
```

**Execution flow**: Orchestrator → Explore/Websearch → Plan → Implement → Review → (Doc-write) → Report

## Agents

| Agent | Mode | Model | Temp | Role |
|-------|------|-------|------|------|
| `orchestrator` | primary | `github-copilot/claude-opus-4-6` | 0.1 | Central coordinator; analyzes intent, plans, delegates, verifies |
| `explore` | subagent | `github-copilot/gpt-5-mini` | 0.0 | Read-only analyst; discovers architecture, traces dependencies, identifies conventions |
| `implementer` | subagent | `github-copilot/claude-sonnet-4-6` | 0.2 | Code executor; writes/edits code, runs builds/tests, reports outcomes |
| `reviewer` | subagent | `github-copilot/claude-opus-4-6` | 0.1 | Quality gate; validates correctness, consistency, maintainability, safety |
| `doc-writer` | subagent | `github-copilot/gpt-5-mini` | 0.2 | Documentation maintainer; updates changelogs, READMEs, and docs only |
| `websearch` | subagent | `github-copilot/claude-haiku-4-5` | 0.1 | Technical research analyst; framework comparisons, OSS discovery, API research |

### Agent Routing

The `description` field in each agent's frontmatter is what OpenCode uses to route tasks. Key routing rules:

| If you want to… | Use this agent |
|-----------------|---------------|
| Update README, CHANGELOG, or any `.md` file | `@doc-writer` |
| Write or edit source code (`.kt`, `.swift`, `.ts`, etc.) | `@implementer` |
| Explore the codebase, find files, trace dependencies | `@explore` |
| Research libraries, APIs, or external tools | `@websearch` |
| Review code for correctness and safety | `@reviewer` |

> **Tip:** Use explicit trigger phrases for `@doc-writer`: *"update readme"*, *"write changelog"*, *"document this"*, *"update docs"*. Without these, the router may default to `@implementer` for any file-modification task.

### Agent Responsibilities

#### 🎯 Orchestrator
The only primary agent. Owns the full 7-phase workflow. Has **no edit permissions** — it cannot write code, only plan and delegate.

#### 🔍 Explore
Read-only codebase analyst. Discovers architecture, traces call graphs, identifies conventions and patterns. **Temperature 0.0** for maximum determinism.

#### 🔨 Implementer
Executes implementation plans precisely. Has edit + guarded bash permissions. Follows orchestrator plans — does not make architecture decisions.

#### 🔬 Reviewer
Quality gate using the most capable model (Opus). Read-only — cannot fix issues directly, only approve or reject with structured feedback. Catches bugs, security issues, and architectural drift.

#### 📝 Doc-Writer
Restricted to documentation files only. Activated only after reviewer approval. Cannot touch source code.

#### 🌐 Websearch
Web-fetch only, no local file access. Used for framework comparisons, API version checks, OSS discovery, and deprecation validation.

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `diagnose` | "debug this", "diagnose", bug reports | 5-phase loop: reproduce → minimise → hypothesise → instrument → fix |
| `zoom-out` | "zoom out", unfamiliar code section | Architectural mapping; shows broader context, callers, dependencies |
| `graphify` | knowledge graph requests | Generates HTML + JSON knowledge graphs with community detection |
| `websearch` | research, compare, find, investigate | Senior technical research analyst skill |
| `handoff` | session wrap-up, context handoff | Compacts conversation into structured handoff document |
| `grill-with-docs` | stress-test a plan, "grill me" | Challenges plans against domain model and existing documentation |

## Workflow

The orchestrator follows a strict **7-phase execution model**:

```
Phase 1: Analysis      → Parse intent, identify ambiguities, estimate complexity
Phase 2: Exploration   → @explore (codebase) and/or @websearch (external)
Phase 3: Planning      → Synthesize findings into explicit implementation plan
Phase 4: Implementation→ @implementer with full plan + context + validation commands
Phase 5: Review        → @reviewer sees ALL changes before anything is marked done
Phase 6: Documentation → @doc-writer only after reviewer approval
Phase 7: Reporting     → Summarize changes, caveats, follow-up items
```

### Parallel Delegation Rules
- ✅ Explore + Websearch can run in parallel (independent, no shared state)
- ✅ Independent implementation subtasks can run in parallel (no file overlap)
- ❌ Review is always sequential (must see all changes holistically)
- ❌ Doc-writer never runs in parallel with reviewer

## Permission Matrix

| Agent | Read | Edit | Bash | Delegate | Web | Skills |
|-------|------|------|------|----------|-----|--------|
| Orchestrator | ✅ | ❌ | ❌ (git read-only) | ✅ | ❌ | All |
| Explore | ✅ | ❌ | ❌ (git/grep only) | ❌ | ❌ | graphify, zoom-out, diagnose |
| Implementer | ✅ | ✅ | ✅ (guarded) | ❌ | ✅ | — |
| Reviewer | ✅ | ❌ | ❌ (git/grep only) | ❌ | ❌ | zoom-out, graphify |
| Doc-Writer | ✅ (docs only) | ✅ (docs only) | ❌ (git/grep only) | ❌ | ❌ | — |
| Websearch | ❌ | ❌ | ❌ | ❌ | ✅ | — |

> **Notes:** Bash permissions are restricted per agent — Orchestrator allows only read-only git commands (`status`, `diff`, `log`, `branch`); git write operations (`add`, `commit`, `push`) are exclusively the Implementer's job, and only after Reviewer approval. Explore, Reviewer, and Doc-Writer allow only `git`, `grep`, and `find`. Implementer has guarded bash (destructive operations require confirmation) and web-fetch access. Doc-Writer has no bash access except git log/diff — it uses native Read/Glob/Grep for discovery and Write/Edit tools for file modification, preventing token-wasting bash fallback failures.

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Explore separated from implementer | Forces "read before write" discipline; prevents hallucinated implementations |
| Reviewer is read-only | Prevents "fixing" issues directly; ensures structured, actionable feedback |
| Doc-writer restricted to docs files | Prevents accidental source code modification during documentation passes |
| Orchestrator has no edit permissions | Prevents bypassing the delegation workflow; enforces separation of concerns |
| Temperature 0.0 for explore | Maximizes determinism and reproducibility in codebase analysis |
| Max 2 retry cycles | Prevents infinite loops; escalates to user after repeated failures |
| Reviewer uses Opus (most capable model) | Quality gate deserves the highest-capability model; catches subtle bugs |
| Orchestrator has no git write access | Git commits/pushes are implementer's job — only after reviewer approval; giving orchestrator commit access would bypass the review gate |
| Doc-writer uses Write tool (not bash) for large files | Native Write tool is safer than bash redirection; bash has no safety checks and can corrupt files |
| Doc-writer uses GPT-5 mini (free) | Zero cost for documentation tasks; GPT-5 mini writes clean prose and follows structured instructions reliably |

## Benchmark Results

Validated on a real iOS project (FoodNutritions):

| Task Complexity | Single Agent | Multi-Agent | Winner | Notes |
|----------------|-------------|-------------|--------|-------|
| Simple (read-only) | Fast, accurate | Adds overhead | Single agent | No delegation needed for trivial tasks |
| Medium (1-file impl) | Missed 1 bug | Caught all bugs | **Multi-agent** | +1 critical bug caught by reviewer |
| Complex (multi-file) | Missed 3 bugs | Caught all bugs | **Multi-agent** | +3 blocking bugs caught |

**ROI**: ~3K tokens of orchestration overhead pays for itself on medium+ complexity tasks.

Test suite: 12 benchmark cases (T01–T12) defined in `AGENT_BENCHMARK.md` covering:
- Full workflow validation
- Skill trigger accuracy
- Permission boundary enforcement
- Rejection cycle handling
- Doc-writer activation conditions

## Getting Started

### Prerequisites
- [OpenCode](https://opencode.ai) installed
- GitHub Copilot or Anthropic API access (for Claude models)
- Node.js (for zod validation plugin)

### Installation

1. Clone this repository into your project:
```bash
git clone https://github.com/Rozariozaro/opencode-subagents.git
cd your-project
cp -r opencode-subagents/.opencode .
cp opencode-subagents/opencode.json .
```

2. Install dependencies:
```bash
cd .opencode && npm install
```

3. Start OpenCode:
```bash
opencode
```

The orchestrator agent will be your primary entry point. All other agents are invoked automatically as subagents.

### Configuration

Edit `opencode.json` to set your preferred default model:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4-6"
}
```

Agent models are configured individually in `.opencode/agents/*.md` frontmatter.

## Project Status

### ✅ Implemented
- [x] 6 agents with full definitions and permission isolation
  - Orchestrator (primary coordinator)
  - Explore (read-only analyst)
  - Implementer (code executor)
  - Reviewer (quality gate, Opus model)
  - Doc-Writer (docs-only maintainer)
  - Websearch (external research)
- [x] 6 specialized skills
  - `diagnose` — 5-phase debug loop
  - `zoom-out` — architectural context mapping
  - `graphify` — knowledge graph generation
  - `websearch` — technical research
  - `handoff` — session continuity
  - `grill-with-docs` — interactive planning
- [x] Strict permission matrix enforced per agent
- [x] 7-phase orchestration workflow
- [x] Parallel delegation rules defined
- [x] Max 2 retry / escalation strategy
- [x] Benchmark suite (12 test cases T01–T12)
- [x] Empirical validation on real iOS project
- [x] Architecture documentation (`SYSTEM-OVERVIEW.md`)
- [x] Original requirements captured (`Goal.md`)
- [x] Agent routing fix — doc-writer trigger keywords added, implementer scoped to source code only
- [x] Permission matrix corrected — Skills column added, Implementer web permission fixed
- [x] Full model IDs documented with `github-copilot/` prefix
- [x] Orchestrator git commit timing gate — commits only delegated to implementer after reviewer approval
- [x] Doc-writer large file strategy — Write tool (full rewrite) preferred over Edit tool for files >100 lines
- [x] Agent models optimized for cost — free models (GPT-5 mini) for explore/doc-writer, cheap (Haiku 4-5) for websearch, capable (Sonnet/Opus) for implementation/review
- [x] Doc-writer bash permissions stripped (grep/rg/find removed) — forces native tool usage
- [x] Orchestrator anti-pattern: content generation before delegation explicitly prevented

### 🔲 Planned
- [ ] Additional skills: `test-writer`, `migration-helper`, `security-audit`
- [ ] CI/CD integration examples (GitHub Actions, Bitrise)
- [ ] Benchmark results across more project types (KMP, backend, DevOps)
- [ ] Plugin system for custom agent extensions
- [ ] Agent performance dashboard / token usage tracking
- [ ] Pre-built templates for common project types
- [ ] Integration with Supabase MCP for database-aware agents

### 💡 Considered
- Multi-model fallback (if primary model unavailable, fall back to secondary)
- Agent memory / persistent context across sessions
- Automated benchmark regression testing in CI
- Visual workflow diagram generator from agent definitions
- Cost estimation before delegating complex tasks
- Agent description keyword tuning for improved routing accuracy

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-skill`
3. Add your agent or skill definition in `.opencode/agents/` or `.opencode/skills/`
4. Update `AGENT_BENCHMARK.md` with test cases for new behavior
5. Submit a pull request with benchmark results

## License

MIT

---

*Built with [OpenCode](https://opencode.ai) · Powered by Anthropic Claude, OpenAI GPT, and Google Gemini*
