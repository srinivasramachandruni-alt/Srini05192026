-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : ROLLBACK for fix.sql — completely undoes the fix
-- WARNING : Confirm data state before running
-- ==========================================================

WHENEVER SQLERROR CONTINUE;

-- TODO: Add complete undo SQL here

COMMIT;
PROMPT rollback.sql completed.
