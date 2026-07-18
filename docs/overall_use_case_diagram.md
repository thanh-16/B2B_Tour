# 📊 Sơ Đồ Use Case Tổng Quan Toàn Hệ Thống (Overall Use Case Diagram)

> Tài liệu này chứa sơ đồ Use Case tổng quan và bao quát toàn bộ 12 phân hệ chức năng của dự án B2B Travel Platform, thể hiện đầy đủ mối liên kết giữa các Actor nội bộ/ngoại vi với tất cả các Use Case cốt lõi.

---

## 1. Sơ Đồ Use Case Tổng Quan Toàn Diện (Mermaid)

Sơ đồ sử dụng mô hình luồng từ trái qua phải (Left-to-Right), bố trí các Actor chính ở hai bên biên để tránh giao cắt đường nối, giúp sơ đồ bao quát nhưng vẫn cực kỳ rõ ràng và dễ đọc.

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
    %% RANH GIỚI HỆ THỐNG & CÁC USE CASE (KHÔNG SUBGRAPH CON ĐỂ GIẢM CHÉO DÂY)
    %% ──────────────────────────────────────────────────────────
    subgraph B2B_System["🏗 RANH GIỚI HỆ THỐNG B2B TRAVEL PLATFORM"]
        %% 1. Xác thực & KYC đại lý
        UC_Login["UC-01: Đăng nhập & Cấp Token"]
        UC_Register["UC-04: Đăng ký đại lý mới"]
        UC_KYC_Approve["UC-10: Phê duyệt KYC đại lý"]
        UC_KYC_Reject["UC-11: Từ chối KYC đại lý"]
        UC_Suspend["UC-12: Đình chỉ đại lý vi phạm"]

        %% 2. Tìm kiếm & Cấu hình Markup
        UC_Search["UC-13: Tìm kiếm dịch vụ sỉ"]
        UC_Markup_View["UC-14: Xem Markup đại lý"]
        UC_Markup_Update["UC-15: Cập nhật tỷ lệ Markup"]

        %% 3. Đặt chỗ (Booking Engine)
        UC_Hold["UC-16: Giữ chỗ tạm thời (Hold PNR)"]
        UC_Pay["UC-17: Thanh toán đơn bằng ví (Pay)"]
        UC_View_Book["UC-18: Xem tất cả đơn đặt chỗ"]
        UC_Approve_Req["UC-19/20: Duyệt/Từ chối đơn On-Request"]
        UC_Autocancel["UC-21: Tự động hủy đơn HELD quá hạn"]

        %% 4. Ví tài chính & Thanh toán
        UC_Wallet_View["UC-22: Xem số dư ví & Hạn mức"]
        UC_Adj_Wallet["UC-23/24: Nạp/Trừ số dư ví thủ công"]
        UC_VNPay_Url["UC-25: Tạo link nạp ví VNPay"]
        UC_VNPay_IPN["UC-26: Xử lý IPN Callback nạp tiền"]

        %% 5. Quản lý Kho dịch vụ
        UC_Inv_View["UC-27: Xem danh sách dịch vụ sỉ"]
        UC_Inv_Create["UC-28: Tạo sản phẩm dịch vụ mới"]
        UC_Inv_Update["UC-30: Cập nhật slot chỗ trống/giá"]
        UC_Inv_Stop["UC-31: Ngừng bán sản phẩm dịch vụ"]

        %% 6. Voucher & Tích hợp vận chuyển đối tác
        UC_Vou_Issue["UC-36: Phát hành E-Voucher / Vé"]
        UC_Vou_Sync["UC-37: Gọi API đặt chỗ sang đối tác"]
        UC_Vou_Download["UC-38: Tải vé & Tự check-in"]

        %% 7. Khiếu nại (Claims)
        UC_Claim_Create["UC-39: Tạo yêu cầu khiếu nại hoàn/hủy"]
        UC_Claim_Resolve["UC-42/43: Duyệt/Từ chối khiếu nại"]

        %% 8. Báo cáo & Cấu hình sàn
        UC_Rep_Dash["UC-47: Xem Dashboard báo cáo doanh thu"]
        UC_Rep_Ledger["UC-49: Xem lịch sử giao dịch Ledger"]
        UC_Sys_Config["UC-52: Cập nhật cấu hình toàn sàn"]

        %% 9. Hệ thống Thông báo
        UC_Noti_View["UC-44: Xem danh sách thông báo"]
        UC_Noti_Read["UC-45/46: Đánh dấu thông báo đã đọc"]
    end

    %% ──────────────────────────────────────────────────────────
    %% ĐƯỜNG KẾT NỐI (RELATIONSHIPS)
    %% ──────────────────────────────────────────────────────────

    %% 1. Tác nhân nội bộ (Đặt ở bên trái sơ đồ)
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

    %% 2. Tác nhân ngoài & Hệ thống (Đặt ở bên phải sơ đồ)
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

## 2. Ý Nghĩa Của Sơ Đồ Đối Với Hội Đồng Phản Biện

1.  **Tính Rõ Ràng (Clarity):** Sơ đồ tách biệt rõ ràng khu vực của người dùng nghiệp vụ (bên trái) và các đối tác công nghệ, hệ thống tự động (bên phải), giúp hội đồng dễ dàng nhận biết ai làm việc gì.
2.  **Tính Khép Kín (End-to-End):** Thể hiện trọn vẹn luồng từ khi đại lý đăng ký (`UC-04`), tìm kiếm và cấu hình giá (`UC-13`, `UC-15`), thực hiện đặt chỗ thanh toán (`UC-16`, `UC-17`), nạp ví tự động (`UC-26`), đẩy đơn sang nhà xe đối tác (`UC-37`), cho tới khi xuất hóa đơn báo cáo (`UC-47`).
3.  **Tích Hợp API Chặt Chẽ:** Làm nổi bật vai trò của **VNPay** và **External Transport** trong việc nhận đồng bộ đơn hàng tự động mà không cần vận hành thủ công.
