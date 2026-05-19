-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Package body for [XXBU]_[MODULE]_PKG
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

CREATE OR REPLACE PACKAGE BODY [XXBU]_[MODULE]_PKG AS

  /*
  ** File        : [XXBU]_[MODULE]_PKG.pkb
  ** Description : [Full description of package purpose, logic, and key design decisions]
  ** Schema      : [XXBU]
  ** Ticket      : [TICKET-ID]
  */

  -- ==========================================================
  -- Private Constants
  -- ==========================================================
  c_proc_name  CONSTANT VARCHAR2(100) := '[XXBU]_[MODULE]_PKG';

  -- ==========================================================
  -- Private Subprograms — Forward Declarations
  -- ==========================================================
  PROCEDURE get_config(
    p_key   IN  VARCHAR2,
    p_value OUT VARCHAR2
  );

  PROCEDURE start_run_log(
    p_triggered_by IN  VARCHAR2,
    p_run_id       OUT NUMBER
  );

  PROCEDURE finish_run_log(
    p_run_id    IN NUMBER,
    p_status    IN VARCHAR2,
    p_error_msg IN VARCHAR2 DEFAULT NULL
  );

  -- ==========================================================
  -- Private Implementations
  -- ==========================================================

  /*
  ** Purpose    : Read a runtime config value from [XXBU]_[MODULE]_CONFIG
  ** Parameters : p_key    IN  VARCHAR2  Config key to look up
  **              p_value  OUT VARCHAR2  Config value (NULL if key not found)
  */
  PROCEDURE get_config(
    p_key   IN  VARCHAR2,
    p_value OUT VARCHAR2
  ) IS
  BEGIN
    SELECT config_value
    INTO   p_value
    FROM   [XXBU]_[MODULE]_CONFIG
    WHERE  config_key = p_key;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_value := NULL;  -- Return NULL if key not found; caller decides default
    WHEN OTHERS THEN
      [XXBU]_LOG_PKG.log_error(
        p_module => c_proc_name || '.get_config',
        p_error  => SQLERRM
      );
      RAISE;
  END get_config;

  /*
  ** Purpose    : Insert a RUNNING row into [XXBU]_[MODULE]_PROCESS_LOG and commit
  **              so monitoring tools see the run in progress immediately.
  ** Parameters : p_triggered_by  IN  VARCHAR2  Who triggered the run
  **              p_run_id        OUT NUMBER     Generated run ID
  */
  PROCEDURE start_run_log(
    p_triggered_by IN  VARCHAR2,
    p_run_id       OUT NUMBER
  ) IS
  BEGIN
    SELECT [XXBU]_[MODULE]_LOG_SEQ.NEXTVAL
    INTO   p_run_id
    FROM   DUAL;

    INSERT INTO [XXBU]_[MODULE]_PROCESS_LOG (
      run_id,
      run_status,
      triggered_by,
      run_start_time
    ) VALUES (
      p_run_id,
      'RUNNING',
      p_triggered_by,
      SYSTIMESTAMP
    );

    COMMIT;  -- Standalone commit so RUNNING is visible to monitoring before DML starts
  EXCEPTION
    WHEN OTHERS THEN
      [XXBU]_LOG_PKG.log_error(
        p_module => c_proc_name || '.start_run_log',
        p_error  => SQLERRM
      );
      RAISE;
  END start_run_log;

  /*
  ** Purpose    : Update [XXBU]_[MODULE]_PROCESS_LOG to final status and commit.
  ** Parameters : p_run_id    IN  NUMBER    Run ID to update
  **              p_status    IN  VARCHAR2  Final status (COMPLETED / COMPLETED_WITH_WARNINGS / FAILED)
  **              p_error_msg IN  VARCHAR2  Error message (populated on FAILED runs only)
  */
  PROCEDURE finish_run_log(
    p_run_id    IN NUMBER,
    p_status    IN VARCHAR2,
    p_error_msg IN VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    UPDATE [XXBU]_[MODULE]_PROCESS_LOG
    SET    run_status    = p_status,
           error_message = p_error_msg,
           run_end_time  = SYSTIMESTAMP
    WHERE  run_id = p_run_id;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      [XXBU]_LOG_PKG.log_error(
        p_module => c_proc_name || '.finish_run_log',
        p_error  => SQLERRM
      );
      RAISE;
  END finish_run_log;

  -- ==========================================================
  -- Public Entry Points
  -- ==========================================================

  /*
  ** Purpose    : Main process entry point — [brief description]
  ** Parameters : p_triggered_by  IN  VARCHAR2  Who triggered the run (SCHEDULER / MANUAL)
  ** Exceptions : Raises application errors on unrecoverable failure; run log updated to FAILED
  */
  PROCEDURE process_run(
    p_triggered_by IN VARCHAR2 DEFAULT 'SCHEDULER'
  ) IS
    l_run_id      NUMBER;
    l_run_status  VARCHAR2(50) := 'COMPLETED';
    l_error_msg   VARCHAR2(4000);
  BEGIN
    -- Step 1: Open run log entry (RUNNING)
    start_run_log(
      p_triggered_by => p_triggered_by,
      p_run_id       => l_run_id
    );

    -- Step 2: [Validate staging data — fail fast if critical data is missing]
    -- TODO: Add validation logic here

    -- Step 3: [Main processing logic]
    -- TODO: Implement core business logic here

    -- Step 4: [Generate output / file if applicable]
    -- TODO: Add output generation here

    -- Step 5: Close run log with final status
    finish_run_log(
      p_run_id    => l_run_id,
      p_status    => l_run_status,
      p_error_msg => l_error_msg
    );

  EXCEPTION
    WHEN OTHERS THEN
      l_error_msg := SQLERRM;
      IF l_run_id IS NOT NULL THEN
        finish_run_log(
          p_run_id    => l_run_id,
          p_status    => 'FAILED',
          p_error_msg => l_error_msg
        );
      END IF;
      [XXBU]_LOG_PKG.log_error(
        p_module => c_proc_name || '.process_run',
        p_error  => l_error_msg
      );
      RAISE;
  END process_run;

END [XXBU]_[MODULE]_PKG;
/
