#!/usr/bin/env bash

set -e

# Find the latest tag
latest_tag=$(git tag --sort=-v:refname | grep -E '^v0\.0\.[0-9]+$' | head -n 1)

if [ -z "$latest_tag" ]; then
  echo "No tag found. Starting at v0.0.1"
  new_tag="v0.0.1"
else
  echo "Latest tag: $latest_tag"

  # Extract patch number and increment it
  patch=$(echo "$latest_tag" | cut -d '.' -f 3)
  patch=$((patch + 1))

  new_tag="v0.0.$patch"
fi

echo "Creating new tag: $new_tag"

# Create and push the tag
git tag "$new_tag"
git push origin "$new_tag"

echo "✅ Tagged and pushed: $new_tag"
echo "🚀 This will trigger CircleCI to build and release."
