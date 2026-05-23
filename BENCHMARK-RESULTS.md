# Multi-Agent Benchmark Results

## Test Environment
- **Project**: FoodNutritions (SwiftUI iOS 17+ meal tracking app, 37 Swift files)
- **Without agents**: Default OpenCode build agent (single agent, full permissions)
- **With agents**: Orchestrator -> Explore -> Implementer -> Reviewer -> Doc-Writer pipeline
- **With agents + graphify**: Same pipeline, but explore agent uses pre-built knowledge graph (348 nodes, 429 edges, 20 communities)

---

## Task 1: "Explain how authentication works" (Simple / Read-Only)

| Metric | Without Agents | With Agents | Delta |
|--------|---------------|-------------|-------|
| Tool calls | 6 | 7 | +1 (+17%) |
| Files read | 4 | 5 | +1 |
| Lines consumed | ~82 | ~288 | +251% |
| Agent hops | 0 | 2 | +2 |
| Token overhead | 0 | ~400-500 | +400-500 |
| Quality of answer | Accurate, complete | Accurate, complete | Same |
| Bugs caught | N/A | N/A | N/A |

### Verdict: WITHOUT AGENTS WINS
For simple read-only questions, the multi-agent pipeline adds ~400 tokens of pure coordination overhead with zero quality benefit. The orchestrator should detect this is trivial and short-circuit to a single explore call, but even then there's inter-agent formatting overhead.

---

## Task 2: "Add swipe-to-delete for food logs" (Medium / Targeted Implementation)

| Metric | Without Agents | With Agents | Delta |
|--------|---------------|-------------|-------|
| Tool calls | 5 | 8 | +3 (+60%) |
| Files read | 3 | 5 | +2 |
| Lines consumed | ~260 | ~929 | +257% |
| Agent hops | 0 | 7 | +7 |
| Token overhead | 0 | ~2,000-3,000 | +2K-3K |
| Correctly found existing impl | Yes | Yes | Same |
| Bugs caught | 0 | 1 HIGH | **+1 critical bug** |

### Bug caught by reviewer (WITH agents only):
> `.swipeActions` is attached inside a `VStack > ForEach`, NOT inside a `List`. This is a **SwiftUI no-op** — the code compiles but the swipe gesture silently doesn't work at runtime.

### Verdict: WITH AGENTS WINS
The reviewer (`github-copilot/claude-opus-4.6`) caught a real runtime bug that the single agent missed entirely. The ~3K token overhead paid for itself by preventing a silently broken feature. The explore phase also prevented unnecessary reimplementation.

---

## Task 3: "Add favorites system with new tab" (Complex / Multi-File Feature)

| Metric | Without Agents | With Agents | Delta |
|--------|---------------|-------------|-------|
| Tool calls | 20 | 22 | +2 (+10%) |
| Files read | 15 | 19 | +4 |
| Lines consumed | ~1,900 | ~1,980 | +4% |
| Agent hops | 0 | 6 | +6 |
| Token overhead | 0 | ~15,000-20,000 | +15K-20K |
| New files planned | 4 | 4 | Same |
| Modified files | 2 | 2-4 | +0-2 |
| HIGH issues caught | 0 | 3 | **+3 blocking bugs** |
| MEDIUM issues caught | 0 | 2 | +2 |
| Arch decisions grounded | ~70% verified | 100% verified | +30% |
| Backend gap identified | Yes (noted) | Yes (with schema) | Same |

### Bugs caught by reviewer (WITH agents only):

1. **HIGH — Shared state problem**: `FavoritesViewModel` created in two places (FavoritesView + FoodDetailView) means they don't share state. Favoriting in detail view doesn't reflect in Favorites tab. Fix: inject via `@Environment` at `MainTabView` level.

2. **HIGH — Duplicate favorites**: `toggleFavorite` checks local array, but if favorites aren't loaded yet, the check fails — user can favorite the same item multiple times. Fix: add server-side `findFavorite()` fallback.

