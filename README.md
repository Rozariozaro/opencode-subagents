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

The system enforces a **read-before-write discipline**, routes all implementations through a dedicated auditor, and restricts each agent to only the permissions it needs — preventing hallucination, scope creep, and accidental damage.

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                       ARCHITECT                          │
│         (Grills · Plans · Confirms · Hands off)          │
└────────────────────────┬─────────────────────────────────┘
                         │ confirmed plan
┌────────────────────────▼─────────────────────────────────┐
│                       CONDUCTOR                          │
│         (Delegates · Escalates · Verifies · Reports)     │
└────────┬──────────┬──────────┬──────────────────────────┘
         │          │          │
    ┌────▼───┐ ┌────▼────┐ ┌──▼──────┐
    │ SCOUT  │ │ BUILDER │ │ AUDITOR │
    │        │ │         │ │         │
    │Read-   │ │Write ·  │ │Approve/ │
    │only    │ │Edit ·   │ │Reject / │
    │analyst │ │Build ·  │ │Clarify  │
    │        │ │Test ·   │ │         │
    │        │ │Docs*    │ │         │
    └────────┘ └─────────┘ └─────────┘
         │
    ┌────▼──────┐
    │RESEARCHER │
    │           │
    │Web-fetch  │
    │only       │
    │(no local  │
    │file read) │
    └───────────┘
