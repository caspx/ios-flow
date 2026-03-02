---
allowed-tools: Read, Write, Edit, Glob, Grep, Agent, mcp__xcodebuildmcp__*
description: Create multiple UI design variants in parallel worktrees for comparison
model: opus
---

# Design Variants

Create multiple UI design variants in parallel, each in its own git worktree, for side-by-side comparison. Supports both new screen designs and refinements of existing views.

## Input

```text
$ARGUMENTS
```

## Phase 1 — Detect Mode and Plan Variants

### Step 1: Parse Arguments

Extract from `$ARGUMENTS`:
- **View description or name** — what to design or refine
- **Variant count** — look for numbers like "3 variants", "try 4 options". Default: 3, max: 5
- **Variation dimensions** — any specific aspects to vary (colors, fonts, spacing, layout, etc.)

### Step 2: Detect Mode

Determine which mode to use:

**Mode B (Refinement)** if ANY of these are true:
- `$ARGUMENTS` references a view/screen name that exists in the codebase (e.g., "SettingsView", "home screen")
- `$ARGUMENTS` mentions specific aspects to vary: colors, palette, fonts, typography, spacing, corners, shadows, etc.
- `$ARGUMENTS` uses words like "try", "explore", "variations of", "alternatives for"

**Mode A (New Design)** if:
- `$ARGUMENTS` describes a screen that doesn't exist yet
- `$ARGUMENTS` uses words like "a settings screen with...", "create a...", "design a..."

**If ambiguous** — ask the user: "Should I create a new view from scratch, or refine an existing one?"

### Step 3: Read App Context

Use Glob and Read to understand the current app:
- Read `project.yml` for the project name and source structure
- Scan the `Sources/` directory for existing views and view models
- If Mode B: read the target view's code and identify its file path
- Note the navigation structure (how screens connect)

### Step 4: Define Variant Directions

**For Mode A (New Design)** — define N distinct design approaches. Vary along 2-3 of these dimensions:

| Dimension | Options |
|-----------|---------|
| Layout | List-based, Card-based, Grid, Full-bleed sections |
| Color | Warm, Cool, Neutral, Monochrome, High-contrast |
| Density | Spacious-airy, Compact-dense, Balanced |
| Typography | Large headlines, Uniform sizing, Mixed weights |
| Visual style | Minimalist-flat, Elevated-material, Bold-vibrant |

Each variant must be meaningfully different — not just a color swap.

**For Mode B (Refinement)** — define N targeted variations scoped to the user's request:
- If user asked for "color palettes" → define N specific palettes with names and hex values
- If user asked for "font combinations" → define N typography systems
- If user asked for "layout options" → define N structural arrangements
- Keep each variant description precise and concrete (not vague like "warmer" — say "warm earth: primary #C4704B, secondary #8B5E3C, background #FFF8F0")

### Step 5: Present Plan for Approval

Show the user a table:

```text
Mode: [New Design / Refinement of ViewName]
Variants: N

| # | Name | Direction |
|---|------|-----------|
| 1 | ... | ... |
| 2 | ... | ... |
| 3 | ... | ... |
```

For Mode B, also show:
- Target file(s) that will be modified
- What will NOT change (layout, navigation, data model — whatever is out of scope)

Wait for user approval. The user may adjust variant directions or count.

## Phase 2 — Dispatch Parallel Agents

### Simulator Assignment

Assign each variant a different simulator device to avoid contention:

| Variant | Device |
|---------|--------|
| 1 | iPhone 16 Pro |
| 2 | iPhone 16 |
| 3 | iPhone 15 |
| 4 | iPhone SE (3rd generation) |
| 5 | iPhone 15 Pro Max |

### Agent Dispatch

Launch ALL variant agents in a **single message** so they run in parallel. Each agent call uses:
- `subagent_type: "general-purpose"`
- `isolation: "worktree"`
- `model: "sonnet"`

Each agent receives a prompt structured as follows (fill in the specifics per variant):

---

**Agent prompt template:**

```text
You are implementing UI design variant N of M for an iOS app.

## Project Setup

This is a worktree — there is no .xcodeproj yet. Before building:
1. Run `xcodegen generate` via the Bash tool to generate the Xcode project
2. Then proceed with builds using XcodeBuildMCP tools

## App Context

- Project: [PROJECT_NAME from project.yml]
- Source directory: [path to Sources/]
- Existing views: [list of relevant views]
- Navigation structure: [how screens connect]
- Target file (if refinement): [path to view file]

## Mode: [New Design / Refinement]

[For Mode A:]
Create a new SwiftUI view for: [FUNCTIONAL_DESCRIPTION]
The view must include: [REQUIRED_ELEMENTS]

[For Mode B:]
Modify the existing view at [FILE_PATH].
SCOPE CONSTRAINT: Only modify [WHAT_TO_CHANGE]. Do NOT change:
- View structure or layout hierarchy (unless layout is the variation dimension)
- Navigation or routing
- Data model or view model logic
- Other files not related to the visual change

## Design Direction: [VARIANT_NAME]

[DETAILED_DESIGN_DESCRIPTION — colors with hex codes, font specs, spacing values, layout approach, etc.]

## Coding Standards

- Swift 6.0 strict concurrency
- @MainActor for all UI code
- @Observable for view models (not ObservableObject)
- No force unwrapping (!) or force try (try!)
- SwiftUI best practices: NavigationStack, system colors, SF Symbols
- Support dynamic type and dark mode

## Build and Screenshot Loop (max 3 rounds)

For each round:

1. Build with xcodebuildmcp_build — fix any errors
2. Boot simulator: xcodebuildmcp_boot_simulator (device: "[ASSIGNED_DEVICE]")
3. Install: xcodebuildmcp_install_app
4. Launch: xcodebuildmcp_launch_app
5. Take screenshot: xcodebuildmcp_take_screenshot
6. Compare screenshot to the design direction above
7. If discrepancies remain and rounds left → refine and repeat
8. If looks good → proceed to commit

## Commit

When satisfied with the result:
1. Stage all changed files with git add (specific files, not -A)
2. Commit with message: "design-variants: [VARIANT_NAME] — [brief description of visual approach]"

Report back with:
- Variant name and design direction
- Files created or modified
- Number of build iterations needed
- Any issues encountered
```

---

## Phase 3 — Collect and Present Results

After all agents complete, present a comparison summary:

### For Mode A (New Design):

```text
## Design Variants Complete

| # | Variant | Branch | Key Characteristics |
|---|---------|--------|-------------------|
| 1 | [name] | [worktree branch] | [2-3 visual highlights] |
| 2 | [name] | [worktree branch] | [2-3 visual highlights] |
| 3 | [name] | [worktree branch] | [2-3 visual highlights] |

Screenshots were taken on different simulator devices for each variant.
```

### For Mode B (Refinement):

```text
## Design Variants Complete

Original: [ViewName] at [file path]

| # | Variant | Branch | Changes from Original |
|---|---------|--------|--------------------|
| 1 | [name] | [worktree branch] | [specific diffs: colors, fonts, etc.] |
| 2 | [name] | [worktree branch] | [specific diffs] |
| 3 | [name] | [worktree branch] | [specific diffs] |

Layout and functionality are identical across all variants — only [dimension] differs.
```

### Next Steps

Tell the user:

```text
To adopt a variant:
  git merge [worktree-branch-name]

To compare code between variants:
  git diff [branch-1] [branch-2] -- Sources/

To discard all variants:
  The worktrees will be cleaned up automatically, or:
  git worktree remove .claude/worktrees/[name]
```

If only one variant clearly stands out, recommend it. Otherwise, let the user decide.
