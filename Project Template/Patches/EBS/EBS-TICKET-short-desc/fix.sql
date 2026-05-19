-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : <short description of what this fixes>
-- Rollback: see rollback.sql
-- ==========================================================

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- TODO: Add the minimal fix SQL here

COMMIT;
PROMPT fix.sql completed successfully.
