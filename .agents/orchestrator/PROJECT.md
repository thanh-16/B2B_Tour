# Project: B2B Tour — Teamwork Trial & Audit

## Architecture
- **Skill Audit Target**: `C:\Users\nqtha\.gemini\config\skills\teamwork\` (5 files: SKILL.md, AGENT_ROLES.md, PATTERNS.md, SKILL_CATALOG.md, scan_skills.ps1)
- **Live Trial Target**: `d:\Đồ Án` (B2B Tour Project)
- **Module to Implement**: `GET /api/tours`
  - Tour Data Model / Schema / Interface
  - API Endpoint with validation & error handling
  - UI List Component (responsive, search/filter, presentation)
  - Unit Tests & verification suite

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Skill Audit | Audit 5 `/teamwork` skill files, evaluate completeness, clarity, logic gaps, edge cases, score 1-10, list 3 strengths & 3 weaknesses | none | IN_PROGRESS |
| 2 | Codebase Exploration | Inspect `d:\Đồ Án` architecture, detect tech stack (Node/Express, Next.js, C#, Python, etc.), design contracts for GET /api/tours | none | IN_PROGRESS |
| 3 | Concurrent Implementation | Implement Tour model, GET /api/tours API endpoint, UI list component, unit tests | M2 | PLANNED |
| 4 | Verification & Audit | Execute build/lint/test, Reviewer verification, Challenger stress testing, Forensic Auditor integrity check | M3 | PLANNED |
| 5 | Evaluation & Reporting | Synthesize results, write `teamwork_audit_report.md`, update progress.md with VICTORY CLAIM | M1, M4 | PLANNED |

## Interface Contracts
### GET /api/tours
- Query Parameters: `search` (string, optional), `page` (number, default 1), `limit` (number, default 10), `category` (string, optional), `minPrice`/`maxPrice` (number, optional)
- Response Format: `{ success: boolean, data: Tour[], meta: { total: number, page: number, limit: number, totalPages: number } }`
- Error Response Format: `{ success: false, error: { code: string, message: string, details?: any } }`

## Code Layout
- Determined after Codebase Exploration (Milestone 2).
