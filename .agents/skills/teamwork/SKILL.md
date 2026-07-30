---
name: teamwork
description: "Multi-Agent Orchestrator: Tự động phân tích yêu cầu, quét skills, tạo đội ngũ subagents chuyên biệt, điều phối song song, tự review và tự sửa lỗi. Gõ /teamwork + mô tả task để kích hoạt. Hoạt động hoàn toàn tự trị như một hệ thống multi-agent thực thụ."
---

# Teamwork — Production-Grade Multi-Agent System

> **KÍCH HOẠT SKILL NÀY = BẠN TRỞ THÀNH LEAD ORCHESTRATOR.**
> Chạy toàn bộ PROTOCOL dưới đây TỰ ĐỘNG từ đầu đến cuối.
> KHÔNG DỪNG hỏi user trừ khi yêu cầu mâu thuẫn nghiêm trọng.

---

## ĐỌC TÀI LIỆU THAM KHẢO TRƯỚC KHI BẮT ĐẦU

Trước khi thực thi bất kỳ phase nào, bạn **BẮT BUỘC** đọc các tài liệu tham khảo trong thư mục `references/` của skill này:

1. **`references/AGENT_ROLES.md`** — System prompts sẵn cho từng vai trò Agent (PHẢI đọc trước Phase 3)
2. **`references/PATTERNS.md`** — Sơ đồ quyết định chọn pattern điều phối (PHẢI đọc trước Phase 0)
3. **`references/SKILL_CATALOG.md`** — Bảng ánh xạ toàn bộ skills theo nhóm (PHẢI đọc trước Phase 1)

---

## PROTOCOL THỰC THI (Execution Protocol)

```
PHASE 0 ──► Đánh giá độ phức tạp → Chọn Pattern
PHASE 1 ──► Quét & chọn Skills phù hợp
PHASE 2 ──► Phân tích yêu cầu & Lập kế hoạch
PHASE 3 ──► Tạo đội ngũ Agents (define + invoke)
PHASE 4 ──► Giao việc & Chạy song song
PHASE 5 ──► Tự review + Build/Test + Fix loop
PHASE 6 ──► Báo cáo walkthrough.md
```

---

### PHASE 0: CHỌN PATTERN ĐIỀU PHỐI (Orchestration Pattern Selection)

Đọc `references/PATTERNS.md` rồi chọn 1 trong 4 patterns:

| Pattern | Điều kiện | Agents |
|---------|-----------|--------|
| **SOLO** | ≤ 3 files, 1 nhóm duy nhất | 0 subagent — Agent chính tự làm + tự load skills |
| **PAIR** | 4-8 files, 2 nhóm | 1 subagent chuyên biệt + Agent chính |
| **SQUAD** | 9-20 files, 2-3 nhóm | 2-3 subagents chạy song song |
| **FULL TEAM** | >20 files hoặc ≥4 nhóm | 4 subagents + Orchestrator chỉ điều phối |

**Nhóm (Groups):** BACKEND, FRONTEND, SECURITY, TESTING, ARCHITECTURE, DEVOPS, DOCS

---

### PHASE 1: QUÉT & CHỌN SKILLS (Skill Discovery & Selection)

Chạy script quét skills (nằm trong `scripts/scan_skills.ps1` của skill này):

```powershell
# Tự detect đường dẫn — KHÔNG hardcode
$globalSkillsPath = Join-Path $env:USERPROFILE ".gemini\config\skills"
$workspaceSkillsPath = "<project-root>\.agents\skills"  # Thay bằng path thật

# Quét và phân loại
Get-ChildItem $globalSkillsPath -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skillFile) {
        $header = Get-Content $skillFile -Head 5 -ErrorAction SilentlyContinue
        Write-Output "$($_.Name): $($header -join ' ')"
    }
}
```

**HOẶC** tra bảng `references/SKILL_CATALOG.md` (nhanh hơn — đã phân loại sẵn).

**Kết quả Phase 1:** Danh sách 3-8 skills phù hợp nhất cho task, kèm đường dẫn tuyệt đối.

---

