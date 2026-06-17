# TÀI LIỆU YÊU CẦU CHỨC NĂNG & PHI CHỨC NĂNG (FR & NFR)
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

---

## PHẦN 1: FUNCTIONAL REQUIREMENTS (YÊU CẦU CHỨC NĂNG)

---

### M01 - Authentication & RBAC (Xác thực & Phân quyền)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Người dùng hệ thống (Admin, Agent Manager, Agent Staff, Supplier, Finance),
    *   *I want to* đăng nhập bằng email/mật khẩu và bật xác thực 2 lớp (2FA),
    *   *So that* tài khoản và số dư ví đại lý của tôi được bảo vệ an toàn.
*   **User Story 2**:
    *   *As an* Agent Manager (Chủ đại lý),
    *   *I want to* tạo tài khoản con cho nhân viên (Agent Staff) và gán quyền phù hợp,
    *   *So that* nhân viên có thể tự thực hiện đặt phòng nhưng không được xem số dư tổng hoặc rút tiền.

#### 2. Acceptance Criteria (Điều kiện nghiệm thu)
*   **Given** Người dùng đã đăng nhập hệ thống thành công với vai trò `Agent Staff`.
    *   **When** Họ cố gắng truy cập vào đường dẫn API rút tiền `/api/v1/payments/withdraw` hoặc xem cấu hình hạn mức tín dụng.
    *   **Then** Hệ thống chặn yêu cầu, trả về mã lỗi `403 Forbidden` và hiển thị cảnh báo "Bạn không có quyền thực hiện hành động này".

#### 3. Business Rules (Quy tắc nghiệp vụ)
*   Mật khẩu phải dài tối thiểu 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
*   Tài khoản bị khóa tạm thời trong 15 phút nếu đăng nhập sai mật khẩu quá 5 lần liên tiếp.

#### 4. Bảng danh sách yêu cầu M01

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M01-01** | Đăng nhập hệ thống | Xác thực tài khoản người dùng qua Email/Password và cấp JWT Token. | **Must Have** | JWT Token hết hạn sau 15 phút. |
| **FR-M01-02** | Phân quyền RBAC | Quản lý danh sách Role và Permission cho các nhóm đối tượng người dùng. | **Must Have** | Cấp quyền động ở mức API Endpoint. |
| **FR-M01-03** | Xác thực 2 lớp (2FA) | Gửi mã OTP qua Google Authenticator hoặc Email khi đăng nhập trên thiết bị mới. | **Should Have** | Sử dụng TOTP. |

---

### M02 - Agent Onboarding (Đăng ký & Phê duyệt Đại lý)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Doanh nghiệp lữ hành mới,
    *   *I want to* đăng ký tài khoản đại lý trực tuyến và tải lên tài liệu KYC,
    *   *So that* tôi có thể bắt đầu sử dụng dịch vụ trên sàn.
*   **User Story 2**:
    *   *As a* Platform Admin,
    *   *I want to* duyệt hồ sơ đại lý và thiết lập hạn mức tín dụng ban đầu (Credit Setup),
    *   *So that* đại lý có thể thanh toán đặt chỗ theo dạng công nợ trả sau.

#### 2. Acceptance Criteria
*   **Given** Hồ sơ đăng ký của Agency ở trạng thái `Pending KYC`.
    *   **When** Platform Admin kiểm duyệt giấy phép kinh doanh hợp lệ và nhấn nút "Approve", sau đó điền hạn mức tín dụng `50,000,000 VND`.
    *   **Then** Hệ thống đổi trạng thái Agency sang `Active`, tạo ví đại lý với số dư nợ cho phép tối đa là `-50,000,000 VND`, và gửi email thông báo kích hoạt thành công kèm mật khẩu khởi tạo cho đại lý.

#### 3. Business Rules
*   Mã số thuế (Tax Code) của đại lý đăng ký phải là duy nhất trên hệ thống.
*   Hồ sơ đại lý bắt buộc phải có ảnh chụp Giấy đăng ký kinh doanh và Căn cước công dân của người đại diện pháp luật mới được gửi duyệt.

#### 4. Bảng danh sách yêu cầu M02

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M02-01** | Đăng ký đại lý trực tuyến | Giao diện thu thập thông tin doanh nghiệp, MST, Email đại diện và tài liệu KYC. | **Must Have** | Lưu trữ tài liệu KYC trên S3. |
| **FR-M02-02** | Phê duyệt & Kích hoạt | Admin Panel cho phép duyệt hồ sơ đại lý, phân nhóm Agency (Vàng/Bạc/Đồng). | **Must Have** | Admin duyệt thủ công. |
| **FR-M02-03** | Cấu hình Credit Line | Thiết lập hạn mức tín dụng tối đa và thời gian trả nợ (ví dụ: 15 ngày). | **Must Have** | Lưu log thay đổi credit limit. |

---

### M03 - Inventory Management (Quản lý kho sản phẩm)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Supplier,
    *   *I want to* khai báo thông tin phòng khách sạn, chuyến bay, tour du lịch,
    *   *So that* đại lý có thể tìm kiếm và đặt mua sản phẩm của tôi.
*   **User Story 2**:
    *   *As a* Supplier,
    *   *I want to* cập nhật số lượng tồn kho (Inventory) theo ngày,
    *   *So that* tránh tình trạng đặt trùng lặp (Overbooking).

#### 2. Acceptance Criteria
*   **Given** Supplier đang quản lý kho phòng của khách sạn A.
    *   **When** Họ thực hiện thay đổi số lượng phòng trống từ 2 về 0 phòng cho ngày 15/07/2026.
    *   **Then** Hệ thống cập nhật cơ sở dữ liệu PostgreSQL, đồng thời gửi lệnh xóa bộ nhớ đệm phòng trống của sản phẩm đó trên Redis Cache ngay lập tức.

