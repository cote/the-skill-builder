---
name: SKILL_MACHINE_NAME
description: >
  What this skill does and when to use it. Include the trigger phrases the
  user is likely to say so Claude picks it up.
compatibility: Requires bash.
metadata:
  author: cote
  version: "1.0"
---

<!--
  Placeholders to fill in:
    SKILL_MACHINE_NAME  - lowercase, hyphens (matches src/<name>/ dir)
    SKILL_DISPLAY_NAME  - Title Case prose
    SKILL_PACKAGE_NAME  - SKILL_MACHINE_NAME with hyphens replaced by underscores
-->

# SKILL_DISPLAY_NAME

## Actions

<!-- Describe what the skill does. If it picks among prompt variants, document
     the matching rule: list shipped NAME_DOMAIN_PROMPT.md files, explain that
     a case-insensitive match on NAME wins, and that DEFAULT is the fallback.
     If the skill has source-specific pre-processing recipes, document the
     NAME_DOMAIN_TEMPLATE.md files too. -->

## XDG Paths

| What | Location |
|------|----------|
| Config | `~/.config/io.cote.ai.skill.SKILL_PACKAGE_NAME/` |
| Data | `~/.local/share/io.cote.ai.skill.SKILL_PACKAGE_NAME/` |
| State | `~/.local/state/io.cote.ai.skill.SKILL_PACKAGE_NAME/` |
| Cache | `~/.cache/io.cote.ai.skill.SKILL_PACKAGE_NAME/` |
