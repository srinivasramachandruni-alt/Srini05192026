# Git Workflow

## Branch Naming
- New features:  `feature/TICKET-short-description`
- Bug fixes:     `bugfix/TICKET-short-description`
- Releases:      `release/YYYY.MM.DD`

## Commit Message Format
```
feat(EBS):   add AR invoice processing package
fix(DB):     correct tax calculation in [XXBU]_TAX_PKG
docs(APEX):  update deployment notes
```

## Pull Request Rules
- No direct commits to `main` — always raise a PR
- PR must have at least one reviewer before merging
- PR title: short (under 70 characters)
- PR description: summary bullets + test plan

## Deployment Environments
DEV -> UAT -> PROD
- Never deploy directly to PROD
- UAT sign-off required before PROD
- Run `/project:deploy` before every UAT or PROD deployment
- Run `/project:code-review` before every PR

## Release Tagging
`release/YYYY.MM.DD`
