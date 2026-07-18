# 📊 Use Case Diagram — B2B Travel Platform

> Sơ đồ Use Case tổng quan cho hệ thống B2B Travel Platform, dựa trên phân tích mã nguồn thực tế.

---

## Sơ đồ tổng quan

```mermaid
graph LR
    %% Định nghĩa phong cách (styles) cho các Actors để làm nổi bật sơ đồ
    classDef actorStyle fill:#f9f,stroke:#333,stroke-width:2px;
    classDef systemStyle fill:#bbf,stroke:#333,stroke-width:2px;
    
    %% Actors bên trái (Con người hệ thống)
    subgraph LeftActors["👥 Tác nhân nội bộ"]
        PA["🔑 Platform Admin"]
        AM["🏢 Agency Manager"]
        AS["👤 Agency Staff"]
    end

    %% Actors bên phải (Hệ thống & Đối tác ngoài)
    subgraph RightActors["⚙️ Hệ thống & Đối tác ngoài"]
        SA["📦 Supplier Admin"]
        EXT["🚌 External Transport"]
        SYS["⏰ System / Hangfire"]
        VNPAY["💳 VNPay Gateway"]
    end

    %% Nhóm Use Case Auth & KYC
    subgraph Module_Auth["🔐 Auth & KYC"]
        UC04["UC-04: Đăng ký Đại lý"]
        UC05["UC-05: Duyệt KYC"]
        UC12["UC-12: Đình chỉ Đại lý"]
    end

    %% Nhóm Use Case Tìm kiếm & Markup
    subgraph Module_Search["🔍 Search & Pricing"]
        UC13["UC-13: Tìm dịch vụ"]
        UC15["UC-15: Cập nhật Markup"]
    end

    %% Nhóm Use Case Đặt chỗ (Booking)
    subgraph Module_Booking["📝 Booking Engine"]
        UC16["UC-16: Giữ chỗ (Hold PNR)"]
        UC17["UC-17: Thanh toán ví (Pay)"]
        UC19["UC-19/20: Duyệt/Từ chối On-Request"]
        UC21["UC-21: Auto-cancel đơn quá hạn"]
    end

    %% Nhóm Use Case Ví & Thanh toán
    subgraph Module_Wallet["💰 Wallet & Payment"]
        UC23["UC-23/24: Nạp/Trừ ví thủ công"]
        UC25["UC-25: Tạo link nạp VNPay"]
        UC26["UC-26: IPN Callback nạp ví"]
    end

    %% Nhóm Use Case Voucher & Vận chuyển
    subgraph Module_Voucher["🎫 Voucher & Tích hợp"]
        UC36["UC-36: Phát hành E-Voucher"]
        UC37["UC-37: Gửi đặt chỗ sang đối tác"]
        UC38["UC-38: Tải vé & Tự check-in"]
    end

    %% Nhóm Use Case Khiếu nại
    subgraph Module_Claims["📢 After-Sales & Claims"]
        UC39["UC-39: Tạo khiếu nại"]
        UC42["UC-42: Duyệt khiếu nại"]
    end

    %% Kết nối phía Tác nhân nội bộ (Trái)
    AM --> UC04
    PA --> UC05
    PA --> UC12

    AS --> UC13
    AM --> UC13
    AM --> UC15

    AS --> UC16
    AM --> UC16
    AS --> UC17
    AM --> UC17

    PA --> UC23
    AS --> UC25
    AM --> UC25

    PA --> UC36
    AS --> UC38
    AM --> UC38

    AS --> UC39
    AM --> UC39
    PA --> UC42

    %% Kết nối phía Hệ thống & Đối tác ngoài (Phải)
    SA --> UC19
    SA --> UC37
    SYS --> UC21
    SYS --> UC37
    VNPAY --> UC26
    EXT --> UC37
    EXT --> UC38
```

---

## 1. Module: Xác thực & Quản lý người dùng (Auth)

```mermaid
graph LR
    subgraph UC_Auth["🔐 Xác thực & Quản lý người dùng"]
        UC1["UC-01: Đăng nhập hệ thống"]
        UC2["UC-02: Refresh Token"]
        UC3["UC-03: Thu hồi Token"]
        UC4["UC-04: Đăng ký Đại lý mới"]
        UC5["UC-05: Duyệt KYC Đại lý"]
    end

    PA["🔑 Platform Admin"] --> UC5
    AM["🏢 Agency Manager"] --> UC4

    ALL["👥 Mọi Actor"] --> UC1
    ALL --> UC2
    ALL --> UC3
```

