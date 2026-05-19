-- ==========================================================
-- Ticket  : <ClickUp#/ticket ID>
-- Author  : <developer name>
-- Date    : <YYYY-MM-DD>
-- Desc    : Package specification for [XXBU]_[MODULE]_PKG
-- Change History:
--   <YYYY-MM-DD> <name> - Initial creation
-- ==========================================================

CREATE OR REPLACE PACKAGE [XXBU]_[MODULE]_PKG AS

  /*
  ** Purpose    : [Short description of what this package does]
  ** Technology : Oracle Database 19c
  ** Schema     : [XXBU]
  ** Ticket     : [TICKET-ID]
  **
  ** Change Log:
  **   [YYYY-MM-DD]  [Author]  Initial creation
  */

  -- ==========================================================
  -- Public Constants
  -- ==========================================================
  c_package_name  CONSTANT VARCHAR2(100) := '[XXBU]_[MODULE]_PKG';

  -- ==========================================================
  -- Public Entry Points
  -- ==========================================================

  /*
  ** Purpose    : Main process entry point — [brief description]
  ** Parameters : p_triggered_by  IN  VARCHAR2  Who triggered the run (SCHEDULER / MANUAL)
  ** Returns    : n/a (raises application error on unrecoverable failure)
  ** Exceptions : Raises application errors on failure; run log updated to FAILED
  */
  PROCEDURE process_run(
    p_triggered_by IN VARCHAR2 DEFAULT 'SCHEDULER'
  );

  -- TODO: Add additional public procedures/functions here

END [XXBU]_[MODULE]_PKG;
/