#### 3. Business Rules
*   Supplier không được phép xóa sản phẩm đang có booking ở trạng thái `Held` hoặc `Paid` chưa sử dụng. Chỉ được phép đổi trạng thái sang `Inactive` (dừng bán mới).
*   Nếu Supplier không cập nhật kho chỗ trống dẫn đến booking bị từ chối do hết chỗ thực tế bên ngoài (Double Booking), Supplier sẽ bị phạt **20% giá trị đơn hàng** để sàn đền bù bồi thường cho Đại lý.

#### 4. Bảng danh sách yêu cầu M03

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M03-01** | Quản lý sản phẩm | Cung cấp CRUD cho các loại hình dịch vụ: Flights, Hotels, Tours, Visa. | **Must Have** | Cấu trúc dữ liệu mở rộng JSONB. |
| **FR-M03-02** | Quản lý lịch Kho phòng | Giao diện Calendar View để chỉnh sửa tồn kho và giá bán sỉ theo từng ngày cụ thể. | **Must Have** | Tối ưu hóa giao diện kéo thả. |
| **FR-M03-03** | Auto-close Inventory | Tự động đóng kho khi số lượng khả dụng (available quantity) về 0. | **Must Have** | Chạy kiểm tra đồng thời ở mức DB. |
| **FR-M03-04** | Đóng bán nhanh (Stop Selling) | Nút gạt đóng bán tour nhanh trên Supplier App hoặc Zalo/Telegram Bot; cập nhật kho về 0 lập tức. | **Must Have** | Giảm thiểu trễ thao tác khi hết chỗ đột xuất. |

---

### M04 - Search Engine (Tìm kiếm đa tiêu chí)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* tìm kiếm phòng khách sạn theo điểm đến, khoảng ngày, số khách và khoảng giá,
    *   *So that* tôi nhanh chóng tìm ra các lựa chọn tốt nhất gửi cho khách hàng.
*   **User Story 2**:
    *   *As an* Agent Staff,
    *   *I want to* lọc danh sách chuyến bay theo hãng hàng không, giờ cất cánh và số điểm dừng,
    *   *So that* đáp ứng đúng nhu cầu khắt khe của khách hàng thương gia.

#### 2. Acceptance Criteria
*   **Given** Nhân viên đại lý nhập tìm kiếm khách sạn tại "Đà Nẵng" từ ngày 10/07/2026 đến 12/07/2026.
    *   **When** Hệ thống thực hiện tìm kiếm.
    *   **Then** Hệ thống trả về danh sách khách sạn còn phòng trống thực tế trong khoảng ngày đó kèm theo giá đã tính toán tự động qua Markup Engine của đại lý.

#### 3. Business Rules
*   Dữ liệu tìm kiếm chuyến bay phải được lưu cache trong vòng 3 phút; dữ liệu khách sạn lưu cache trong 5 phút để giảm thiểu số lượng truy vấn trực tiếp đến Supplier gốc.

#### 4. Bảng danh sách yêu cầu M04

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M04-01** | Tìm kiếm đa dịch vụ | Hỗ trợ tìm kiếm theo nhiều tiêu chí cho Khách sạn, Chuyến bay, Tour du lịch. | **Must Have** | Kết xuất dữ liệu từ Redis Cache. |
| **FR-M04-02** | Bộ lọc nâng cao (Filters) | Lọc kết quả theo giá Net/Markup, xếp hạng sao, hãng bay, khung giờ di chuyển. | **Must Have** | Xử lý lọc hoàn toàn ở phía client. |
| **FR-M04-03** | Ẩn giá Net (Agent Mode) | Chức năng chuyển đổi nhanh trên giao diện để ẩn/hiển thị giá Net gốc của nhà cung cấp. | **Should Have** | Dùng phím nóng Ctrl+Alt+H. |
| **FR-M04-04** | Gợi ý sản phẩm chéo | Gợi ý Vé máy bay khứ hồi và Xe đưa đón sân bay phù hợp lịch trình khi tìm kiếm Tour. | **Should Have** | Tự động phân tích điểm đi/đến và thời gian đón/trả. |

---

### M05 - Shopping Cart & Price Lock (Giỏ hàng & Khóa giá)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* gom nhiều dịch vụ khác nhau vào một giỏ hàng,
    *   *So that* tôi có thể checkout toàn bộ hành trình cho khách hàng trong một phiên giao dịch.
*   **User Story 2**:
    *   *As an* Agent Staff,
    *   *I want to* khóa giá bán trong vòng 10 phút khi đang nhập thông tin hành khách,
    *   *So that* giá dịch vụ không bị tăng đột ngột giữa chừng khi hãng bay đổi giá.

#### 2. Acceptance Criteria
*   **Given** Nhân viên đã thêm 1 vé máy bay vào giỏ hàng và chuyển sang màn hình nhập thông tin khách.
    *   **When** Hệ thống kích hoạt trạng thái "Price Lock" cho giỏ hàng đó.
    *   **Then** Giá vé máy bay được giữ nguyên cố định trong 10 phút, ngay cả khi giá gốc của Supplier biến động tăng lên. Nếu quá 10 phút chưa thanh toán, khóa giá sẽ tự động hết hiệu lực.

#### 3. Business Rules
*   Tính năng khóa giá (Price Lock) chỉ được áp dụng đối với các sản phẩm hỗ trợ giữ chỗ tạm thời.
*   Mỗi đại lý chỉ được phép khóa tối đa 3 giỏ hàng đồng thời.

