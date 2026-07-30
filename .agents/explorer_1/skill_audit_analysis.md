# Comprehensive Technical Audit Report: `/teamwork` Skill Suite

**Auditor**: Explorer 1 (`teamwork_preview_explorer`)  
**Target Suite Path**: `C:\Users\nqtha\.gemini\config\skills\teamwork\`  
**Audit Date**: 2026-07-28  
**Scope**: 5 Core Files (`SKILL.md`, `references/AGENT_ROLES.md`, `references/PATTERNS.md`, `references/SKILL_CATALOG.md`, `scripts/scan_skills.ps1`)

---

## Executive Summary

The `/teamwork` skill suite defines an autonomous, multi-agent orchestration architecture for complex software engineering tasks. It structures execution into 7 phases (Phase 0 to Phase 6), provides ready-to-use subagent prompts, establishes a decision framework for team sizing (SOLO to FULL TEAM), catalogs 115 skills, and provides an automated PowerShell discovery script.

While the suite exhibits exceptional operational discipline, strict production standards, and contract-first workflows, the audit revealed key architectural circularities, script parsing/categorization bugs, directory scope isolation conflicts, and documentation mismatches.

---

## 1. File-by-File Technical Audit & Evaluation

### 1.1 `SKILL.md` (Main Execution Protocol)

- **Purpose**: Primary orchestrator prompt establishing execution flow, phase requirements, and iron laws.
- **Lines Viewed**: 1 – 265 (Total: 265 lines)

#### Technical Analysis
1. **Execution Protocol Clarity (Lines 24–36)**:
   - Structures orchestrator workflow into 7 sequential phases: Phase 0 (Pattern Selection) ➔ Phase 1 (Skill Discovery) ➔ Phase 2 (Analysis & Planning) ➔ Phase 3 (Squad Formation) ➔ Phase 4 (Dispatch & Execute) ➔ Phase 5 (Self-Review & Verification) ➔ Phase 6 (Final Report). The protocol design is logical and clear.
2. **Phase 0 Circular Logic & Complexity Estimation Gap (Lines 38–51)**:
   - *Logic Gap / Ambiguity*: Phase 0 mandates selecting an Orchestration Pattern based on file count (`SOLO` ≤3 files, `PAIR` 4–8 files, `SQUAD` 9–20 files, `FULL TEAM` >20 files). However, Phase 2A/2B (codebase survey and scope planning) occurs *after* Phase 0. At Phase 0, the orchestrator has not yet explored the codebase, making file count estimation speculative and prone to misclassification before discovery.
3. **Phase 1 Code Snippet & Script Inconsistency (Lines 53–76)**:
   - *Inconsistency*: Phase 1 provides an inline PowerShell snippet (Lines 57–70) that defines `$workspaceSkillsPath = "<project-root>\.agents\skills"` but never iterates `$workspaceSkillsPath` in the subsequent loop. Furthermore, the inline script uses `Get-Content -Head 5` matching while `scripts/scan_skills.ps1` uses regex matching over 10 lines.
4. **Phase 2 & Contract-First Rule (Lines 78–108)**:
   - *Strength*: Phase 2C explicitly mandates that if both Backend and Frontend work is involved, the orchestrator MUST generate API contracts (TypeScript interfaces/OpenAPI) *before* dispatching subagents. This eliminates integration drift.
5. **Phase 3 Squad Formation & Rule Contradictions (Lines 110–136)**:
   - *Contradiction*: Line 131 states: *"Agent QA + Security: LUÔN LUÔN có mặt trong mọi team. Không ngoại lệ."* However, Line 44 defines the `SOLO` pattern as *"0 subagent — Agent chính tự làm"*. This creates a direct rule collision regarding subagent creation in SOLO mode.
6. **Phase 4 Dispatch, Timer & Timeout Recovery (Lines 138–170)**:
   - *Strength*: Defines explicit DAG constraints (BE/FE parallel when contracts exist; Architecture->BE->FE sequential otherwise; QA sequential after BE/FE). 4C introduces a 5-minute timeout recovery mechanism using the `schedule` tool with a 2-strike replacement protocol.
7. **Phase 5 Self-Review & Verification Loop (Lines 172–221)**:
   - *Strength*: Exceptionally rigorous. Covers static checks (no placeholders, variable naming ≥3 chars), integration checks (BE/FE response matching, auth headers, error codes), 4-tier build/test fix loops, and 5 Senior Review questions (Principal approval, edge cases, N+1 queries, OWASP security, 1000 concurrent user scaling).
8. **Phase 6 & 10 Iron Laws (Lines 223–264)**:
   - Requires `walkthrough.md` with execution proofs (build/test output logs) and enforces strict end-to-end autonomy.

#### Evaluation & Score
- **Score**: **8.5 / 10**
- **Rationale**: Outstanding operational rigor, strict contract-first workflow, and comprehensive self-verification checks. Deducted 1.5 points due to Phase 0 estimation circularity, the QA presence rule contradiction in SOLO mode, and inline script code divergence.

---

### 1.2 `references/AGENT_ROLES.md` (Subagent System Prompts)

- **Purpose**: Pre-configured system prompts for `define_subagent` across 5 specialized roles.
- **Lines Viewed**: 1 – 198 (Total: 198 lines)

#### Technical Analysis
1. **Role 1: Architect + Backend Engineer (Lines 8–37)**:
   - Enforces 6 mandatory backend skills (`backend-dev-guidelines`, `api-endpoint-builder`, etc.).
   - Establishes production rules: Zero placeholder, N+1 query prevention via bulk queries, transaction safety for multi-step operations (e.g. tour booking), early input validation, standard error JSON schema `{ success: false, error: { code, message } }`, and variable names ≥3 characters.
2. **Role 2: Frontend + UI/UX Architect (Lines 41–75)**:
   - Mandates framework-specific skill loading (React, Next.js, Tailwind).
   - Enforces design quality standards: HSL color tokens (no generic colors), Google Fonts, micro-animations (150–300ms), mobile-first touch targets ≥44px, skeleton loaders, and error UI toasts.
   - Includes explicit `[PASTE_API_CONTRACTS_HERE]` placeholder injection.
3. **Role 3: QA + Security Auditor (Lines 79–130)**:
   - *Logic Gap / Concurrency Risk*: Lines 120–122 specify working scope: *"Được ĐỌC tất cả file trong dự án... Chỉ VIẾT file trong [TEST_SCOPE_DIR]... Được sửa file code NẾU phát hiện lỗ hổng bảo mật nghiêm trọng (phải ghi log lý do)"*. Allowing QA subagents to directly modify source code outside `[TEST_SCOPE_DIR]` violates directory isolation (Iron Law 6) and creates severe race conditions when Backend/Frontend subagents are actively editing those same files concurrently.
   - *Strength*: Defines a clear 4-step audit sequence (Code Review ➔ OWASP Top 10 Security Audit ➔ Test Creation ➔ Build/Test Execution).
4. **Role 4: DevOps + Documentation Engineer (Lines 134–161)** & **Role 5: Fullstack Generalist (Lines 165–186)**:
   - Clear scope boundaries (`docs/`, `README.md`, `Dockerfile`, `.env.example`) and PAIR pattern fallback configurations.
5. **Usage & Parameter Substitution Guide (Lines 189–198)**:
   - Simple 5-step prompt instantiation workflow for orchestrators.

#### Evaluation & Score
- **Score**: **9.0 / 10**
- **Rationale**: Highly detailed, production-ready system prompts that embed senior engineering constraints directly into subagent instructions. Deducted 1.0 point due to QA emergency source code edit privilege overriding scope isolation and risking race conditions.

---

### 1.3 `references/PATTERNS.md` (Orchestration Decision Tree)

- **Purpose**: Framework for selecting subagent team size and workflow structure based on project complexity.
- **Lines Viewed**: 1 – 144 (Total: 144 lines)

#### Technical Analysis
1. **Decision Tree & Pattern Categorization (Lines 7–36)**:
   - Maps estimated file count (`≤3`, `4-20`, `>20`) and functional groups (`1`, `2`, `≥3`, `≥4`) to `SOLO`, `PAIR`, `SQUAD`, and `FULL TEAM`.
2. **Discrepancy between ASCII Tree and Section Breakdown (Lines 21–35 vs 57–80)**:
   - *Documentation Inconsistency*: In the ASCII tree (Lines 24–35), under `4-20 files` ➔ `Mấy nhóm?` ➔ `2 nhóm`, the box outputs `SQUAD`. However, under Section `Pattern 2: PAIR` (Line 58), it states `PAIR` is for `4-8 files, 2 nhóm`, and `SQUAD` (Line 79) is for `9-20 files, 2-3 nhóm`. The ASCII tree simplifies 4–20 files directly to SQUAD for 2 groups, omitting PAIR from that specific branch box.
3. **Pattern Specifications (Lines 40–136)**:
   - **SOLO** (0 subagents): Light tasks. Main agent loads skills, codes, reviews, and tests directly.
   - **PAIR** (1 subagent + Main): Medium tasks (4–8 files, 2 groups). Main agent handles primary group + QA review; subagent handles secondary group.
   - **SQUAD** (2–3 subagents): Complex tasks (9–20 files). Main agent is pure orchestrator; BE, FE, and QA subagents run in parallel/sequence.
   - **FULL TEAM** (4 subagents): Large tasks (>20 files). Pure orchestrator + Architect/BE, FE/UI, QA/Security, DevOps/Docs subagents.
4. **DAG Execution Diagrams (Lines 91–98 & 118–134)**:
   - Clear graph representations of task execution dependencies, ensuring contracts precede code and QA runs before final orchestrator review.

#### Evaluation & Score
- **Score**: **8.0 / 10**
- **Rationale**: Highly intuitive pattern framework that avoids over-engineering small tasks while structuring complex projects cleanly. Deducted 2.0 points for minor ASCII decision tree discrepancy with text definitions and reliance on pre-discovery file count estimates.

---

### 1.4 `references/SKILL_CATALOG.md` (Categorized Skill Index)

- **Purpose**: Lookup table mapping 115 skills across 8 functional domains for Phase 1 selection.
- **Lines Viewed**: 1 – 154 (Total: 154 lines)

#### Technical Analysis
1. **Structure & Mapping Utility (Lines 1–154)**:
   - Categorizes skills into `BACKEND`, `FRONTEND`, `SECURITY`, `TESTING`, `ARCHITECTURE`, `DEVOPS`, `DOCS`, `WORKFLOW`, and `OTHER`.
2. **Category Header vs Table Row Count Mismatches**:
   - *Mathematical / Maintenance Errors*:
     - Section `## FRONTEND (17 skills)` (Line 15): The table actually lists **20 skills** (Lines 18–37).
     - Section `## TESTING (17 skills)` (Line 57): The table actually lists **20 skills** (Lines 60–79).
     - Section `## DEVOPS (8 skills)` (Line 98): The table actually lists **9 skills** (Lines 101–109).
     - Section `## DOCS (10 skills)` (Line 111): The table actually lists **11 skills** (Lines 114–124).
     - Section `## WORKFLOW (32 skills)` (Line 126): The table actually lists **25 skills** (Lines 129–153).
   - Sum of section header counts: 3 + 17 + 14 + 17 + 13 + 8 + 10 + 32 = **114 skills**.
   - Sum of actual rows across tables: 3 + 20 + 14 + 20 + 13 + 9 + 11 + 25 = **115 items**.
   - The numerical counts in section headings do not match the actual table contents, indicating manual editing errors without automated validation.
