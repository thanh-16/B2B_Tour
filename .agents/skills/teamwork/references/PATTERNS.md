# Orchestration Patterns — Decision Tree

> Orchestrator đọc file này ở Phase 0 để chọn pattern phù hợp.

---

## Sơ Đồ Quyết Định (Decision Tree)

```
                    ┌─────────────────────┐
                    │  Nhận yêu cầu user  │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │ Đếm số files bị      │
                    │ ảnh hưởng (ước tính) │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
        ≤ 3 files        4-20 files        > 20 files
              │                │                │
              ▼                ▼                ▼
     ┌────────────┐   ┌──────────────┐   ┌──────────────┐
     │ Mấy nhóm?  │   │  Mấy nhóm?   │   │  FULL TEAM   │
     └──────┬─────┘   └──────┬───────┘   └──────────────┘
            │                │
      ┌─────┼─────┐    ┌────┼────┐
      │           │    │         │
   1 nhóm    ≥2 nhóm  2 nhóm  ≥3 nhóm
      │           │    │         │
      ▼           ▼    ▼         ▼
   ┌──────┐  ┌──────┐ ┌──────┐ ┌───────┐
   │ SOLO │  │ PAIR │ │SQUAD │ │ SQUAD │
   └──────┘  └──────┘ └──────┘ └───────┘
```

---

## Pattern 1: SOLO (0 subagents)

**Khi nào:** Task đơn giản, ≤ 3 files, chỉ 1 nhóm (chỉ backend HOẶC chỉ frontend).

**Cách chạy:**
1. Agent chính tự load skills phù hợp (view_file đọc SKILL.md)
2. Tự code + tự review + tự build/test
3. Vẫn BẮT BUỘC Phase 5 (self-review)

**Ví dụ:**
- "Thêm 1 endpoint GET /api/users/:id"
- "Sửa CSS cho component Card"
- "Viết unit test cho hàm calculateCommission"

---

## Pattern 2: PAIR (1 subagent + Agent chính)

**Khi nào:** Task trung bình, 4-8 files, 2 nhóm.

**Cách chạy:**
1. Agent chính đảm nhận nhóm chính (thường là Backend hoặc Frontend)
2. 1 Subagent đảm nhận nhóm phụ
3. Agent chính kiêm luôn vai trò QA review cuối cùng

**Ví dụ:**
- "Tạo API + giao diện cho trang danh sách sản phẩm"
- "Refactor backend service + cập nhật frontend tương ứng"

**Cấu hình:**
```
Agent chính: Fullstack Generalist (nhóm chính) + QA reviewer
Subagent 1:  Vai trò còn lại (Backend hoặc Frontend)
```

---

## Pattern 3: SQUAD (2-3 subagents)

**Khi nào:** Task phức tạp, 9-20 files, 2-3 nhóm.

**Cách chạy:**
1. Agent chính = Orchestrator thuần (chỉ điều phối, viết contracts, review)
2. Subagent 1 = Backend Engineer
3. Subagent 2 = Frontend Architect
4. Subagent 3 = QA + Security (BẮT BUỘC)

**Ví dụ:**
- "Tạo module quản lý đặt Tour: DB schema + API + UI + Tests"
- "Redesign toàn bộ trang Dashboard: backend data + frontend UI + security review"

**Thứ tự thực thi:**
```
Orchestrator viết API contracts
        │
        ├──► Backend Agent (dùng contracts)  ──┐
        │                                       ├──► QA Agent (review + test)
        └──► Frontend Agent (dùng contracts) ──┘
```

---

## Pattern 4: FULL TEAM (4 subagents)

**Khi nào:** Task rất lớn, >20 files, ≥4 nhóm.

**Cách chạy:**
1. Agent chính = Orchestrator thuần (KHÔNG code, chỉ điều phối + review)
2. Subagent 1 = Architect + Backend
3. Subagent 2 = Frontend + UI
4. Subagent 3 = QA + Security (BẮT BUỘC)
5. Subagent 4 = DevOps + Docs

**Ví dụ:**
- "Xây dựng toàn bộ module Booking từ A-Z"
- "Tạo MVP hoàn chỉnh cho ứng dụng mới"

**Thứ tự thực thi:**
```
Orchestrator:
  Phase 1: Viết API contracts + DB schema design
  Phase 2: Dispatch song song
        │
        ├──► Backend Agent ──────────────────────┐
        ├──► Frontend Agent ─────────────────────┤
        └──► DevOps/Docs Agent ─────────────────┤
                                                  │
                                                  ▼
                                          QA Agent (chạy cuối)
                                                  │
                                                  ▼
                                          Orchestrator review
                                          Build/Test final
                                          walkthrough.md
```

---

## Quy Tắc Chung Cho Mọi Pattern

1. **QA luôn có mặt:** Pattern PAIR trở lên PHẢI có QA review (hoặc Agent chính kiêm QA).
2. **Contracts trước Code:** Nếu có ≥2 agents code → viết API contracts trước.
3. **Scope thư mục rõ ràng:** Mỗi agent chỉ sửa file trong scope được giao.
4. **Phase 5 không bỏ qua:** Dù SOLO hay FULL TEAM, self-review là BẮT BUỘC.
