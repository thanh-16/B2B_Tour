# 🚀 B2B Travel Platform — Project Roadmap & Status

> **File này là ĐIỂM BẮT ĐẦU cho bất kỳ ai (developer, AI agent, teammate) tham gia dự án.**
> Đọc file này TRƯỚC KHI đọc bất kỳ thứ gì khác.

---

## 📋 Dự Án Là Gì?

**B2B Travel Platform** là nền tảng đặt chỗ du lịch dành cho **đại lý du lịch nhỏ/vừa (B2B)**, không phải cho khách lẻ (B2C).

Đại lý đăng nhập → tìm kiếm dịch vụ (khách sạn, tour, vé xe, vé bay) → cộng markup lợi nhuận → giữ chỗ → thanh toán bằng ví nội bộ → nhận E-Voucher QR → khách đi check-in.

### Actors (Ai dùng hệ thống?)

| Actor | Vai trò |
| :--- | :--- |
| **Platform Admin** | Quản trị sàn — duyệt KYC, quản lý ví, cấu hình hệ thống |
| **Agency Manager** | Chủ đại lý — cấu hình markup, quản lý nhân viên |
| **Agency Staff** | Nhân viên đại lý — tìm kiếm, đặt chỗ, thanh toán |
| **Supplier Admin** | Nhà cung cấp — duyệt đơn On-Request, quản lý kho |
| **Delivery Staff** | Tài xế/guide — quét QR check-in (online/offline) |

---

## 🏗️ Kiến Trúc Tổng Quan

```
Tech Stack:
  Backend:  ASP.NET Core 8 + EF Core 8 + MediatR + FluentValidation
  Frontend: React Native (Mobile) + Next.js (Web Admin)
  Database: PostgreSQL 16 (Supabase Free + Docker Local)
  Cache:    Redis 7
  Jobs:     Hangfire
  AI:       Google Gemini API (Function Calling)
  Deploy:   Docker Compose

Kiến trúc: Clean Architecture + DDD + CQRS
  Domain Layer      → Entities, Value Objects, Business Rules (zero dependency)
  Application Layer → Commands, Queries, MediatR Handlers
  Infrastructure    → EF Core, Redis, VNPay, FCM, Hangfire
  WebAPI            → REST Controllers, JWT Auth, Swagger
```

---

## 📅 Roadmap — 3 Phase

```
PHASE A — DATABASE (Đang làm)
  └── Thiết kế ERD 21 bảng → Migration SQL → Seed Data → Docker

PHASE B — BACKEND API (Tiếp theo)
  └── Domain → Infrastructure → Application → WebAPI → Testing

PHASE C — FRONTEND (Sau cùng)
  └── Web Admin (Next.js) → Mobile Agency (React Native) → Mobile Supplier
```

**Chi tiết từng Phase:** Xem file tương ứng trong thư mục này.

---

## 📊 Tiến Độ Hiện Tại

Xem file → [PROGRESS.md](./PROGRESS.md)

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
d:\Đồ Án\
├── docs/                           # Tài liệu đặc tả (đã hoàn thành)
│   ├── specs/                      # 4 tài liệu gốc (Vision, SRS, Logic, Q&A)
│   ├── software_architecture/      # Kiến trúc phần mềm (Clean Arch, CQRS, ERD)
│   ├── hardware_architecture/      # Kiến trúc phần cứng (Deploy, Docker, Cloud)
│   ├── actors_and_usecases/        # Actors, Use Cases, Phase 1 & 2
│   ├── database/                   # ERD, Data Dictionary (Phase A output)
│   └── implementation_plan.md      # Kế hoạch tổng (3 Phase)
│
├── roadmap/                        # 📍 BẠN ĐANG Ở ĐÂY
│   ├── README.md                   # File này — điểm bắt đầu
│   ├── PROGRESS.md                 # Tiến độ chi tiết từng task
│   ├── PHASE_A_DATABASE.md         # Kế hoạch Phase A
│   ├── PHASE_B_BACKEND.md          # Kế hoạch Phase B
│   └── PHASE_C_FRONTEND.md         # Kế hoạch Phase C
│
├── db/                             # Database scripts
│   ├── migrations/                 # SQL migration files (V001..V025)
│   ├── seeds/                      # Demo data
│   └── docker-compose.yml          # PostgreSQL local
│
├── src/                            # Source code (Phase B+C)
│   ├── B2BTravelPlatform.Domain/
│   ├── B2BTravelPlatform.Application/
│   ├── B2BTravelPlatform.Infrastructure/
│   └── B2BTravelPlatform.WebApi/
│
├── tests/                          # Test projects
├── .env                            # Secrets (KHÔNG commit Git)
├── .gitignore
├── docker-compose.yml              # Full system compose
└── Dockerfile
```

---

## 🔗 File Quan Trọng Cần Đọc

| Thứ tự | File | Nội dung |
| :---: | :--- | :--- |
| 1 | `roadmap/README.md` | File này — tổng quan dự án |
| 2 | `roadmap/PROGRESS.md` | Dự án đang làm tới đâu |
| 3 | `docs/implementation_plan.md` | Kế hoạch tổng 3 Phase |
| 4 | `docs/specs/` | 4 tài liệu đặc tả gốc |
| 5 | `docs/software_architecture/` | Kiến trúc phần mềm chi tiết |