3. **Static Catalog Risk**:
   - As new skills are added locally to `.agents/skills` or globally, this static markdown file becomes out-of-sync unless updated manually or generated via script.

#### Evaluation & Score
- **Score**: **7.5 / 10**
- **Rationale**: Useful quick-reference tool for phase 1 selection with clear Vietnamese summaries. Deducted 2.5 points for widespread numerical mismatches between category section headers and actual table rows.

---

### 1.5 `scripts/scan_skills.ps1` (Skill Discovery Script)

- **Purpose**: PowerShell script to dynamically discover, inspect, categorize, and format installed skills.
- **Lines Viewed**: 1 – 82 (Total: 82 lines)

#### Technical Analysis
1. **Directory Discovery & Omission of Workspace Skills (Lines 5–26)**:
   - *Critical Omision*: Line 5 sets `$globalSkillsPath = Join-Path $env:USERPROFILE ".gemini\config\skills"`. The script ONLY scans global skills. It completely ignores project local skills in `<project-root>\.agents\skills` (where custom skills like `backend-engineer`, `frontend-ui-architect`, `lead-architect`, `qa-security-auditor` reside).
2. **Regex Substring Matching & Categorization Bug (Lines 43–52)**:
   - *Classification Bug*:
     - Line 46: `elseif ($skillName -match "frontend|ui|react|nextjs|tailwind|shadcn|brandkit|imagegen|form-cro|seo|enhance_ui|redesign|high-end|image-to-code|web_performance") { $category = "FRONTEND" }`
     - Line 48: `elseif ($skillName -match "test|playwright|k6|qa|locator|flaky|scaffold|screen-reader|browser-automation|browser-testing|webapp-testing|ui_debug") { $category = "TESTING" }`
     - The pattern `"ui"` in Line 46 matches any skill containing `ui`.
     - When evaluating `ui_debug_agent`, `"ui_debug_agent" -match "ui"` returns `$true` on Line 46. Therefore, `ui_debug_agent` is categorized under `FRONTEND` instead of reaching Line 48 (`TESTING`)!
     - Similarly, `ui-a11y` is forced into `FRONTEND`.
