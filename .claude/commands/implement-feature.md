---
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__xcodebuildmcp__*
description: Implement the next uncompleted task for a feature
---

# Implement Feature: $ARGUMENTS

Implement the next uncompleted task from the feature's task list.

## Process

1. **Read the task list** at `docs/tasks/$ARGUMENTS-tasks.md`
2. **Read the spec** at `docs/specs/$ARGUMENTS.md`
3. **Find the first unchecked task** (`- [ ]`)
4. **Read relevant existing code** before making changes

5. **Implement the task:**
   - Follow the coding standards in `CLAUDE.md`
   - Write clean, minimal code — only what the task requires
   - Use `@Observable` for view models, `@MainActor` for UI code
   - Use Swift 6 strict concurrency throughout

6. **Write tests** for the implemented functionality (if applicable)

7. **Build and test:**
   - Build with `xcodebuildmcp_build`
   - Run tests with `xcodebuildmcp_test`
   - Fix any build errors or test failures

8. **Mark the task complete** — change `- [ ]` to `- [x]` in the task file

9. **Stop and report:**
   - Summarize what was implemented
   - Show the next uncompleted task
   - Ask if the user wants to continue to the next task

## Rules

- Implement **one task at a time** — do not batch multiple tasks
- Always **build and verify** before marking complete
- If a task is unclear, ask the user for clarification before implementing
- If you discover the task list needs adjustment, propose changes before proceeding
- Do NOT skip ahead — tasks are ordered intentionally
