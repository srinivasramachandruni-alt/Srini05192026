-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Create DBMS_SCHEDULER job for [XXBU]_[MODULE]_PKG nightly run
-- Rollback: see 05_SCHEDULER_ROLLBACK.sql
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

-- Run as: DBA or user with CREATE JOB privilege
-- Prerequisites: 04_PKG_BODY.sql must have compiled without errors
-- IMPORTANT: Job is created DISABLED — enable only after first manual test is confirmed

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

BEGIN
  -- Drop if exists (idempotent re-run)
  BEGIN
    DBMS_SCHEDULER.DROP_JOB(
      job_name => '[XXBU]_[MODULE]_NIGHTLY_JOB',
      force    => TRUE
    );
  EXCEPTION
    WHEN OTHERS THEN NULL;  -- Ignore if job does not exist
  END;

  -- Create the scheduler job
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => '[XXBU]_[MODULE]_NIGHTLY_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN [XXBU]_[MODULE]_PKG.PROCESS_RUN(p_triggered_by => ''SCHEDULER''); END;',
    start_date      => TRUNC(SYSDATE + 1) + 22/24,   -- Tomorrow at 22:00
    repeat_interval => 'FREQ=DAILY; BYHOUR=22; BYMINUTE=0; BYSECOND=0',
    end_date        => NULL,
    enabled         => FALSE,      -- DISABLED until first manual test confirmed
    auto_drop       => FALSE,
    comments        => 'Nightly run of [XXBU]_[MODULE]_PKG.PROCESS_RUN — Ticket: [TICKET-ID]'
  );
END;
/

-- Verify job was created
SELECT job_name, job_type, state, enabled, run_count, failure_count, last_run_duration
FROM   user_scheduler_jobs
WHERE  job_name = '[XXBU]_[MODULE]_NIGHTLY_JOB';

PROMPT 05_SCHEDULER.sql completed successfully.
PROMPT NOTE: Job is DISABLED — run manual test first, then enable with:
PROMPT   EXEC DBMS_SCHEDULER.ENABLE('[XXBU]_[MODULE]_NIGHTLY_JOB');