#### 4. Bảng danh sách yêu cầu M05

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M05-01** | Giỏ hàng B2B | Cho phép thêm, xóa, cập nhật số lượng các loại dịch vụ khác nhau vào giỏ hàng. | **Must Have** | Lưu thông tin giỏ hàng trong Local DB của Client. |
| **FR-M05-02** | Khóa giá (Price Lock) | Giữ nguyên mức giá Net và giá Markup tại thời điểm checkout trong một khoảng thời gian. | **Must Have** | Khóa giá lưu trên Redis key TTL. |
| **FR-M05-03** | Cảnh báo hết hạn giá | Hiển thị đồng hồ đếm ngược thời gian khóa giá trên màn hình checkout. | **Should Have** | Hiệu ứng nhấp nháy đỏ khi còn 1 phút. |
| **FR-M05-04** | Đồng bộ khóa giữ chỗ | Khóa giữ chỗ vé bay/khách sạn đồng bộ khi đặt cùng Tour chờ xác nhận; tự động nhả nếu Tour bị từ chối. | **Must Have** | Tránh rủi ro đại lý bị mồ côi vé máy bay/phòng. |

---

### M06 - Booking Workflow (Luồng đặt chỗ)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* tạo lệnh giữ chỗ (Hold Booking) và lấy mã PNR tạm thời,
    *   *So that* tôi có thời gian thu tiền của khách hàng mà không lo bị mất vé.
*   **User Story 2**:
    *   *As an* Agent Manager,
    *   *I want to* thực hiện hủy một phần dịch vụ (Partial Cancellation) trong booking đoàn,
    *   *So that* giảm chi phí cho những khách báo hủy phút chót mà không ảnh hưởng đến cả đoàn.

#### 2. Acceptance Criteria
*   **Given** Booking đoàn gồm 10 phòng khách sạn có trạng thái `Paid`.
    *   **When** Agent Manager gửi yêu cầu hủy 2 phòng trong đoàn trước ngày khởi hành 7 ngày.
    *   **Then** Hệ thống gửi lệnh hủy 2 phòng lên Supplier, tính toán số tiền phạt hủy cho 2 phòng đó, hoàn lại số tiền còn lại vào ví đại lý, và cập nhật số lượng phòng của booking trên hệ thống thành 8 phòng.

#### 3. Business Rules
*   Hold Booking tự động hủy và giải phóng inventory nếu quá thời gian giữ chỗ (Hold Time Limit) mà đại lý chưa thực hiện thanh toán thành công.
*   Hủy một phần (Partial Cancel) chỉ được chấp nhận đối với các dịch vụ khách sạn và tour lẻ có chính sách hủy phòng/vé riêng lẻ, không áp dụng cho vé máy bay đoàn (Group PNR).

#### 4. Bảng danh sách yêu cầu M06

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M06-01** | Tạo giữ chỗ (Hold Booking) | Gửi yêu cầu giữ chỗ tạm thời lên hệ thống gốc và nhận về mã PNR định danh. | **Must Have** | Trạng thái booking chuyển sang HELD. |
| **FR-M06-02** | Hủy đặt chỗ (Full Cancel) | Hủy toàn bộ booking và xử lý hoàn trả tiền vào ví dựa trên Cancellation Policy. | **Must Have** | Trạng thái đổi sang CANCELLED. |
| **FR-M06-03** | Hủy một phần (Partial Cancel) | Cho phép chọn một hoặc vài hành khách/dịch vụ cụ thể trong booking tổng để hủy. | **Should Have** | Tạo ra hóa đơn điều chỉnh phụ. |
| **FR-M06-04** | Khung giờ yên lặng & nhắc nhở | Tour đặt từ 21h-6h được đưa vào hàng chờ. Khung giờ hoạt động nhắc Supplier mỗi tiếng 1 lần. | **Must Have** | Sử dụng Hangfire background worker. |
| **FR-M06-05** | Báo động leo thang trễ | Gửi cảnh báo trễ cho Đại lý và thực hiện cuộc gọi robot IVR/SMS đến Supplier sau 3 tiếng trễ. | **Must Have** | Tích hợp hệ thống tổng đài tự động. |
| **FR-M06-06** | Khóa sổ & Hủy tự động (Cut-off) | Khóa đặt lúc 18h & hủy lúc 21h hôm trước đối với tour sáng sớm; hủy trước giờ đi 2 tiếng đối với tour khác. | **Must Have** | Tránh việc hủy sát giờ gây khó chịu cho khách hàng. |

---

### M07 - Payment (Thanh toán ví & Cổng trực tuyến)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* thanh toán booking bằng hạn mức tín dụng (Credit Line) được cấp,
    *   *So that* tôi có thể xuất vé ngay lập tức cho khách hàng khi số dư ví đang hết.
*   **User Story 2**:
    *   *As an* Agent Manager,
    *   *I want to* nạp tiền vào ví đại lý qua cổng VNPay/MoMo quét mã QR Code,
    *   *So that* tiền được cộng vào tài khoản ví tự động không cần gửi hóa đơn ngân hàng cho admin.

#### 2. Acceptance Criteria
*   **Given** Đại lý thanh toán booking trị giá 10,000,000 VND bằng phương thức chuyển khoản trực tuyến qua cổng VNPay.
    *   **When** Giao dịch thanh toán bị gián đoạn do lỗi kết nối mạng (Timeout) từ phía ngân hàng.
    *   **Then** Hệ thống ghi nhận trạng thái giao dịch là `Pending Reconciliation`, không tự động hủy booking và kích hoạt Job kiểm tra trạng thái thanh toán tự động qua API đối soát của VNPay sau mỗi 5 phút.

