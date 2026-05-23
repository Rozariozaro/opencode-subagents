# DIAGNOSE SKILL

A disciplined, phase-gated debugging loop for hard bugs and performance regressions. Follow every phase in order. Never skip phases. Never test multiple hypotheses simultaneously.

## WHEN TO USE

Invoke this skill when:
- A bug is reported and the root cause is unknown
- A performance regression has been observed
- Something is broken, throwing, or failing in a non-obvious way
- A crash or panic has occurred with no clear cause

Do NOT invoke this skill for:
- Feature implementation (use the normal implementation workflow)
- Known bugs with a clear fix already identified
- Lint or type errors with obvious causes

---

## THE 5-PHASE DEBUG LOOP

### Phase 1 — Reproduce (owned by @explore)

**Goal**: Build a fast, deterministic feedback loop.

1. Identify the exact failure mode: error message, stack trace, incorrect output, or performance metric
2. Construct the minimal invocation that triggers the failure:
   - Failing test (`pytest -k test_name`, `go test -run TestFoo`, `./gradlew test --tests "..."`)
   - curl/httpie script for API failures
   - CLI invocation for command-line tools
   - Headless browser script for UI failures
   - Replay harness for event-driven systems
3. Confirm the reproduction is **deterministic** — run it 3 times, confirm it fails every time
4. Record the exact failure output (error message, stack trace, timing)

**Exit criteria**: You can trigger the failure on demand in under 30 seconds.

**Hand off to Phase 2** with: reproduction command, exact failure output, and environment details.

---

### Phase 2 — Minimise (owned by @explore)

**Goal**: Strip away everything that isn't the bug.

1. Start from the reproduction case from Phase 1
2. Remove one thing at a time (a dependency, a config option, a code path)
3. After each removal, re-run the reproduction — does it still fail?
4. Keep removing until removing anything more makes the bug disappear
5. The result is the **minimal reproducible case (MRC)**

**Rules**:
- Never remove two things at once
- If removal makes the bug disappear, that thing is a clue — restore it and note it
- If the MRC is in a third-party library, note the library version and stop — do not debug third-party code

**Exit criteria**: You have the smallest possible reproduction case. Document it precisely.

**Hand off to Phase 3** with: MRC, all clues collected during minimisation, and a list of what was ruled out.

---

### Phase 3 — Hypothesise (owned by @implementer)

**Goal**: Form one falsifiable hypothesis at a time.

1. Review the MRC and clues from Phase 2
2. Form **one** hypothesis: "The bug is caused by X because Y"
3. The hypothesis must be **falsifiable** — it must predict a specific observable outcome
4. Write the hypothesis down before testing it
5. Identify the single observation that would confirm or refute it

**Rules**:
- Never test multiple hypotheses simultaneously
- Never form a hypothesis without evidence from the MRC
- If you have multiple candidate hypotheses, rank them by likelihood and test the most likely first
- A hypothesis is not "it might be X" — it is "X causes Y, therefore if I do Z I will observe W"

**Exit criteria**: One written, falsifiable hypothesis with a predicted observable outcome.

---

### Phase 4 — Instrument (owned by @implementer)

**Goal**: Add the minimal instrumentation needed to confirm or refute the hypothesis.

1. Add the smallest possible logging, assertions, or metrics to test the hypothesis
2. Run the MRC reproduction
3. Observe the output — does it confirm or refute the hypothesis?
4. **If confirmed**: proceed to Phase 5
5. **If refuted**: return to Phase 3 with the new evidence, form the next hypothesis

**Rules**:
- Add only what is needed to test this one hypothesis — no exploratory logging
- **Remove all instrumentation after the hypothesis is resolved** — never commit debug logging
- If instrumentation requires a code change, make it in a clearly marked temporary branch or stash
- Never leave `console.log`, `print`, `println`, `NSLog`, or equivalent debug output in committed code

**Exit criteria**: Hypothesis confirmed or refuted with evidence. All instrumentation removed.

---

### Phase 5 — Fix + Regression Test (owned by @implementer)

**Goal**: Fix the root cause and prevent recurrence.

1. Implement the fix for the confirmed root cause
2. Run the MRC reproduction — confirm it no longer fails
3. Run the full test suite — confirm no regressions
4. Write a regression test that:
   - Directly exercises the code path that was broken
   - Would have caught this bug before the fix was applied
   - Is named clearly (e.g., `test_should_not_crash_when_input_is_empty`)
5. Commit the fix and the regression test together

**Rules**:
- Fix the root cause, not the symptom
- Do not add defensive code that hides the bug without fixing it (e.g., `if err != nil { return }` without understanding why err is non-nil)
- The regression test must fail on the unfixed code and pass on the fixed code
- If the fix requires a breaking change, report it to the orchestrator before committing

**Exit criteria**: Bug fixed, full test suite passing, regression test written and passing.

---

## ANTI-PATTERNS

| Anti-pattern | Why it fails |
|---|---|
| Testing multiple hypotheses at once | You cannot know which one fixed it |
| Skipping minimisation | You waste time debugging irrelevant code |
| Committing debug logging | Pollutes production logs, masks future bugs |
| Fixing the symptom | Bug reappears in a different form |
| Guessing without evidence | Leads to random changes that may introduce new bugs |
| Debugging third-party code | Not your bug to fix — report it upstream, pin the version |

---

## HANDOFF FORMAT

When handing off between phases, always include:

```
### Debug Handoff

**Phase completed**: [1 / 2 / 3 / 4]
**Reproduction command**: [exact command]
**Failure output**: [exact error/output]
**MRC**: [minimal reproducible case — code or config]
**Clues collected**: [list of observations from minimisation]
**Ruled out**: [list of things confirmed NOT to be the cause]
**Current hypothesis**: [one falsifiable statement]
**Predicted observation**: [what you expect to see if hypothesis is correct]
```
