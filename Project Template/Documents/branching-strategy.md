# Branching Strategy

## Overview
- `main` — production-ready code; protected branch
- `feature/*` — new development; branch from `main`
- `bugfix/*` — fixes; branch from `main`
- `release/*` — release candidates; branch from `main`

## Workflow
1. Branch from `main` using the correct prefix
2. Develop and test in DEV
3. Raise PR to `main`
4. PR reviewed and approved
5. Merge to `main`
6. Deploy to UAT, then PROD following the deployment rules

## Naming Examples
```
feature/LGLT-001-lot-genealogy-transposition
bugfix/DB-4521-ar-tax-calculation
release/2026.04.01
```
