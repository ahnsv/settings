# BASE.md

Basic coding and thinking guidelines. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward understanding over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't guess. Don't skip steps. Surface what you don't know.**

Before writing a single line:
- Restate the problem in your own words. If you can't, you don't understand it yet.
- Work through one concrete example end-to-end. What goes in, what comes out, what are the intermediate shapes?
- List edge cases explicitly: empty, single, max, negative, duplicate.
- If anything is unclear, stop. Name what's confusing. Ask.

When stuck:
- Rubber duck it — explain the problem out loud, line by line. 90% of the time you'll find it before finishing.
- Read the full error. Stack trace, line numbers, the whole thing. Don't skim.
- Take a walk. Your subconscious works while you're away from the keyboard.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code. No generics until the pattern repeats three times.
- No interfaces until there are two implementations.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- A 10-line function anyone can read beats a 1-line monstrosity.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

Name things for what they DO, not what they ARE: `filterActiveUsers` > `processData`. No abbreviations unless universal — `index` > `idx`. No magic numbers — name every constant.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the task at hand.

## 4. Verify Relentlessly

**Trust nothing. Prove everything.**

- Assert your assumptions at function entry and exit. If an invariant must hold, write an assert for it.
- Test the smallest unit first. Before the whole pipeline, test each function in isolation with known inputs.
- Print-debug when stuck. There is no shame in `console.log`. See the actual values — don't guess.
- When something breaks, find the root cause before touching code. The bug is almost never where you think it is.
- Make one change at a time. Change three things and it works? You don't know which fixed it.

## 5. Iterate in Tight Loops

**Code → Run → Observe → Adjust. Under 30 seconds.**

Keep the cycle short:
- Write the simplest version. Run it. Does it work for the happy path?
- Add one edge case. Run it. Does it work?
- Add the next edge case. Run it.
- Only then consider optimization — and only after measuring.

Commit working states. A broken intermediate state is a trap. Commit when something works, then move on.

---

**These guidelines are working if:** you ask clarifying questions before coding, your first attempt compiles and passes happy-path, your diffs contain only necessary changes, and you find bugs by reasoning rather than by random trial and error.
