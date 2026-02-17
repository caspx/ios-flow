---
allowed-tools: Read, Write, Glob
description: Create a Product Requirements Document for the app
---

# Create Product Requirements Document

Generate a comprehensive PRD for the app. This is typically done once at the start of a project.

## Process

First, check if `docs/PRD.md` already exists. If it does, ask the user if they want to replace or update it.

Ask the user these clarifying questions (adapt based on what's already known):

1. **What does the app do?** — core purpose in one sentence
2. **Who is it for?** — target users
3. **What are the key features?** — list the main capabilities (prioritized)
4. **What's the MVP scope?** — what ships in v1.0?
5. **Any specific design preferences?** — dark mode, color scheme, style
6. **Any integrations needed?** — APIs, authentication, data storage

## Output

Think deeply and thoroughly about the product before writing.

Create `docs/PRD.md` with this structure:

```text
# [App Name] — Product Requirements Document

## Overview
[One paragraph describing the app]

## Target Users
[Who uses this and why]

## Core Features (MVP)
[Numbered list with brief descriptions]

## Future Features (Post-MVP)
[Features intentionally deferred]

## Technical Constraints
- iOS 17+, SwiftUI, Swift 6
- [Any user-specified constraints]

## Design Direction
[Visual style, key UX principles]

## Data Model (High-Level)
[Key entities and relationships]

## Success Metrics
[How we know the app is working]

## Implementation Roadmap
[Ordered list of features to build, sequenced by dependencies.
Each entry includes the feature name and a short reason for its position.
Example:
1. **Data Layer** — foundation other features depend on
2. **Auth** — required before any user-facing features
3. **Home Screen** — primary entry point
...
This is the order to use with `/plan-feature`.]
```

After writing, summarize the PRD and explicitly list the implementation roadmap so the user knows exactly which feature to `/plan-feature` next.