#### 3. Business Rules
*   Hệ thống không cho phép thanh toán bằng tài khoản ví đại lý nếu số dư nợ hiện tại vượt quá hạn mức tín dụng âm cho phép.
*   Mọi giao dịch trừ tiền trên ví đại lý bắt buộc phải đi qua cơ chế xác thực mã PIN bảo mật giao dịch.

#### 4. Bảng danh sách yêu cầu M07

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M07-01** | Ví đại lý (Wallet Payment) | Trừ tiền trực tiếp vào số dư ví của đại lý khi đặt dịch vụ. | **Must Have** | Áp dụng Database Transaction locks. |
| **FR-M07-02** | Nạp tiền cổng VNPay/MoMo | Quét mã QR thanh toán trực tuyến, xử lý IPN Webhook tự động cộng tiền ví. | **Must Have** | Chữ ký số SHA256 bắt buộc. |
| **FR-M07-03** | Xử lý lỗi & Đối soát tự động | Tự động chạy Job đối soát giao dịch nghi ngờ lỗi, tránh trừ tiền 2 lần. | **Must Have** | Idempotency Key cho API thanh toán. |

---

### M08 - Invoicing & VAT (Hóa đơn & Thuế)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Manager,
    *   *I want* hệ thống tự động xuất hóa đơn VAT (E-Invoice) dạng PDF sau khi thanh toán thành công,
    *   *So that* tôi có thể gửi trực tiếp cho kế toán của công ty khách hàng làm thủ tục thanh quyết toán.

#### 2. Acceptance Criteria
*   **Given** Một booking đã thanh toán thành công và có thông tin xuất hóa đơn VAT do đại lý nhập.
    *   **When** Booking chuyển sang trạng thái `Paid`.
    *   **Then** Hệ thống tự động kích hoạt tiến trình tạo hóa đơn điện tử PDF chứa đầy đủ thông tin Tên công ty, Mã số thuế, Địa chỉ và gửi file PDF này vào email của đại lý.

#### 3. Business Rules
*   Thông tin xuất hóa đơn VAT không được phép chỉnh sửa sau khi hóa đơn điện tử đã được ký số và phát hành chính thức lên cơ quan thuế.

#### 4. Bảng danh sách yêu cầu M08

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M08-01** | Điền thông tin hóa đơn | Cho phép đại lý nhập thông tin xuất hóa đơn VAT (MST, Tên công ty, Địa chỉ) lúc checkout. | **Must Have** | Hỗ trợ tìm MST nhanh qua API tổng cục thuế. |
| **FR-M08-02** | Xuất hóa đơn tự động | Tự động sinh file PDF hóa đơn VAT dựa trên biểu mẫu quy định sau khi thanh toán. | **Must Have** | Lưu trữ tệp PDF trên S3. |
| **FR-M08-03** | Gửi Email hóa đơn | Tự động đính kèm file hóa đơn PDF gửi đến email của đại lý và khách hàng. | **Should Have** | Sử dụng SendGrid API. |

---

### M09 - Fulfillment & Delivery (Bàn giao dịch vụ)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Khách hàng cuối (End Customer),
    *   *I want to* nhận được vé điện tử (E-Ticket/E-Voucher) tự động qua SMS và Zalo ngay sau khi thanh toán,
    *   *So that* tôi có thể tự tin đi ra sân bay hoặc đến khách sạn sử dụng dịch vụ.
*   **User Story 2**:
    *   *As a* Hướng dẫn viên du lịch (Delivery Agent),
    *   *I want* app di động tự động tải danh sách khách hàng đón trong ngày,
    *   *So that* tôi biết rõ số lượng và địa điểm đón khách kể cả khi mạng internet chập chờn.

#### 2. Acceptance Criteria
*   **Given** Tài xế xe du lịch đang đứng đón khách tại điểm đón ngoài vùng phủ sóng mạng 4G.
    *   **When** Họ quét mã QR của khách hàng lên xe bằng app di động ngoại tuyến (Offline Mode).
    *   **Then** App di động đối soát mã QR chữ ký số cục bộ, hiển thị trạng thái hợp lệ để cho khách lên xe, lưu bản ghi quét vào bộ nhớ SQLite cục bộ và sẵn sàng đẩy dữ liệu lên server khi có mạng lại.

#### 3. Business Rules
*   Mã QR Code trên voucher phải chứa timestamp và chữ ký số HMAC-SHA256 được mã hóa để chống sao chép và chỉnh sửa ngoại tuyến.

#### 4. Bảng danh sách yêu cầu M09

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M09-01** | Sinh E-Voucher tự động | Tự động sinh Voucher chứa mã QR Code bảo mật và gửi file PDF cho khách hàng. | **Must Have** | Dùng thư viện sinh PDF của .NET Core. |
| **FR-M09-02** | Ứng dụng quét mã QR | App di động Flutter cho nhân viên quét mã QR check-in dịch vụ. | **Must Have** | Chạy trên cả iOS và Android. |
| **FR-M09-03** | Đồng bộ Offline dữ liệu quét | Lưu trữ lịch sử quét check-in ngoại tuyến trên thiết bị khi mất mạng di động. | **Should Have** | Dùng Hive DB/SQLite cho Flutter local. |

---

### M10 - Notification System (Hệ thống thông báo)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* nhận được thông báo in-app và SMS trước khi booking hết hạn giữ chỗ 10 phút,
    *   *So that* tôi kịp thời nhắc nhở khách hàng thanh toán cọc.

#### 2. Acceptance Criteria
*   **Given** Booking đang ở trạng thái `Held` và chỉ còn 10 phút nữa là đến thời gian `Hold Expiration`.
    *   **When** Hệ thống chạy background scheduler quét dữ liệu.
    *   **Then** Hệ thống tự động gửi thông báo in-app màu vàng nhấp nháy cho tài khoản nhân viên tạo booking, đồng thời kích hoạt gửi 1 tin nhắn SMS cảnh báo đến số điện thoại của đại lý.

