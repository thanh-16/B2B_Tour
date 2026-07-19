# 📊 Sơ Đồ Use Case Tóm Tắt (Phase 1 MVP Summary)

> Tài liệu này cung cấp một góc nhìn tổng quan, ngắn gọn về các nghiệp vụ cốt lộ của hệ thống B2B Travel Platform trong Giai đoạn 1 (MVP). Các Use Case chi tiết đã được nhóm gộp lại thành các Use Case tổng quát để phục vụ việc thuyết trình và báo cáo nhanh trước hội đồng.

---

## 🗺️ 1. Sơ Đồ Use Case Tổng Quát (Phase 1 MVP)

Sơ đồ sử dụng mô hình phát triển từ trên xuống dưới (**Top-to-Bottom**) và chia thành 5 nhóm cột nghiệp vụ lớn để dễ dàng quan sát luồng vận hành chính.

```mermaid
graph TB
    %% ──────────────────────────────────────
    %% ACTORS
    %% ──────────────────────────────────────
    subgraph Actors["👤 Người dùng (Actors)"]
        direction LR
        PA["🔑 Platform Admin"]
        AM["🏢 Agency Manager"]
        AS["👤 Agency Staff"]
        SA["📦 Supplier Admin"]
    end

    %% ──────────────────────────────────────
    %% SYSTEM BOUNDARY
    %% ──────────────────────────────────────
    subgraph B2B_Platform["🏗️ Hệ thống B2B Travel Platform (MVP)"]
        direction TB

        %% Nhóm 1: Tài khoản & KYC
        subgraph Group1["🔑 Quản lý Tài khoản & KYC"]
            UC_G01["UC-G01: Quản lý tài khoản<br>(Đăng nhập, Đăng ký, Đổi mật khẩu)"]
            UC_G02["UC-G02: Phê duyệt hồ sơ KYC"]
        end

        %% Nhóm 2: Tìm kiếm & Đề xuất AI
        subgraph Group2["🔍 Tìm kiếm & Báo giá AI"]
            UC_G03["UC-G03: Tìm kiếm dịch vụ & Markup"]
            UC_G04["UC-G04: Xuất báo giá lẻ (Quotation)"]
            UC_G05["UC-G05: Trợ lý AI tư vấn & Đề xuất combo"]
        end

        %% Nhóm 3: Giỏ hàng & Booking Engine
        subgraph Group3["🛒 Giỏ hàng & Đặt chỗ (Saga)"]
            UC_G06["UC-G06: Quản lý giỏ hàng combo"]
            UC_G07["UC-G07: Giữ chỗ & Thanh toán gộp 1 chạm"]
            UC_G08["UC-G08: Duyệt đơn On-Request"]
            UC_G09["UC-G09: Hủy đơn (Chủ động/Tự động)"]
        end

        %% Nhóm 4: Bàn giao & Check-in
        subgraph Group4["🎟️ Bàn giao & Check-in"]
            UC_G10["UC-G10: Phát hành & Tải E-Voucher"]
            UC_G11["UC-G11: Xác nhận đón khách (Check-in)<br>(Quét QR / Đối chiếu thông tin)"]
        end

        %% Nhóm 5: Ví tài chính
        subgraph Group5["💰 Ví tài chính & Payment"]
            UC_G12["UC-G12: Quản lý số dư & Lịch sử ví"]
            UC_G13["UC-G13: Nạp tiền ví qua VNPay"]
        end
    end

    %% ──────────────────────────────────────
    %% SYSTEM ACTORS
    %% ──────────────────────────────────────
    subgraph SystemActors["⚙️ Đối tác ngoại (System)"]
        direction LR
        SYS["⏰ System / Hangfire"]
        VNPAY["💳 VNPay Gateway"]
        EXT["🚌 Đối tác API xe/bay"]
    end

    %% ──────────────────────────────────────
    %% LIÊN KẾT (CONNECTIONS)
    %% ──────────────────────────────────────
    PA --> UC_G02 & UC_G12
    AM --> UC_G01 & UC_G03 & UC_G04 & UC_G05 & UC_G06 & UC_G07 & UC_G09 & UC_G10 & UC_G12
    AS --> UC_G01 & UC_G03 & UC_G04 & UC_G05 & UC_G06 & UC_G07 & UC_G09 & UC_G10 & UC_G12
    SA --> UC_G01 & UC_G08 & UC_G11

    %% Liên kết hệ thống ngoài
    SYS -.-> UC_G09 & UC_G10
    VNPAY -.-> UC_G13
    EXT -.-> UC_G10
```