| Use Case | Actor chính | Mô tả |
|----------|------------|-------|
| UC-01 | Tất cả | Đăng nhập bằng username/password, nhận JWT Token |
| UC-02 | Tất cả | Gia hạn access token bằng refresh token |
| UC-03 | Tất cả | Thu hồi refresh token (đăng xuất) |
| UC-04 | Agency Manager | Đăng ký đại lý mới vào hệ thống (chờ KYC) |
| UC-05 | Platform Admin | Duyệt / Từ chối KYC của đại lý |

---

## 2. Module: KYC & Quản lý Đại lý (KYC)

```mermaid
graph LR
    subgraph UC_KYC["📋 KYC & Quản lý Đại lý"]
        UC7["UC-07: Xem danh sách Đại lý"]
        UC8["UC-08: Xem Đại lý chờ KYC"]
        UC9["UC-09: Xem chi tiết Đại lý"]
        UC10["UC-10: Duyệt KYC"]
        UC11["UC-11: Từ chối KYC"]
        UC12["UC-12: Đình chỉ Đại lý"]
    end

    PA["🔑 Platform Admin"] --> UC7
    PA --> UC8
    PA --> UC9
    PA --> UC10
    PA --> UC11
    PA --> UC12
```

| Use Case | Mô tả |
|----------|-------|
| UC-07 | Xem toàn bộ đại lý trên hệ thống |
| UC-08 | Lọc đại lý đang chờ xét duyệt KYC (phân trang) |
| UC-09 | Xem chi tiết thông tin 1 đại lý cụ thể |
| UC-10 | Phê duyệt KYC → đại lý được phép giao dịch |
| UC-11 | Từ chối KYC → đại lý phải bổ sung hồ sơ |
| UC-12 | Đình chỉ hoạt động đại lý vi phạm |

---

## 3. Module: Tìm kiếm & Markup (Search)

```mermaid
graph LR
    subgraph UC_Search["🔍 Tìm kiếm & Cấu hình Markup"]
        UC13["UC-13: Tìm kiếm dịch vụ"]
        UC14["UC-14: Xem cấu hình Markup"]
        UC15["UC-15: Cập nhật Markup"]
    end

    AS["👤 Agency Staff"] --> UC13
    AS --> UC14
    AM["🏢 Agency Manager"] --> UC13
    AM --> UC14
    AM --> UC15
```

| Use Case | Actor | Mô tả |
|----------|-------|-------|
| UC-13 | Agency Staff/Manager | Tìm kiếm dịch vụ du lịch (khách sạn, tour, vé, v.v.) |
| UC-14 | Agency Staff/Manager | Xem cấu hình markup (phí dịch vụ) hiện tại |
| UC-15 | Agency Manager | Cập nhật tỷ lệ markup cho đại lý |

---

## 4. Module: Đặt chỗ (Booking)

```mermaid
graph LR
    subgraph UC_Booking["📝 Đặt chỗ"]
        UC16["UC-16: Giữ chỗ (Hold)"]
        UC17["UC-17: Thanh toán đặt chỗ (Pay)"]
        UC18["UC-18: Xem tất cả đơn đặt chỗ"]
        UC19["UC-19: Duyệt đơn đặt chỗ"]
        UC20["UC-20: Từ chối đơn đặt chỗ"]
        UC21["UC-21: Auto-cancel đơn quá hạn"]
    end

    AS["👤 Agency Staff"] --> UC16
    AS --> UC17
    AM["🏢 Agency Manager"] --> UC16
    AM --> UC17
    PA["🔑 Platform Admin"] --> UC18
    SA["📦 Supplier Admin"] --> UC19
    SA --> UC20
    SYS["⏰ Hangfire"] --> UC21

    UC17 -.-> |"«include»"| UC_PAY["Trừ ví Đại lý"]
    UC16 -.-> |"«include»"| UC_SLOT["Giảm Slot tồn kho"]
```

| Use Case | Actor | Mô tả |
|----------|-------|-------|
| UC-16 | Agency Staff/Manager | Giữ chỗ (HELD) — lock slot, reserve balance |
| UC-17 | Agency Staff/Manager | Xác nhận thanh toán → trừ ví đại lý |
| UC-18 | Platform Admin | Xem toàn bộ đơn trên hệ thống |
| UC-19 | Supplier Admin | Duyệt đơn đặt chỗ cần xác nhận |
| UC-20 | Supplier Admin | Từ chối đơn → hoàn tiền cho đại lý |
| UC-21 | System (Hangfire) | Tự động hủy đơn HELD quá thời hạn |

