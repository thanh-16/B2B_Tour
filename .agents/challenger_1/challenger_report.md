# Challenge & Adversarial Stress Test Report: `GET /api/tours`

## 1. Challenge Summary
- **Target Endpoint**: `GET /api/tours` & `TourFilters` UI component
- **Test Suite Executed**: `tests/unit/tours_challenger.test.ts`
- **Total Assertions Executed**: 26 dedicated adversarial test cases across 4 major threat vectors
- **Overall Risk Assessment**: LOW
- **Execution Result**: 100% PASS (41/41 total project unit tests passed)

---

## 2. Tested Dimensions & Findings

### Vector A: SQL / Script Injection Attempts
- **Inputs Tested**:
  - `' OR 1=1 --`
  - `' OR '1'='1`
  - `<script>alert('xss')</script>`
  - `"; DROP TABLE tours; --`
  - `UNION SELECT * FROM users`
  - `'; EXEC xp_cmdshell('dir'); --`
  - `${7*7}`
  - `{{constructor.constructor('return process')()}}`
  - `' HAVING 1=1 --`
  - `\0\n\r\Z`
- **Result**: PASS (Status 200 OK with sanitized filtering).
- **Analysis**: The string filter safely uses JavaScript `.toLowerCase().includes()` on string fields. No SQL or script evaluation occurs. Search terms with payload syntax return an empty list `[]` without unhandled exceptions or crashes.

### Vector B: Extreme Boundary Values
- **Inputs Tested**:
  - `minPrice=-999999`: Returned HTTP 400 with `VALIDATION_ERROR` on `minPrice`.
  - `maxPrice=0`: Returned HTTP 200 with empty array (no tours cost <= 0).
  - `page=99999`: Returned HTTP 200 with empty array `[]` and `meta.page = 99999`, handling slice out-of-bounds cleanly.
  - `limit=10000`: Returned HTTP 400 with `VALIDATION_ERROR` on `limit` exceeding Zod schema max (100).
  - `page=0`: Returned HTTP 400 with `VALIDATION_ERROR`.
- **Result**: PASS. Zod preprocessors and bounds checking effectively reject invalid parameters.

### Vector C: Conflicting Filters
- **Inputs Tested**:
  - `minPrice=100000000&maxPrice=100`: Returned HTTP 400 Bad Request.
- **Result**: PASS. Zod refinement rule `.refine(data => maxPrice >= minPrice)` fired correctly with message `"maxPrice must be greater than or equal to minPrice"`.
- **Inputs Tested**:
  - `minPrice=2000000&maxPrice=2000000`: Returned HTTP 200 with exact price match tours.

### Vector D: Special Characters & Unicode Strings
- **Inputs Tested**:
  - `"🦔 Tour 💥 %20"`, `"Đà Lạt 🌸🌿"`, `"日本語のツアー"`, `"Русский тур"`, RTL marks, and control characters.
- **Result**: PASS. URL component decoding and string indexing handle multi-byte UTF-8 characters without corruption or string length errors.

---

## 3. UI Component Stress Inspection (`TourFilters.tsx`)
- **Debounce Handling**: 300ms debounce loop handles rapidly changing inputs cleanly without race conditions.
- **Controlled Input**: `searchInput` state synchronizes properly with outer props.
- **Type Coercion**: `minPrice` and `maxPrice` parse empty inputs to `undefined` rather than `NaN`.

---

## 4. Verification Proof
```bash
npx vitest run

 RUN  v1.6.1 D:/Đồ Án

 ✓ tests/tours.test.ts  (10 tests) 10ms
 ✓ tests/unit/tours.test.ts  (5 tests) 11ms
 ✓ tests/unit/tours_challenger.test.ts  (26 tests) 18ms

 Test Files  3 passed (3)
      Tests  41 passed (41)
```
