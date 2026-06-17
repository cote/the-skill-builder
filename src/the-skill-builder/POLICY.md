# POLICY

Follow these rules and check for this policy when making and modifying a skill.

1. **No PII in source files.** No real names, email addresses, phone numbers, home addresses, employer-specific identifiers. If the skill needs an identity for examples, use generic placeholders (`user@example.com`, `Jane Doe`, `Acme Co.`).

2. **No hardcoded user paths.** No `/Users/<name>/`, `/home/<name>/`, `/Volumes/<personal-share>/`. Use `~`, `$HOME`, or XDG roots. Repos must be relocatable.

3. **No secrets, API keys, tokens, or passwords in source.** No `Bearer ...`, no base64 blobs that decode to keys, no `password=...`, no `.env` contents. Credentials come from the environment at run time, never from disk in the repo.

4. **No private IP ranges or hostnames** (`192.168.*`, `10.*`, internal `*.local`, internal `*.ts.net`, employer intranet domains) hardcoded in source. Make them config inputs.

5. **No references to author-specific tooling, projects, or environments.** No mention of the author's other skills, internal projects, machine hostnames, employer names, or personal services. The skill should make sense to a stranger.

6. **SKILL.md frontmatter is spec-compliant.** Only fields from the Agent Skills spec: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`. No invented fields. `name` matches the inner directory name exactly. `description` says what the skill does *and* when to use it.

7. **Machine name is consistent everywhere.** Repo dir is `skill-<machine-name>`. Inner dir is `src/<machine-name>`. Frontmatter `name:` is `<machine-name>`. `build.sh` `SKILL_NAME` variable is `<machine-name>`. XDG namespace is `io.cote.ai.skill.<machine-name>`.

8. **XDG namespace tiers are not collapsed.** Config / Data / State / Cache go to their respective XDG roots. State is not the same as cache.

9. **`build.sh` runs cleanly with `--no-install`.** A fresh clone plus `./build.sh --no-install` must produce `target/<machine-name>/` and `target/<machine-name>.zip` with no errors.

10. **`.gitignore` excludes build output and OS cruft.** At minimum: `target/`, `.DS_Store`.

11. **README has display name as H1, install command, and brief usage.** A reader should know what the skill does and how to install it within ten seconds.

12. **CHANGELOG has at least one entry.** Format: `## <version> - YYYY-MM-DD` then bullet points. Update on every meaningful change.

13. **No security-sensitive logic without an explicit reason.** If the skill writes credentials, executes user-supplied shell, or downloads-and-runs code, justify it in SKILL.md. Default: skills don't do these things.

14. **The skill describes its own behavior, not the author's workflow.** If the skill embeds a domain prompt or template, that's fine; if it embeds opinions about how the author files notes, that belongs in the author's private config, not the shipped skill.

15. **Re-walk this policy on every modification.** Not just on initial scaffold. A change can introduce a violation that wasn't there before.
