-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Object-level grants for [XXBU]_[MODULE] objects
-- Rollback: see 02_GRANTS_ROLLBACK.sql
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: DBA or schema owner with GRANT privilege
-- Prerequisites: 01_DDL.sql must have been run successfully

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- Grant SELECT on output table to reporting user / read-only role
-- TODO: Replace [XXBU]_REPORT_ROLE with the actual role/user
GRANT SELECT ON [XXBU]_[MODULE]_OUT             TO [XXBU]_REPORT_ROLE;
GRANT SELECT ON [XXBU]_[MODULE]_PROCESS_LOG     TO [XXBU]_REPORT_ROLE;
GRANT SELECT ON [XXBU]_[MODULE]_PROCESS_LOG_DTL TO [XXBU]_REPORT_ROLE;

-- Grant SELECT on config to application user
-- GRANT SELECT ON [XXBU]_[MODULE]_CONFIG TO <APP_USER>;

-- Grant read/write on directory if UTL_FILE is used
-- GRANT READ, WRITE ON DIRECTORY [XXBU]_[MODULE]_DIR TO [XXBU];

PROMPT 02_GRANTS.sql completed successfully.
