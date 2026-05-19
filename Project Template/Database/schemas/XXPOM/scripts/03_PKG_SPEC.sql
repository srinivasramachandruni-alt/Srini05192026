-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Compile package spec for [XXBU]_[MODULE]_PKG
-- Rollback: DROP PACKAGE [XXBU]_[MODULE]_PKG;
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: [XXBU] schema owner
-- Prerequisites: 01_DDL.sql, 02_GRANTS.sql must have been run successfully

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

@../packages/[XXBU]_[MODULE]_PKG.pks

-- Verify spec compiled without errors
SHOW ERRORS PACKAGE [XXBU]_[MODULE]_PKG

PROMPT 03_PKG_SPEC.sql completed successfully.