#### 3. Business Rules
*   Tần suất gửi tin nhắn SMS cảnh báo giới hạn tối đa 2 tin nhắn/booking để tiết kiệm chi phí vận hành SMS Gateway.

#### 4. Bảng danh sách yêu cầu M10

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M10-01** | Thông báo trong ứng dụng (In-app) | Hiển thị chuông thông báo thời gian thực về biến động số dư và trạng thái booking. | **Must Have** | Sử dụng SignalR/WebSockets. |
| **FR-M10-02** | Gửi Email / SMS tự động | Gửi thông tin hóa đơn, voucher, cảnh báo hết hạn giữ chỗ qua Email/SMS. | **Must Have** | Tích hợp Twilio/SendGrid. |
| **FR-M10-03** | Webhook thông báo Supplier | Đẩy sự kiện đặt vé mới (Booking Created Event) về API của Supplier tự động. | **Should Have** | Cơ chế tự động gọi lại khi thất bại. |

---

### M11 - After-sales & Support (Chăm sóc sau bán)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Staff,
    *   *I want to* gửi yêu cầu đổi ngày bay hoặc đổi hạng phòng khách sạn trên hệ thống,
    *   *So that* xử lý nhanh nhu cầu thay đổi của khách hàng mà không cần gọi điện thoại lên tổng đài.

#### 2. Acceptance Criteria
*   **Given** Nhân viên gửi yêu cầu đổi ngày bay cho booking `BK-9092` từ ngày 10/07 sang 12/07.
    *   **When** Supplier báo giá chênh lệch đổi ngày là 500,000 VND.
    *   **Then** Hệ thống hiển thị nút "Đồng ý thanh toán chênh lệch" cho đại lý, thực hiện trừ ví 500,000 VND và tự động cập nhật lại ngày bay mới trên vé.

#### 3. Business Rules
*   Yêu cầu đổi ngày/dịch vụ chỉ được gửi trước ngày khởi hành tối thiểu 24 giờ.
*   Báo cáo sự cố hủy tour đột xuất yêu cầu Supplier chọn phân loại Bất khả kháng hoặc Lỗi vận hành. Lỗi vận hành sẽ áp dụng chế tài phạt 30% - 50% đơn hàng hoặc chịu phí chênh lệch định tuyến lại tour thay thế.

#### 4. Bảng danh sách yêu cầu M11

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M11-01** | Đổi lịch trình dịch vụ | Gửi yêu cầu đổi ngày, đổi hạng dịch vụ và tính giá chênh lệch tự động. | **Must Have** | Trạng thái đổi sang PENDING_CHANGE. |
| **FR-M11-02** | Gửi yêu cầu hoàn tiền (Refund Claims) | Đại lý gửi yêu cầu hủy và hoàn tiền cho booking gặp sự cố đột xuất (khách ốm có giấy chứng nhận y tế). | **Must Have** | Yêu cầu upload tài liệu chứng minh. |
| **FR-M11-03** | Tích hợp Live Chat hỗ trợ | Kênh chat trực tuyến giữa nhân viên đại lý và đội ngũ support hỗ trợ kỹ thuật của sàn. | **Should Have** | Dùng thư viện SignalR tự phát triển. |
| **FR-M11-04** | Khai báo sự cố (Incident Report) | Cho phép Supplier khai báo hỏng xe/bão lũ đột xuất; tự động hoàn tiền hoặc chuyển đổi đối tác cho khách. | **Must Have** | Gửi Zalo/FCM thông báo khẩn cấp đến Đại lý. |

---

### M12 - Reporting & Analytics (Báo cáo thống kê)

#### 1. User Stories
*   **User Story 1**: 
    *   *As an* Agent Manager,
    *   *I want to* xem biểu đồ doanh số bán hàng của từng nhân viên sales theo tuần và tháng,
    *   *So that* tôi có thể đánh giá hiệu quả làm việc và tính thưởng chính xác.

#### 2. Acceptance Criteria
*   **Given** Chủ đại lý truy cập vào trang Dashboard tài chính của Agent Portal.
    *   **When** Họ chọn thời gian lọc từ ngày 01/06/2026 đến 30/06/2026 và nhấn "Xuất báo cáo".
    *   **Then** Hệ thống tạo và hiển thị biểu đồ cột doanh thu theo ngày và bảng chi tiết doanh số bán của từng nhân viên, cho phép tải file Excel báo cáo về máy tính.

#### 3. Business Rules
*   Dữ liệu báo cáo thống kê doanh thu được cập nhật trễ tối đa 1 giờ (chạy qua Data Warehouse/Read-replica DB) để tránh làm nghẽn Database giao dịch chính.

#### 4. Bảng danh sách yêu cầu M12

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M12-01** | Dashboard doanh thu đại lý | Xem doanh số, lợi nhuận gộp, số tiền hoa hồng của đại lý. | **Must Have** | Sử dụng thư viện Chart.js/Recharts. |
| **FR-M12-02** | Báo cáo hiệu suất nhân viên | Bảng thống kê số lượng booking, tỷ lệ chốt thành công của từng nhân viên kinh doanh. | **Must Have** | Chỉ hiển thị cho tài khoản Agent Manager. |
| **FR-M12-03** | Xuất báo cáo Excel/PDF | Cho phép kết xuất toàn bộ dữ liệu bảng báo cáo ra file định dạng Excel hoặc PDF. | **Must Have** | Dùng thư viện EPPlus của .NET. |

---

