---
allowed-tools: Read, Write, Glob, Grep
description: Create a spec and task list for a feature
model: opus
---

# Plan Feature: $ARGUMENTS

Plan a feature by creating a detailed spec and an ordered task list. Do NOT write any code.

## Process

1. **Read context:**
   - Read `docs/PRD.md` for product context
   - Read `CLAUDE.md` for technical standards
   - Scan existing specs in `docs/specs/` and tasks in `docs/tasks/` for consistency
   - Read relevant source files if the feature extends existing functionality

2. **Think deeply** about the feature requirements, edge cases, and implementation approach. Consider:
   - How this feature fits into the existing architecture
   - What new types/files are needed
   - What existing code needs modification
   - Data flow and state management
   - Error handling and edge cases
   - UI states (loading, empty, error, success)

3. **Create spec** at `docs/specs/$ARGUMENTS.md`:

```text
# Feature: [Feature Name]

## Overview
[What this feature does and why]

## Requirements
- [Requirement 1]
- [Requirement 2]

## UI Description
Screen: [Screen Name]
Navigation: [type]
Layout:
  - [Component details]
States: [loading, empty, error]

## Acceptance Criteria
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]

## Edge Cases
- [Edge case and how to handle it]

## Technical Notes
- [Architecture decisions, patterns to use]
- [Dependencies on other features]

## Related
- @import docs/PRD.md
- @import docs/specs/[related-feature].md (if applicable)
```

4. **Create task list** at `docs/tasks/$ARGUMENTS-tasks.md`:

```text
# Tasks: [Feature Name]

@import docs/specs/$ARGUMENTS.md

## Tasks

- [ ] Task 1: [Short title]
  - [What to do, what file(s) to create/modify]
  - [Expected outcome]

- [ ] Task 2: [Short title]
  - [Details]

...
```

Task ordering rules:
- Data model / types first
- Then business logic / view models
- Then UI views
- Then tests
- Each task should be atomic (completable in one implementation pass)
- Each task should build on prior tasks
- Include specific file paths where code will be added/modified

## Output

After creating both files, present:
1. A summary of the feature plan
2. The number of tasks
3. Suggestion to start with `/implement-feature $ARGUMENTS`
