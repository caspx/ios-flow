---
allowed-tools: Read, Write, Edit, Bash(fastlane *), Bash(git *), mcp__xcodebuildmcp__*
description: Build and release to TestFlight via Fastlane
---

# Release to TestFlight: $ARGUMENTS

Build the app, bump version, and release to TestFlight via Fastlane.

The argument should be the version number (e.g., `1.0.0`). If not provided, ask the user.

## Pre-flight Checks

1. Ensure `Fastfile` exists in `fastlane/` directory. If not, inform the user they need to set up Fastlane first
2. Check for uncommitted changes — warn if working tree is dirty
3. Verify the app builds successfully with `xcodebuildmcp_build` (for device)
4. Run tests with `xcodebuildmcp_test` — abort if tests fail

## Release Process

1. **Bump version** in `project.yml`:
   - Set `MARKETING_VERSION` to the provided version (`$ARGUMENTS`)
   - Auto-increment `CURRENT_PROJECT_VERSION` (read current value, add 1)

2. **Regenerate Xcode project:**
   - Run `xcodegen generate`

3. **Generate changelog:**
   - Find the last git tag: `git describe --tags --abbrev=0`
   - Collect commits since that tag: `git log <last-tag>..HEAD --oneline`
   - Format as a changelog entry
   - Prepend to `CHANGELOG.md` (create if it doesn't exist)

4. **Commit and tag:**
   - `git add project.yml CHANGELOG.md`
   - `git commit -m "Release v$ARGUMENTS"`
   - `git tag v$ARGUMENTS`

5. **Release via Fastlane:**
   - `fastlane beta` (or the appropriate lane)

6. **Report:**
   - Confirm the release was submitted
   - Show the changelog entry
   - Remind to push: `git push && git push --tags`
