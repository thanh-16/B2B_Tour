# TÀI LIỆU 1: TẦM NHÌN & PHẠM VI DỰ ÁN (VISION & SCOPE)
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

---

## 1. BỐI CẢNH DỰ ÁN & CƠ HỘI THỊ TRƯỜNG CHI TIẾT

### 1.1 Tóm tắt dự án (Executive Summary)
Dự án **B2B Travel Platform — End-to-End Booking & Delivery** là một hệ thống nền tảng công nghệ dạng B2B SaaS (Software-as-a-Service) chuyên biệt cho ngành du lịch (Travel Tech). Hệ thống được thiết kế để giải quyết chuỗi quy trình kinh doanh khép kín từ tìm kiếm dịch vụ trực tuyến (phòng khách sạn, vé máy bay, tour), tạo giữ chỗ (Hold Booking), thanh toán tự động bằng ví đại lý (Agency Wallet), cho tới phân phối vé điện tử (E-Voucher) và bàn giao dịch vụ cuối cùng (Delivery) đến tay khách hàng.

Nền tảng hướng tới mục tiêu tối ưu hóa hiệu quả hoạt động cho các đại lý du lịch vừa và nhỏ (Travel Agents), cung cấp kênh phân phối hiệu quả cho nhà cung cấp dịch vụ địa phương (Suppliers) và bảo đảm tính xác thực của dịch vụ dành cho khách hàng cuối (End Customers) thông qua ứng dụng di động quét mã QR bảo mật.

---

### 1.2 Bối cảnh thị trường B2B Travel tại Việt Nam & Đông Nam Á
*   **Quy mô và Tăng trưởng**: Thị trường du lịch trực tuyến tại Đông Nam Á dự kiến đạt quy mô lớn với tốc độ phát triển nhanh chóng. Tại Việt Nam, hơn 70% thị phần phân phối dịch vụ vẫn đang nằm trong tay các đại lý truyền thống vừa và nhỏ (Sub-agents / Freelance agents).
*   **Xu hướng số hóa**: Các đại lý nhỏ này không trực tiếp kết nối với các hệ thống phân phối lớn (GDS) hay chuỗi khách sạn lớn do chi phí duy trì công nghệ và tiền ký quỹ quá cao. Họ cần một nền tảng B2B trung gian cung cấp giao diện thân thiện, giá sỉ tốt (Net Rate) và cơ chế thanh toán linh hoạt.
*   **Pain Points (Nỗi đau nghiệp vụ) của đại lý truyền thống**:
    1.  *Tìm kiếm thủ công*: Phải chat qua Zalo/Skype với nhiều Supplier để kiểm tra tình trạng chỗ và giá Net, mất từ 30 phút đến 2 giờ cho 1 báo giá.
    2.  *Rủi ro hủy giữ chỗ (Hold Expiration)*: Thời gian giữ chỗ vé máy bay và phòng khách sạn rất ngắn. Nếu đại lý không chốt tiền kịp với khách hoặc kế toán chậm chuyển khoản, booking sẽ bị hủy.
    3.  *Tính toán giá Markup thủ công*: Dễ gây sai sót nhầm lẫn thuế phí hoặc tính sai hoa hồng của cộng tác viên (CTV).
    4.  *Quản lý Voucher lỏng lẻo*: Voucher PDF thô gửi qua tin nhắn dễ bị chỉnh sửa, làm giả hoặc sử dụng trùng lặp (Double Spend) tại điểm đón xe/khách sạn.

---

### 1.3 Đối thủ cạnh tranh & Phân tích khoảng trống thị trường (Market Gap)

| Tiêu chí | GDS Truyền thống (Amadeus, Sabre) | B2C OTA (Agoda, Booking.com) | Nền tảng B2B Travel Platform |
| :--- | :--- | :--- | :--- |
| **Đối tượng khách** | Hãng hàng không, Đại lý vé cấp 1. | Khách du lịch lẻ tự túc (B2C). | Đại lý du lịch vừa, nhỏ và CTV (B2B). |
| **Ký quỹ** | Cực kỳ cao (hàng trăm triệu đồng). | Không yêu cầu ký quỹ nhưng không có giá sỉ thương mại. | Nạp tiền vào ví linh hoạt, hỗ trợ hạn mức nợ. |
| **Markup giá** | Phức tạp, giao diện dòng lệnh khó dùng. | Không hỗ trợ. | **Tự động cộng Markup theo tỷ lệ % hoặc số tiền cố định.** |
| **Dịch vụ local** | Chỉ mạnh về Vé máy bay và Khách sạn lớn. | Yếu về Tour lẻ và Vé xe khách nội địa. | **Tích hợp sâu các dịch vụ local (Tours, Vé xe).** |
| **Bàn giao (Delivery)** | Không hỗ trợ. | Khách tự trình email đặt phòng tại lễ tân. | **Có Mobile App quét mã QR xác thực check-in offline.** |

