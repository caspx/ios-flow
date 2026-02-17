---
allowed-tools: mcp__xcodebuildmcp__*
description: Build, run on simulator, and take a screenshot
---

# Run on Simulator

Full feedback loop: build → boot simulator → install → launch → screenshot.

## Steps

1. **Build** the app using `xcodebuildmcp_build` for the iOS Simulator
2. If build fails, fix errors and rebuild (max 3 attempts)
3. **Boot simulator** using `xcodebuildmcp_boot_simulator` (iPhone 16 Pro preferred)
4. **Install** the app using `xcodebuildmcp_install_app`
5. **Launch** the app using `xcodebuildmcp_launch_app`
6. Wait a moment for the app to render
7. **Take screenshot** using `xcodebuildmcp_take_screenshot`
8. Show the screenshot and confirm the app is running

If any step fails, report the error with the specific step that failed and suggest a fix.
