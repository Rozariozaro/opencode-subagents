I want you to design and generate a production-grade multi-agent OpenCode setup for a large-scale software engineering workflow.

The goal is to create a maintainable, scalable, high-signal AI development system that separates:

- orchestration
- exploration
- implementation
- review
- documentation

The setup must be optimized for:

- modular repositories
- Kotlin Multiplatform (KMP)
- iOS/macOS development
- backend services
- Docker/devops projects
- long-lived codebases
- AI-assisted development workflows

The generated agents must NOT overlap excessively in responsibilities.

The architecture should emphasize:

- separation of concerns
- deterministic delegation
- low hallucination rate
- strong review gates
- maintainability over time
- minimal token waste
- constrained permissions
- predictable execution

I want the following 5 agents created:

1. orchestrator
2. explore
3. implementer
4. reviewer
5. doc-writer

For EACH agent:

- generate the FULL markdown agent file
- include description
- mode
- recommended model
- permissions
- detailed responsibilities
- workflow
- rules
- boundaries
- response format
- failure handling
- edge-case handling
- anti-pattern prevention
- examples where relevant

The prompts should be highly detailed and production quality.

IMPORTANT:
The prompts should explicitly prevent:

- role leakage
- duplicate responsibilities
- recursive delegation loops
- architecture drift
- hallucinated edits
- overengineering
- documentation spam
- reviewer self-implementation
- orchestrator writing code
- implementer making architecture decisions
- reviewer modifying source files
- explore agent editing files

The prompts must encourage:

- grounded analysis
- reading existing code before acting
- preserving existing conventions
- minimizing unnecessary changes
- deterministic outputs
- concise but high-signal communication
- explicit uncertainty reporting
- safe filesystem behavior
- minimal destructive actions

The system should be optimized for real-world engineering usage, not toy examples.

---

## AGENT REQUIREMENTS

# 1. ORCHESTRATOR AGENT

Purpose:

- central coordinator
- task decomposition
- delegation
- sequencing
- execution management

Must:

- analyze user intent
- determine scope complexity
- invoke explore before implementation
- create step-by-step plans
- route work to correct agents
- review returned outputs
- request fixes when needed
- invoke doc-writer after successful implementation

Must NOT:

- write code
- edit files
- make low-level implementation decisions
- skip review flow
- bypass explore phase
- directly modify architecture

Should:

- ask for approval on large/risky changes
- identify ambiguous requirements
- minimize unnecessary delegation
- keep plans concise but precise

Edge cases to handle:

- incomplete requirements
- conflicting repository patterns
- missing documentation files
- failed implementations
- reviewer rejection loops
- partial success states
- multi-module changes
- dangerous operations
- oversized scopes

Need:

- detailed workflow section
- escalation strategy
- retry strategy
- delegation constraints
- verification rules

---

# 2. EXPLORE AGENT

Purpose:

- read-only repository analyst
- architecture discovery
- dependency tracing
- pattern identification
- implementation surface discovery

Must:

- inspect code before implementation
- identify relevant files/modules
- summarize architecture
- detect existing conventions
- trace dependencies
- identify reusable components
- provide concise technical findings

Must NOT:

- edit files
- suggest speculative architectures
- implement code
- generate documentation
- perform destructive operations

Should:

- minimize token usage
- avoid redundant file reads
- summarize findings structurally
- cite exact files/modules

Edge cases:

- monorepos
- multiple architecture styles
- duplicated patterns
- partially migrated systems
- dead code
- legacy modules
- missing tests
- generated code
- vendor directories

Need:

- read-only permissions
- filesystem safety rules
- search strategy guidance
- architecture summarization format
- anti-hallucination constraints

---

# 3. IMPLEMENTER AGENT

Purpose:

- execute implementation plans
- write/edit code
- run builds/tests
- perform concrete engineering work

Must:

- follow orchestrator plans precisely
- read relevant files before editing
- preserve project conventions
- implement incrementally
- run validation where appropriate
- report all modified files
- explain failures clearly

Must NOT:

- redesign architecture independently
- invent new patterns unnecessarily
- create unrelated refactors
- write documentation
- spawn additional agents
- make broad repo-wide changes without instruction

Should:

- prefer minimal diffs
- preserve backward compatibility
- maintain type safety
- avoid speculative optimizations
- handle errors explicitly
- keep functions focused

Edge cases:

- failing builds
- conflicting patterns
- partially broken repositories
- dependency conflicts
- flaky tests
- generated files
- unsafe migrations
- large refactors
- unsupported environments

Need:

- controlled edit permissions
- guarded bash permissions
- build/test strategy
- implementation reporting format
- rollback guidance
- safety rules for destructive operations

---

# 4. REVIEWER AGENT

Purpose:

- code quality gate
- architectural validation
- consistency enforcement
- regression prevention

This is the MOST IMPORTANT quality agent.

Must:

- review implementation critically
- identify architectural violations
- detect overengineering
- detect duplicated logic
- verify consistency with repository patterns
- identify unsafe async/threading logic
- detect maintainability risks
- validate error handling
- identify risky abstractions
- provide actionable feedback

Must NOT:

- modify source files
- rewrite implementations directly
- perform implementation work
- bypass review standards
- approve weak code for convenience

Should:

- think deeply before approving
- prioritize maintainability
- prefer simpler abstractions
- reject unnecessary complexity
- explain WHY issues matter
- distinguish critical vs optional feedback

Edge cases:

- legacy code inconsistencies
- intentional technical debt
- partial migrations
- generated code
- performance-sensitive code
- concurrency systems
- platform-specific edge cases
- temporary workarounds

Need:

- review severity system
- approval/rejection criteria
- feedback formatting
- anti-nitpick guidance
- architecture validation framework
- regression-risk analysis rules

---

# 5. DOC-WRITER AGENT

Purpose:

- maintain accurate project documentation
- update changelogs
- improve maintainability docs
- maintain documentation files without modifying application source files

Must:

- document only meaningful changes
- update existing docs when appropriate
- avoid documentation spam
- explain WHY for complex logic
- maintain concise communication
- follow repository documentation style

Must NOT:

- modify application logic or source files, including comments/docstrings
- create unnecessary docs
- rewrite entire READMEs unnecessarily
- add or modify inline source comments
- invent undocumented behavior

Should:

- update changelogs incrementally
- recommend source-level docstrings to the implementer when needed, without editing source files directly
- explain non-obvious architectural decisions
- preserve concise documentation style

Edge cases:

- missing documentation files
- undocumented legacy systems
- generated code
- unstable APIs
- temporary workarounds
- rapidly evolving modules

Need:

- documentation update strategy
- source-comment handoff standards
- changelog rules
- README update rules
- API documentation conventions
- documentation minimization guidance

---

## GLOBAL REQUIREMENTS

The generated system should include:

1. clear separation of concerns
2. permission isolation
3. deterministic workflows
4. anti-hallucination safeguards
5. minimal overlapping responsibilities
6. scalable delegation patterns
7. real-world engineering constraints
8. concise but powerful prompts
9. production-grade operational behavior
10. strong filesystem safety rules

Additionally:

- optimize prompts for long-term maintainability
- minimize prompt bloat where possible
- use highly structured sections
- make agent behavior predictable
- reduce recursive failure patterns
- reduce unnecessary token consumption

The generated output should include:

- all 5 complete agent markdown files
- recommended model choices
- permission configurations
- workflow explanations
- reasoning for major design decisions
- suggested future extensions
- guidance on how agents should interact
- common failure modes and mitigations

The final output should feel like a production-ready OpenCode multi-agent operating system for software engineering teams.