---

## 5. Module: Ví tài chính (Wallet)

```mermaid
graph LR
    subgraph UC_Wallet["💰 Ví tài chính"]
        UC22["UC-22: Xem số dư ví"]
        UC23["UC-23: Nạp tiền vào ví (Credit)"]
        UC24["UC-24: Trừ tiền ví (Debit)"]
    end

    AS["👤 Agency Staff"] --> UC22
    AM["🏢 Agency Manager"] --> UC22
    PA["🔑 Platform Admin"] --> UC23
    PA --> UC24

    UC23 -.-> |"«include»"| LEDGER["Tạo WalletLedger entry"]
    UC24 -.-> |"«include»"| LEDGER
```

| Use Case | Actor | Mô tả |
|----------|-------|-------|
| UC-22 | Agency Staff/Manager | Xem số dư khả dụng, hạn mức tín dụng |
| UC-23 | Platform Admin | Nạp tiền vào ví đại lý (phê duyệt nạp tiền) |
| UC-24 | Platform Admin | Trừ tiền ví đại lý (điều chỉnh thủ công) |

---

## 6. Module: Thanh toán (Payment — VNPay)

```mermaid
graph LR
    subgraph UC_Payment["💳 Thanh toán VNPay"]
        UC25["UC-25: Tạo URL thanh toán VNPay"]
        UC26["UC-26: Xử lý IPN Callback"]
    end

    AS["👤 Agency Staff"] --> UC25
    AM["🏢 Agency Manager"] --> UC25
    VNPAY["💳 VNPay Gateway"] --> UC26

    UC26 -.-> |"«include»"| CREDIT["Nạp ví Đại lý"]
```

---

## 7. Module: Kho dịch vụ (Inventory)

```mermaid
graph LR
    subgraph UC_Inventory["📦 Kho dịch vụ"]
        UC27["UC-27: Xem danh sách dịch vụ"]
        UC28["UC-28: Tạo dịch vụ mới"]
        UC29["UC-29: Xem slot theo dịch vụ"]
        UC30["UC-30: Cập nhật slot"]
        UC31["UC-31: Ngừng bán dịch vụ"]
    end

    PA["🔑 Platform Admin"] --> UC27
    PA --> UC28
    PA --> UC29
    PA --> UC30
    PA --> UC31
    SA["📦 Supplier Admin"] --> UC27
    SA --> UC28
    SA --> UC29
    SA --> UC30
    SA --> UC31
```

| Use Case | Mô tả |
|----------|-------|
| UC-27 | Xem danh sách dịch vụ của nhà cung cấp |
| UC-28 | Tạo dịch vụ du lịch mới (tour, khách sạn, vé...) |
| UC-29 | Xem slot/tồn kho theo khoảng thời gian |
| UC-30 | Cập nhật số lượng, giá slot |
| UC-31 | Dừng bán 1 dịch vụ |

---

## 8. Module: Nhà cung cấp (Supplier)

```mermaid
graph LR
    subgraph UC_Supplier["🏭 Quản lý Nhà cung cấp"]
        UC32["UC-32: Xem Dashboard NCC"]
        UC33["UC-33: Xem đơn chờ duyệt"]
        UC34["UC-34: Duyệt đơn đặt chỗ"]
        UC35["UC-35: Từ chối đơn đặt chỗ"]
    end

    SA["📦 Supplier Admin"] --> UC32
    SA --> UC33
    SA --> UC34
    SA --> UC35
```

---

## 9. Module: Voucher & Tích hợp vận chuyển

```mermaid
graph LR
    subgraph UC_Voucher["🎫 Voucher & Tích hợp vận chuyển"]
        UC36["UC-36: Phát hành E-Voucher / Vé điện tử"]
        UC37["UC-37: Gửi thông tin đặt vé sang Nhà xe/Hãng bay"]
        UC38["UC-38: Tải E-Voucher / Vé điện tử"]
    end

    PA["🔑 Platform Admin"] --> UC36
    SYS["⏰ System / Hangfire"] --> UC37
    AS["👤 Agency Staff"] --> UC38
    AM["🏢 Agency Manager"] --> UC38
```

| Use Case | Actor | Mô tả |
|----------|-------|-------|
| UC-36 | Platform Admin | Phát hành E-Voucher / Vé điện tử sau khi đơn hàng được thanh toán |
| UC-37 | System / Hangfire | Gọi API đồng bộ thông tin đặt chỗ với Nhà xe (vd: Phương Trang) hoặc Hãng bay |
| UC-38 | Agency Staff/Manager | Tải E-Voucher / Vé điện tử để gửi cho khách hàng tự check-in |