3. **HIGH — No navigation path from favorites**: `Favorite` stores denormalized data, but `FoodDetailView` needs a full `FoodItem`. No `fetchById` method exists on repositories. Tapping a favorite would crash or show incomplete data.

### Verdict: WITH AGENTS WINS DECISIVELY
The review phase caught 3 high-severity architectural bugs that would have shipped broken. The single agent identified the issues as "quality risks" in its self-assessment but didn't catch them as blocking problems — it would have implemented the code and shipped the bugs. The explore phase ensured 100% of architectural decisions were grounded in actual codebase patterns.

---

## Summary Table

| Task Complexity | Winner | Token Cost Delta | Quality Delta |
|-----------------|--------|-----------------|---------------|
| **Simple** (read-only) | Without agents | +400-500 tokens wasted | No difference |
| **Medium** (targeted impl) | With agents | +2K-3K tokens | +1 critical bug caught |
| **Complex** (multi-file) | With agents | +15K-20K tokens | +3 blocking bugs caught |
| **Complex + Graphify** | With agents + graphify | +12-15K tokens | +3 blocking bugs + faster arch discovery |

---

## Task 3b: Favorites Feature WITH GRAPHIFY (Complex / Multi-File)

| Metric | Without Agents | With Agents (no graphify) | With Agents + Graphify |
|--------|---------------|--------------------------|----------------------|
| Tool calls | 20 | 22 | **11** |
| Files read | 15 | 19 | **6** |
| Lines consumed | ~1,900 | ~1,980 | **~420** |
| Agent hops | 0 | 6 | 6 |
| Token overhead | 0 | ~15-20K | **~12-15K** |
| HIGH issues caught | 0 | 3 | 3 |
| MEDIUM issues caught | 0 | 2 | 2 |
| Arch decisions grounded | ~70% | 100% | 100% |
| Architecture discovery | File-by-file | File-by-file | **3 graph queries** |

### Graphify Impact

**9 file reads avoided** — the graph provided method signatures, call relationships, community structure, and model fields without opening a single source file for:
- SearchViewModel, DiaryViewModel, APIClient, Recipe, PackagedFood, FoodNutritionsApp, DesignTokens, SearchView, DiaryView

**Net token savings: ~32-37K tokens** (1,460 fewer lines consumed, offset by ~3K tokens for graph queries)

**Quality improvements**:
- Graph community analysis made the missing `fetchById` pattern immediately obvious
- God node analysis (CodingKeys at 51 edges) confirmed Recipe model complexity
- Bridge node analysis revealed future integration path with search filters

### Verdict: GRAPHIFY REDUCES COST WHILE MAINTAINING QUALITY

The graph-first approach cut tool calls by 50%, files read by 68%, and lines consumed by 79% — while catching the same bugs and grounding the same architectural decisions. The one-time cost of running graphify (~3 min) pays for itself after 2-3 complex exploration tasks.

---

## Key Findings

### 1. The multi-agent system scales with complexity
- Simple tasks: overhead is pure waste
- Medium tasks: overhead pays for itself via review catches
- Complex tasks: the review phase is **essential** — it caught 3 blocking bugs that a single agent would have shipped

### 2. The explore phase has diminishing returns
Both approaches read similar files. For simple tasks, explore adds overhead. For complex tasks, explore enforces discipline — the single agent verified ~70% of architectural decisions while the multi-agent system verified 100%.

### 3. The reviewer (`github-copilot/claude-opus-4.6`) is the highest-value agent
Across all tasks, the reviewer was the only agent that produced findings the single-agent approach missed. The investment in `github-copilot/claude-opus-4.6` for the reviewer is justified.

### 4. Token overhead is roughly 2x for the full pipeline
The multi-agent approach consumes approximately 2x the tokens of a single agent for the same task, primarily due to context duplication across agent handoffs.

---

