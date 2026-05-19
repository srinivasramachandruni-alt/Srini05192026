-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Compile package body for [XXBU]_[MODULE]_PKG
-- Rollback: DROP PACKAGE BODY [XXBU]_[MODULE]_PKG;
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: [XXBU] schema owner
-- Prerequisites: 03_PKG_SPEC.sql must have been run and compiled without errors

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

@../packages/[XXBU]_[MODULE]_PKG.pkb

-- Verify body compiled without errors
SHOW ERRORS PACKAGE BODY [XXBU]_[MODULE]_PKG

-- Verify no invalid objects introduced
SELECT object_name, object_type, status, last_ddl_time
FROM   user_objects
WHERE  status = 'INVALID'
ORDER  BY object_type, object_name;

PROMPT 04_PKG_BODY.sql completed successfully.
