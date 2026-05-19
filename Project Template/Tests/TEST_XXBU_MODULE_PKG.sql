-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : utPLSQL test package for [XXBU]_[MODULE]_PKG
--           Rename this file to TEST_[XXBU]_[MODULE]_PKG.sql
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: [XXBU] schema owner in DEV only
-- Execute: exec ut.run('[XXBU].TEST_[XXBU]_[MODULE]_PKG');

CREATE OR REPLACE PACKAGE TEST_[XXBU]_[MODULE]_PKG AS

  --%suite([MODULE] Package Tests)

  -- Happy path
  --%test(process_run completes successfully with valid data)
  PROCEDURE test_happy_path;

  -- Idempotency
  --%test(re-run produces same row count without duplicates)
  PROCEDURE test_idempotency;

  -- Invalid input
  --%test(invalid input row is excluded and logged)
  PROCEDURE test_invalid_input_excluded;

  -- Empty staging
  --%test(empty staging table causes FAILED run status)
  PROCEDURE test_empty_staging_fails;

  -- Boundary value
  --%test(boundary value [describe] is handled correctly)
  PROCEDURE test_boundary_value;

END TEST_[XXBU]_[MODULE]_PKG;
/

CREATE OR REPLACE PACKAGE BODY TEST_[XXBU]_[MODULE]_PKG AS

  -- ==========================================================
  -- Helper: Set up standard test data
  -- ==========================================================
  PROCEDURE setup_test_data IS
  BEGIN
    -- TODO: Truncate staging and insert representative test rows
    -- EXECUTE IMMEDIATE 'TRUNCATE TABLE [XXBU]_[MODULE]_STG';
    -- INSERT INTO [XXBU]_[MODULE]_STG (...) VALUES (...);
    COMMIT;
  END setup_test_data;

  -- ==========================================================
  -- Helper: Tear down — clear test data
  -- ==========================================================
  PROCEDURE teardown IS
  BEGIN
    -- TODO: Clean up test output rows if needed
    -- DELETE FROM [XXBU]_[MODULE]_OUT WHERE created_by_test = 'Y';
    COMMIT;
  END teardown;

  -- ==========================================================
  -- TEST: Happy Path
  -- ==========================================================
  PROCEDURE test_happy_path IS
    l_run_status  VARCHAR2(50);
    l_run_id      NUMBER;
  BEGIN
    setup_test_data;

    [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'TEST');

    SELECT run_id, run_status
    INTO   l_run_id, l_run_status
    FROM   [XXBU]_[MODULE]_PROCESS_LOG
    ORDER  BY run_start_time DESC
    FETCH  FIRST 1 ROW ONLY;

    ut.expect(l_run_status).to_equal('COMPLETED');

    teardown;
  EXCEPTION
    WHEN OTHERS THEN
      teardown;
      RAISE;
  END test_happy_path;

  -- ==========================================================
  -- TEST: Idempotency
  -- ==========================================================
  PROCEDURE test_idempotency IS
    l_count_first   NUMBER;
    l_count_second  NUMBER;
  BEGIN
    setup_test_data;

    [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'TEST');
    SELECT COUNT(*) INTO l_count_first FROM [XXBU]_[MODULE]_OUT;

    [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'TEST');
    SELECT COUNT(*) INTO l_count_second FROM [XXBU]_[MODULE]_OUT;

    ut.expect(l_count_second).to_equal(l_count_first);

    teardown;
  EXCEPTION
    WHEN OTHERS THEN
      teardown;
      RAISE;
  END test_idempotency;

  -- ==========================================================
  -- TEST: Invalid Input Excluded
  -- ==========================================================
  PROCEDURE test_invalid_input_excluded IS
    l_excluded_count  NUMBER;
  BEGIN
    -- TODO: Insert a row with invalid data that should be excluded
    setup_test_data;
    -- INSERT INTO [XXBU]_[MODULE]_STG (...invalid row...) VALUES (...);

    [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'TEST');

    SELECT rows_excluded
    INTO   l_excluded_count
    FROM   [XXBU]_[MODULE]_PROCESS_LOG
    ORDER  BY run_start_time DESC
    FETCH  FIRST 1 ROW ONLY;

    ut.expect(l_excluded_count).to_be_greater_than(0);

    teardown;
  EXCEPTION
    WHEN OTHERS THEN
      teardown;
      RAISE;
  END test_invalid_input_excluded;

  -- ==========================================================
  -- TEST: Empty Staging Fails
  -- ==========================================================
  PROCEDURE test_empty_staging_fails IS
    l_run_status  VARCHAR2(50);
  BEGIN
    -- TODO: Ensure staging is empty
    -- EXECUTE IMMEDIATE 'TRUNCATE TABLE [XXBU]_[MODULE]_STG';

    BEGIN
      [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => 'TEST');
    EXCEPTION
      WHEN OTHERS THEN NULL;  -- Expected to raise
    END;

    SELECT run_status
    INTO   l_run_status
    FROM   [XXBU]_[MODULE]_PROCESS_LOG
    ORDER  BY run_start_time DESC
    FETCH  FIRST 1 ROW ONLY;

    ut.expect(l_run_status).to_equal('FAILED');
  END test_empty_staging_fails;

  -- ==========================================================
  -- TEST: Boundary Value
  -- ==========================================================
  PROCEDURE test_boundary_value IS
  BEGIN
    -- TODO: Set up boundary-value test data and assert expected outcome
    ut.expect(1).to_equal(1);  -- Replace with real assertion
  END test_boundary_value;

END TEST_[XXBU]_[MODULE]_PKG;
/
