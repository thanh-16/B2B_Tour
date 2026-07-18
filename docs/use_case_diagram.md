# 📊 Use Case Diagram — B2B Travel Platform

> Sơ đồ Use Case tổng quan cho hệ thống B2B Travel Platform, dựa trên phân tích mã nguồn thực tế.

---

## Sơ đồ tổng quan

```mermaid
graph LR
    %% ──────────────────────────────────────────────────────────
    %% ĐỊNH NGHĨA ACTORS (TÁC NHÂN TỰ DO ĐỂ TỰ ĐỘNG CĂN BIÊN 2 BÊN)
    %% ──────────────────────────────────────────────────────────
    PA["🔑 Platform Admin"]
    AM["🏢 Agency Manager"]
    AS["👤 Agency Staff"]

    SA["📦 Supplier Admin"]
    EXT["🚌 External Transport"]
    SYS["⏰ System / Hangfire"]
    VNPAY["💳 VNPay Gateway"]

    %% ──────────────────────────────────────────────────────────
    %% RANH GIỚI HỆ THỐNG VỚI 3 CỘT DỌC USE CASE SONG SONG Ở GIỮA
    %% ──────────────────────────────────────────────────────────
    subgraph B2B_System["🏗 RANH GIỚI HỆ THỐNG B2B TRAVEL PLATFORM"]
        
        %% Cột 1: Xác thực, KYC & Cấu hình quản trị
        subgraph Col_Admin["🔐 Cột 1: Quản trị & KYC"]
            UC_Login["UC-01: Đăng nhập & Cấp Token"]
            UC_Register["UC-04: Đăng ký đại lý mới"]
            UC_KYC_Approve["UC-10: Phê duyệt KYC đại lý"]
            UC_KYC_Reject["UC-11: Từ chối KYC đại lý"]
            UC_Suspend["UC-12: Đình chỉ đại lý vi phạm"]
            UC_Sys_Config["UC-52: Cập nhật cấu hình toàn sàn"]
            UC_Rep_Dash["UC-47: Xem Dashboard báo cáo"]
            UC_Rep_Ledger["UC-49: Xem giao dịch Ledger"]
        end

        %% Cột 2: Nghiệp vụ Tìm kiếm, Đặt chỗ & Ví tiền
        subgraph Col_Booking["📝 Cột 2: Đặt chỗ & Ví tiền"]
            UC_Search["UC-13: Tìm kiếm dịch vụ sỉ"]
            UC_Markup_View["UC-14: Xem Markup đại lý"]
            UC_Markup_Update["UC-15: Cập nhật tỷ lệ Markup"]
            UC_Hold["UC-16: Giữ chỗ tạm thời (Hold PNR)"]
            UC_Pay["UC-17: Thanh toán đơn bằng ví"]
            UC_Wallet_View["UC-22: Xem số dư ví & Hạn mức"]
            UC_Adj_Wallet["UC-23/24: Nạp/Trừ ví thủ công"]
            UC_VNPay_Url["UC-25: Tạo link nạp VNPay"]
            UC_VNPay_IPN["UC-26: IPN Callback nạp tiền"]
        end

        %% Cột 3: Tích hợp Vận chuyển, Kho hàng & Hậu mãi
        subgraph Col_Services["📦 Cột 3: Dịch vụ & Hậu mãi"]
            UC_Inv_View["UC-27: Xem danh sách dịch vụ sỉ"]
            UC_Inv_Create["UC-28: Tạo sản phẩm dịch vụ mới"]
            UC_Inv_Update["UC-30: Cập nhật slot chỗ/giá"]
            UC_Inv_Stop["UC-31: Ngừng bán sản phẩm"]
            UC_Approve_Req["UC-19/20: Duyệt On-Request"]
            UC_Autocancel["UC-21: Tự động hủy đơn"]
            UC_Vou_Issue["UC-36: Phát hành E-Voucher / Vé"]
            UC_Vou_Sync["UC-37: Gọi API đặt chỗ sang đối tác"]
            UC_Vou_Download["UC-38: Tải vé & Tự check-in"]
            UC_Claim_Create["UC-39: Tạo khiếu nại hoàn/hủy"]
            UC_Claim_Resolve["UC-42/43: Duyệt/Từ chối khiếu nại"]
            UC_Noti_View["UC-44: Xem danh sách thông báo"]
            UC_Noti_Read["UC-45/46: Đánh dấu đã đọc"]
        end
    end

    %% ──────────────────────────────────────────────────────────
    %% ĐƯỜNG KẾT NỐI (RELATIONSHIPS)
    %% ──────────────────────────────────────────────────────────

    %% 1. Tác nhân nội bộ (Đặt ở lề bên trái sơ đồ)
    PA --> UC_KYC_Approve
    PA --> UC_KYC_Reject
    PA --> UC_Suspend
    PA --> UC_View_Book
    PA --> UC_Adj_Wallet
    PA --> UC_Inv_View
    PA --> UC_Vou_Issue
    PA --> UC_Claim_Resolve
    PA --> UC_Rep_Dash
    PA --> UC_Rep_Ledger
    PA --> UC_Sys_Config
    PA --> UC_Login
    PA --> UC_Noti_View
    PA --> UC_Noti_Read

    AM --> UC_Register
    AM --> UC_Markup_Update
    AM --> UC_Search
    AM --> UC_Markup_View
    AM --> UC_Hold
    AM --> UC_Pay
    AM --> UC_Wallet_View
    AM --> UC_VNPay_Url
    AM --> UC_Vou_Download
    AM --> UC_Claim_Create
    AM --> UC_Login
    AM --> UC_Noti_View
    AM --> UC_Noti_Read

    AS --> UC_Search
    AS --> UC_Markup_View
    AS --> UC_Hold
    AS --> UC_Pay
    AS --> UC_Wallet_View
    AS --> UC_VNPay_Url
    AS --> UC_Vou_Download
    AS --> UC_Claim_Create
    AS --> UC_Login
    AS --> UC_Noti_View
    AS --> UC_Noti_Read

    %% 2. Tác nhân ngoài & Hệ thống (Đặt ở lề bên phải sơ đồ)
    SA --> UC_Inv_View
    SA --> UC_Inv_Create
    SA --> UC_Inv_Update
    SA --> UC_Inv_Stop
    SA --> UC_Approve_Req
    SA --> UC_Login
    SA --> UC_Noti_View
    SA --> UC_Noti_Read

    SYS --> UC_Autocancel
    SYS --> UC_Vou_Sync

    VNPAY --> UC_VNPay_IPN

    EXT --> UC_Vou_Sync
    EXT --> UC_Vou_Download
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
