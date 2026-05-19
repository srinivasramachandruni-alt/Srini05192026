# Coding Standards

See the skills files for full technology-specific standards:
- PL/SQL:   @../../.claude/skills/oracle-db/SKILL.md
- APEX:     @../../.claude/skills/oracle-apex/SKILL.md
- EBS:      @../../.claude/skills/oracle-ebs/SKILL.md
- Fusion:   @../../.claude/skills/oracle-fusion/SKILL.md
- OIC:      @../../.claude/skills/oracle-oic/SKILL.md

## Universal Rules (all technologies)

### Naming
- All [XXBU] custom objects: `[XXBU]_` prefix, UPPER_CASE
- PL/SQL locals: `l_variable_name`
- PL/SQL params: `p_param_name`
- PL/SQL globals: `g_variable_name`
- Constants: `c_constant_name`
- Cursors: `cur_cursor_name`

### Headers
Every file must have:
```
-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : <short description>
-- Change History:
--   <YYYY-MM-DD> <name> - <what changed>
-- ==========================================================
```

### Error Handling
- Every PL/SQL block must have an EXCEPTION handler
- Always log: `[XXBU]_LOG_PKG.log_error(p_module, p_error)`
- Always re-raise unexpected exceptions with RAISE
- Never swallow: no empty `WHEN OTHERS THEN NULL`

### Security
- No hardcoded passwords or credentials
- No hardcoded schema names — use synonyms
- Use bind variables — never concatenate user input into SQL