3. **YAML Frontmatter Description Parsing Fragility (Lines 35–41)**:
   - Script fetches `Get-Content -TotalCount 10` and matches `^description:\s*(.+)$`. If a skill uses multi-line scalar syntax (`description: >`) or puts `description` after line 10, the description is missed.
4. **Console Output Missing Required Absolute Paths (Lines 66–77)**:
   - *Requirement Gap*: `SKILL.md` (Phase 1, Line 74) states that Phase 1 output must be: *"Danh sách 3-8 skills phù hợp nhất cho task, kèm đường dẫn tuyệt đối."*
   - However, `scan_skills.ps1` (Lines 72–73) ONLY outputs `$skill.Name` and `$shortDescription` to the console! It never prints `$skill.Path`, failing to provide absolute paths to the orchestrator.

#### Evaluation & Score
- **Score**: **6.5 / 10**
- **Rationale**: Functional basic script with clean output formatting. Deducted 3.5 points due to the `ui` regex categorization bug (`ui_debug_agent` ➔ FRONTEND), total omission of `.agents/skills` local folder scanning, missing absolute path console output, and fragile YAML parsing.

---

## 2. Cross-Suite Score Summary Table

| File Path | Role / Component | Score (1-10) | Primary Technical Finding |
|-----------|------------------|--------------|---------------------------|
| `SKILL.md` | Main Execution Protocol | **8.5** | Excellent 7-phase protocol & verification loops; Phase 0 estimation circularity & SOLO QA rule collision. |
| `references/AGENT_ROLES.md` | Subagent System Prompts | **9.0** | Production-ready prompts with strict coding constraints; QA emergency source code edit privilege risks race conditions. |
| `references/PATTERNS.md` | Decision Tree & Topology | **8.0** | Clear DAG graphs & scaling tiers; minor ASCII tree discrepancy for 2-group branch box. |
| `references/SKILL_CATALOG.md` | Static Skill Catalog | **7.5** | Convenient fast lookup table; section header count numbers fail to match table row counts. |
| `scripts/scan_skills.ps1` | Dynamic Discovery Script | **6.5** | Broad `"ui"` regex misclassifies `ui_debug_agent` to FRONTEND; ignores `.agents/skills` local skills; omits absolute path output. |

