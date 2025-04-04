#!/bin/bash
set -e

# Read current version
CURRENT_VERSION=$(git tag --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1 | sed 's/^v//')
IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION:-0.0.0}"

# Increment PATCH
PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_VERSION_TAG="v$NEW_VERSION"

# Update pubspec.yaml
sed -i "s/version: .*/version: $NEW_VERSION/" pubspec.yaml

# Commit changes
git add pubspec.yaml
git commit -m "Release $NEW_VERSION_TAG"

# Tag and push
git tag "$NEW_VERSION_TAG"
git push origin "$NEW_VERSION_TAG"
git push origin master

echo "Tagged and pushed $NEW_VERSION_TAG"
