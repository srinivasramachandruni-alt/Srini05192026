# Project: [SHORT PROJECT NAME] — [TICKET-ID]

## Overview
<!-- One paragraph: what business problem does this solve and how? -->
[DESCRIPTION]

- **FS Reference:** [FS-XXXX-NNN vX.X]
- **TDD Reference:** [TDD_XXXX_NNN_Short_Name.md]
- **Technology:** [EBS / Fusion / APEX / Database / OIC / ADF-OAF]
- **Status:** [In Development / UAT / Production]

---

## Location
`Project Template/` (copy this folder and rename for each new project)

---

## Key Database / Application / Integration Objects

| Object | Type | Purpose |
|--------|------|---------|
| [XXBU]_[NAME]_STG | Table | Staging — [description] |
| [XXBU]_[NAME]_OUT | Table | Output — [description]; PK = ([columns]) |
| [XXBU]_[NAME]_PROCESS_LOG | Table | Run-level log; statuses: RUNNING / COMPLETED / COMPLETED_WITH_WARNINGS / FAILED |
| [XXBU]_[NAME]_PROCESS_LOG_DTL | Table | Row-level detail (autonomous txn); FK to [XXBU]_[NAME]_PROCESS_LOG |
| [XXBU]_[NAME]_CONFIG | Table | Runtime key/value config |
| [XXBU]_[NAME]_LOG_SEQ | Sequence | Generates RUN_ID for process log |
| [XXBU]_[NAME]_DIR | Directory | Oracle DIRECTORY object for UTL_FILE output (if applicable) |

<!-- Add/remove rows as needed. Remove table entirely if no DB objects. -->

---

## Package: [XXBU]_[NAME]_PKG

- **Spec:** `Database/schemas/[XXBU]/packages/[XXBU]_[NAME]_PKG.pks`
- **Body:** `Database/schemas/[XXBU]/packages/[XXBU]_[NAME]_PKG.pkb`
- **Public entry point(s):**
  - `PROCESS_RUN(p_triggered_by IN VARCHAR2 DEFAULT 'SCHEDULER')`
  <!-- Add other public procedures/functions here -->
- **Private subprograms:** `get_config`, `start_run_log`, `finish_run_log`, `log_row_issue`
  <!-- List all private subprograms -->
- **Key constants:**
  - `c_package_name CONSTANT VARCHAR2(100) := '[XXBU]_[NAME]_PKG'`
- **Idempotency:** [Describe how re-runs are handled]
- **Commit strategy:** [Batch commit every N rows / single commit at end / caller commits]

---

## Process Flow

1. [Step 1 — e.g., Open run log entry, status = RUNNING]
2. [Step 2 — e.g., Validate staging data — fail fast if invalid]
3. [Step 3]
4. [Step 4]
5. [Step 5 — e.g., Generate output file via UTL_FILE]
6. [Step 6 — e.g., Update run log to final status]

---

## Validation & Exclusion Rules

| Issue Code | Condition | Behaviour |
|------------|-----------|-----------|
| INVALID_[X] | [condition] | Exclude row / Fail run |
| BLANK_[X] | [column] is NULL or blank | Exclude row |

---

## Config Keys ([XXBU]_[NAME]_CONFIG)

| Key | Default | Purpose |
|-----|---------|---------|
| [KEY_NAME] | [value] | [what it controls] |

---

## Deploy Order

```
Database/schemas/[XXBU]/scripts/01_DDL.sql       -- Tables, sequences, directory objects
Database/schemas/[XXBU]/scripts/02_GRANTS.sql    -- Object-level grants
Database/schemas/[XXBU]/scripts/03_PKG_SPEC.sql  -- Package spec (@packages/[XXBU]_[NAME]_PKG.pks)
Database/schemas/[XXBU]/scripts/04_PKG_BODY.sql  -- Package body (@packages/[XXBU]_[NAME]_PKG.pkb)
Database/schemas/[XXBU]/scripts/05_SCHEDULER.sql -- DBMS_SCHEDULER job (if applicable)
Database/schemas/[XXBU]/scripts/06_TEST.sql      -- End-to-end test script
```

<!-- Rollback scripts must exist alongside every DDL file -->

---

## Run Commands

```sql
-- Manual run
EXEC [XXBU]_[NAME]_PKG.PROCESS_RUN('MANUAL');

-- Check run log
SELECT * FROM [XXBU]_[NAME]_PROCESS_LOG ORDER BY RUN_START_TIME DESC FETCH FIRST 5 ROWS ONLY;

-- Check row-level issues
SELECT * FROM [XXBU]_[NAME]_PROCESS_LOG_DTL WHERE RUN_ID = &run_id;
```

---

## Scheduler Job

- **Job name:** `[XXBU]_[NAME]_NIGHTLY_JOB`
- **Schedule:** [e.g., Daily at 22:00]
- **Enabled:** FALSE until first manual test confirmed
- **Created by:** `Database/schemas/[XXBU]/scripts/05_SCHEDULER.sql`

```sql
-- Disable after deploy, before first manual test
EXEC DBMS_SCHEDULER.DISABLE('[XXBU]_[NAME]_NIGHTLY_JOB');

-- Re-enable after manual test confirmed
EXEC DBMS_SCHEDULER.ENABLE('[XXBU]_[NAME]_NIGHTLY_JOB');
```

<!-- Remove this section if no scheduler job -->

---

## Test Script

- **File:** `Tests/TEST_[XXBU]_[NAME]_PKG.sql`
- **Scenarios:** happy path, idempotency, invalid input, boundary values, fail-fast conditions

---

## Known Constraints & Gotchas

<!-- Anything non-obvious that would trip up someone working on this project -->
- [Add project-specific constraints here]

---

## Change Log

| Date | Ticket | Author | Change |
|------|--------|--------|--------|
| [YYYY-MM-DD] | [TICKET-ID] | [Name] | Initial implementation |
