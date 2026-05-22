#!/usr/bin/env bash
#
# Create the "Protect main" ruleset WITH required CI status checks.
#
# WARNING: Run this only after GitHub Actions CI has completed at least once on
# main and the check names below are confirmed. Required check names must match
# CI job names exactly, or main will become un-mergeable.
#
# Required status checks:
#   - test (20)
#   - test (22)
#
# (Workflow name "ci" + matrix job "test (<node>)" — confirm against the
# Actions tab before running.)
#
# All lite-variant rules also apply:
#   - block deletion
#   - block non-fast-forward
#   - require pull requests (0 approvers, thread resolution, dismiss stale)
#   - require linear history
#
# If the lite ruleset with the same name exists, this script attempts to UPDATE
# it in place. If updating fails or behaves unexpectedly, delete the lite
# ruleset first via the GitHub UI (Settings > Rules > Rulesets) and re-run.
#
# Requires: gh CLI authenticated with admin access to the repo.

set -euo pipefail

OWNER="codepawl"
REPO="template-typescript-package"
NAME="Protect main"

step() { printf "\n==> %s\n" "$*"; }
warn() { printf "\n!! %s\n" "$*" >&2; }

warn "Run this only after CI has completed once and check names are confirmed."
warn "Required check names: 'test (20)', 'test (22)'."

payload=$(cat <<'JSON'
{
  "name": "Protect main",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["~DEFAULT_BRANCH"],
      "exclude": []
    }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "required_linear_history" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": ["squash"]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          { "context": "test (20)" },
          { "context": "test (22)" }
        ]
      }
    }
  ],
  "bypass_actors": []
}
JSON
)

existing_id=$(gh api "repos/${OWNER}/${REPO}/rulesets" --jq ".[] | select(.name==\"${NAME}\") | .id" 2>/dev/null || true)

if [[ -n "${existing_id}" ]]; then
  step "Updating existing ruleset '${NAME}' (id ${existing_id}) to require CI checks"
  if ! printf '%s' "${payload}" | gh api -X PUT "repos/${OWNER}/${REPO}/rulesets/${existing_id}" --input -; then
    warn "Update failed. Delete the existing '${NAME}' ruleset in the GitHub UI"
    warn "(Settings > Rules > Rulesets) and re-run this script to create it fresh."
    exit 1
  fi
else
  step "Creating ruleset '${NAME}' with required CI checks"
  printf '%s' "${payload}" | gh api -X POST "repos/${OWNER}/${REPO}/rulesets" --input -
fi

step "Done."
