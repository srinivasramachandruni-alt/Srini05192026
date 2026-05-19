-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Table DDL for [XXBU]_[MODULE] objects
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- NOTE: This file is for reference only.
-- Run the full DDL via scripts/01_DDL.sql

-- Standard table template — copy and replace [MODULE] and column definitions
CREATE TABLE [XXBU]_[MODULE]_STG (
  record_id        NUMBER         NOT NULL,
  status           VARCHAR2(20)   DEFAULT 'PENDING' NOT NULL,
  error_message    VARCHAR2(4000),
  created_by       NUMBER         NOT NULL,
  creation_date    DATE           DEFAULT SYSDATE NOT NULL,
  last_updated_by  NUMBER         NOT NULL,
  last_update_date DATE           DEFAULT SYSDATE NOT NULL,
  CONSTRAINT [XXBU]_[MODULE]_STG_PK PRIMARY KEY (record_id)
);
