# Project: [SHORT PROJECT NAME] — [TICKET-ID]

## Overview
<!-- One paragraph: what business problem does this solve and how? -->
[DESCRIPTION]

- **FS Reference:** [FS-XXXX-NNN vX.X]
- **TDD Reference:** [TDD_XXXX_NNN_Short_Name.md]
- **Technology:** [EBS / Fusion / APEX / Database / OIC]
- **Status:** [In Development / UAT / Production]

---

## Location
`Projects/[Technology]/[FolderName]/` (subfolder of this repo)

---

## Key Database/Application/Integrations Objects

| Object | Type | Purpose |
|--------|------|---------|
| [XXBU]_[NAME]_STG | Table | Staging — [description] |
| [XXBU]_[NAME]_OUT | Table | Output — [description]; PK = ([columns]) |
| [XXBU]_[NAME]_LOG | Table | Run-level log; statuses: RUNNING / COMPLETED / COMPLETED_WITH_WARNINGS / FAILED |
| [XXBU]_[NAME]_LOG_DTL | Table | Row-level detail (autonomous txn); FK to [XXBU]_[NAME]_LOG |
| [XXBU]_[NAME]_CONFIG | Table | Runtime key/value config |
| [XXBU]_[NAME]_SEQ | Sequence | Generates RUN_ID for process log |
| [XXBU]_[NAME]_DIR | Directory | Oracle DIRECTORY object for UTL_FILE output (if applicable) |

<!-- Add/remove rows as needed. Remove table entirely if no DB objects. -->

---

## Key Artifacts,  like:  Package(s)

### [XXBU]_[NAME]_PKG
- **Spec:** `packages/[XXBU]_[NAME]_PKG.pks`
- **Body:** `packages/[XXBU]_[NAME]_PKG.pkb`
- **Public entry point(s):**
  - `PROCESS_RUN(p_triggered_by IN VARCHAR2 DEFAULT 'SCHEDULER')`
  <!-- Add other public procedures/functions here -->
- **Private subprograms:** `get_config`, `start_run_log`, `finish_run_log`, `log_row_issue`
  <!-- List all private subprograms -->
- **Key constants:**
  - `C_[NAME] CONSTANT [TYPE] := [VALUE]` — [purpose]
- **Idempotency:** [Describe how re-runs are handled — e.g., deletes existing rows before re-inserting]
- **Commit strategy:** [e.g., batch commit every 1,000 rows / single commit at end / caller commits]

<!-- Add more packages if the project spans multiple -->

---

## Process Flow

<!-- Number each step. Be specific enough that Claude can trace the logic. -->
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
| INVALID_[X] | [condition that triggers it] | Exclude row / Fail run |
| BLANK_[X] | [column] is NULL or blank | Exclude row |
| [RULE_CODE] | [condition] | [behaviour] |

---

## Config Keys ([XXBU]_[NAME]_CONFIG)

| Key | Default | Purpose |
|-----|---------|---------|
| [KEY_NAME] | [value] | [what it controls] |
| [KEY_NAME] | [value] | [what it controls] |

---

## Deploy Order

```
01_DDL          -- Tables, sequences, directory objects
02_GRANTS       -- Object-level grants
03_PKG_SPEC     -- Package spec (.pks)
04_PKG_BODY     -- Package body (.pkb)
05_SCHEDULER    -- DBMS_SCHEDULER job (if applicable)
06_TEST         -- utPLSQL test package
```

<!-- Rollback scripts must exist alongside every DDL file -->

---

## Run Commands

```sql
-- Manual run
EXEC [XXBU]_[NAME]_PKG.PROCESS_RUN('MANUAL');

-- Check run log
SELECT * FROM [XXBU]_[NAME]_LOG ORDER BY START_TIME DESC;

-- Check row-level issues
SELECT * FROM [XXBU]_[NAME]_LOG_DTL WHERE RUN_ID = [id];
```

---

## Scheduler Job

- **Job name:** `[XXBU]_[NAME]_NIGHTLY_JOB`
- **Schedule:** [e.g., Daily at 22:00]
- **Enabled:** FALSE until first manual test confirmed
- **Created by:** `05_SCHEDULER/[XXBU]_[NAME]_SCHEDULER.sql`

<!-- Remove this section if no scheduler job -->

---

## Test Package

- **Package:** `TEST_[XXBU]_[NAME]_PKG` (`tests/TEST_[XXBU]_[NAME]_PKG.pkb`)
- **Covers:** happy path, NO_DATA_FOUND, invalid input, boundary values
  <!-- List specific test scenarios here -->

---

## Known Constraints & Gotchas

<!-- Anything non-obvious that would trip up someone working on this project -->
- [e.g., Staging table holds only one active chain at a time — truncate before reload]
- [e.g., LEVEL_GEN must match exact format 'L' + integer — regex validated in validate_level]
- [e.g., UTL_FILE requires [XXBU]_[NAME]_DIR directory grant before first run]

---

## Change Log

| Date | Ticket | Author | Change |
|------|--------|--------|--------|
| [YYYY-MM-DD] | [TICKET-ID] | [Name] | Initial implementation |
