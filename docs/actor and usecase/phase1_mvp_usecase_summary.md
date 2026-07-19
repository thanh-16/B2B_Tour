# 📊 Sơ Đồ Use Case Tóm Tắt (Phase 1 MVP Summary)

> **Tài liệu tối ưu hiển thị trực tiếp trên GitHub:** Thay vì gộp chung một sơ đồ lớn gây chồng chéo liên kết chằng chịt, tài liệu này chia nhỏ sơ đồ Use Case theo góc nhìn của từng nhóm đối tượng sử dụng (Actors). Điều này giúp sơ đồ hiển thị rõ nét, gọn gàng, không bị cuộn ngang trên giao diện GitHub.

---

## 🗺️ 1. Sơ Đồ Theo Góc Nhìn Từng Đối Tượng (Actor Perspectives)

### 1.1 Phân hệ Đại lý (Agency Manager & Staff)
*Phân hệ cốt lõi phục vụ đại lý thực hiện tìm kiếm dịch vụ, lên combo, giữ chỗ Saga và quản lý ví tài chính.*

```mermaid
graph LR
    %% ACTORS
    AM["🏢 Agency Manager"]
    AS["👤 Agency Staff"]
    AI_AST["🤖 AI Assistant"]

    subgraph Agency_Features["🛒 Nghiệp Vụ Cho Đại Lý (Agency)"]
        UC_G01["UC-G01: Quản lý tài khoản đại lý"]
        UC_G03["UC-G03: Tìm kiếm dịch vụ & Markup"]
        UC_G04["UC-G04: Xuất báo giá lẻ (Quotation)"]
        UC_G05["UC-G05: Trợ lý AI tư vấn & gợi ý combo"]
        UC_G06["UC-G06: Quản lý giỏ hàng combo"]
        UC_G07["UC-G07: Giữ chỗ & Thanh toán gộp (Saga)"]
        UC_G09["UC-G09: Hủy đơn giữ chỗ chủ động"]
        UC_G10["UC-G10: Tải E-Voucher / Vé điện tử"]
        UC_G12["UC-G12: Xem số dư ví & lịch sử giao dịch"]
        UC_G13["UC-G13: Nạp tiền ví qua VNPay"]
    end

    %% CONNECTIONS
    AM --> UC_G01 & UC_G03 & UC_G04 & UC_G05 & UC_G06 & UC_G07 & UC_G09 & UC_G10 & UC_G12 & UC_G13
    AS --> UC_G01 & UC_G03 & UC_G04 & UC_G05 & UC_G06 & UC_G07 & UC_G09 & UC_G10 & UC_G12
    AI_AST -.-> UC_G05
```

---

### 1.2 Phân hệ Nhà cung cấp (Supplier Admin)
*Dành cho nhà cung cấp dịch vụ du lịch (khách sạn, tour, nhà xe) quản lý kho hàng và thực hiện đón khách.*

```mermaid
graph LR
    %% ACTORS
    SA["📦 Supplier Admin"]

    subgraph Supplier_Features["📦 Nghiệp Vụ Cho Nhà Cung Cấp (Supplier)"]
        UC_S01["UC-S01: Đăng nhập & Quản lý hồ sơ NCC"]
        UC_S02["UC-S02: Xem & Quản lý kho dịch vụ"]
        UC_S03["UC-S03: Cập nhật slot chỗ & cấu hình giá sỉ"]
        UC_S04["UC-S04: Duyệt / Từ chối đơn On-Request"]
        UC_S05["UC-S05: Xác nhận đón khách (Check-in QR/CCCD)"]
    end

    %% CONNECTIONS
    SA --> UC_S01 & UC_S02 & UC_S03 & UC_S04 & UC_S05
```

---

### 1.3 Phân hệ Quản trị & Tự động hóa (Platform Admin & System)
*Phân hệ dành cho Admin vận hành sàn B2B và các tiến trình chạy ngầm tự động.*

