-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : ROLLBACK for 01_DDL.sql — drops all objects created by 01_DDL.sql
-- WARNING : This is destructive and irreversible. Confirm data backup before running.
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

WHENEVER SQLERROR CONTINUE;

DROP TABLE [XXBU]_[MODULE]_OUT              PURGE;
DROP TABLE [XXBU]_[MODULE]_PROCESS_LOG_DTL  PURGE;
DROP TABLE [XXBU]_[MODULE]_PROCESS_LOG      PURGE;
DROP TABLE [XXBU]_[MODULE]_CONFIG           PURGE;

DROP SEQUENCE [XXBU]_[MODULE]_LOG_SEQ;
DROP SEQUENCE [XXBU]_[MODULE]_DTL_SEQ;
DROP SEQUENCE [XXBU]_[MODULE]_OUT_SEQ;

-- DROP DIRECTORY [XXBU]_[MODULE]_DIR;

PROMPT 01_DDL_ROLLBACK.sql completed.
