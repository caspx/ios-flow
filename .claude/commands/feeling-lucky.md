---
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__xcodebuildmcp__*
description: Build the entire app — plan and implement all features end-to-end
model: opus
---

# I'm Feeling Lucky

Build the entire app from the PRD. Plan each feature, then implement every task — fully autonomous.

## Process

1. **Read the PRD** at `docs/PRD.md`
   - If it doesn't exist, stop and tell the user to run `/create-prd` first

2. **Read the Implementation Roadmap** section from the PRD
   - This is the ordered list of features to build

3. **For each feature in the roadmap, in order:**

   a. **Check if already planned** — look for `docs/specs/<feature>.md` and `docs/tasks/<feature>-tasks.md`

   b. **Plan the feature** (if not already planned):
      - Read `CLAUDE.md` for technical standards
      - Read existing specs/tasks for consistency with what's already built
      - Think deeply about requirements, architecture, edge cases
      - Create `docs/specs/<feature>.md` with requirements, UI description, acceptance criteria
      - Create `docs/tasks/<feature>-tasks.md` with ordered atomic tasks
      - Follow the task ordering: data model → business logic → UI → tests

   c. **Implement all tasks** for the feature:
      - Work through each `- [ ]` task in order
      - For each task:
        - Read relevant existing code before changing anything
        - Write clean, minimal code following `CLAUDE.md` standards
        - Write tests where applicable
        - Build with `xcodebuildmcp_build`
        - Run tests with `xcodebuildmcp_test`
        - Fix any errors before moving on
        - Mark task `- [x]` when complete
      - After all tasks for the feature are done, do a final build + test

4. **After all features are implemented:**
   - Do a full build and test pass
   - Take a simulator screenshot of the app running
   - Summarize what was built (features, files created, test results)

## Rules

- Follow the roadmap order strictly — earlier features are dependencies for later ones
- If a build or test fails, fix it before moving to the next task
- If something is genuinely ambiguous or blocking, stop and ask the user
- Do NOT skip tests — every feature should have test coverage
- Keep commits granular: one commit per feature (after all its tasks pass)