```mermaid
graph LR
    %% ACTORS
    PA["🔑 Platform Admin"]
    SYS["⏰ System / Hangfire"]
    VNPAY["💳 VNPay Gateway"]

    subgraph Admin_Features["🛡️ Nghiệp Vụ Quản Trị & Hệ Thống"]
        UC_A01["UC-A01: Thẩm định & Phê duyệt KYC đại lý"]
        UC_A02["UC-A02: Đình chỉ / Khóa tài khoản đại lý vi phạm"]
        UC_A03["UC-A03: Xem dashboard báo cáo tài chính toàn sàn"]
        UC_A04["UC-A04: Cập nhật cấu hình hệ thống"]
        UC_A05["UC-A05: Auto-cancel đơn giữ chỗ quá hạn (15 phút)"]
        UC_A06["UC-A06: Xử lý IPN Callback nạp ví tự động"]
    end

    %% CONNECTIONS
    PA --> UC_A01 & UC_A02 & UC_A03 & UC_A04
    SYS -.-> UC_A05
    VNPAY -.-> UC_A06
```

---

## 📝 2. Bảng Mô Tả Nghiệp Vụ Tóm Tắt

| Mã Use Case | Tên Use Case Tóm Tắt | Actor Chính | Nội dung nghiệp vụ cốt lõi |
| :--- | :--- | :--- | :--- |
| **UC-G01** | Quản lý tài khoản | Đại lý, NCC, Admin | Quản lý đăng ký mới, đăng nhập cấp JWT, và thay đổi mật khẩu/hồ sơ của tất cả nhân sự. |
| **UC-G02/A01** | Phê duyệt hồ sơ KYC | Platform Admin | Thẩm định và duyệt/từ chối hồ sơ pháp lý của Đại lý mới đăng ký để mở khóa quyền giao dịch. |
| **UC-G03** | Tìm kiếm & Markup | Agency Manager/Staff | Tìm kiếm kho phòng khách sạn, vé xe, tour. Manager tự cấu hình % markup (lợi nhuận đại lý) cộng vào giá gốc. |
| **UC-G04** | Xuất báo giá lẻ | Agency Manager/Staff | Trích xuất thông tin hành trình và giá bán lẻ đã cộng Markup thành file PDF/Excel gửi trực tiếp cho khách lẻ. |
| **UC-G05** | Trợ lý AI tư vấn | Agency Manager/Staff | Nhập yêu cầu bằng ngôn ngữ tự nhiên, AI phân tích dữ liệu kho sỉ để đề xuất combo tối ưu kèm liên kết giữ chỗ nhanh. |
| **UC-G06** | Quản lý giỏ hàng | Agency Manager/Staff | Cho phép thêm/bớt nhiều dịch vụ du lịch (tour, phòng, xe) vào một giỏ hàng trước khi tiến hành giữ chỗ đồng thời. |
| **UC-G07** | Giữ chỗ & Thanh toán gộp | Agency Manager/Staff | **Saga Pattern:** Giữ chỗ đồng thời toàn bộ dịch vụ trong giỏ hàng (khóa kho 15p) và thanh toán gộp 1 lần từ ví đại lý. |
| **UC-S04** | Duyệt đơn On-Request | Supplier Admin | Phê duyệt thủ công các yêu cầu đặt chỗ đối với các dịch vụ không khóa slot tự động (cần NCC check phòng/xe thực tế). |
| **UC-G09/A05** | Hủy đơn đặt chỗ | Đại lý, Hangfire | Đại lý chủ động hủy đơn giữ chỗ để giải phóng kho, hoặc hệ thống tự động hủy và hoàn kho sau 15 phút nếu chưa thanh toán. |
| **UC-G10** | Phát hành E-Voucher | Đại lý, Hệ thống | Sinh mã QR và file PDF E-Voucher cho dịch vụ nội bộ, hoặc gọi API đối tác bên thứ ba xuất vé thật (Bus/Flight E-Ticket). |
| **UC-S05** | Xác nhận đón (Check-in) | Supplier Admin | **Check-in phân loại:**<br>- *Tour/Khách sạn:* Supplier quét QR Voucher trên điện thoại khách.<br>- *Nhà xe đối tác:* Tài xế đối chiếu thông tin hành khách (CCCD/Tên).<br>- *Hãng bay:* Khách tự check-in trực tiếp tại sân bay bằng vé điện tử nhận được. |
| **UC-G12** | Quản lý ví tài chính | Agency Manager/Staff | Xem số dư ví tiền mặt, hạn mức tín dụng công nợ tạm ứng, và truy vấn lịch sử giao dịch (sổ cái ledger không thể sửa đổi). |
| **UC-G13** | Nạp tiền ví qua VNPay | Agency Manager, VNPay | Sinh link thanh toán online qua VNPay, tự động cập nhật số dư ví đại lý ngay lập tức khi giao dịch thành công (IPN callback). |
