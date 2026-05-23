# Multi-Agent OpenCode System — Architecture Overview

## System Design

This is a 5-agent system with strict separation of concerns, deterministic delegation, and strong quality gates.

```
┌─────────────────────────────────────────────┐
│              USER REQUEST                    │
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│           ORCHESTRATOR (primary)             │
│  Analyzes → Plans → Delegates → Verifies    │
│  ❌ No code  ❌ No edits  ✓ High-level plan  │
└──┬──────┬──────────┬──────────┬─────────────┘
   │      │          │          │
   ▼      │          │          │
┌──────┐  │          │          │
│EXPLORE│  │          │          │
│(read) │  │          │          │
│  only │  │          │          │
└──┬───┘  │          │          │
   │      ▼          │          │
   │ ┌──────────┐   │          │
   │ │IMPLEMENTER│   │          │
   │ │(write+run)│   │          │
   │ └──┬───────┘   │          │
   │    │           ▼          │
   │    │    ┌──────────┐      │
   │    │    │ REVIEWER  │      │
   │    │    │(read-only)│      │
   │    │    └──┬───────┘      │
   │    │       │              ▼
   │    │       │       ┌───────────┐
   │    │       │       │DOC-WRITER │
   │    │       │       │(docs only)│
   │    │       │       └───────────┘
   │    │       │
   ▼    ▼       ▼
┌─────────────────────────────────────────────┐
│              ORCHESTRATOR                    │
│         Validates → Reports to User         │
└─────────────────────────────────────────────┘
```

## Execution Flow

Every non-trivial task follows this sequence:

1. **Orchestrator** analyzes user intent
2. **Explore** gathers codebase context (read-only)
3. **Orchestrator** creates implementation plan
4. **Implementer** executes the plan (writes code, runs builds)
5. **Reviewer** validates the implementation (read-only)
6. If rejected → back to Implementer (max 2 cycles)
7. **Doc-writer** updates documentation (docs files only)
8. **Orchestrator** reports results to user

## Agent Summary

| Agent | Mode | Model | Permissions | Temperature | Purpose |
|---|---|---|---|---|---|
| **orchestrator** | primary | `github-copilot/claude-sonnet-4.6` | read-only + task delegation + skills | 0.1 | Plan, delegate, verify |
| **explore** | subagent | `github-copilot/claude-haiku-4.5` | read-only + graphify skill when graph exists | 0.0 | Discover architecture, find files |
| **implementer** | subagent | `github-copilot/claude-sonnet-4.6` | edit + guarded bash | 0.2 | Write code, run builds/tests |
| **reviewer** | subagent | `github-copilot/claude-opus-4.6` | read-only | 0.1 | Quality gate, approve/reject |
| **doc-writer** | subagent | `github-copilot/claude-haiku-4.5` | docs files only | 0.2 | Update changelogs, READMEs, docs |

## Permission Matrix

| Capability | Orchestrator | Explore | Implementer | Reviewer | Doc-Writer |
|---|---|---|---|---|---|
| Read files | yes | yes | yes | yes | yes |
| Edit source files | no | no | yes | no | no |
| Edit docs files | no | no | no | no | yes |
| Run bash (general) | no | no | ask | no | no |
| Run git read commands | no | yes | yes | yes | yes |
| Delegate to agents | yes | no | no | no | no |
| Todo tracking | yes | no | yes | no | no |
| Web fetch | yes | no | no | no | no |
| Skill usage | yes | graphify only | no | no | no |
| External directories | ask | inherited/default | inherited/default | inherited/default | inherited/default |

## Model Recommendations

The markdown agent files are the source of truth. `opencode.json` intentionally does not duplicate agent definitions, avoiding drift between copied markdown files and JSON overrides.

Current model defaults:

| Agent | Default | Alternative for Cost Savings | Alternative for Higher Quality |
|---|---|---|---|
| orchestrator | `github-copilot/claude-sonnet-4.6` | `github-copilot/claude-haiku-4.5` for simple routing | `github-copilot/claude-opus-4.6` for high-risk multi-module planning |
| explore | `github-copilot/claude-haiku-4.5` | — | `github-copilot/claude-sonnet-4.6` for unusually complex architecture discovery |
| implementer | `github-copilot/claude-sonnet-4.6` | — | `github-copilot/claude-opus-4.6` for complex logic |
| reviewer | `github-copilot/claude-opus-4.6` | `github-copilot/claude-sonnet-4.6` for low-risk diffs | — |
| doc-writer | `github-copilot/claude-haiku-4.5` | — | `github-copilot/claude-sonnet-4.6` for large docs rewrites |

## Design Decisions

### Why separate explore from implementer?
Forces a "read before write" discipline. The implementer receives pre-analyzed context rather than exploring ad-hoc during implementation, reducing hallucinated edits and unnecessary file reads.

### Why is the reviewer read-only?
Prevents the reviewer from "fixing" issues directly, which would bypass the review gate. The reviewer must articulate what is wrong so the implementer can fix it — this produces better code and better feedback.

### Why does doc-writer only edit docs files?
Prevents documentation work from accidentally modifying application logic. The file-type permission restriction ensures the agent physically cannot touch source code.

### Why does the orchestrator have no edit permissions?
Prevents the coordinator from bypassing its own delegation workflow. If the orchestrator could edit, it would be tempted to "just fix it" rather than properly routing work.

### Why does the orchestrator own high-level planning?
Avoids a decision gap between explore and implementer. Explore reports facts, implementer executes concrete steps, and orchestrator chooses the high-level approach based on explored repository evidence.

### Why temperature 0.0 for explore?
Exploration should be maximally deterministic. We want consistent, reproducible findings — not creative interpretations of code.

## Common Failure Modes & Mitigations

| Failure | Mitigation |
|---|---|
| Reviewer rejects repeatedly | Orchestrator escalates to user after 2 cycles |
| Implementer cannot follow plan | Orchestrator refines plan with new explore data |
| Explore finds conflicting patterns | Explore reports all patterns; orchestrator asks user which to follow |
| Scope grows during implementation | Orchestrator constrains to original scope; defers additions |
| Build fails after changes | Implementer gets 2 fix attempts; then reports to orchestrator |
| Agent tries to exceed permissions | Permission system blocks the action automatically |
| Delegation loop | Orchestrator enforces max 2 retries per agent per task |

## Installation

1. Copy `.opencode/agents/` directory into your project root
2. Optionally copy `opencode.json` for schema/editor support; the agent markdown files define the agents
3. Adjust model IDs in the markdown frontmatter if using a different provider
4. Run `opencode` and use Tab to select the orchestrator as your primary agent

## Future Extensions

- **test-runner agent**: Dedicated agent for test execution and analysis
- **security-auditor agent**: Specialized security review pass
- **migration agent**: Database and schema migration specialist
- **ci-debugger agent**: CI/CD pipeline failure analyst
- **perf-profiler agent**: Performance analysis and optimization review
