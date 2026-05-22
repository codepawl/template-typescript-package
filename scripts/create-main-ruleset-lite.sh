#!/usr/bin/env bash
#
# Create the "Protect main" repository ruleset (lite variant).
#
# Lite = no required status checks, no signed-commit requirement, no required
# reviewers. Safe to apply before CI has produced check names. Use
# create-main-ruleset-with-ci.sh once CI check names are confirmed.
#
# Rules applied:
#   - block deletion of the default branch
#   - block non-fast-forward (force) pushes
#   - require pull requests (0 approvers, dismiss stale, require thread resolution)
#   - require linear history
#
# Requires: gh CLI authenticated with admin access to the repo.

set -euo pipefail

OWNER="codepawl"
REPO="template-typescript-package"
NAME="Protect main"

step() { printf "\n==> %s\n" "$*"; }

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
    }
  ],
  "bypass_actors": []
}
JSON
)

existing_id=$(gh api "repos/${OWNER}/${REPO}/rulesets" --jq ".[] | select(.name==\"${NAME}\") | .id" 2>/dev/null || true)

if [[ -n "${existing_id}" ]]; then
  step "Updating existing ruleset '${NAME}' (id ${existing_id})"
  printf '%s' "${payload}" | gh api -X PUT "repos/${OWNER}/${REPO}/rulesets/${existing_id}" --input -
else
  step "Creating ruleset '${NAME}'"
  printf '%s' "${payload}" | gh api -X POST "repos/${OWNER}/${REPO}/rulesets" --input -
fi

step "Done."