---

## 📝 2. Bảng Mô Tả Nghiệp Vụ Tóm Tắt

| Mã Use Case | Tên Use Case Tóm Tắt | Actor Chính | Nội dung nghiệp vụ cốt lõi |
| :--- | :--- | :--- | :--- |
| **UC-G01** | Quản lý tài khoản | Đại lý, NCC, Admin | Quản lý đăng ký mới, đăng nhập cấp JWT, và thay đổi mật khẩu/hồ sơ của tất cả nhân sự. |
| **UC-G02** | Phê duyệt hồ sơ KYC | Platform Admin | Thẩm định và duyệt/từ chối hồ sơ pháp lý của Đại lý mới đăng ký để mở khóa quyền giao dịch. |
| **UC-G03** | Tìm kiếm & Markup | Agency Manager/Staff | Tìm kiếm kho phòng khách sạn, vé xe, tour. Manager tự cấu hình % markup (lợi nhuận đại lý) cộng vào giá gốc. |
| **UC-G04** | Xuất báo giá lẻ | Agency Manager/Staff | Trích xuất thông tin hành trình và giá bán lẻ đã cộng Markup thành file PDF/Excel gửi trực tiếp cho khách lẻ. |
| **UC-G05** | Trợ lý AI tư vấn | Agency Manager/Staff | Nhập yêu cầu bằng ngôn ngữ tự nhiên, AI phân tích dữ liệu kho sỉ để đề xuất combo tối ưu kèm liên kết giữ chỗ nhanh. |
| **UC-G06** | Quản lý giỏ hàng | Agency Manager/Staff | Cho phép thêm/bớt nhiều dịch vụ du lịch (tour, phòng, xe) vào một giỏ hàng trước khi tiến hành giữ chỗ đồng thời. |
| **UC-G07** | Giữ chỗ & Thanh toán gộp | Agency Manager/Staff | **Saga Pattern:** Giữ chỗ đồng thời toàn bộ dịch vụ trong giỏ hàng (khóa kho 15p) và thanh toán gộp 1 lần từ ví đại lý. |
| **UC-G08** | Duyệt đơn On-Request | Supplier Admin | Phê duyệt thủ công các yêu cầu đặt chỗ đối với các dịch vụ không khóa slot tự động (cần NCC check phòng/xe thực tế). |
| **UC-G09** | Hủy đơn đặt chỗ | Đại lý, Hangfire | Đại lý chủ động hủy đơn giữ chỗ để giải phóng kho, hoặc hệ thống tự động hủy và hoàn kho sau 15 phút nếu chưa thanh toán. |
| **UC-G10** | Phát hành E-Voucher | Đại lý, Hệ thống | Sinh mã QR và file PDF E-Voucher cho dịch vụ nội bộ, hoặc gọi API đối tác bên thứ ba xuất vé thật (Bus/Flight E-Ticket). |
| **UC-G11** | Xác nhận đón (Check-in) | Supplier Admin, Đại lý | **Check-in phân loại:**<br>- *Tour/Khách sạn:* Supplier quét QR Voucher trên điện thoại khách.<br>- *Nhà xe đối tác:* Tài xế đối chiếu thông tin hành khách (CCCD/Tên).<br>- *Hãng bay:* Khách tự check-in trực tiếp tại sân bay bằng vé điện tử nhận được. |
| **UC-G12** | Quản lý ví tài chính | Agency Manager/Staff | Xem số dư ví tiền mặt, hạn mức tín dụng công nợ tạm ứng, và truy vấn lịch sử giao dịch (sổ cái ledger không thể sửa đổi). |
| **UC-G13** | Nạp tiền ví qua VNPay | Agency Manager, VNPay | Sinh link thanh toán online qua VNPay, tự động cập nhật số dư ví đại lý ngay lập tức khi giao dịch thành công (IPN callback). |
