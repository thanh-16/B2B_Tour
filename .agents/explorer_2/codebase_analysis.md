# Codebase Architecture Analysis & GET /api/tours Blueprint

**Project Name**: B2B Travel Platform — End-to-End Booking & Delivery  
**Workspace Root**: `d:\Đồ Án`  
**Author**: Explorer 2 (`teamwork_preview_explorer`)  
**Date**: 2026-07-28  

---

## 1. Executive Summary

This codebase inspection confirms that `d:\Đồ Án` is a comprehensive **B2B Travel Platform** project entering its Phase 1 (MVP) implementation stage. The workspace contains detailed architectural specifications, Software Requirements Specifications (SRS), domain use cases, sequence diagrams, database schemas, and CI/CD configuration files.

---

## 2. Directory Tree & Key Project Artifacts

```text
d:\Đồ Án\
├── .agents/                                # Agent metadata & working logs
│   ├── explorer_1/                         # Explorer 1 logs & analysis
│   ├── explorer_2/                         # Explorer 2 logs & analysis (Self)
│   ├── orchestrator/                       # Orchestrator plan & PROJECT.md
│   ├── rules/                              # Workspace agent rules
│   ├── sentinel/                           # Guardrail rules
│   └── skills/                             # Local team skills
├── .github/
│   └── workflows/
│       └── ci.yml                          # GitHub Actions CI/CD workflow (.NET 8/10, Postgres 16, Redis 7)
├── db/
│   ├── init.sql/                           # SQL init scripts directory
│   ├── migration_phase0.sql/               # Database migration scripts directory
│   └── init-multiple-databases.sh/         # Docker multi-db startup script directory
├── docs/
│   ├── Kiến trúc phần cứng/                # Deployment architecture (Phase 1 MVP & Phase 2 Scale-up)
│   ├── Kiến trúc phần mềm/                 # Software architecture (Clean Architecture, CQRS, sequence diagrams)
│   │   ├── README.md                       # Core software architecture specification
│   │   ├── phase1_mvp_software.md          # MVP scope (14 modules, 55 use cases)
│   │   └── phase2_scale_up_software.md     # Future scale-up architecture
│   └── actor and usecase/                  # Use cases & Actor documentation
├── B2BTP_Capstone_Project_Register.pdf     # Capstone Project Registration
├── Tài_liệu_1_Tầm_nhìn_&_Phạm_vi_Dự_án.md # Document 1: Project Vision & Scope
├── Tài_liệu_2_Đặc_tả_Yêu_cầu_Phần_mềm_SRS.md # Document 2: Software Requirements Specification
├── Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md # Document 3: Detailed Logic & Architecture
└── Tài_liệu_4_Kịch_bản_Hỏi_đáp_Hội_đồng.md # Document 4: Q&A Council Defense Script
```

---

## 3. Technology Stack Identification

Based on `.github/workflows/ci.yml`, `docs/Kiến trúc phần mềm/README.md`, and SRS specifications, the target technology stack is structured as follows:

| Layer / Aspect | Selected Technology | Details / Version |
|---|---|---|
| **Backend Framework** | **ASP.NET Core** (with TypeScript / Next.js support for web contracts) | 8.0 LTS / 10.0 |
| **Architecture Pattern** | **Clean Architecture + CQRS** | Presentation -> Application -> Domain -> Infrastructure |
| **Database & ORM** | **PostgreSQL 16** + **Entity Framework Core 8.x** | ACID transactions, Optimistic Concurrency Control (`version` column) |
| **Caching & Locking** | **Redis 7** (StackExchange.Redis) | Distributed locks (`NX EX 30`), Idempotency Keys |
| **In-Process Bus & CQRS**| **MediatR** 12.x | Command / Query Handlers with Pipeline Behaviors |
| **Validation & Mapping**| **FluentValidation** 11.x + **AutoMapper** 13.x | Input validation pipelines & DTO mapping |
| **Frontend Applications**| **React Native** (Mobile) & **React / Next.js** (Web Admin / Extranet) | React Query v5, Axios, Tailwind CSS |
| **Testing Suite** | **xUnit** / **Vitest** / **Jest** + **WebApplicationFactory** / **Playwright** | Unit tests for Domain & Application logic, E2E integration tests |