---

### 1.4 Mô hình doanh thu (Revenue Model)
1.  **Commission-based (Markup)**: Nhận chiết khấu hoa hồng từ 3% đến 7% trên tổng giá trị giao dịch (GMV) từ nhà cung cấp nhờ sản lượng đặt chỗ lớn của sàn.
2.  **SaaS Subscription**: Thu phí phiên bản Premium (công cụ báo cáo tài chính nâng cao, quản lý phân quyền nhân viên nâng cao) với mức giá cố định theo tháng/năm đối với các đại lý lớn.
3.  **Transaction Fee**: Thu phí xử lý nạp/rút tiền trực tuyến từ 0.5% - 1% trên giao dịch nạp ví.

---

## 2. PHÂN TÍCH STAKEHOLDER & USER PERSONAS

### 2.1 Ma trận Actor & Stakeholder Map
*   **Travel Agent (Nhân viên đại lý)**: Người tìm kiếm, giữ chỗ và đặt dịch vụ hàng ngày cho khách hàng.
*   **Agency Manager (Chủ đại lý)**: Quản lý số dư ví, phê duyệt yêu cầu đặt tiền, cấp quyền nhân viên, cấu hình tỷ lệ Markup và xem báo cáo kinh doanh.
*   **Supplier (Nhà cung cấp)**: Đơn vị sở hữu dịch vụ (Khách sạn, xe, tour). Cập nhật số lượng chỗ trống và duyệt các booking cần xác nhận.
*   **Delivery Agent (Tài xế/Hướng dẫn viên)**: Nhân viên bàn giao dịch vụ, thực hiện quét QR check-in khách tại điểm đón.
*   **Platform Admin & Finance**: Kiểm soát hệ thống, duyệt hồ sơ KYC đại lý, cấu hình phí toàn sàn và đối soát dòng tiền tài chính.

---

### 2.2 Chân dung và Đặc điểm của các User Classes

| Vai trò người dùng | Trình độ công nghệ | Tần suất sử dụng hệ thống | Động cơ & Mục tiêu chính |
| :--- | :--- | :--- | :--- |
| **Agency Manager** | Trung bình | Hàng ngày (1-2 lần/ngày) | Kiểm soát tài chính, phân quyền nhân viên, tối ưu cấu hình Markup. |
| **Agency Staff** | Tốt (Sử dụng smartphone sành sỏi) | Rất cao (Liên tục trong giờ làm việc) | Tìm dịch vụ nhanh, chốt booking nhanh, báo giá Markup tự động cho khách. |
| **Supplier Admin** | Trung bình | Hàng ngày (Vài lần/ngày) | Quản lý kho tồn phòng/xe, duyệt nhanh các booking chờ xác nhận. |
| **Delivery Agent** | Thấp đến trung bình | Khi đi đón khách (Liên tục ngoài hiện trường) | Quét QR check-in nhanh, xác thực vé thật/giả không cần internet, định vị GPS điểm đón. |
| **Platform Admin** | Cao (Chuyên gia hệ thống) | Liên tục | Vận hành hệ thống ổn định, duyệt KYC đại lý mới, xử lý tranh chấp tài chính. |

---

### 2.3 User Personas (Chân dung người dùng điển hình)

#### Chân dung 1: Hoàng Thu Trang — Chủ đại lý du lịch (Agency Owner)
*   *Mục tiêu*: Tối ưu hóa lợi nhuận kinh doanh, quản lý chặt chẽ dòng tiền nạp/rút của nhân viên, mở rộng mạng lưới cộng tác viên (CTV).
*   *Nỗi đau*: Khó đối soát công nợ cuối tháng; nhân viên quên thanh toán làm hủy booking đoàn của khách.
*   *Hành vi hàng ngày*: Sáng duyệt tiền ví nạp cho nhân viên. Chiều nhận cảnh báo booking sắp hết hạn hold để duyệt chi thanh toán. Cuối tháng xuất file đối soát công nợ gửi kế toán.

#### Chân dung 2: Nguyễn Minh Tuấn — Nhân viên sales đại lý (Agency Staff)
*   *Mục tiêu*: Tìm kiếm và báo giá phòng/vé nhanh cho khách qua Zalo; giữ chỗ thành công để đợi khách chuyển khoản cọc tiền.
*   *Nỗi đau*: Sợ gõ sai tên khách bị hãng bay phạt tiền; mất thời gian so sánh giá trên nhiều trang web khác nhau.
*   *Hành vi hàng ngày*: Nhận yêu cầu combo từ khách, tìm kiếm trên sàn, giữ chỗ (Hold Booking) lấy mã đặt chỗ tạm thời gửi khách. Khi khách chuyển khoản cọc, Tuấn bấm thanh toán ví để xuất voucher gửi khách.

