---
name: SKILL_NAME
description: >
  What this skill does and when to use it. Include the trigger phrases the
  user is likely to say so Claude picks it up.
compatibility: Requires bash.
metadata:
  author: cote
  version: "1.0"
---

# SKILL_NAME

## Actions

<!-- Describe what the skill does. If it picks among prompt variants, document
     the matching rule: list shipped NAME_DOMAIN_PROMPT.md files, explain that
     a case-insensitive match on NAME wins, and that DEFAULT is the fallback.
     If the skill has source-specific pre-processing recipes, document the
     NAME_DOMAIN_TEMPLATE.md files too. -->

## XDG Paths

| What | Location |
|------|----------|
| Config | `~/.config/io.cote.ai.skill.SKILL_NAME/` |
| Data | `~/.local/share/io.cote.ai.skill.SKILL_NAME/` |
| State | `~/.local/state/io.cote.ai.skill.SKILL_NAME/` |
| Cache | `~/.cache/io.cote.ai.skill.SKILL_NAME/` |
