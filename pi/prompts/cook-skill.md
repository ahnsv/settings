---
description: Cook a reusable skill from a working method or pattern discovered during the session
argument-hint: "<skill-name> <description>"
---
Cook a reusable skill for the following technique/method discovered during this session.

Skill name: $1
Description: $2

Follow the recipe in `skill-cooker`:
1. Create the skill directory at `~/.agents/skills/$1/`
2. Write `SKILL.md` with proper frontmatter (name, description)
3. Include clear usage instructions with bash commands
4. Add any supporting scripts or references
5. Validate the file exists

Use what we just did in this session as the basis — extract the general pattern,
remove project-specific details, and make it followable without context.
