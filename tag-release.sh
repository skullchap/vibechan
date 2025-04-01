#!/bin/bash
set -e

# Read current version
CURRENT_VERSION=$(git tag --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 | sed 's/^v//')
IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION:-0.0.0}"

# Increment PATCH
PATCH=$((PATCH + 1))
NEW_VERSION="v$MAJOR.$MINOR.$PATCH"

# Commit version bump (optional)
git commit --allow-empty -m "Release $NEW_VERSION"

# Tag and push
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"

echo "Tagged and pushed $NEW_VERSION"
