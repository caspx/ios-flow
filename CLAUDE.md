# APP_NAME — Claude Code Instructions

## Quick Reference

| Key | Value |
|-----|-------|
| Platform | iOS 17+ |
| Language | Swift 6.0 (strict concurrency) |
| UI | SwiftUI |
| Architecture | MVVM with @Observable |
| Dependencies | Swift Package Manager |
| Project gen | XcodeGen (`project.yml` → `.xcodeproj`) |
| Build tool | XcodeBuildMCP |

## Prerequisites

- **Xcode 16+** with iOS 17+ SDK
- **XcodeGen:** `brew install xcodegen`
- **Node.js/npx:** for XcodeBuildMCP
- **Fastlane:** `brew install fastlane` (for releases)

## XcodeBuildMCP Integration

Use XcodeBuildMCP tools for all build operations. Key tools:

- **Build:** `xcodebuildmcp_build` — build for simulator
- **Test:** `xcodebuildmcp_test` — run unit tests
- **Run:** `xcodebuildmcp_build`, then `xcodebuildmcp_boot_simulator`, `xcodebuildmcp_install_app`, `xcodebuildmcp_launch_app`
- **Screenshot:** `xcodebuildmcp_take_screenshot` — capture simulator screen
- **Logs:** `xcodebuildmcp_get_app_logs` — read app console output

Always use these tools instead of raw `xcodebuild` commands.

## XcodeGen

The `.xcodeproj` is generated from `project.yml`. Rules:

1. **Never edit `.xcodeproj` directly** — changes will be lost
2. Edit `project.yml` for any project configuration changes
3. Run `xcodegen generate` after modifying `project.yml`
4. The `.xcodeproj` is in `.gitignore` — never commit it

## Coding Standards

### Swift 6 Strict Concurrency
- All new types must be `Sendable` or actor-isolated
- Use `@MainActor` for all UI-related code (views, view models)
- Use `async/await` — never completion handlers
- Never suppress concurrency warnings

### SwiftUI & MVVM
- Use `@Observable` (not `ObservableObject`/`@Published`)
- View models: `@Observable @MainActor final class FooViewModel { }`
- Keep views thin — logic belongs in view models
- Use `NavigationStack` with value-based navigation

### General Swift
- `guard` for early returns
- Value types (`struct`, `enum`) over reference types when possible
- No force unwrapping (`!`) — use `guard let`, `if let`, or nil coalescing
- No `try!` or `as!` — handle errors properly
- Descriptive naming, no abbreviations

## UI Design Workflow

Screenshot-driven development for pixel-accurate UI:

1. **Describe or paste mockup** — provide visual reference or structured description
2. **Claude implements** — SwiftUI view matching the design
3. **Build & screenshot** — build, install, launch, take simulator screenshot
4. **Compare** — compare screenshot to mockup/description
5. **Iterate** — refine until visual match (max 3 rounds, then ask for feedback)

### Structured UI Description Format

When describing UI without a mockup, use this format:

```text
Screen: [Screen Name]
Navigation: [NavigationStack / Sheet / Tab]
Layout:
  - [Component]: [description, position, styling]
  - [Component]: [description, position, styling]
Colors: [color scheme details]
Typography: [font sizes, weights]
Spacing: [padding, gaps]
States: [loading, empty, error states]
```

Always take a simulator screenshot after making UI changes.

## DO NOT

- Use deprecated APIs (UIKit lifecycle in SwiftUI, ObservableObject for new code)
- Force unwrap (`!`) or force try (`try!`)
- Ignore or suppress concurrency warnings
- Edit `.xcodeproj` manually — use `project.yml` + `xcodegen generate`
- Delete `DerivedData/` unless explicitly asked
- Use storyboards or XIBs
- Use Combine for new code (use async/await and @Observable)
- Commit `.xcodeproj` to git

## Planning Workflow

For new features, follow this structured workflow:

1. **PRD** (`/create-prd`) — product requirements for the entire app (one-time)
2. **Spec** (`/plan-feature <name>`) — detailed spec + ordered task list per feature
3. **Implement** (`/implement-feature <name>`) — one task at a time, build & test after each
4. **UI** (`/design-view`) — screenshot-driven UI implementation

Spec and task files use `@import` references to link to each other.

## Project Setup Checklist

When starting a concrete project from this template:

1. Run `setup.sh` — replaces placeholders, generates Xcode project, inits git
2. Verify build: use XcodeBuildMCP to build and run on simulator
3. Create `docs/PRD.md` with `/create-prd`
4. Plan features with `/plan-feature`
5. (Optional) Add [Swift Snapshot Testing](https://github.com/pointfreeco/swift-snapshot-testing) for UI verification
6. (Optional) Configure Fastlane for TestFlight releases when ready