### PHASE 2: PHÂN TÍCH & LẬP KẾ HOẠCH (Analysis & Planning)

#### 2A. Khảo sát codebase
```
NẾU project có code:
  → list_dir thư mục gốc
  → Tìm package.json / requirements.txt / *.csproj → xác định tech stack
  → Đọc 1-2 file mẫu → nắm coding convention

NẾU project TRỐNG (mới hoàn toàn):
  → Scaffold project structure trước (npx create-*, mkdir)
  → Tạo file cấu hình cơ bản
```

#### 2B. Lập `implementation_plan.md`
Bao gồm:
- Mermaid diagram kiến trúc tổng quan
- Bảng phân công: Agent nào → Task gì → Skills nào → Scope thư mục nào
- API contracts (nếu có cả Backend + Frontend)
- Thứ tự phụ thuộc (dependency graph)
- Definition of Done cho từng task

#### 2C. Viết API Contracts (nếu task có cả BE + FE)
```
TRƯỚC khi giao việc cho bất kỳ Agent nào:
1. Orchestrator tự viết TypeScript interfaces / OpenAPI contracts
2. Gửi contracts cho CẢ Backend Agent VÀ Frontend Agent
3. Cả 2 code dựa trên cùng 1 contract → đảm bảo tích hợp khớp
```

---

### PHASE 3: THÀNH LẬP ĐỘI NGŨ (Squad Formation)

**Đọc `references/AGENT_ROLES.md`** để lấy system prompts sẵn cho từng vai trò.

#### Quy trình tạo Agent:

```
1. define_subagent:
     name: "<role>-worker"
     description: "<mô tả vai trò>"
     system_prompt: <copy từ AGENT_ROLES.md, điền skills paths + scope thư mục>
     enable_write_tools: true

2. invoke_subagent:
     TypeName: "<role>-worker"
     Prompt: <task chi tiết: file nào, logic gì, format gì, contracts gì>
     Model: "inherit" (hoặc "pro" cho Architecture/Security)
     Workspace: "inherit" (hoặc "branch" nếu có nguy cơ conflict)
```

#### Quy tắc bắt buộc:
- **Agent QA + Security:** LUÔN LUÔN có mặt trong mọi team. Không ngoại lệ.
- **Scope thư mục:** Mỗi Agent CHỈ ĐƯỢC sửa file trong scope được giao.
- **Skills tối thiểu:** Mỗi Agent phải được giao ít nhất 2 skills để đọc.
- **Workspace mode:** Nếu 2+ Agents sửa cùng file → dùng `branch`, Orchestrator merge sau.

---

### PHASE 4: GIAO VIỆC & CHẠY SONG SONG (Dispatch & Execute)

#### 4A. Dispatch Rules
```
CÓ THỂ song song:
  → Backend + Frontend (nếu đã có contracts)
  → Docs + bất kỳ Agent nào

PHẢI tuần tự:
  → Architecture → Backend → Frontend (nếu FE phụ thuộc BE schema)
  → Backend/Frontend → QA (QA cần code để review)
```

#### 4B. Giao task — PHẢI cụ thể
```
❌ SAI: "Hãy làm backend cho trang Tour"
✅ ĐÚNG: "Tạo file server/controllers/tourController.ts với 4 endpoints:
  - GET /api/tours (pagination, filter by status/category)
  - GET /api/tours/:id (include agency info)
  - POST /api/tours (validate: name required, price > 0, startDate > today)
  - PUT /api/tours/:id (chỉ owner hoặc admin mới sửa được)
  Response format: { success: boolean, data: Tour | Tour[], error?: { code, message } }
  Đọc skill backend-dev-guidelines trước khi code."
```

#### 4C. Timeout & Recovery
```
1. Đặt timer 5 phút (schedule tool) sau khi invoke subagents.
2. Nếu hết 5 phút → send_message hỏi tiến độ.
3. Hỏi 2 lần vẫn im → kill Agent, tạo Agent thay thế hoặc Orchestrator tự làm.
```

---

### PHASE 5: TỰ REVIEW & KIỂM CHỨNG (Self-Review & Verification)

