-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : ROLLBACK for 05_SCHEDULER.sql — drops scheduler job
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

BEGIN
  DBMS_SCHEDULER.DROP_JOB(
    job_name => '[XXBU]_[MODULE]_NIGHTLY_JOB',
    force    => TRUE
  );
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Job not found or already dropped: ' || SQLERRM);
END;
/

PROMPT 05_SCHEDULER_ROLLBACK.sql completed.