### M13 - Admin Panel (Quản trị hệ thống)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Platform Admin,
    *   *I want to* xem nhật ký hoạt động (Audit Log) của hệ thống,
    *   *So that* tôi có thể truy vết người dùng nào đã thực hiện thay đổi số dư ví đại lý khi có tranh chấp xảy ra.

#### 2. Acceptance Criteria
*   **Given** Platform Admin truy cập trang Audit Log trên Admin Panel.
    *   **When** Họ lọc theo ID của ví đại lý `Wallet-8902`.
    *   **Then** Hệ thống hiển thị danh sách tất cả các hành động liên quan bao gồm: Thời gian, Địa chỉ IP, Tài khoản thực hiện, Hành động (Nạp tiền/Trừ tiền), Số dư trước và sau khi thay đổi.

#### 3. Business Rules
*   Bản ghi Audit Log là dữ liệu chỉ thêm (Append-only), không được phép chỉnh sửa hoặc xóa bởi bất kỳ người dùng nào, kể cả tài khoản có quyền Admin cao nhất.

#### 4. Bảng danh sách yêu cầu M13

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M13-01** | Quản lý người dùng hệ thống | Tạo, khóa, cập nhật thông tin tài khoản Admin, Finance, Đại lý và Nhà cung cấp. | **Must Have** | Chuyển trạng thái is_active thành false. |
| **FR-M13-02** | Cấu hình tham số hệ thống | Điều chỉnh phí giao dịch, phí hủy phòng, cấu hình tỷ lệ hoa hồng Markup chung toàn sàn. | **Must Have** | Lưu cache cấu hình trên Redis. |
| **FR-M13-03** | Nhật ký hệ thống (Audit Log) | Ghi lại mọi hành động nhạy cảm liên quan đến tài chính, công nợ, thay đổi quyền hạn. | **Must Have** | Lưu vào bảng riêng biệt chỉ ghi (Read-only log). |

---

### M14 - Supplier Portal (Cổng thông tin Nhà cung cấp)

#### 1. User Stories
*   **User Story 1**: 
    *   *As a* Supplier,
    *   *I want to* xem danh sách các đơn đặt phòng mới của khách hàng từ sàn đổ về,
    *   *So that* tôi chuẩn bị phòng tiếp đón chu đáo.

#### 2. Acceptance Criteria
*   **Given** Supplier đăng nhập vào Supplier Portal.
    *   **When** Có một booking phòng khách sạn của họ được đại lý thanh toán thành công trên sàn.
    *   **Then** Hệ thống gửi thông báo in-app thời gian thực và hiển thị booking mới đó ở đầu danh sách "Booking chờ phục vụ".

#### 3. Business Rules
*   Supplier bắt buộc phải phản hồi xác nhận trạng thái booking (Xác nhận còn phòng/Hết phòng) trong vòng tối đa 30 phút kể từ khi nhận được booking dạng cần xác nhận thủ công.

#### 4. Bảng danh sách yêu cầu M14

| ID | Tên yêu cầu | Mô tả chi tiết | Priority | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| **FR-M14-01** | Nhận & Quản lý booking | Xem danh sách chi tiết thông tin hành khách đặt dịch vụ của nhà cung cấp. | **Must Have** | Cho phép lọc theo mã PNR và ngày đi. |
| **FR-M14-02** | Quản lý lịch giá & phòng | Giao diện cập nhật nhanh số lượng phòng trống và giá bán cho từng ngày cụ thể. | **Must Have** | Tương tự giao diện của Booking.com extranet. |
| **FR-M14-03** | Yêu cầu đối soát thanh toán | Tạo yêu cầu thanh toán tiền thu hộ gửi cho Platform Admin khi kết thúc kỳ phục vụ. | **Should Have** | Đính kèm hóa đơn VAT đầu vào. |

---
--- KẾT THÚC TÀI LIỆU 1 ---

## PHẦN 2: NON-FUNCTIONAL REQUIREMENTS (YÊU CẦU PHI CHỨC NĂNG)

---

### NFR01 - Performance (Hiệu năng)
*   **Mô tả kỹ thuật**: Hệ thống phải đảm bảo xử lý các yêu cầu truy cập và giao dịch với độ trễ thấp để mang lại trải nghiệm mượt mà cho đại lý khi đang thao tác trực tiếp với khách hàng.
*   **Mục tiêu cụ thể**:
    *   Độ trễ phản hồi API thông thường (giao dịch ví, cập nhật thông tin): **< 200ms** (ở mức phân vị 95 - P95).
    *   API tìm kiếm chuyến bay/phòng khách sạn (có hit Cache): **< 500ms**.
    *   Thời gian xử lý luồng Checkout & Thanh toán: **< 1s**.
*   **Cách đo lường**: Sử dụng công cụ giám sát hiệu năng ứng dụng **APM (Application Performance Monitoring)** như Elastic APM, Grafana Prometheus kết hợp chạy thử nghiệm hiệu năng tự động bằng **k6** trước mỗi phiên bản deploy.
*   **Ghi chú**: Sử dụng cấu trúc bộ nhớ đệm Redis phân tầng (Caching Layer) để tối ưu tốc độ đọc dữ liệu tĩnh.

---

### NFR02 - Scalability (Khả năng co giãn)
*   **Mô tả kỹ thuật**: Hệ thống phải có khả năng tự động mở rộng tài nguyên phần cứng (CPU, RAM, số lượng pods) để đáp ứng tải khi lượng truy cập tăng đột biến trong mùa cao điểm du lịch.
*   **Mục tiêu cụ thể**:
    *   Hỗ trợ tối thiểu **1.000 người dùng hoạt động đồng thời (CCU)** không bị gián đoạn.
    *   Xử lý tối thiểu **10.000 giao dịch đặt chỗ (Bookings) thành công trên ngày**.
    *   Tự động mở rộng (Horizontal Auto-scaling) tài nguyên trong vòng 3 phút khi CPU sử dụng vượt mức 70%.
