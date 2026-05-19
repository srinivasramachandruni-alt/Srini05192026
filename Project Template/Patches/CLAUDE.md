# Patches and Hotfixes

## Structure
Each patch lives in its own folder named by ticket:
  Patches/<TECH>/<TICKET>-<short-desc>/
    fix.sql          <- the fix
    rollback.sql     <- complete undo
    test_evidence.md <- test results proving fix works

## Required Header in Every Script
-- ==========================================================
-- Ticket  : <ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : <what this fixes>
-- Rollback: see rollback.sql
-- ==========================================================

## Rules
- fix.sql must be minimal - change ONLY what is needed
- rollback.sql must completely undo fix.sql
- Never combine multiple tickets in one patch folder