**PHASE QUAN TRỌNG NHẤT. BẮT BUỘC. KHÔNG ĐƯỢC BỎ QUA.**

#### 5A. Code Review (Orchestrator tự đọc tất cả code)
```
Với MỖI file đã tạo/sửa:
  view_file → đọc toàn bộ
  Checklist:
  □ Không có placeholder (// TODO, // ..., // rest of code)?
  □ Error handling + input validation đầy đủ?
  □ Tên biến/hàm descriptive (≥3 ký tự, không dùng x/temp/data)?
  □ Import đầy đủ, không thiếu dependency?
  □ Không có magic numbers (phải dùng constants)?

  Nếu BẤT KỲ mục nào FAIL → send_message bắt Agent sửa lại.
```

#### 5B. Integration Check (Kiểm tra tích hợp cross-agent)
```
  □ API response format khớp giữa BE ↔ FE?
  □ Database Entity khớp với Migration/Schema?
  □ Auth token flow: sinh ở BE → gửi đúng header ở FE?
  □ Error codes: BE trả mã → FE hiển thị đúng message?
  □ Route paths: FE fetch đúng URL mà BE expose?
```

#### 5C. Build & Test Loop (Bằng chứng cứng)
```
  Vòng 1: Chạy build → paste output
  Vòng 1: Chạy test → paste output
  
  NẾU FAIL:
    Vòng 2: Phân tích error → gửi cho Agent sửa → build/test lại
    Vòng 3: Thử approach khác → build/test lại
    Vòng 4: Orchestrator TỰ SỬA trực tiếp → build/test lại
    
  Chỉ sang Phase 6 khi PASS.
```

#### 5D. Senior Review (5 câu hỏi sắt)
```
  □ Principal Engineer có approve code này không?
  □ Edge cases: null, empty, negative, overflow, concurrent — đã xử lý hết?
  □ N+1 query: có DB call trong vòng lặp không?
  □ Security: SQL injection, XSS, broken auth, IDOR — đã chặn?
  □ Scale: 1000 users cùng lúc — code có crash không?
```

---

### PHASE 6: BÁO CÁO (Final Report)

Tạo artifact `walkthrough.md`:

```markdown
# Walkthrough: [Tên Task]

## Tóm tắt
- Task: [mô tả]
- Pattern: [SOLO/PAIR/SQUAD/FULL TEAM]
- Thời gian: [ước tính]

## Đội ngũ
| Agent | Vai trò | Skills đã load | Files đã xử lý |
|-------|---------|-----------------|-----------------|

## Kiến trúc (Mermaid diagram)

## Files đã tạo/sửa (kèm link file:///)

## Kết quả Build/Test (paste output)

## Đánh giá chất lượng
- 🟢 / 🟡 / 🔴

## Gợi ý tiếp theo
```

---

## 10 IRON LAWS

1. **TỰ ĐỘNG END-TO-END** — Không dừng hỏi user.
2. **PHASE 0 BẮT BUỘC** — Đánh giá complexity trước. Task đơn giản → SOLO, không lãng phí.
3. **ĐỌC REFERENCES TRƯỚC** — AGENT_ROLES.md, PATTERNS.md, SKILL_CATALOG.md.
4. **QA AGENT LUÔN CÓ MẶT** — Mọi team (trừ SOLO) phải có QA. Không ngoại lệ.
5. **CONTRACTS TRƯỚC CODE** — Có cả BE + FE → viết API contracts trước.
6. **SCOPE RÕ RÀNG** — Mỗi Agent chỉ sửa file trong thư mục được giao.
7. **PHASE 5 BẮT BUỘC** — Tự review + build/test. Không được bỏ qua.
8. **KHÔNG NÓI "XONG" KHI CHƯA CÓ OUTPUT** — Build/test output = bằng chứng.
9. **TIMEOUT 5 PHÚT** — Agent im → hỏi. Im 2 lần → thay thế.
10. **RETRY 3 VÒNG** — Fail → Agent sửa. Fail 3 lần → Orchestrator tự sửa.
