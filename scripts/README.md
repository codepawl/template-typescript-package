# Scripts

Repo-configuration helpers. Run them in order after the template is cloned into
a new repo (or when configuring the template repo itself).

## Order

1. **Install and verify locally**
   ```bash
   pnpm install
   pnpm check && pnpm build && pnpm test
   ```

2. **Commit and push the template files**
   ```bash
   git add -A
   git commit -m "chore: scaffold template"
   git push -u origin main
   ```

3. **Wait for CI to run at least once.** Check the Actions tab on GitHub and
   confirm the job names match `test (20)` and `test (22)`.

4. **Configure repository settings**
   ```bash
   bash scripts/configure-repo.sh
   ```
   Sets description, homepage, topics, merge strategy, security flags, and
   keeps the repo marked as a template.

5. **Apply the lite branch ruleset** (no required CI yet)
   ```bash
   bash scripts/create-main-ruleset-lite.sh
   ```
   Protects `main` from deletion, force-push, and direct commits while CI check
   names are still being confirmed.

6. **(Optional) Upgrade to CI-required ruleset** once CI check names are stable
   ```bash
   bash scripts/create-main-ruleset-with-ci.sh
   ```
   Adds required status checks `test (20)` and `test (22)`. Reuses the existing
   ruleset name; if the in-place update misbehaves, delete `Protect main` in
   **Settings > Rules > Rulesets** and re-run.

## Requirements

- `gh` CLI authenticated with admin access to `codepawl/template-typescript-package`.
- Network access to GitHub.

All scripts are idempotent and avoid destructive operations.
