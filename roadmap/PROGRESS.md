# 📊 Tiến Độ Dự Án — B2B Travel Platform

> **Cập nhật lần cuối:** 2026-07-28
> **Trạng thái tổng:** 🟡 Phase A — Database (Đang lập kế hoạch)

---

## 📈 Tổng Quan Tiến Độ

```
Phase A — Database     [██████████] 100%  ← HOÀN THÀNH ✅
Phase B — Backend API  [░░░░░░░░░░]   0%  ← TIẾP THEO
Phase C — Frontend     [░░░░░░░░░░]   0%
```

---

## ✅ Những Gì ĐÃ HOÀN THÀNH

### 🗄️ Phase A — Database (100% ✅)
- [x] A1: Setup Supabase Cloud Project + Docker Local Setup
- [x] A2: Duyệt ERD 21 bảng + 13 Enum types + 6 nhóm nghiệp vụ
- [x] A3: Viết 24 Migration SQL files (`db/migrations/V001` .. `V024`)
- [x] A4: Refactor bảo mật từ Code Audit (Strict Tenant Role Check, Available Balance Check, Append-only Audit Logs & Ledgers, Cross-Tenant Validation Triggers for Topup/Booking/Claim, Composite Search Index, Idempotent Seeds)
- [x] A5: Chạy thành công toàn bộ migration schema trên Supabase (`db/scripts/full_schema.sql`)
- [x] A6: Viết 7 Seed Data files + `seed_all.sql` dữ liệu demo (Idempotent UUIDs)
- [x] A7: Bổ sung `docker-compose.yml` & `.gitignore` ở gốc dự án + Verify & Document (`docs/database/erd.md`)

### 📝 Tài Liệu Đặc Tả (100% ✅)
- [x] Tài liệu 1: Tầm nhìn & Phạm vi Dự án
- [x] Tài liệu 2: Đặc tả Yêu cầu Phần mềm (SRS) — 14 modules, 55 Use Cases
- [x] Tài liệu 3: Mô tả Chi tiết & Giải pháp Logic (Saga, OCC, Double-entry Ledger)
- [x] Tài liệu 4: Kịch bản Hỏi đáp Hội đồng
- [x] Kiến trúc Phần mềm: Clean Architecture + CQRS + DDD
- [x] Kiến trúc Phần cứng: Deploy Diagram + Docker Compose
- [x] Actors & Use Cases: 5 actors, 13 Use Case Groups
- [x] Phase 1 MVP Summary + Phase 2 Scale-up plans

### 📋 Kế Hoạch Phát Triển (100% ✅)
- [x] Implementation Plan tổng (3 Phase: DB → BE → FE)
- [x] Phase A Database Plan chi tiết (5 bước, 21 bảng, 25 migration files)
- [x] Roadmap & Progress tracking (thư mục này)

### 🧹 Dọn Dẹp Dự Án (100% ✅)
- [x] Xóa prototype code cũ (src/, tests/, node_modules/)
- [x] Tổ chức lại thư mục docs/ theo chuẩn
- [x] Tạo cấu trúc thư mục db/migrations/ và db/seeds/

---

## 🔄 Những Gì ĐANG LÀM

### 🗄️ Phase A — Database
| # | Task | Trạng thái | Ghi chú |
|---|------|-----------|---------|
| A1 | Setup Supabase + Docker | ✅ Hoàn thành | Supabase Cloud project connected |
| A2 | Duyệt ERD 21 bảng | ✅ Hoàn thành | 21 bảng + 12 enums + constraints |
| A3 | Viết 25 Migration SQL files | ✅ Hoàn thành | V001..V025 đầy đủ |
| A4 | Chạy migrations trên Supabase | ✅ Hoàn thành | Success on Supabase SQL Editor |
| A5 | Viết 7 Seed Data files | ✅ Hoàn thành | `db/seeds/seed_all.sql` sẵn sàng |
| A6 | Verify & Document | ✅ Hoàn thành | `docs/database/erd.md` |

---

## 📅 Những Gì SẮP LÀM (Backlog)

### ⚙️ Phase B — Backend API
- [ ] B1: Domain Layer (Entities, Value Objects, Enums, Events)
- [ ] B2: Infrastructure Layer (EF Core, Redis, VNPay, FCM)
- [ ] B3: Application Layer — Đợt 1 (Auth, KYC, System Config)
- [ ] B3: Application Layer — Đợt 2 (Inventory, Wallet, VNPay, Markup)
- [ ] B3: Application Layer — Đợt 3 (Cart, Booking, Saga, Supplier Approval)
- [ ] B3: Application Layer — Đợt 4 (Voucher, Claims, Notification, Report, AI)
- [ ] B4: WebAPI Layer (Controllers, Middleware, Swagger)
- [ ] B5: Background Jobs (AutoCancel, Reconciliation, KeyRotation)
- [ ] B6: Testing + API Documentation

### 📱 Phase C — Frontend
- [ ] C1: Web Admin Portal (Next.js)
- [ ] C2: Mobile App — Agency (React Native)
- [ ] C3: Mobile App — Supplier/Delivery (React Native)

---

## 🚨 Quyết Định Kiến Trúc Đã Duyệt

| # | Quyết định | Lý do | Ngày |
|---|-----------|-------|------|
| 1 | **Bottom-Up Layered** (DB → BE → FE) | Tách riêng từng tầng làm chuyên sâu, giảm rework | 2026-07-28 |
| 2 | **Supabase Free + Docker Local** | Team cần shared DB; free tier đủ cho đồ án | 2026-07-28 |
| 3 | **SQL-First migrations** | Control 100% schema, dễ review, tài liệu rõ ràng | 2026-07-28 |
| 4 | **Clean Architecture + CQRS** | Tách biệt nghiệp vụ/kỹ thuật, dễ test, dễ scale | 2026-07-28 |

---

## 📌 Ghi Chú Cho AI Agent Mới

> Nếu bạn là AI agent mới tham gia dự án, hãy:
> 1. Đọc file `roadmap/README.md` trước
> 2. Đọc file này (`PROGRESS.md`) để biết đang làm tới đâu
> 3. Đọc file Phase tương ứng (vd: `PHASE_A_DATABASE.md`) để biết chi tiết task
> 4. KHÔNG viết code prototype/skeleton — dự án yêu cầu production-grade
> 5. KHÔNG đoán schema/API — luôn đọc tài liệu specs trước
> 6. Kiểm tra `.agents/` folder cho workspace-specific skills
