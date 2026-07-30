# ⚙️ Phase B — BACKEND API: Kế Hoạch Triển Khai

> **Trạng thái:** ⬜ Chưa bắt đầu — Đợi Phase A (Database) hoàn thành
> **Thời gian ước tính:** 12-15 ngày
> **Deliverable:** Swagger API 44 endpoints + Postman Collection

---

## 📋 Tóm Tắt

Phase B xây dựng toàn bộ Backend API trên nền Clean Architecture + CQRS:

```
B1: Domain Layer          (~2 ngày)  → Entities, Value Objects, Events, Exceptions
B2: Infrastructure Layer  (~3 ngày)  → EF Core, Redis, VNPay, FCM, Hangfire
B3: Application Layer     (~5 ngày)  → 44 Command/Query Handlers (4 đợt theo dependency)
B4: WebAPI Layer          (~2 ngày)  → REST Controllers, JWT Auth, Middleware, Swagger
B5: Background Jobs       (~1 ngày)  → AutoCancel, Reconciliation, KeyRotation
B6: Testing & Docs        (~2 ngày)  → Unit Test, Integration Test, Swagger annotations
```

---

## 🔗 Dependencies

```
Phase A (Database) PHẢI hoàn thành trước.
Backend sẽ dùng EF Core kết nối đến Supabase PostgreSQL.
Schema đã được xác định bởi migration files trong db/migrations/.
```

---

## 📊 Tiến Độ

| # | Task | Trạng thái |
|---|------|-----------|
| B1 | Domain Layer | ⬜ Chưa bắt đầu |
| B2 | Infrastructure Layer | ⬜ Chưa bắt đầu |
| B3 | Application Layer | ⬜ Chưa bắt đầu |
| B4 | WebAPI Layer | ⬜ Chưa bắt đầu |
| B5 | Background Jobs | ⬜ Chưa bắt đầu |
| B6 | Testing & Docs | ⬜ Chưa bắt đầu |

---

> **Chi tiết đầy đủ** sẽ được bổ sung khi bắt đầu Phase B.
> Xem `docs/implementation_plan.md` để biết tổng quan.