---

## 3. Comprehensive Suite Assessment

### 3.1 Distinct Technical Strengths (Top 3)

1. **Rigorous End-to-End Execution Protocol with Contract-First Integration**:
   - The suite establishes a clear multi-phase protocol (Phases 0–6) featuring contract-first API specification (Phase 2C). By requiring orchestrators to write TypeScript interfaces/OpenAPI specs before subagent dispatch, frontend and backend subagents can develop concurrently against a unified contract, eliminating integration mismatches.
2. **Production-Grade Subagent Prompt Engineering (`AGENT_ROLES.md`)**:
   - Subagent system prompts embed strict, real-world engineering standards directly into agent contexts: N+1 query prevention via bulk fetching, transaction boundaries for multi-step mutations, standardized JSON error payloads, WCAG AA touch targets (≥44px), HSL color token palettes, and 4-step OWASP vulnerability auditing.
3. **Pragmatic Quality Gates & Self-Correction Mechanisms (Phase 5)**:
   - Phase 5 enforces mandatory self-review checklists, integration cross-checks, and a 4-level build/test retry escalation loop (Agent fix ➔ Alternate approach ➔ Orchestrator direct fix). It mandates hard build/test output logs as proof of completion before generating `walkthrough.md`.

---

### 3.2 Distinct Technical Weaknesses & Gaps (Top 3)

