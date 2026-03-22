# Work Engine Ideas Roadmap

## Status Key
- ACTIVE = being used now
- NEXT = likely next focus
- PLANNED = good idea, not started
- LATER = future stage

## Purpose
This folder stores observations, ideas, and learning from batch runs.

## Rules
- No changes to core engine without evidence
- Ideas must come from real runs, not guesses
- No silent behavior changes
- Improvements are promoted only after validation

## Current Goal
Strengthen pipeline without drift and move toward real deliverables.

---

## Roadmap

### Phase 1 — Observe
Status: ACTIVE

Focus:
- Run batches
- Capture what worked
- Capture what failed
- Notice repeated patterns

Files:
- batch_learning/BATCH_LOG_001.md
- failures/FAILURE_PATTERNS.md

---

### Phase 2 — Understand
Status: NEXT

Focus:
- Group repeated failures
- Identify weak spots in intent parsing
- Identify weak spots in output quality
- Separate one-off errors from recurring patterns

---

### Phase 3 — Propose
Status: PLANNED

Focus:
- Write possible improvements
- Keep all ideas marked NOT IMPLEMENTED
- Require evidence from batch runs before promoting any change

Files:
- pipeline_improvements/PIPELINE_NOTES.md

---

### Phase 4 — Validate
Status: PLANNED

Focus:
- Test whether a proposed improvement solves a real recurring issue
- Confirm no drift is introduced
- Confirm pipeline stays stable

---

### Phase 5 — Promote
Status: LATER

Focus:
- Move only validated improvements into the real engine
- Keep a clean record of what changed and why
- Protect deliverable quality

---

## Current Active Items
- Build batch learning history
- Track recurring failure patterns
- Keep improvement ideas separate from engine code

---

## Promotion Rule
Nothing moves from idea to implementation unless:
1. It came from real batch evidence
2. It solves a recurring problem
3. It does not introduce drift
4. It supports future deliverables