---

## 4. Code Conventions & Standards

1. **Layer Responsibilities**:
   - **Domain**: Pure business entities (`Booking`, `Tour`, `Wallet`), value objects, domain exceptions. Zero dependencies.
   - **Application**: DTOs, Commands, Queries, MediatR Handlers, Validation rules.
   - **Infrastructure**: DbContext, Repositories, Redis Lock, External API clients.
   - **Presentation / API**: Controllers / Route handlers, OpenAPI/Swagger attributes.

2. **Standard API Envelope Contract**:
   - **Success Response**:
     ```json
     {
       "success": true,
       "data": [ ... ],
       "meta": {
         "total": 42,
         "page": 1,
         "limit": 10,
         "totalPages": 5
       }
     }
     ```
   - **Error Response**:
     ```json
     {
       "success": false,
       "error": {
         "code": "VALIDATION_ERROR",
         "message": "Invalid query parameters",
         "details": [
           { "field": "limit", "issue": "Limit must not exceed 100" }
         ]
       }
     }
     ```

3. **Naming Conventions**:
   - PascalCase for C# files/classes, camelCase for JSON properties & query parameters.
   - kebab-case for API route URLs (`/api/tours`, `/api/bookings/hold`).
   - Standardized status codes: `200 OK`, `201 Created`, `400 Bad Request`, `401 Unauthorized`, `404 Not Found`, `500 Internal Server Error`.

---

## 5. Implementation Blueprint: GET /api/tours

### 5.1 Data Model / Type Interface Schema

**File Location**:
- TypeScript Interface: `src/types/tour.ts`
- C# Entity Path: `src/B2BTravelPlatform.Domain/Entities/Tour.cs`
- C# DTO Path: `src/B2BTravelPlatform.Application/Features/Tours/DTOs/TourDto.cs`

**Schema Fields & Specifications**:
```typescript
export interface Tour {
  id: string;                // UUID v4
  title: string;             // Tour title (e.g. "Tour Khám Phá Đà Lạt 3N2Đ")
  description: string;       // Detailed description
  location: string;          // Destination location (e.g. "Đà Lạt, Lâm Đồng")
  category: string;          // Category (e.g. "Eco-Tour", "Cultural", "Beach & Sun", "Adventure")
  price: number;             // Base price in VND (decimal)
  duration: string;          // Duration tag (e.g. "3 ngày 2 đêm")
  rating: number;            // Average rating (0.0 to 5.0)
  availableSeats: number;    // Remaining seats count
  images: string[];          // Array of image URLs
  supplierId: string;        // UUID of supplier agency
  isActive: boolean;         // Soft delete / publish state flag
  createdAt: string;         // ISO 8601 UTC Timestamp
  updatedAt: string;         // ISO 8601 UTC Timestamp
}
```

---

### 5.2 API Endpoint File Path & Exact Signature

**File Locations**:
- Next.js Route Handler: `src/app/api/tours/route.ts`
- Express Controller: `src/controllers/tourController.ts` & `src/routes/tourRoutes.ts`
- ASP.NET Core Controller: `src/B2BTravelPlatform.WebApi/Controllers/ToursController.cs`
- Application Query Handler: `src/B2BTravelPlatform.Application/Features/Tours/Queries/GetToursQuery.cs`

**HTTP Request Specification**:
- **Method**: `GET`
- **Path**: `/api/tours`
- **Query Parameters**:

| Parameter | Type | Default | Required | Validation Rules |
|---|---|---|---|---|
| `search` | string | `undefined` | No | Min 1 char, trimmed, sanitized |
| `category` | string | `undefined` | No | One of valid categories |
| `page` | number | `1` | No | Integer ≥ 1 |
| `limit` | number | `10` | No | Integer between 1 and 100 |
| `minPrice` | number | `undefined` | No | Number ≥ 0 |
| `maxPrice` | number | `undefined` | No | Number ≥ minPrice |
| `sortBy` | string | `createdAt_desc` | No | Enum: `price_asc`, `price_desc`, `rating_desc`, `createdAt_desc` |

