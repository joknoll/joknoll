#!/usr/bin/env bash
set -euo pipefail

remote="${1:-origin}"
github_url="${GITHUB_PROFILE_PUSH_URL:-git@github.com:joknoll/joknoll.git}"
codeberg_url="${CODEBERG_PROFILE_PUSH_URL:-ssh://git@codeberg.org/joknoll/.profile.git}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this script from inside the profile repository." >&2
  exit 1
fi

if ! git remote get-url "$remote" >/dev/null 2>&1; then
  echo "Remote '$remote' does not exist." >&2
  exit 1
fi

git config --unset-all "remote.$remote.pushurl" 2>/dev/null || true
git config --add "remote.$remote.pushurl" "$github_url"
git config --add "remote.$remote.pushurl" "$codeberg_url"

echo "Configured push targets for remote '$remote':"
git config --get-all "remote.$remote.pushurl" | sed 's/^/  /'
echo
echo "Fetch URL is unchanged:"
git remote get-url "$remote" | sed 's/^/  /'
