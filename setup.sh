#!/bin/bash
set -euo pipefail

# iOS Flow — Project Bootstrap Script
# Replaces template placeholders and generates Xcode project

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BOLD}iOS Flow — Project Setup${NC}\n"

# Prompt for app name
read -p "App name (e.g. MyApp): " APP_NAME
if [[ -z "$APP_NAME" ]]; then
  echo "Error: App name cannot be empty."
  exit 1
fi

# Validate app name — must be a valid Swift identifier
if [[ ! "$APP_NAME" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
  echo "Error: App name must start with a letter and contain only letters/numbers (no spaces or special characters)."
  exit 1
fi

# Prompt for organization
read -p "Organization identifier (e.g. mycompany): " ORGANIZATION
if [[ -z "$ORGANIZATION" ]]; then
  echo "Error: Organization cannot be empty."
  exit 1
fi

# Validate organization — lowercase alphanumeric + hyphens
if [[ ! "$ORGANIZATION" =~ ^[a-z][a-z0-9-]*$ ]]; then
  echo "Error: Organization must be lowercase, start with a letter, and contain only letters, numbers, or hyphens."
  exit 1
fi

echo -e "\n${BOLD}Setting up ${GREEN}${APP_NAME}${NC} ${BOLD}(com.${ORGANIZATION}.${APP_NAME})${NC}\n"

# Replace placeholders in project files
echo "Replacing placeholders..."
for file in project.yml CLAUDE.md; do
  if [[ -f "$file" ]]; then
    sed -i '' "s/APP_NAME/${APP_NAME}/g" "$file"
    sed -i '' "s/ORGANIZATION/${ORGANIZATION}/g" "$file"
    echo "  ✓ ${file}"
  fi
done

# Create source directories
echo "Creating source directories..."
mkdir -p "Sources/${APP_NAME}"
mkdir -p "Tests/${APP_NAMETests:-${APP_NAME}Tests}"
mkdir -p Resources

# Create app entry point
APP_FILE="Sources/${APP_NAME}/${APP_NAME}App.swift"
if [[ ! -f "$APP_FILE" ]]; then
  cat > "$APP_FILE" << SWIFT
import SwiftUI

@main
struct ${APP_NAME}App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
SWIFT
  echo "  ✓ ${APP_FILE}"
fi

# Create ContentView
CONTENT_VIEW="Sources/${APP_NAME}/ContentView.swift"
if [[ ! -f "$CONTENT_VIEW" ]]; then
  cat > "$CONTENT_VIEW" << SWIFT
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundStyle(.orange)
                Text("${APP_NAME}")
                    .font(.largeTitle.bold())
            }
            .navigationTitle("${APP_NAME}")
        }
    }
}

#Preview {
    ContentView()
}
SWIFT
  echo "  ✓ ${CONTENT_VIEW}"
fi

# Create test file
TEST_FILE="Tests/${APP_NAME}Tests/${APP_NAME}Tests.swift"
if [[ ! -f "$TEST_FILE" ]]; then
  cat > "$TEST_FILE" << SWIFT
import Testing
@testable import ${APP_NAME}

struct ${APP_NAME}Tests {
    @Test func appLaunches() async throws {
        // Basic smoke test
        #expect(true)
    }
}
SWIFT
  echo "  ✓ ${TEST_FILE}"
fi

# Create docs structure
echo "Creating docs structure..."
mkdir -p docs/specs
mkdir -p docs/tasks
touch docs/PRD.md
echo "  ✓ docs/"

# Generate Xcode project
echo "Generating Xcode project..."
if command -v xcodegen &> /dev/null; then
  xcodegen generate
  echo -e "  ${GREEN}✓ Xcode project generated${NC}"
else
  echo -e "  ${YELLOW}⚠ XcodeGen not found. Install with: brew install xcodegen${NC}"
  echo "  Run 'xcodegen generate' after installing."
fi

# Initialize git repo (no-op if already exists)
git init 2>/dev/null || true
git add -A
git commit -m "Initialize ${APP_NAME} from ios-flow template"
echo -e "  ${GREEN}✓ Changes committed${NC}"

echo -e "\n${GREEN}${BOLD}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Open with Claude Code: claude"
echo "  2. Create a PRD: /create-prd"
echo "  3. Plan a feature: /plan-feature <feature-name>"
echo "  4. Implement: /implement-feature <feature-name>"
