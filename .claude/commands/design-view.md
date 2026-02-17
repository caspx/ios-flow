---
allowed-tools: Read, Write, Edit, mcp__xcodebuildmcp__*
description: Implement a SwiftUI view with screenshot-driven feedback loop
---

# Design View

Implement a SwiftUI view based on a mockup, sketch, or text description, using a screenshot feedback loop to achieve visual accuracy.

## Input

The user should provide one of:
- A pasted screenshot/mockup image
- A text description of the desired UI
- A reference to a spec in `docs/specs/`

If no input is provided, ask the user what view they want to create.

## Process

### Iteration Loop (max 3 rounds)

**Round N:**

1. **Implement** (or refine) the SwiftUI view
   - Match the mockup/description as closely as possible
   - Use SwiftUI best practices: `NavigationStack`, proper spacing, system colors
   - Support dynamic type and dark mode
   - Keep the view code clean — extract subviews for complex layouts

2. **Build** with `xcodebuildmcp_build`
   - Fix any build errors immediately

3. **Run on simulator:**
   - Boot simulator with `xcodebuildmcp_boot_simulator`
   - Install with `xcodebuildmcp_install_app`
   - Launch with `xcodebuildmcp_launch_app`

4. **Take screenshot** with `xcodebuildmcp_take_screenshot`

5. **Compare** the screenshot to the mockup/description
   - Identify discrepancies in layout, spacing, colors, typography, alignment
   - List specific differences found

6. **Decide:**
   - If the view matches well → **Done**, report success
   - If there are differences and rounds remain → fix and iterate
   - If 3 rounds completed → show the screenshot and ask the user for specific feedback

## Guidelines

- Prefer system colors and materials for iOS-native appearance
- Use SF Symbols for icons
- Test with different content lengths (short text, long text)
- Consider safe areas and keyboard avoidance
- Use `.padding()` consistently — avoid hardcoded pixel values where possible