1. **Phase 0 Execution Circularity & Blind Complexity Estimation**:
   - Pattern selection in Phase 0 relies on file count thresholds (`≤3`, `4-8`, `9-20`, `>20`), but codebase survey and scope breakdown occur in Phase 2. Orchestrators are required to select team structure prior to inspecting the repository, introducing guesswork into Phase 0.
2. **Directory Isolation Breakdown & Concurrency Race Risks**:
   - While `SKILL.md` (Iron Law 6) and `PATTERNS.md` mandate strict folder scope isolation for each subagent, `AGENT_ROLES.md` (Role 3) permits the QA Auditor to directly edit source code anywhere in the project if a critical vulnerability is found. In concurrent multi-agent executions, QA's out-of-scope edits risk causing write collisions and race conditions with Backend/Frontend subagents.
3. **Discovery Script Logic Bugs & Metadata Misalignment**:
   - `scan_skills.ps1` contains a regex ordering bug where matching `"ui"` categorizes testing utilities like `ui_debug_agent` under `FRONTEND` instead of `TESTING`. Furthermore, the script ignores local project skills (`.agents/skills`), fails to print absolute file paths in console output, and `SKILL_CATALOG.md` has internal header-vs-row count mismatches across 5 sections.

---

## 4. Actionable Remediation Recommendations

1. **Fix Phase 0 Sequence**: Move basic codebase survey (`list_dir` / file count estimation) into Phase 0, or explicitly re-evaluate pattern selection at the end of Phase 2.
2. **Fix `scan_skills.ps1` Categorization Regex & Paths**:
   - Evaluate `TESTING` before `FRONTEND`, or use word boundary regex (`\bui\b` or `frontend|react|nextjs`).
   - Add `$workspaceSkillsPath` scanning to `scan_skills.ps1`.
   - Update console output loop to print `$skill.Path`.
3. **Reconcile QA Role Privileges**: Restrict QA subagents to writing test files and filing vulnerability reports in `walkthrough.md` or sending messages to the orchestrator, rather than direct source edits.
4. **Synchronize `SKILL_CATALOG.md` Counts**: Update section header count numbers to match actual row counts (`FRONTEND`: 20, `TESTING`: 20, `DEVOPS`: 9, `DOCS`: 11, `WORKFLOW`: 25).
