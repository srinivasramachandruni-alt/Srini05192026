-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : ROLLBACK for 02_GRANTS.sql — revokes grants
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

WHENEVER SQLERROR CONTINUE;

REVOKE SELECT ON [XXBU]_[MODULE]_OUT             FROM [XXBU]_REPORT_ROLE;
REVOKE SELECT ON [XXBU]_[MODULE]_PROCESS_LOG     FROM [XXBU]_REPORT_ROLE;
REVOKE SELECT ON [XXBU]_[MODULE]_PROCESS_LOG_DTL FROM [XXBU]_REPORT_ROLE;

PROMPT 02_GRANTS_ROLLBACK.sql completed.