### 5. Graphify is a force multiplier for the explore phase
- One-time cost: ~3 minutes to build the graph
- Per-task savings: 50% fewer tool calls, 79% fewer lines consumed
- The graph provides instant architecture context that would otherwise require reading 9+ files
- Most valuable for complex multi-file tasks; diminishing returns for simple queries

---

## Task 4: Updated Agents + Existing Graphify Graph (Read-Only Flow Trace)

**Task:** Explain how the diary logging flow connects `AddFoodView`, `DiaryViewModel`, `FoodLogRepository`, `APIClient`, refresh notifications, and toast behavior in the FoodNutritions sample app.

**Purpose:** Validate the updated agent prompts and permissions after adding graphify skill usage to `explore` and allowing skill usage in `orchestrator`.

| Metric | Result |
|--------|--------|
| Graph present | Yes — `graphify-out/graph.json` |
| Graph-first applicable | Yes |
| Orchestrator skill usage | Passed — loaded `graphify` |
| Relevant components discovered | `AddFoodView`, `AddFoodViewModel`, `DiaryView`, `DiaryViewModel`, `FoodLogRepository`, `APIClient`, `ToastView` |
| Graph sufficient for architecture | Yes |
| Graph sufficient for runtime flow | Partial |
| Source reads still required | Yes — notifications, toast payload, optimistic update, async/task boundaries |
| File sync validation | Global agent files match project agent files |

### What Worked

- The updated orchestrator successfully loaded the `graphify` skill.
- Existing `graphify-out` artifacts were detected and used before normal source exploration.
- Graph communities quickly identified the relevant layers: Add Food, Diary, Repository, Networking, and UI Components.
- The graph reduced discovery overhead by surfacing the main files and symbols before reading source.

### What Still Required Source Reads

- `NotificationCenter.default.post(name: .diaryNeedsRefresh, userInfo: ...)` in `AddFoodView`.
- `.onReceive(NotificationCenter.default.publisher(for: .diaryNeedsRefresh))` in `DiaryView`.
- Toast message passing through `userInfo["toastMessage"]`.
- Optimistic UI update via `diaryViewModel.addLogLocally(created)`.
- `Task { await ... }`, haptics, `dismiss()`, and loading/error state changes.

### Verdict: UPDATED GRAPH-FIRST FLOW PASSES

The updated agents behave as intended. Graphify is now correctly used as a first-pass architecture map when `graphify-out/graph.json` already exists, and source reads are reserved for runtime behavior and line-level verification. This is the desired balance: graph-first for structure, targeted reads for behavior.

## Recommendations

### Option A: Install with smart routing + graphify (RECOMMENDED)
Install agents globally. If a project already has `graphify-out/graph.json`, the explore agent loads the `graphify` skill and uses graph-first strategy. If no graph exists, it skips graphify and falls back to native exploration. Add orchestrator short-circuit logic for trivial tasks.

**Cost profile**: ~2x tokens for medium tasks, ~1.5x for complex tasks with graphify, same quality gates.

### Option B: Install only reviewer + graphify-enhanced explore
Keep default build agent. Add reviewer as mandatory quality gate and replace the built-in explore subagent with the graphify-enhanced version. Captures 90% of quality benefit at lowest overhead.

### Option C: Full pipeline for everything
Install as-is with graphify. Accept token overhead for maximum quality. Best for critical codebases.

### Option D: Don't install globally
Keep project-scoped and use only where the quality gate justifies the cost.

### Current Recommendation

Use the full 5-agent setup globally with `github-copilot/*` models:

| Agent | Model |
|-------|-------|
| orchestrator | `github-copilot/claude-sonnet-4.6` |
| explore | `github-copilot/claude-haiku-4.5` |
| implementer | `github-copilot/claude-sonnet-4.6` |
| reviewer | `github-copilot/claude-opus-4.6` |
| doc-writer | `github-copilot/claude-haiku-4.5` |

Keep Opus concentrated on reviewer by default. Use Opus for orchestrator only for high-risk, multi-module planning where the cost is justified.
