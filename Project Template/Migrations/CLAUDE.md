# Migration Scripts

## Rules
- Naming MUST be: V<NNN>__<short_description>.sql  (e.g. V004__add_status_index.sql)
- NEVER edit an existing V file once it has been run in any environment
- To fix a migration: create a new V file with the next number
- This folder is WRITE-PROTECTED in Claude Code settings - human review required
- Every migration must include rollback instructions as a comment at the top

## Format
-- ==========================================================
-- Migration : V004__add_status_index.sql
-- Ticket    : DB-115
-- Author    : <name>
-- Date      : <YYYY-MM-DD>
-- Rollback  : DROP INDEX [XXBU]_AR_INVOICE_STG_IDX2;
-- ==========================================================