```

*Builder owns docs files that are directly affected by the implementation.

**Execution flow**: Architect (plan) → Conductor (execute) → Scout/Researcher → Builder → Auditor → Report

## Agents

| Agent | Mode | Model | Temp | Role |
|-------|------|-------|------|------|
| `architect` | primary | `github-copilot/claude-opus-4.6` | 0.1 | Planning + grilling; produces confirmed implementation plans |
| `conductor` | primary | `github-copilot/claude-sonnet-4.6` | 0.1 | Execution coordinator; delegates, escalates, verifies, reports |
| `scout` | subagent | `github-copilot/gpt-5-mini` | 0.0 | Read-only analyst; discovers architecture, traces dependencies, identifies conventions |
| `builder` | subagent | `github-copilot/claude-sonnet-4.6` | 0.2 | Code + docs executor; writes/edits code and directly affected docs, runs builds/tests |
| `auditor` | subagent | `github-copilot/claude-opus-4.6` | 0.1 | Quality gate; validates correctness, consistency, maintainability, safety |
| `researcher` | subagent | `github-copilot/claude-haiku-4.5` | 0.1 | Technical research analyst; framework comparisons, OSS discovery, API research |

### Agent Routing

The `description` field in each agent's frontmatter is what OpenCode uses to route tasks. Key routing rules:

| If you want to… | Use this agent |
|-----------------|---------------|
| Plan a feature, refactor, or non-trivial task | `@architect` |
| Execute a confirmed plan | `@conductor` |
| Write or edit source code (`.kt`, `.swift`, `.ts`, etc.) | `@builder` |
| Explore the codebase, find files, trace dependencies | `@scout` |
| Research libraries, APIs, or external tools | `@researcher` |
| Audit code for correctness and safety | `@auditor` |

### Agent Responsibilities

#### 🏛️ Architect
Primary planning agent. Conducts grill-me style interviews, explores the codebase via `@scout`, and produces a confirmed implementation plan. Has **no edit permissions** — job ends at plan confirmation.

#### 🎼 Conductor
Primary execution coordinator. Reads the confirmed plan, delegates to `@builder`, manages escalation via `@scout`/`@researcher`, and routes all completed work through `@auditor`. Has **no edit permissions**.

#### 🔍 Scout
Read-only codebase analyst. Discovers architecture, traces call graphs, identifies conventions and patterns. **Temperature 0.0** for maximum determinism. Owns phases 1–2 of the diagnose debug loop.

#### 🔨 Builder
Executes implementation plans precisely. Has edit + guarded bash permissions. Follows conductor plans — does not make architecture decisions. Owns docs for files directly affected by the current implementation. Owns phases 3–5 of the diagnose debug loop.

#### 🔬 Auditor
Quality gate using the most capable model (Opus). Read-only — cannot fix issues directly. Returns APPROVE, REJECT, or CLARIFICATION_NEEDED with structured feedback. Catches bugs, security issues, and architectural drift.

#### 🌐 Researcher
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

The system follows a **two-stage execution model**: plan first, then execute.

### Stage 1: Planning (Architect)
```
Phase 1: Scout exploration  → @scout gathers codebase context
Phase 2: Grilling session   → Architect challenges requirements one question at a time
Phase 3: Plan synthesis     → Confirmed plan output in ---CONFIRMED EXECUTION PLAN--- block
```

### Stage 2: Execution (Conductor)
```
Phase 1: Plan intake        → Parse confirmed plan, create todos
Phase 2: Implementation     → @builder with full plan + context + validation commands
Phase 3: Escalation         → @scout (local) or @researcher (external) if builder blocked
Phase 4: Audit              → @auditor sees ALL changes before anything is marked done
Phase 5: Reporting          → Summarize changes, caveats, follow-up items
```

### Retry Strategy (Standardized 3-Attempt Model)
1. Attempt 1 — normal delegation
2. Attempt 2 — local diagnosis fix (builder self-diagnoses with `diagnose` skill)
3. Escalate via `@scout` (local) or `@researcher` (external)
4. Attempt 3 — retry with new evidence
5. Still failing → escalate to user

### Parallel Delegation Rules
- ✅ Scout + Researcher can run in parallel (independent, no shared state)
- ✅ Independent implementation subtasks can run in parallel (no file overlap)
- ❌ Audit is always sequential (must see all changes holistically)

## Permission Matrix

| Agent | Read | Edit | Bash | Delegate | Web | Skills |
|-------|------|------|------|----------|-----|--------|
| Architect | ✅ | ❌ | ❌ (git read-only) | scout, researcher | ❌ | All |
| Conductor | ✅ | ❌ | ❌ (git read-only) | scout, builder, auditor, researcher | ❌ | All |
| Scout | ✅ | ❌ | ❌ (git/grep only) | ❌ | ❌ | graphify, zoom-out, diagnose |
| Builder | ✅ | ✅ (all) | ✅ (guarded) | ❌ | ❌ | diagnose |
| Auditor | ✅ | ❌ | ❌ (git/grep/audit only) | ❌ | ❌ | zoom-out, graphify |
| Researcher | ❌ | ❌ | ❌ | ❌ | ✅ | — |

> **Notes:** Bash permissions are restricted per agent — Architect and Conductor allow only read-only git commands (`status`, `diff`, `log`, `branch`). Git write operations (`add`, `commit`, `push`) are exclusively the Builder's job, and only after Auditor approval. Scout and Auditor allow only `git`, `grep`, and `find`. Builder has guarded bash (destructive operations require confirmation). Researcher has web-fetch only access.

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Architect separated from Conductor | Planning and execution are different cognitive modes; separation prevents premature implementation drift |
| Confirmed plan block required | Strict `---CONFIRMED EXECUTION PLAN---` delimiter prevents free-text parsing ambiguity |
| Scout separated from builder | Forces "read before write" discipline; prevents hallucinated implementations |
| Auditor is read-only | Prevents "fixing" issues directly; ensures structured, actionable feedback |
| Auditor has CLARIFICATION_NEEDED verdict | Allows audit to pause for more context rather than forcing a wrong APPROVE/REJECT |
| Builder owns directly affected docs | Avoids a separate doc-writer round-trip for docs that are obviously part of the change |
| Conductor has no edit permissions | Prevents bypassing the delegation workflow; enforces separation of concerns |
| Temperature 0.0 for scout | Maximizes determinism and reproducibility in codebase analysis |
| Standardized 3-attempt retry | Prevents infinite loops; escalates with new evidence at each stage before giving up |
| Auditor uses Opus (most capable model) | Quality gate deserves the highest-capability model; catches subtle bugs |
| Conductor has no git write access | Git commits/pushes are builder's job — only after auditor approval |

## Benchmark Results

Validated on a real iOS project (FoodNutritions):

| Task Complexity | Single Agent | Multi-Agent | Winner | Notes |
|----------------|-------------|-------------|--------|-------|
| Simple (read-only) | Fast, accurate | Adds overhead | Single agent | No delegation needed for trivial tasks |
| Medium (1-file impl) | Missed 1 bug | Caught all bugs | **Multi-agent** | +1 critical bug caught by auditor |
| Complex (multi-file) | Missed 3 bugs | Caught all bugs | **Multi-agent** | +3 blocking bugs caught |

**ROI**: ~3K tokens of orchestration overhead pays for itself on medium+ complexity tasks.

Test suite: 12 benchmark cases (T01–T12) defined in `AGENT_BENCHMARK.md` covering:
- Full workflow validation
- Skill trigger accuracy
- Permission boundary enforcement
- Rejection cycle handling

## Getting Started

### Prerequisites
- [OpenCode](https://opencode.ai) installed
- GitHub Copilot or Anthropic API access (for Claude models)

### Installation

1. Clone this repository into your project:
```bash
git clone https://github.com/Rozariozaro/opencode-subagents.git
cd your-project
cp -r opencode-subagents/.opencode .
cp opencode-subagents/opencode.json .
```

2. Start OpenCode:
```bash
opencode
```

The architect agent will be your primary entry point for planning. Switch to conductor to execute confirmed plans. All other agents are invoked automatically as subagents.

### Configuration

Edit `opencode.json` to set your preferred default model:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "default_agent": "architect"
}
```

Agent models are configured individually in `.opencode/agents/*.md` frontmatter.

## Project Status

### ✅ Implemented
- [x] 6 agents with full definitions and permission isolation
  - Architect (planning + grilling)
  - Conductor (execution coordinator)
  - Scout (read-only analyst)
  - Builder (code + directly affected docs executor)
  - Auditor (quality gate, Opus model, CLARIFICATION_NEEDED verdict)
  - Researcher (external research)
- [x] 6 specialized skills
  - `diagnose` — 5-phase debug loop
  - `zoom-out` — architectural context mapping
  - `graphify` — knowledge graph generation
  - `websearch` — technical research
  - `handoff` — session continuity
  - `grill-with-docs` — interactive planning
- [x] Strict permission matrix enforced per agent
- [x] Two-stage workflow: planning (architect) + execution (conductor)
- [x] Confirmed plan block format (`---CONFIRMED EXECUTION PLAN---`)
- [x] Parallel delegation rules defined
- [x] Standardized 3-attempt retry model across all agents
- [x] Auditor CLARIFICATION_NEEDED verdict for uncertain analysis
- [x] Builder owns directly affected documentation
- [x] Benchmark suite (12 test cases T01–T12)
- [x] Empirical validation on real iOS project

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
