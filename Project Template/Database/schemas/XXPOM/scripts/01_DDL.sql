-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : DDL — create all tables, sequences, and directory objects
--           for [XXBU]_[MODULE] project
-- Rollback: see 01_DDL_ROLLBACK.sql
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: [XXBU] schema owner (or DBA with CREATE ANY TABLE privilege)
-- Prerequisites: None

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- ==========================================================
-- Sequence: Run ID generator
-- ==========================================================
CREATE SEQUENCE [XXBU]_[MODULE]_LOG_SEQ
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOORDER
  NOCYCLE;

-- ==========================================================
-- Table: Process log (one row per PROCESS_RUN call)
-- ==========================================================
CREATE TABLE [XXBU]_[MODULE]_PROCESS_LOG (
  run_id            NUMBER          NOT NULL,
  run_status        VARCHAR2(30)    NOT NULL,  -- RUNNING / COMPLETED / COMPLETED_WITH_WARNINGS / FAILED
  triggered_by      VARCHAR2(50),              -- SCHEDULER / MANUAL / <username>
  run_start_time    TIMESTAMP       NOT NULL,
  run_end_time      TIMESTAMP,
  rows_processed    NUMBER          DEFAULT 0,
  rows_excluded     NUMBER          DEFAULT 0,
  error_message     VARCHAR2(4000),
  CONSTRAINT [XXBU]_[MODULE]_PLOG_PK PRIMARY KEY (run_id)
);

COMMENT ON TABLE  [XXBU]_[MODULE]_PROCESS_LOG IS 'Run-level log for [XXBU]_[MODULE]_PKG.PROCESS_RUN';
COMMENT ON COLUMN [XXBU]_[MODULE]_PROCESS_LOG.run_status IS 'RUNNING / COMPLETED / COMPLETED_WITH_WARNINGS / FAILED';

-- ==========================================================
-- Table: Process log detail (row-level exclusions — autonomous txn)
-- ==========================================================
CREATE TABLE [XXBU]_[MODULE]_PROCESS_LOG_DTL (
  log_dtl_id      NUMBER          NOT NULL,
  run_id          NUMBER          NOT NULL,
  row_reference   VARCHAR2(500),
  issue_type      VARCHAR2(50)    NOT NULL,
  issue_detail    VARCHAR2(4000),
  logged_at       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
  CONSTRAINT [XXBU]_[MODULE]_PLOGD_PK  PRIMARY KEY (log_dtl_id),
  CONSTRAINT [XXBU]_[MODULE]_PLOGD_FK  FOREIGN KEY (run_id)
    REFERENCES [XXBU]_[MODULE]_PROCESS_LOG (run_id)
);

CREATE SEQUENCE [XXBU]_[MODULE]_DTL_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;

-- ==========================================================
-- Table: Runtime configuration (key/value pairs)
-- ==========================================================
CREATE TABLE [XXBU]_[MODULE]_CONFIG (
  config_key      VARCHAR2(100)   NOT NULL,
  config_value    VARCHAR2(500),
  description     VARCHAR2(1000),
  last_updated    DATE            DEFAULT SYSDATE,
  CONSTRAINT [XXBU]_[MODULE]_CFG_PK PRIMARY KEY (config_key)
);

-- Seed default config values
INSERT INTO [XXBU]_[MODULE]_CONFIG (config_key, config_value, description)
VALUES ('LOG_RETENTION_DAYS', '90', 'Days to retain process log entries before purge');

-- TODO: Add project-specific config key/value pairs here

COMMIT;

-- ==========================================================
-- Table: Output / staging table
-- ==========================================================
-- TODO: Replace with actual output table definition
CREATE TABLE [XXBU]_[MODULE]_OUT (
  record_id        NUMBER         NOT NULL,
  -- TODO: Add project-specific columns here
  status           VARCHAR2(20)   DEFAULT 'PENDING' NOT NULL,
  error_message    VARCHAR2(4000),
  created_date     DATE           DEFAULT SYSDATE NOT NULL,
  CONSTRAINT [XXBU]_[MODULE]_OUT_PK PRIMARY KEY (record_id)
);

CREATE SEQUENCE [XXBU]_[MODULE]_OUT_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;

-- ==========================================================
-- Directory object (only if UTL_FILE output is required)
-- ==========================================================
-- CREATE OR REPLACE DIRECTORY [XXBU]_[MODULE]_DIR AS '/path/to/output';
-- GRANT READ, WRITE ON DIRECTORY [XXBU]_[MODULE]_DIR TO [XXBU];
-- NOTE: Verify the OS path exists and is writable before creating

PROMPT 01_DDL.sql completed successfully.