*   **Cách đo lường**: Chạy kiểm thử chịu tải giới hạn (Stress Test) và kiểm thử tăng đột biến tải (Spike Test) bằng công cụ **JMeter** giả lập 2.000 VUs truy cập đồng thời.
*   **Ghi chú**: Triển khai API backend dạng container chạy trên Kubernetes (hoặc AWS ECS) hỗ trợ cơ chế Horizontal Pod Autoscaler (HPA).

---

### NFR03 - Availability (Tính sẵn sàng)
*   **Mô tả kỹ thuật**: Đảm bảo hệ thống hoạt động liên tục 24/7, giảm thiểu tối đa thời gian downtime ngoài ý muốn gây tổn thất doanh thu của các đại lý.
*   **Mục tiêu cụ thể**:
    *   Tỷ lệ Uptime đạt tối thiểu **99.9%** hàng năm (tổng thời gian downtime không quá **8.76 giờ/năm**).
    *   Thời gian phát hiện và tự động chuyển đổi sang máy chủ dự phòng (Failover) **< 30 giây**.
*   **Cách đo lường**: Sử dụng công cụ theo dõi Uptime bên thứ ba (như UptimeRobot hoặc Pingdom) gọi kiểm tra HTTP GET đến endpoint `/health` của hệ thống mỗi 1 phút từ các khu vực địa lý khác nhau.
*   **Ghi chú**: Cấu hình cơ sở dữ liệu PostgreSQL ở chế độ High-Availability (Multi-AZ Replication) và thiết lập cân bằng tải (Load Balancer) trước các server API.

---

### NFR04 - Security (Bảo mật)
*   **Mô tả kỹ thuật**: Bảo vệ toàn vẹn thông tin tài chính của đại lý, thông tin cá nhân của khách hàng và ngăn chặn các cuộc tấn công mạng phá hoại.
*   **Mục tiêu cụ thể**:
    *   Đảm bảo bao phủ kiểm tra an toàn theo danh mục **OWASP Top 10** (không có lỗi SQL Injection, XSS, CSRF, IDOR).
    *   Toàn bộ luồng giao dịch truyền tải qua mạng bắt buộc mã hóa qua giao thức **HTTPS/TLS 1.3**.
    *   Token JWT được ký số bằng thuật toán bảo mật bất đối xứng **RS256** (khóa riêng tư giữ trên server, khóa công khai chia sẻ cho API Gateway).
    *   Mã hóa toàn bộ dữ liệu nhạy cảm lưu trữ trong DB bằng thuật toán đối xứng **AES-256**.
*   **Cách đo lường**: Thực hiện kiểm thử thâm nhập tự động (Vulnerability Scanning) hàng tháng bằng công cụ OWASP ZAP hoặc SonarQube Security Hotspots.
*   **Ghi chú**: Sử dụng thư viện bảo mật chính thức của Microsoft ASP.NET Core Identity.

---

### NFR05 - Data Integrity (Tính toàn vẹn dữ liệu)
*   **Mô tả kỹ thuật**: Đảm bảo tính nhất quán tuyệt đối của dữ liệu tài chính (ví đại lý, công nợ) và kho hàng (phòng khách sạn/vé xe), không xảy ra tình trạng trừ tiền nhưng không ghi nhận giao dịch hoặc overbooking.
*   **Mục tiêu cụ thể**:
    *   100% các giao dịch liên quan đến ví tiền và trừ kho hàng phải chạy dưới cơ chế **ACID database transaction**.
    *   Sử dụng cơ chế **Distributed Lock (Redis Redlock)** cho luồng Price Lock và giữ chỗ phòng để đảm bảo tính duy nhất khi có race condition.
*   **Cách đo lường**: Viết các bài test tích hợp (Integration Tests) giả lập luồng giao dịch đồng thời và kiểm tra tính nhất quán của số dư ví sau khi chạy test.
*   **Ghi chú**: Đặt cơ chế Isolation Level ở mức `Read Committed` hoặc `Serializable` trên database Postgres cho các câu lệnh thay đổi số dư ví.

---

### NFR06 - Maintainability (Khả năng bảo trì)
*   **Mô tả kỹ thuật**: Cấu trúc mã nguồn của hệ thống phải sạch sẽ, dễ hiểu, dễ sửa đổi và nâng cấp tính năng mới bởi các nhà phát triển khác nhau mà không làm phá vỡ các chức năng cũ.
*   **Mục tiêu cụ thể**:
    *   Độ bao phủ kiểm thử đơn vị (**Unit Test Coverage**) đạt tối thiểu **> 80%** trên toàn bộ các domain core logic.
    *   Tài liệu hóa API chi tiết với độ bao phủ tự động (**Swagger/OpenAPI Coverage**) đạt **> 90%** tổng số API Endpoints.
*   **Cách đo lường**: Kiểm tra tự động bằng công cụ **SonarQube** và công cụ đo phủ code test (`dotnet test /p:CollectCoverage=true`).
*   **Ghi chú**: Tuân thủ kiến trúc thiết kế **Clean Architecture** chia tách dự án thành 4 lớp rõ ràng: Domain, Application, Infrastructure và WebAPI.

---

