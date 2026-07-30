# 📖 AGENTS.md — Hướng Dẫn Cho AI Agent

> **File này tự động được đọc bởi mọi AI agent khi mở dự án.**
> Chứa quy tắc, context, và hướng dẫn cụ thể cho workspace này.

---

## 🎯 Dự Án Là Gì?

**B2B Travel Platform** — Nền tảng đặt chỗ du lịch B2B cho đại lý nhỏ/vừa tại Việt Nam.
- Đồ án tốt nghiệp — yêu cầu chất lượng production-grade
- Backend: ASP.NET Core 8 + Clean Architecture + CQRS + DDD
- Frontend: React Native (Mobile) + Next.js (Web Admin)
- Database: PostgreSQL 16 (Supabase Free + Docker Local)

---

## 📍 Đọc Gì Trước?

```text
1. roadmap/README.md        → Tổng quan dự án
2. roadmap/PROGRESS.md      → Đang làm tới đâu
3. roadmap/PHASE_A_*.md     → Kế hoạch Phase hiện tại
4. docs/specs/              → 4 tài liệu đặc tả gốc
5. docs/software_architecture/ → Kiến trúc phần mềm
```

---

## 🚫 Quy Tắc TUYỆT ĐỐI

1. **KHÔNG tạo prototype/skeleton** — mỗi file phải production-grade
2. **KHÔNG đoán schema** — đọc `db/migrations/` để biết cấu trúc DB
3. **KHÔNG đoán API** — đọc Swagger hoặc Application Layer handlers
4. **KHÔNG sửa migration đã chạy** — tạo migration mới để ALTER
5. **LUÔN cập nhật** `roadmap/PROGRESS.md` sau khi hoàn thành task
6. **LUÔN đọc** file mẫu cùng pattern trước khi tạo file mới

---

## 🔧 Quyết Định Kiến Trúc

| Quyết định | Chi tiết |
| :--- | :--- |
| Phát triển | Bottom-Up: DB → BE → FE |
| Database | Supabase Free (cloud) + Docker (local dev) |
| Migration | SQL-First (viết SQL tay, không dùng EF Code-First) |
| Backend | Clean Architecture + CQRS (MediatR) + DDD |
| Auth | JWT HS256 + Refresh Token Rotation + RBAC 5 roles |
| Concurrency | Redis Distributed Lock + OCC (version column) |
| Financial | Double-entry Ledger (append-only wallet_ledgers) |
| Booking | Saga Orchestrator cho combo (Tour-First strategy) |
| QR Check-in | HMAC-SHA256 offline verification + daily key rotation |

---

## 📁 Cấu Trúc Thư Mục

```
Đồ Án/
├── .agents/                    # Workspace skills cho AI
│   └── skills/                 # backend-engineer, frontend-ui-architect, etc.
├── roadmap/                    # Kế hoạch & tiến độ (đọc đầu tiên)
├── docs/                       # Tài liệu đặc tả
│   ├── specs/                  # 4 tài liệu gốc
│   ├── software_architecture/  # Kiến trúc PM
│   ├── hardware_architecture/  # Kiến trúc PC
│   ├── actors_and_usecases/    # Use Cases
│   └── database/               # ERD, Data Dictionary
├── db/                         # Database scripts
│   ├── migrations/             # V001..V025 SQL files
│   └── seeds/                  # Demo data
├── src/                        # Source code (khi Phase B bắt đầu)
└── tests/                      # Test projects
```