#### Chân dung 3: Lê Quốc Huy — Tài xế / Nhân viên đón khách (Delivery Agent)
*   *Mục tiêu*: Đón đúng hành khách lên xe đi tour, xuất phát đúng giờ quy định.
*   *Nỗi đau*: Khách đưa mã đặt chỗ viết tay mờ; mất thời gian đếm và đối chiếu danh sách giấy dưới trời nắng nóng; nhiều khu vực đón khách bị mất sóng di động 4G.
*   *Hành vi hàng ngày*: Mở app di động xem danh sách đón khách hôm nay. Đến điểm hẹn, dùng camera điện thoại quét QR trên voucher của khách để xác nhận hành khách hợp lệ.

---

### 2.4 Ma trận RACI cho các quy trình nghiệp vụ chính

| Quy trình nghiệp vụ | Platform Admin | Travel Agency | Supplier | Delivery Agent | Finance |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Duyệt hồ sơ Đại lý (KYC)** | **A** (Accountable) | **R** (Responsible) | **N/A** | **N/A** | **C** (Consulted) |
| **Giữ chỗ (Hold Booking)** | **I** (Informed) | **R** (Responsible) | **A** (Accountable) | **N/A** | **N/A** |
| **Thanh toán & Xuất vé** | **I** (Informed) | **R** (Responsible) | **A** (Accountable) | **N/A** | **I** (Informed) |
| **Check-in QR quét vé** | **I** (Informed) | **I** (Informed) | **I** (Informed) | **R** (Responsible) | **N/A** |
| **Hủy & Hoàn tiền ví** | **A** (Accountable) | **R** (Responsible) | **R** (Responsible) | **N/A** | **R** (Responsible) |

---

## 3. PHẠM VI SẢN PHẨM & RANH GIỚI BÊN NGOÀI (SYSTEM BOUNDARY)

### 3.1 Nằm trong phạm vi (In-Scope)
*   Xây dựng hệ thống Portal Web cho Admin hệ thống, Finance và đối tác Supplier.
*   Xây dựng hệ thống Mobile App (cho iOS & Android) dành cho nhân viên Đại lý du lịch (tìm kiếm, đặt vé, quản lý giỏ hàng) và tài xế Delivery (quét mã QR offline).
*   Tích hợp cổng thanh toán trực tuyến (nạp tiền ví qua VNPay IPN).
*   Cơ chế giữ chỗ tạm thời (Hold PNR) kết hợp hoàn trả kho tự động.
*   Giải thuật đối soát tiền ví tự động và cơ chế bảo mật chống tiêu trùng (Double Spending).
*   Hỗ trợ xuất hóa đơn điện tử VAT dạng tệp PDF tự động.

### 3.2 Nằm ngoài phạm vi (Out-of-Scope)
*   Tự xây dựng cổng thanh toán trực tiếp ngân hàng (chỉ tích hợp và phụ thuộc vào trung gian cổng VNPay).
*   Quản lý lịch trình xe và bảo trì phương tiện của nhà xe (hệ thống chỉ quản lý kho chỗ của xe chạy tour).
*   Dịch vụ chăm sóc khách hàng trực tuyến (Chatbot thông minh AI) - chỉ hỗ trợ gửi thông báo qua SMS/Email.
*   Các loại bảo hiểm du lịch quốc tế phức tạp (chỉ hỗ trợ đặt dịch vụ cơ bản chuyến bay, phòng, tour local).

---

### 3.3 Sơ đồ ngữ cảnh trao đổi dữ liệu ngoại vi (Context Boundary Description)
Hệ thống B2B Travel Platform tương tác trực tiếp với các tác nhân bên ngoài qua các cổng kết nối API chuẩn hóa:
1.  **Hệ thống phân phối hàng không toàn cầu (GDS API)**: Hệ thống gửi yêu cầu giữ chỗ (Hold PNR), xuất vé thật (Issue Ticket), và hủy vé (Release PNR) sang hệ thống của các hãng hàng không.
2.  **Cổng thanh toán trực tuyến VNPay**: Hệ thống gửi yêu cầu khởi tạo cổng thanh toán và tiếp nhận Webhook IPN phản hồi biến động số dư tài khoản ngân hàng của đại lý, hoặc gọi API QueryDR để đối soát giao dịch nạp tiền.
3.  **Hệ thống Thông báo & SMS Gateway**: Hệ thống gửi yêu cầu kích hoạt tin nhắn SMS OTP hoặc thông báo đẩy FCM xuống thiết bị di động của người dùng cuối.
4.  **Hệ thống Bản đồ địa lý (Goong Maps / Google Maps API)**: Hệ thống định vị bản đồ tọa độ GPS của tài xế lúc quét check-in offline để vẽ lộ trình hành trình.