**Validation Logic (TypeScript/Zod example)**:
```typescript
import { z } from 'zod';

export const GetToursQuerySchema = z.object({
  search: z.string().optional(),
  category: z.string().optional(),
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(10),
  minPrice: z.coerce.number().min(0).optional(),
  maxPrice: z.coerce.number().min(0).optional(),
  sortBy: z.enum(['price_asc', 'price_desc', 'rating_desc', 'createdAt_desc']).default('createdAt_desc'),
}).refine(data => {
  if (data.minPrice !== undefined && data.maxPrice !== undefined) {
    return data.maxPrice >= data.minPrice;
  }
  return true;
}, {
  message: "maxPrice must be greater than or equal to minPrice",
  path: ["maxPrice"]
});
```

---

### 5.3 UI List Component Structure & Specs

**File Location**: `src/components/tours/TourList.tsx`

**Component Architecture**:
1. **Filter Header (`TourFilters.tsx`)**:
   - Search input field with debounce (300ms).
   - Category pills selection bar ("Tất cả", "Eco-Tour", "Cultural", "Adventure", "Beach & Sun").
   - Min / Max Price range inputs.
   - Sort dropdown selector.
2. **Tour Grid (`TourGrid.tsx`)**:
   - Grid layout: `grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6`.
   - Renders individual `TourCard.tsx` items:
     - Image container with ratio 16:9 and hover zoom effect.
     - Location badge tag (e.g. `📍 Đà Lạt`).
     - Category pill tag.
     - Title with line-clamp-2.
     - Rating stars (e.g. `⭐ 4.8 / 5`).
     - Duration tag (e.g. `⏱️ 3 ngày 2 đêm`).
     - Available seats badge (`🔥 Còn 12 chỗ`).
     - Formatted Price in VND (`3.500.000 ₫`).
     - Primary CTA button "Xem Chi Tiết / Đặt Tour".
3. **Pagination (`Pagination.tsx`)**:
   - Page controls with current page indicator, previous/next triggers, total item count summary.
4. **State Handling**:
   - **Loading State**: Displays 6 Animated Skeleton Cards (`TourCardSkeleton.tsx`).
   - **Empty State**: Friendly illustration with text "Không tìm thấy tour phù hợp với bộ lọc của bạn" + "Xóa bộ lọc" action button.
   - **Error State**: Error alert banner with retry button.

---

### 5.4 Unit & Integration Test Specifications

**File Location**:
- TypeScript / Vitest Test: `tests/unit/tours.test.ts`
- C# xUnit Test: `tests/B2BTravelPlatform.UnitTests/Features/Tours/GetToursQueryHandlerTests.cs`

**Test Cases Suite**:

1. `test_get_tours_default_pagination`:
   - **Given**: 15 tours exist in database.
   - **When**: `GET /api/tours` is called without query params.
   - **Then**: Returns status 200, array of 10 items, `meta.page = 1`, `meta.limit = 10`, `meta.total = 15`, `meta.totalPages = 2`.

2. `test_get_tours_search_filter`:
   - **Given**: Tours with titles "Tour Đà Lạt Hoa", "Tour Nẵng Biển", "Tour Sapa Núi".
   - **When**: `GET /api/tours?search=Đà+Lạt` is called.
   - **Then**: Returns status 200, contains only "Tour Đà Lạt Hoa".

3. `test_get_tours_price_range_filter`:
   - **Given**: Tours priced at 1.000.000 ₫, 2.500.000 ₫, and 5.000.000 ₫.
   - **When**: `GET /api/tours?minPrice=2000000&maxPrice=3000000` is called.
   - **Then**: Returns status 200, contains only the 2.500.000 ₫ tour.

4. `test_get_tours_validation_error`:
   - **When**: `GET /api/tours?page=-1&limit=500` is called.
   - **Then**: Returns status 400 Bad Request with standardized error envelope containing validation details.

5. `test_get_tours_empty_results`:
   - **When**: `GET /api/tours?search=NonExistentDestination` is called.
   - **Then**: Returns status 200, `data` is `[]`, `meta.total = 0`.

---
