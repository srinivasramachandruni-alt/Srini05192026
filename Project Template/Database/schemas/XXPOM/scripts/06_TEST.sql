-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : End-to-end test script for [XXBU]_[MODULE]_PKG
--           Run in DEV only. Not for UAT or PROD.
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Prerequisites: All previous scripts (01–05) must have been run
-- Run as: [XXBU] schema owner in DEV environment only

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

PROMPT ============================================================
PROMPT [XXBU]_[MODULE]_PKG — End-to-End Test Script
PROMPT Environment: DEV only
PROMPT ============================================================

-- ==========================================================
-- TEST SETUP: Load test data into staging table
-- ==========================================================
PROMPT [SETUP] Loading test data...

-- TODO: Replace with actual staging table and test data
-- TRUNCATE TABLE [XXBU]_[MODULE]_STG;
-- INSERT INTO [XXBU]_[MODULE]_STG (...) VALUES (...);
-- COMMIT;

-- ==========================================================
-- TEST 1: Happy Path
-- ==========================================================
PROMPT [TEST 1] Happy Path — standard successful run

DECLARE
  l_run_id   NUMBER;
  l_status   VARCHAR2(50);
BEGIN
  [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'MANUAL');
  DBMS_OUTPUT.PUT_LINE('[TEST 1] PASS — PROCESS_RUN completed without exception');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[TEST 1] FAIL — ' || SQLERRM);
END;
/

-- Verify run log
SELECT run_id, run_status, rows_processed, rows_excluded, run_start_time, run_end_time
FROM   [XXBU]_[MODULE]_PROCESS_LOG
ORDER  BY run_start_time DESC
FETCH  FIRST 1 ROW ONLY;

-- ==========================================================
-- TEST 2: Idempotency — re-run should produce the same result
-- ==========================================================
PROMPT [TEST 2] Idempotency — second run should not duplicate output rows

BEGIN
  [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'MANUAL');
  DBMS_OUTPUT.PUT_LINE('[TEST 2] PASS — re-run completed without exception');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[TEST 2] FAIL — ' || SQLERRM);
END;
/

-- TODO: Add assertion: row count in output table should match TEST 1 result

-- ==========================================================
-- TEST 3: Invalid Input — [describe scenario]
-- ==========================================================
PROMPT [TEST 3] Invalid Input — [describe what you are testing]

-- TODO: Insert invalid test data, run, assert exclusion logged, assert run status

-- ==========================================================
-- TEST 4: Empty Staging — run should fail gracefully
-- ==========================================================
PROMPT [TEST 4] Empty Staging — run should fail with FAILED status

-- TODO: Truncate staging table, run, assert FAILED status in process log

-- ==========================================================
-- RESULTS SUMMARY
-- ==========================================================
PROMPT ============================================================
PROMPT RESULTS — Check run log for final status
PROMPT ============================================================

SELECT run_id, run_status, rows_processed, rows_excluded,
       TO_CHAR(run_start_time, 'DD-MON-YYYY HH24:MI:SS') AS started,
       TO_CHAR(run_end_time,   'DD-MON-YYYY HH24:MI:SS') AS ended,
       error_message
FROM   [XXBU]_[MODULE]_PROCESS_LOG
ORDER  BY run_start_time DESC
FETCH  FIRST 5 ROWS ONLY;

PROMPT [INFO] Check [XXBU]_[MODULE]_PROCESS_LOG_DTL for any excluded rows.
PROMPT Done.
