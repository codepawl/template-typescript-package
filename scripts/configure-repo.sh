#!/usr/bin/env bash
#
# Configure the GitHub repository with production-quality settings.
# Idempotent: safe to re-run. Does not perform destructive actions.
#
# Requires: gh CLI authenticated against an account with admin access to the repo.

set -euo pipefail

OWNER="codepawl"
REPO="template-typescript-package"
FULL="${OWNER}/${REPO}"

DESCRIPTION="Standard TypeScript package and CLI template for CodePawl projects."
HOMEPAGE="https://codepawl.com"
TOPICS=(typescript template cli codepawl agent-infrastructure)

step() { printf "\n==> %s\n" "$*"; }

step "Configuring ${FULL} metadata and feature flags"
gh repo edit "${FULL}" \
  --description "${DESCRIPTION}" \
  --homepage "${HOMEPAGE}" \
  --enable-issues=true \
  --enable-projects=false \
  --enable-wiki=false \
  --enable-discussions=false \
  --enable-squash-merge=true \
  --enable-merge-commit=false \
  --enable-rebase-merge=false \
  --enable-auto-merge=true \
  --delete-branch-on-merge=true \
  --template=true

step "Setting topics"
gh repo edit "${FULL}" --add-topic "$(IFS=,; echo "${TOPICS[*]}")"

step "Enabling vulnerability alerts (best effort)"
gh api -X PUT "repos/${FULL}/vulnerability-alerts" --silent || true

step "Enabling automated Dependabot security updates (best effort)"
gh api -X PUT "repos/${FULL}/automated-security-fixes" --silent || true

step "Done. Verifying view:"
gh repo view "${FULL}" --json name,description,homepage,isTemplate,hasIssuesEnabled,hasWikiEnabled,hasProjectsEnabled,hasDiscussionsEnabled,deleteBranchOnMerge,squashMergeAllowed,mergeCommitAllowed,rebaseMergeAllowed,autoMergeAllowed,repositoryTopics