---

## 10. Module: Khiếu nại (Claim)

```mermaid
graph LR
    subgraph UC_Claim["📢 Khiếu nại"]
        UC39["UC-39: Tạo khiếu nại"]
        UC40["UC-40: Xem chi tiết khiếu nại"]
        UC41["UC-41: Xem danh sách khiếu nại"]
        UC42["UC-42: Duyệt khiếu nại"]
        UC43["UC-43: Từ chối khiếu nại"]
    end

    AS["👤 Agency Staff"] --> UC39
    AS --> UC40
    AS --> UC41
    AM["🏢 Agency Manager"] --> UC39
    AM --> UC40
    AM --> UC41
    PA["🔑 Platform Admin"] --> UC42
    PA --> UC43
```

---

## 11. Module: Thông báo (Notification)

```mermaid
graph LR
    subgraph UC_Notify["🔔 Thông báo"]
        UC44["UC-44: Xem thông báo"]
        UC45["UC-45: Đánh dấu đã đọc"]
        UC46["UC-46: Đánh dấu tất cả đã đọc"]
    end

    ALL["Tất cả User đã đăng nhập"] --> UC44
    ALL --> UC45
    ALL --> UC46
```

---

## 12. Module: Báo cáo & Cấu hình hệ thống

```mermaid
graph LR
    subgraph UC_Report["📊 Báo cáo & Cấu hình"]
        UC47["UC-47: Xem Dashboard tổng quan"]
        UC48["UC-48: Xem báo cáo doanh thu"]
        UC49["UC-49: Xem giao dịch ví"]
        UC50["UC-50: Xuất báo cáo giao dịch"]
        UC51["UC-51: Xem cấu hình hệ thống"]
        UC52["UC-52: Cập nhật cấu hình hệ thống"]
    end

    PA["🔑 Platform Admin"] --> UC47
    PA --> UC48
    PA --> UC49
    PA --> UC50
    PA --> UC51
    PA --> UC52
```

---

## 🎯 Ma trận Actor × Use Case tổng hợp

| Module | Platform Admin | Agency Manager | Agency Staff | Supplier Admin | External Transport | System |
|--------|:---:|:---:|:---:|:---:|:---:|:---:|
| Auth (Đăng nhập/Token) | ✅ | ✅ | ✅ | ✅ | — | — |
| KYC (Quản lý đại lý) | ✅ | — | — | — | — | — |
| Search (Tìm kiếm) | — | ✅ | ✅ | — | — | — |
| Booking (Đặt chỗ) | ✅ (xem all) | ✅ (hold/pay) | ✅ (hold/pay) | ✅ (duyệt/từ chối) | — | ✅ (auto-cancel) |
| Wallet (Ví) | ✅ (credit/debit) | ✅ (xem) | ✅ (xem) | — | — | — |
| Payment (VNPay) | — | ✅ | ✅ | — | — | ✅ (IPN) |
| Inventory (Kho) | ✅ | — | — | ✅ | — | — |
| Voucher & Vận chuyển | ✅ (phát hành) | ✅ (tải về) | ✅ (tải về) | — | 🚌 (nhận API) | ✅ (đồng bộ) |
| Claim (Khiếu nại) | ✅ (duyệt) | ✅ (tạo) | ✅ (tạo) | — | — | — |
| Report (Báo cáo) | ✅ | — | — | — | — | — |
| Config (Hệ thống) | ✅ | — | — | — | — | — |
| Notification | ✅ | ✅ | ✅ | ✅ | — | — |

---

## 📌 Ghi chú

- **Đường nét liền (→)**: Actor trực tiếp sử dụng Use Case
- **Đường nét đứt (`«include»`)**: Use Case bao gồm use case phụ
- **System / Hangfire**: Các tác vụ tự động chạy nền (auto-cancel đơn quá hạn, đồng bộ đặt vé đối tác, v.v.)
- **VNPay Gateway**: Actor ngoài hệ thống — gọi IPN callback khi thanh toán hoàn tất
- **External Transport**: Đối tác vận chuyển ngoại vi (Nhà xe như Phương Trang, Hãng máy bay) kết nối qua API tích hợp. Khách hàng tự chủ động di chuyển đến bến xe/sân bay và check-in với đối tác bằng E-Voucher/Vé điện tử. SYSTEM tự động gọi API đồng bộ thông tin đặt chỗ sau khi thanh toán.
