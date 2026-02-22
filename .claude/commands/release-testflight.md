---
allowed-tools: Read, Write, Edit, Bash(fastlane *), Bash(git *), Bash(xcodegen *), Bash(xcode-select *), mcp__xcodebuildmcp__*
description: Build and release to TestFlight via Fastlane
---

# Release to TestFlight: $ARGUMENTS

Build the app, bump version, and release to TestFlight via Fastlane.

The argument should be the version number (e.g., `1.0.0`). If not provided, ask the user.

## Pre-flight Checks

Run ALL of these before proceeding. Stop and report if any fail:

1. **Fastlane exists** — `fastlane/Fastfile` must exist. If not, tell the user to set up Fastlane first
2. **Clean working tree** — warn if `git status` shows uncommitted changes
3. **Xcode selection** — run `xcode-select -p` and verify it points to a stable Xcode (not a beta). Warn if it contains "beta" or an unexpected path
4. **Team ID configured** — check `project.yml` for `DEVELOPMENT_TEAM`. If it's still `TEAM_ID` (placeholder), stop and ask the user for their team ID
5. **App icon exists** — verify an `AppIcon.png` file exists in the `AppIcon.appiconset` directory. If missing, stop and tell the user to add a 1024x1024 PNG
6. **Fastfile config** — verify `Fastfile` includes `export_method: "app-store"` and `xcargs: "-allowProvisioningUpdates"`. If missing, add them
7. **Build succeeds** — build with `xcodebuildmcp_build`
8. **Tests pass** — run with `xcodebuildmcp_test`

## Release Process

1. **Bump version in `project.yml`** (NOT via agvtool — avoids Info.plist drift):
   - Set `MARKETING_VERSION` to the provided version (`$ARGUMENTS`)
   - Read current `CURRENT_PROJECT_VERSION`, increment by 1, write back

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

## Known Issues

If the release fails, check these common causes:

- **`exportArchive Copy failed`** — Homebrew rsync conflict. Homebrew's rsync doesn't support Apple's `-E` flag. Fix: rename `/opt/homebrew/bin/rsync` temporarily or `brew unlink rsync`
- **`Please sign in with an app-specific password`** — Set env vars: `FASTLANE_USER=<email> FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=<password> fastlane beta`. Create app-specific password at account.apple.com
- **`No Account for Team`** — Open Xcode > Settings > Accounts and sign in with the Apple ID for the team
- **`Signing requires a development team`** — `DEVELOPMENT_TEAM` is missing or still a placeholder in `project.yml`