### NFR07 - Compliance (Tính tuân thủ pháp lý)
*   **Mô tả kỹ thuật**: Hệ thống phải tuân thủ các quy định pháp luật hiện hành về bảo vệ quyền riêng tư cá nhân và bảo mật dữ liệu giao dịch thẻ.
*   **Mục tiêu cụ thể**:
    *   Tuân thủ luật bảo vệ dữ liệu cá nhân **PDPA** (Đại lý và khách hàng phải có quyền yêu cầu xóa vĩnh viễn thông tin cá nhân của họ khỏi hệ thống).
    *   Hệ thống không lưu trữ thông tin số thẻ tín dụng thô của người dùng trên DB để tuân thủ tiêu chuẩn bảo mật thẻ **PCI-DSS Level 4** (Ủy thác hoàn toàn việc lưu thẻ cho cổng thanh toán VNPay/Stripe xử lý qua Tokenization).
*   **Cách đo lường**: Kiểm toán tuân thủ (Compliance Audit) định kỳ 6 tháng một lần do bộ phận Legal của doanh nghiệp thực hiện.
*   **Ghi chú**: Toàn bộ luồng thanh toán thẻ tín dụng chạy qua IFrame hoặc Redirect URL của đối tác cổng thanh toán đạt chuẩn PCI-DSS Level 1.

---
--- KẾT THÚC TÀI LIỆU 2 ---

## PHẦN 3: CONSTRAINTS & ASSUMPTIONS (RÀNG BUỘC & GIẢ THUYẾT)

---

### 1. Ràng buộc kỹ thuật (Technical Constraints)
1.  **Ràng buộc hệ điều hành & Hosting**: Ứng dụng Backend viết bằng .NET 8 phải có khả năng biên dịch chéo và chạy ổn định trên môi trường container Linux (Alpine/Ubuntu) phục vụ việc triển khai Cloud VPS giá rẻ, không được phụ thuộc vào các thư viện độc quyền chạy trên hệ điều hành Windows Server IIS.
2.  **Ràng buộc cơ sở dữ liệu**: Chỉ sử dụng cơ sở dữ liệu quan hệ mã nguồn mở **PostgreSQL** để giảm chi phí bản quyền đồ án tốt nghiệp so với SQL Server hay Oracle. Mọi cấu trúc mở rộng động phải được xử lý qua cột kiểu dữ liệu `JSONB` của Postgres.
3.  **Ràng buộc tốc độ API bên thứ ba**: Hệ thống không kiểm soát được tốc độ phản hồi của API từ Supplier hoặc GDS gốc (độ trễ có thể lên tới 2-3 giây). Do đó, luồng xử lý Backend bắt buộc phải thiết kế theo cơ chế lập trình bất đồng bộ (**Asynchronous Programming / Async-Await**) và không được block luồng xử lý chính khi đợi phản hồi API ngoài.
4.  **Bảo mật dữ liệu trên ứng dụng di động**: App di động Flutter không được lưu trữ thông tin xác thực JWT Token thô trên bộ nhớ thông thường. Bắt buộc phải lưu trữ thông qua thư viện bảo mật phần cứng của hệ điều hành (**Flutter Secure Storage** / iOS Keychain / Android Keystore).

---

### 2. Ràng buộc kinh doanh (Business Constraints)
1.  **Giới hạn thời gian Giữ chỗ (Hold Time Limits)**: Nền tảng B2B phải tuân thủ thời gian giữ chỗ nghiêm ngặt của Supplier. Không được cấu hình thời gian hold trên sàn lâu hơn thời gian hold thực tế của nhà cung cấp gốc (Ví dụ: Vé máy bay gốc chỉ cho hold 20 phút, thì sàn chỉ được hiển thị đếm ngược cho đại lý tối đa là 15 phút để đảm bảo 5 phút đệm xử lý thanh toán xuất vé).
2.  **Ràng buộc quy định xuất hóa đơn VAT**: Theo quy định luật thuế Việt Nam, hóa đơn VAT dịch vụ du lịch chỉ được xuất và ký số trong vòng tối đa 7 ngày kể từ ngày booking chuyển sang trạng thái hoàn thành (`Completed`), hệ thống phải khóa chức năng yêu cầu xuất hóa đơn quá thời hạn này.
3.  **Hạn mức công nợ tối đa**: Tổng hạn mức nợ cấp cho toàn bộ hệ thống đại lý du lịch không được vượt quá số vốn ký quỹ thực tế của Platform Owner tại các hãng hàng không và chuỗi khách sạn để tránh rủi ro mất khả năng thanh toán hệ thống (Systemic Liquidity Risk).

---

### 3. Giả thuyết xây dựng hệ thống (Assumptions)
1.  **Độ tin cậy của Supplier APIs**: Giả thuyết rằng API của các nhà cung cấp hoặc GDS hỗ trợ endpoint kiểm tra tình trạng chỗ trống real-time (`Check Availability API`) hoạt động ổn định và chính xác trước khi gửi lệnh đặt giữ chỗ.
2.  **Uptime của Cổng thanh toán**: Giả định rằng cổng thanh toán VNPay có tỷ lệ Uptime dịch vụ Webhook/IPN đạt trên 99.99% để đảm bảo dòng tiền nạp ví đại lý được cộng tự động thời gian thực mà không gặp lỗi trễ giao dịch.
3.  **Sự đồng ý cung cấp vị trí GPS**: Giả định rằng nhân viên bàn giao dịch vụ (tài xế, hướng dẫn viên) đồng ý cấp quyền truy cập vị trí GPS trên thiết bị di động khi sử dụng ứng dụng di động Flutter để thực hiện việc quét mã check-in hành khách.
4.  **Hạ tầng mạng di động**: Giả thuyết rằng tại các điểm bàn giao dịch vụ du lịch phổ thông ở Việt Nam (Khách sạn trung tâm, ga tàu, cáp treo Bà Nà, cảng tàu Nha Trang) có phủ sóng mạng di động tối thiểu 3G/4G để phục vụ việc xác thực trạng thái voucher trực tuyến.

---
--- KẾT THÚC TÀI LIỆU 3 ---
