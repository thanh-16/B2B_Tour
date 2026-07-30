# TÀI LIỆU 2: ĐẶC TẢ YÊU CẦU PHẦN MỀM (SOFTWARE REQUIREMENTS SPECIFICATION - SRS)
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

---

## 1. CẤU TRÚC CHỨC NĂNG HỆ THỐNG (14 MODULES)

Hệ thống B2B Travel Platform được chia thành 14 modules chức năng chính đáp ứng toàn bộ quy trình đặt hàng và giao nhận dịch vụ khép kín:

*   **M01 - Authentication & RBAC**: Quản lý tài khoản đăng nhập, phân quyền người dùng (Admin, Agency Manager, Agency Staff, Supplier, Delivery Staff). Bao gồm luồng Onboarding riêng biệt cho Delivery Agent: Agency Manager tạo tài khoản tài xế, phân công hành trình cụ thể theo ngày — tài xế chỉ xem được danh sách đón khách của chuyến mình được phân công.
*   **M02 - Agent Onboarding & KYC**: Quy trình đăng ký tài khoản đại lý du lịch, tải lên hồ sơ pháp lý, phê duyệt KYC và cấu hình hạn mức tín dụng. Bổ sung cơ chế tái thẩm định KYC định kỳ 12 tháng/lần: hệ thống tự động gửi yêu cầu cập nhật giấy phép lữ hành 30 ngày trước ngày hết hạn; nếu quá hạn mà chưa cập nhật, tài khoản đại lý tự động chuyển sang trạng thái `SUSPENDED` cho đến khi nộp lại hồ sơ hợp lệ.
*   **M03 - Inventory Management**: Cập nhật kho tồn thực tế và bảng giá sỉ (khách sạn, vé máy bay, tour lẻ địa phương). **Quy tắc Price Freeze (Khóa giá)**: Giá của bất kỳ đơn hàng nào đã chuyển sang trạng thái `HELD`, `PENDING_SUPPLIER_APPROVAL`, `CONFIRMED` hoặc `PAID` được khóa cứng theo mức giá tại thời điểm giữ chỗ. Mọi thay đổi giá sỉ do Supplier cập nhật sau đó chỉ áp dụng cho các booking mới, không hồi tố vào đơn hàng đang xử lý.
*   **M04 - Search & Discovery Engine**: Bộ máy tìm kiếm dịch vụ đa tiêu chí, tự động cộng giá Markup cấu hình trước của đại lý.
*   **M05 - Shopping Cart & Price Lock**: Quản lý giỏ hàng tích hợp và cơ chế khóa giá dịch vụ trong thời gian ngắn (15 phút).
*   **M06 - Booking Engine**: Thực hiện giữ chỗ tạm thời (HELD), lấy mã PNR hãng bay, quản lý trạng thái booking.
*   **M07 - Wallet & Payment System**: Quản lý ví điện tử đại lý, số dư ví, hạn mức nợ và cổng thanh toán nạp ví VNPay.
*   **M08 - Invoicing & VAT Service**: Tự động sinh biên lai thanh toán và xuất hóa đơn VAT điện tử dạng PDF.
*   **M09 - Voucher Generator & QR Delivery**: Sinh E-Voucher chứa mã QR bảo mật động ký số và quét check-in đón khách ngoại tuyến.
*   **M10 - Notification Queue**: Hàng đợi gửi thông báo SMS, Email và thông báo đẩy (Web/App Push).
*   **M11 - After-Sales & Claims**: Tiếp nhận yêu cầu đổi ngày, hoàn tiền, hủy vé hoặc giải quyết tranh chấp dịch vụ.
*   **M12 - Reporting & Business Intelligence**: Thống kê doanh số, doanh thu và báo cáo tài chính đối soát.
*   **M13 - System Configuration**: Thiết lập tham số hệ thống, phí dịch vụ toàn sàn và nhật ký hệ thống (Audit Logs).
*   **M14 - Supplier Extranet Portal**: Cổng quản trị dành riêng cho nhà cung cấp theo dõi booking, duyệt đơn và đối soát tiền thu hộ.

---

### 1.1 Ma trận Yêu cầu chức năng (MoSCoW Matrix)

| ID | Module | Tên yêu cầu chức năng | Mô tả tóm tắt | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **FR-01** | Auth | Đăng nhập & Phân quyền | Đăng nhập, cấp Token phiên và phân quyền 5 vai trò. | **Must Have** |
| **FR-02** | Onboard | Phê duyệt KYC đại lý | Đăng ký thông tin đại lý, phê duyệt tài liệu kinh doanh. | **Must Have** |
| **FR-03** | Inventory | Cấu hình kho chỗ | Supplier cập nhật số lượng phòng và chỗ trống tour theo lịch. | **Must Have** |
| **FR-04** | Search | Tìm kiếm cộng giá tự động | Tìm kiếm thời gian thực, tự động tính giá đã cộng Markup. | **Must Have** |
| **FR-05** | Cart | Khóa giữ giá giỏ hàng | Khóa giá bán của dịch vụ bay/phòng trong 15 phút. | **Must Have** |
| **FR-06** | Booking | Tạo mã giữ chỗ tạm (Hold PNR) | Sinh đơn hàng giữ chỗ, tự giải phóng kho nếu hết hạn. | **Must Have** |
| **FR-07** | Payment | Thanh toán qua Ví nội bộ | Rút tiền ví đại lý để thanh toán, kiểm tra hạn mức khả dụng. | **Must Have** |
| **FR-08** | Invoicing | Sinh hóa đơn VAT PDF | Tự động biên dịch xuất hóa đơn PDF lưu trữ trên mây. | **Must Have** |
| **FR-09** | Delivery | Quét mã QR check-in offline | Quét camera verify chữ ký số voucher không cần internet. | **Must Have** |
| **FR-10** | Notification| Gửi thông báo tự động | SMS/Email nhắc nhở hết hạn thanh toán hoặc đổi trạng thái. | **Should Have**|
| **FR-11** | After-sales | Yêu cầu hoàn/hủy/phạt | Gửi khiếu nại chất lượng hoặc yêu cầu hủy phạt tiền. | **Must Have** |
| **FR-12** | Reporting | Báo cáo tài chính & Export | Xem báo cáo dòng tiền ví, xuất dữ liệu dạng Excel. | **Must Have** |
| **FR-13** | Admin | Nhật ký hệ thống (Audit Log) | Lưu vết hoạt động thay đổi cấu hình, cộng tiền ví thủ công. | **Must Have** |
| **FR-14** | Supplier | Cổng Extranet | Supplier duyệt đơn hàng, cập nhật lịch chạy xe đón khách. | **Must Have** |

---

## 2. ĐẶC TẢ CHI TIẾT USE CASE CHÍNH (USE CASE SPECIFICATIONS)

Dưới đây là đặc tả chi tiết 8 Use Case cốt lõi nhất của hệ thống thể hiện logic nghiệp vụ sâu sắc của phần mềm.

### 2.1 Use Case 1: Giữ chỗ tạm thời (Hold Booking)

*   **Use Case ID**: UC-BOOKING-01
*   **Tên Use Case**: Giữ chỗ tạm thời (Hold Booking)
*   **Tác nhân (Actor)**: Agency Staff (Nhân viên đại lý du lịch)
*   **Mục tiêu**: Đặt giữ chỗ tạm thời một hoặc nhiều dịch vụ du lịch (vé máy bay, phòng khách sạn) để khóa vị trí trống và khóa giá bán trong khi chờ khách chuyển khoản.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Nhân viên đại lý đã đăng nhập thành công vào ứng dụng di động.
    2.  Dịch vụ trong giỏ hàng vẫn còn chỗ trống hợp lệ trong cơ sở dữ liệu.
*   **Hậu điều kiện (Post-conditions)**:
    1.  Một đơn đặt hàng ở trạng thái `HELD` được tạo ra trong hệ thống.
    2.  Số lượng chỗ trống trong bảng quản lý kho tồn (Inventory) bị khấu trừ tương ứng.
    3.  Mã đặt chỗ tạm thời (PNR) được trả về cho đại lý kèm theo đồng hồ đếm ngược thời hạn thanh toán.
    4.  Một tác vụ dọn dẹp tự động quá hạn giữ chỗ được lập lịch chạy ngầm.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor nhấn nút "Tiến hành Giữ chỗ" từ màn hình chi tiết giỏ hàng. | Hệ thống yêu cầu xác nhận thông tin hành khách đi đoàn. |
| **2** | Actor nhập đầy đủ thông tin hành khách (Họ tên, Số hộ chiếu/CCCD, Ngày sinh) và bấm xác nhận. | Hệ thống kiểm tra tính hợp lệ của thông tin nhập vào (định dạng tên không chứa ký tự đặc biệt). |
| **3** | | Hệ thống thực hiện kiểm tra kho chỗ trống thực tế. |
| **4** | | Hệ thống kích hoạt khóa phân tán để bảo vệ tài nguyên kho chỗ. |
| **5** | | Hệ thống trừ số lượng kho trống, lưu bản ghi booking mới ở trạng thái `HELD` kèm mã PNR tự sinh. |
| **6** | | Hệ thống trả về màn hình xác nhận giữ chỗ thành công, hiển thị thời hạn đếm ngược (Hold Expiry) là 15 phút. |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng rẽ nhánh A (Giữ chỗ dịch vụ cần duyệt - On-Request)**:
    *   *Tại bước 3*: Nếu giỏ hàng có chứa tour local đặc thù được cấu hình ở trạng thái "Cần duyệt trước" (On-Request):
    *   *Hệ thống*: Không tạo giữ chỗ tự động sang hãng bay bên thứ 3. Hệ thống thực hiện theo thứ tự:
        1.  **Khóa tiền ví tạm thời (Reserve Balance)**: Hệ thống khấu trừ số tiền tương ứng giá trị đơn hàng vào trường `reserved_balance` của ví đại lý, giảm `available_balance = balance - reserved_balance` để ngăn đại lý dùng số tiền này cho giao dịch khác trong thời gian chờ duyệt.
        2.  Tạo booking ở trạng thái `PENDING_SUPPLIER_APPROVAL`, gửi thông báo đẩy khẩn cấp sang cổng Extranet của Supplier sở hữu tour và hiển thị thời hạn chờ phản hồi tối đa là **3 tiếng** (tính từ lúc gửi yêu cầu, nhưng không được vượt quá mốc Cut-off Time 21:00 đêm hôm trước ngày đi).
        3.  Thời gian chờ duyệt hiệu lực = **MIN(giờ gửi + 3h, 21:00 đêm hôm trước)**.
*   **Luồng ngoại lệ B (Hết kho trống đồng thời - Race Condition)**:
    *   *Tại bước 3*: Nếu trong quá trình kiểm tra, hệ thống phát hiện số lượng chỗ trống thực tế đã giảm xuống thấp hơn số lượng yêu cầu do có một đại lý khác thanh toán trước đó một tích tắc.
    *   *Hệ thống*: Giải phóng khóa phân tán, thông báo lỗi: "Xin lỗi, dịch vụ vừa hết chỗ. Vui lòng chọn dịch vụ khác" và trả người dùng về trang giỏ hàng để cập nhật thông tin.

---

### 2.2 Use Case 2: Thanh toán từ ví đại lý (Wallet Payment)

*   **Use Case ID**: UC-PAYMENT-01
*   **Tên Use Case**: Thanh toán từ ví đại lý (Wallet Payment)
*   **Tác nhân (Actor)**: Agency Staff (Nhân viên) hoặc Agency Manager (Chủ đại lý)
*   **Mục tiêu**: Sử dụng số dư ví điện tử nội bộ hoặc hạn mức tín dụng công nợ để thanh toán dứt điểm đơn hàng đang giữ chỗ (HELD) và kích hoạt xuất vé/voucher chính thức.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Booking đang ở trạng thái `HELD` và chưa quá giờ hết hạn giữ chỗ.
    2.  Tài khoản đại lý có trạng thái hoạt động bình thường (`ACTIVE`).
*   **Hậu điều kiện (Post-conditions)**:
    1.  Số dư ví đại lý bị trừ số tiền tương ứng với giá trị đơn hàng.
    2.  Một bản ghi nhật ký giao dịch tài chính (Wallet Transaction Ledger) được ghi lại vĩnh viễn.
    3.  Trạng thái booking chuyển sang `PAID` (Đã thanh toán).
    4.  Mã QR E-Voucher được kích hoạt sinh tự động và gửi email cho khách.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor mở chi tiết đơn hàng `HELD` và bấm nút "Thanh toán bằng ví". | Hệ thống yêu cầu người dùng xác nhận hành động bằng cách nhập mã PIN bảo mật hoặc sinh trắc học. |
| **2** | Actor nhập mã PIN xác thực. | Hệ thống kiểm tra mã PIN. Nếu đúng, hệ thống sinh một mã giao dịch duy nhất đính kèm vào yêu cầu. |
| **3** | | Hệ thống thực hiện khóa dòng tài khoản ví của đại lý đó trong database để ngăn chặn truy cập song song. |
| **4** | | Hệ thống tính toán Hạn mức khả dụng = Số dư thực tế + Hạn mức nợ cho phép. |
| **5** | | Hệ thống đối chiếu: Hạn mức khả dụng >= Giá trị đơn hàng thanh toán. |
| **6** | | Hệ thống trừ số tiền tương ứng vào số dư ví, ghi log lịch sử giao dịch và đổi trạng thái booking sang `PAID`. |
| **7** | | Hệ thống giải phóng khóa dòng database và hiển thị màn hình thanh toán thành công kèm theo đường link tải vé E-Voucher PDF. |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng ngoại lệ A (Không đủ số dư ví - Insufficient Funds)**:
    *   *Tại bước 5*: Nếu Hạn mức khả dụng của đại lý nhỏ hơn giá trị đơn hàng cần thanh toán.
    *   *Hệ thống*: Dừng transaction, rollback toàn bộ thay đổi, thông báo lỗi: "Số dư ví không đủ để thanh toán. Vui lòng nạp tiền vào ví hoặc liên hệ quản trị viên để nâng hạn mức tín dụng" và đưa người dùng về màn hình chi tiết đơn hàng.
*   **Luồng ngoại lệ B (Trùng lặp yêu cầu thanh toán - Double Submit Prevention)**:
    *   *Tại bước 2*: Nếu hệ thống nhận diện mã Idempotency Key (Mã giao dịch trùng lặp gửi lên do lag mạng) đã tồn tại trong hàng đợi xử lý.
    *   *Hệ thống*: Từ chối xử lý yêu cầu mới, trả về mã lỗi xung đột hệ thống và hiển thị kết quả của yêu cầu thanh toán đầu tiên đã xử lý thành công.

---

### 2.3 Use Case 3: Duyệt Tour đặc thù (Supplier Approval)

*   **Use Case ID**: UC-SUPPLIER-01
*   **Tên Use Case**: Duyệt Tour đặc thù (Supplier Approval)
*   **Tác nhân (Actor)**: Supplier (Nhà cung cấp dịch vụ địa phương)
*   **Mục tiêu**: Supplier tiếp nhận yêu cầu đặt tour lẻ từ đại lý, kiểm tra năng lực vận hành thực tế (xe đón, hướng dẫn viên) để phê duyệt hoặc từ chối đơn hàng.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Booking chứa dịch vụ tour lẻ địa phương đã được tạo ở trạng thái `PENDING_SUPPLIER_APPROVAL`.
    2.  Đơn hàng chưa quá giờ giới hạn khóa sổ (Cut-off Time) quy định của sản phẩm.
*   **Hậu điều kiện (Post-conditions)**:
    1.  Trạng thái booking được cập nhật thành `CONFIRMED` (được duyệt) hoặc `CANCELLED` (bị từ chối).
    2.  **Thực thu tiền** (nếu duyệt): Hệ thống chuyển số tiền đang trong `reserved_balance` sang khấu trừ chính thức, ghi nhận giao dịch vào Wallet Ledger và xóa số tiền khỏi `reserved_balance`.
    3.  **Giải phóng tiền** (nếu từ chối): Hệ thống hoàn trả số tiền từ `reserved_balance` về `balance` thực tế của ví đại lý, `reserved_balance` về 0.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor đăng nhập vào Web Portal/App Supplier và mở danh sách "Đơn hàng chờ duyệt". | Hệ thống hiển thị danh sách đơn đặt tour kèm theo thời gian đếm ngược giới hạn duyệt. |
| **2** | Actor chọn một đơn hàng cụ thể, kiểm tra thông tin số lượng khách, điểm đón và bấm nút "Phê duyệt đơn hàng". | Hệ thống yêu cầu xác nhận phê duyệt. |
| **3** | Actor bấm nút "Xác nhận". | Hệ thống đổi trạng thái đơn hàng sang `CONFIRMED`. |
| **4** | | Hệ thống chuyển số tiền tạm khóa trong ví của đại lý đặt hàng sang trạng thái khấu trừ chính thức. |
| **5** | | Hệ thống gửi thông báo đẩy đến đại lý thông báo đơn hàng đã được đối tác phê duyệt thành công. |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng rẽ nhánh A (Từ chối duyệt đơn hàng - Supplier Rejection)**:
    *   *Tại bước 2*: Nếu Supplier kiểm tra thực tế thấy hết xe hoặc trùng lịch trình chạy, Supplier bấm nút "Từ chối".
    *   *Hệ thống*: Yêu cầu Supplier nhập lý do từ chối (ví dụ: Hết phương tiện đón khách, Thời tiết xấu).
    *   *Hệ thống*: Đổi trạng thái booking sang `CANCELLED`, ghi nhận lý do từ chối.
    *   *Hệ thống*: Tự động giải phóng hoàn trả số tiền ví đang tạm khóa của đại lý đặt hàng, gửi cảnh báo SMS thông báo hủy đơn cho đại lý.
*   **Luồng ngoại lệ B (Hết giờ duyệt tự động - Auto Cancel on Timeout)**:
    *   *Tại bước 1*: Nếu quá mốc giờ quy định duyệt đơn (ví dụ: mốc 21:00 tối trước ngày đi, hoặc quá 3 tiếng kể từ khi gửi đơn đặt đêm).
    *   *Hệ thống*: Tác vụ ngầm quét và tự động chuyển trạng thái đơn hàng sang `CANCELLED` với lý do "Hệ thống tự động hủy do đối tác không phê duyệt đúng hạn", giải phóng số tiền ví đại lý và gửi cảnh báo vi phạm tỷ lệ duyệt cho Supplier.

---

### 2.4 Use Case 4: Quét QR Check-in ngoại tuyến (Offline QR Verification)

*   **Use Case ID**: UC-DELIVERY-01
*   **Tên Use Case**: Quét QR Check-in ngoại tuyến (Offline QR Verification)
*   **Tác nhân (Actor)**: Delivery Staff (Tài xế / Hướng dẫn viên du lịch)
*   **Mục tiêu**: Quét mã QR voucher của khách hàng tại điểm đón để xác nhận dịch vụ bàn giao hợp lệ, ghi nhận tọa độ GPS check-in mà không cần thiết bị di động có kết nối internet 4G/Wifi.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Thiết bị di động của tài xế đã được đồng bộ danh sách đón khách và khóa bảo mật mật mã (Shared Secret Key) từ sáng khi có mạng.
    2.  Khách hàng trình diện mã QR Voucher còn thời hạn sử dụng trên điện thoại.
*   **Hậu điều kiện (Post-conditions)**:
    1.  Bản ghi check-in offline gồm mã voucher, thời gian, tọa độ GPS được lưu trữ vào bộ nhớ cục bộ của app di động.
    2.  Khách hàng được xác nhận hợp lệ và lên xe bắt đầu hành trình.
    3.  Lịch sử check-in được đưa vào hàng đợi chờ đồng bộ tự động khi thiết bị online trở lại.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor mở App di động quét voucher chọn chức năng "Quét mã QR offline" và hướng camera vào mã QR của khách. | Hệ thống kích hoạt camera quét mã và bóc tách dữ liệu chuỗi JSON trong QR. |
| **2** | | Hệ thống đọc các trường thông tin: Mã Voucher, Mã Đặt chỗ, Ngày hết hạn, và Signature chữ ký số. |
| **3** | | Hệ thống tự động tính toán lại Signature cục bộ bằng thuật toán HMAC-SHA256 kết hợp Shared Secret Key lưu trong bộ nhớ máy. |
| **4** | | Hệ thống đối chiếu Signature tự tính và Signature đọc được từ QR. Nếu trùng khớp, hệ thống kiểm tra tiếp ngày đi có khớp với hôm nay không. |
| **5** | | Hệ thống báo rung và hiển thị màn hình tích xanh: "Xác thực thành công. Số ghế: 12. Tên khách: Nguyễn Văn A". |
| **6** | | Hệ thống ghi nhận log check-in offline kèm tọa độ vị trí GPS hiện tại của điện thoại vào cơ sở dữ liệu local (Hive DB). |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng ngoại lệ A (Chữ ký số không khớp - Invalid Signature)**:
    *   *Tại bước 4*: Nếu Signature tính toán không khớp với Signature trên QR (do khách hàng tự sửa đổi chuỗi thông tin bằng phần mềm bên ngoài).
    *   *Hệ thống*: Báo âm thanh cảnh báo lỗi và hiển thị màn hình đỏ: "Cảnh báo: Vé giả mạo hoặc thông tin vé đã bị chỉnh sửa trái phép!".
*   **Luồng ngoại lệ B (Mã QR hết hạn động - Dynamic QR Expired)**:
    *   *Tại bước 4*: Nếu thời gian tạo mã QR động lưu trong trường dữ liệu (`t`) lệch quá 5 phút so với đồng hồ thời gian của thiết bị quét (do khách dùng ảnh chụp màn hình cũ từ hôm trước).
    *   *Hệ thống*: Từ chối xác thực, hiển thị thông báo lỗi: "Mã QR đã hết hiệu lực. Yêu cầu khách hàng mở trực tiếp ứng dụng để lấy mã QR mới".

---

### 2.5 Use Case 5: Đăng ký đại lý & Phê duyệt KYC (Agency Onboarding & KYC Approval)

*   **Use Case ID**: UC-ONBOARD-01
*   **Tên Use Case**: Đăng ký đại lý & Phê duyệt KYC
*   **Tác nhân (Actor)**: Agency Manager (Chủ đại lý đăng ký), Platform Admin (Quản trị viên sàn)
*   **Mục tiêu**: Đăng ký thông tin đại lý mới vào hệ thống, nộp các giấy tờ pháp lý (giấy phép kinh doanh lữ hành, mã số thuế) để sàn phê duyệt kích hoạt tài khoản và cấp hạn mức tín dụng ban đầu.
*   **Tiền điều kiện (Pre-conditions)**:
    *   Đại lý chưa có tài khoản trên hệ thống.
*   **Hậu điều kiện (Post-conditions)**:
    1.  Tài khoản đại lý được tạo ở trạng thái hoạt động (`ACTIVE`).
    2.  Số dư ví khởi tạo bằng 0đ, hạn mức tín dụng công nợ được cấp theo cấu hình.
    3.  Tài khoản quản trị viên của đại lý được phân quyền thành công để bắt đầu tuyển nhân viên.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Agency Manager mở trang đăng ký đại lý trên Web Portal, nhập tên doanh nghiệp, mã số thuế, địa chỉ và thông tin liên hệ. | Hệ thống kiểm tra trùng lặp mã số thuế trong cơ sở dữ liệu. |
| **2** | Actor tải lên ảnh chụp Giấy phép Đăng ký kinh doanh và Giấy phép kinh doanh lữ hành dạng PDF. | Hệ thống ghi nhận các file tài liệu và lưu tạm tài khoản ở trạng thái chờ duyệt `PENDING_KYC`. |
| **3** | Platform Admin đăng nhập vào hệ thống quản trị sàn, mở danh sách "Hồ sơ KYC chờ duyệt". | Hệ thống hiển thị hồ sơ chi tiết của doanh nghiệp vừa đăng ký cùng file đính kèm. |
| **4** | Admin đối chiếu thông tin pháp lý bên ngoài, bấm nút "Phê duyệt KYC" và nhập số hạn mức tín dụng được cấp (ví dụ: 20.000.000đ). | Hệ thống yêu cầu Admin xác nhận hành động. |
| **5** | Admin bấm xác nhận. | Hệ thống chuyển trạng thái đại lý sang `ACTIVE`, tự cập nhật hạn mức tín dụng công nợ. |
| **6** | | Hệ thống tự động gửi email thông báo kích hoạt tài khoản kèm thông tin đăng nhập ban đầu cho Agency Manager. |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng rẽ nhánh A (Từ chối hồ sơ KYC - Reject Onboarding)**:
    *   *Tại bước 4*: Nếu Admin phát hiện giấy phép lữ hành đã hết hạn hoặc thông tin đăng ký không khớp. Admin bấm nút "Từ chối".
    *   *Hệ thống*: Yêu cầu nhập lý do từ chối phê duyệt hồ sơ.
    *   *Hệ thống*: Chuyển trạng thái đại lý sang `REJECTED`, gửi email thông báo từ chối kèm lý do chi tiết để đại lý chỉnh sửa và nộp lại hồ sơ.

---

### 2.6 Use Case 6: Tìm kiếm dịch vụ & Tự động cộng giá Markup (Search & Markup)

*   **Use Case ID**: UC-SEARCH-01
*   **Tên Use Case**: Tìm kiếm dịch vụ & Tự động cộng giá Markup
*   **Tác nhân (Actor)**: Agency Staff (Nhân viên sales đại lý)
*   **Mục tiêu**: Tìm kiếm chuyến bay hoặc khách sạn trống theo các tiêu chí lựa chọn, hệ thống tự động cộng thêm mức giá chênh lệch cấu hình trước (Markup) để hiển thị giá bán cuối cùng cho nhân viên sales báo giá cho khách lẻ.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Actor đăng nhập app thành công.
    2.  Đại lý đã cấu hình trước công cụ Markup (ví dụ: cộng thêm 5% giá khách sạn hoặc cộng 50.000đ/vé máy bay).
    3.  **Ràng buộc Markup hợp lệ**: Tỷ lệ Markup phần trăm phải nằm trong khoảng từ **0% đến mức tối đa Platform Admin quy định** cho từng loại dịch vụ (mặc định tối đa 50%). Markup cố định âm (giảm giá dưới giá gốc) bị hệ thống từ chối lưu cấu hình.
*   **Hậu điều kiện (Post-conditions)**:
    *   Hiển thị danh sách dịch vụ kèm mức giá bán cuối cùng đã được tính toán Markup, ẩn đi mức giá gốc (Net Price) của nhà cung cấp.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor nhập tiêu chí tìm kiếm phòng (Địa điểm: "Nha Trang", Ngày đi: 25/06/2026, Số đêm: 2, Số khách: 2) và bấm nút "Tìm kiếm". | Hệ thống gửi truy vấn tìm kiếm đồng thời xuống database cục bộ và gọi API các Supplier bên ngoài. |
| **2** | | Hệ thống tiếp nhận danh sách kết quả gồm mã phòng và giá gốc (Net Price). |
| **3** | | Hệ thống kiểm tra cấu hình Markup hiện tại của đại lý này trong database. |
| **4** | | Hệ thống tính toán: Giá hiển thị = Giá gốc * (1 + Tỷ lệ % Markup) + Số tiền Markup cố định. |
| **5** | | Hệ thống trả về danh sách kết quả tìm kiếm trên giao diện hiển thị duy nhất giá bán cuối cùng, có công cụ chuyển đổi nhanh để nhân viên bật/tắt xem giá sỉ Net gốc nếu cần thiết. Giá hiển thị luôn >= giá gốc (hệ thống cảnh báo nếu cấu hình Markup dẫn đến giá bán thấp hơn giá Net). |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng ngoại lệ A (Lỗi API kết nối Supplier bên ngoài - Provider Timeout)**:
    *   *Tại bước 2*: Nếu API của một hãng hàng không đối tác bị timeout (quá 8 giây không phản hồi).
    *   *Hệ thống*: Ngắt kết nối gọi hãng đó, vẫn trả về kết quả tìm kiếm phòng khách sạn và vé máy bay của các hãng khác hoạt động bình thường mà không báo lỗi sập toàn bộ trang.

---

### 2.7 Use Case 7: Nạp tiền ví đại lý qua VNPay (Wallet Top-up via VNPay)

*   **Use Case ID**: UC-WALLET-01
*   **Tên Use Case**: Nạp tiền ví đại lý qua VNPay
*   **Tác nhân (Actor)**: Agency Manager (Chủ đại lý)
*   **Mục tiêu**: Khởi tạo yêu cầu nạp tiền vào ví đại lý trực tuyến qua liên kết cổng thanh toán VNPay và được cộng số dư tự động ngay sau khi thanh toán thành công.
*   **Tiền điều kiện (Pre-conditions)**:
    *   Đại lý ở trạng thái hoạt động (`ACTIVE`).
*   **Hậu điều kiện (Post-conditions)**:
    1.  Yêu cầu nạp tiền chuyển từ trạng thái `PENDING` sang `SUCCESS`.
    2.  Số dư ví đại lý tăng lên tương ứng số tiền nạp thực tế (trừ phí giao dịch nếu có).
    3.  Thông báo nạp tiền thành công được đẩy về điện thoại.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor mở mục tài chính chọn chức năng "Nạp tiền ví", nhập số tiền cần nạp (ví dụ: 10.000.000đ), chọn phương thức VNPay và nhấn "Tạo mã thanh toán". | Hệ thống ghi nhận yêu cầu nạp tiền ở trạng thái `PENDING` kèm mã giao dịch duy nhất trong DB. |
| **2** | | Hệ thống gọi API cổng thanh toán VNPay để nhận chuỗi ký link chuyển hướng thanh toán (URL). |
| **3** | | Hệ thống chuyển hướng giao diện của Actor sang trang thanh toán VNPay hiển thị mã QR thanh toán ngân hàng. |
| **4** | Actor mở ứng dụng Mobile Banking quét mã QR và thực hiện xác nhận trừ tiền ngân hàng thành công. | Cổng VNPay tiếp nhận thanh toán thành công, gọi Webhook IPN sang hệ thống Platform báo mã giao dịch khớp trạng thái. |
| **5** | | Hệ thống nhận gói tin Webhook, kiểm tra chữ ký mã hóa checksum bảo mật, thực hiện giao dịch cộng tiền ví đại lý và cập nhật trạng thái yêu cầu nạp sang `SUCCESS`. |
| **6** | | Hệ thống trả Actor về giao diện app đại lý, hiển thị màn hình thông báo: "Đã nạp thành công 10.000.000đ vào ví". |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng ngoại lệ A (Hủy giao dịch nạp tiền - User Cancel top-up)**:
    *   *Tại bước 4*: Nếu Actor bấm nút hủy giao dịch trên trang VNPay hoặc tắt trình duyệt không thanh toán.
    *   *Hệ thống*: VNPay trả Actor về trang callback báo hủy giao dịch. Hệ thống cập nhật trạng thái yêu cầu nạp tiền sang `CANCELLED`, giải phóng dòng và đưa đại lý về trang quản lý số dư ví.

---

### 2.8 Use Case 8: Yêu cầu Đổi ngày / Hoàn tiền đơn hàng (Refund & Change Request)

*   **Use Case ID**: UC-CLAIM-01
*   **Tên Use Case**: Yêu cầu Đổi ngày / Hoàn tiền đơn hàng
*   **Tác nhân (Actor)**: Agency Staff (Nhân viên đại lý), Platform Admin (Quản trị viên sàn)
*   **Mục tiêu**: Đại lý gửi yêu cầu hủy dịch vụ hoàn tiền hoặc thay đổi ngày khởi hành đơn hàng do yêu cầu từ khách lẻ, hệ thống tự động tính phí phạt hủy theo chính sách của nhà cung cấp và hoàn tiền ví tự động khi được duyệt.
*   **Tiền điều kiện (Pre-conditions)**:
    1.  Booking đang ở trạng thái `PAID` hoặc `CONFIRMED`.
    2.  Dịch vụ nằm trong điều khoản cho phép hoàn/hủy quy định của sản phẩm.
*   **Hậu điều kiện (Post-conditions)**:
    1.  Đơn đặt hàng cập nhật trạng thái thành `REFUNDED` hoặc cập nhật ngày đi mới.
    2.  Số dư ví đại lý được cộng lại số tiền sau khi đã trừ đi phí phạt hủy quy định.
    3.  Kho chỗ được giải phóng hoàn trả lại hệ thống.

#### Luồng xử lý chính (Basic Flow)

| Bước | Hành động của Actor | Phản hồi của Hệ thống |
| :--- | :--- | :--- |
| **1** | Actor mở chi tiết đơn hàng đã đặt, nhấn nút "Gửi yêu cầu sau bán hàng", chọn loại yêu cầu: "Yêu cầu hủy hoàn tiền". | Hệ thống kiểm tra điều khoản chính sách hủy phòng/vé của sản phẩm đó trong DB. |
| **2** | | Hệ thống hiển thị số tiền phạt hủy dự tính theo quy định (ví dụ: hủy trước 3 ngày phạt 10%, hủy trong 24h phạt 100%). |
| **3** | Actor đồng ý với mức phí phạt và bấm xác nhận gửi yêu cầu hủy đơn. | Hệ thống chuyển trạng thái booking sang `PENDING_REFUND`, **giải phóng kho chỗ tương ứng**, và **gọi API GDS hủy mã giữ chỗ PNR** (đối với vé máy bay đã xuất), đồng thời **gửi thông báo hủy phòng/chỗ sang Supplier** để Supplier cập nhật lại kho tồn. |
| **4** | Platform Admin mở trang quản trị phê duyệt yêu cầu hoàn tiền, kiểm tra thông tin và nhấn "Xác nhận duyệt hoàn tiền". | Hệ thống thực hiện transaction: tự động hoàn trả số tiền còn lại (Giá trị đơn hàng - Phí phạt hủy) vào số dư ví của đại lý. |
| **5** | | Hệ thống chuyển trạng thái booking sang `REFUNDED`, ghi nhật ký giao dịch biến động ví cộng tiền, gửi email thông báo hoàn tiền ví cho đại lý và email xác nhận hủy cho Supplier. |

#### Luồng rẽ nhánh & Ngoại lệ (Alternative & Exception Flows)

*   **Luồng ngoại lệ A (Đơn hàng không cho phép hủy hoàn - Non-refundable)**:
    *   *Tại bước 1*: Nếu booking được đặt ở chế độ giá sỉ khuyến mãi đặc biệt ghi rõ chính sách "Không hoàn hủy (Non-refundable)".
    *   *Hệ thống*: Khóa nút gửi yêu cầu hủy hoàn tiền trên giao diện, hiển thị thông báo: "Đơn đặt hàng này áp dụng chính sách không được phép hủy hoàn dưới mọi hình thức."

---

## 3. YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS - NFR)

*   **NFR-01: Hiệu năng xử lý (Performance)**:
    *   Thời gian phản hồi trung bình (Response Time) của các API tìm kiếm dịch vụ có cache tĩnh phải dưới **500ms**.
    *   Thời gian xử lý giao dịch thanh toán trừ ví và ghi nhận sổ cái không được vượt quá **1 giây** trong điều kiện mạng bình thường.
*   **NFR-02: Khả năng mở rộng (Scalability)**:
    *   Hệ thống có khả năng hỗ trợ tối thiểu **1.000 người dùng hoạt động đồng thời (CCU)** tại giờ cao điểm.
    *   Tầng cơ sở dữ liệu có khả năng xử lý **10.000 đơn hàng giữ chỗ mỗi ngày** không gây nghẽn kết nối.
*   **NFR-03: Độ sẵn sàng (Availability)**:
    *   Tỷ lệ hoạt động ổn định của dịch vụ (Uptime) đạt mức tối thiểu **99.9%** hàng năm.
    *   Thiết bị di động của tài xế phải vận hành ổn định chế độ quét offline 100% không bị crash bộ nhớ tạm.
    *   Sau khi thiết bị tài xế khôi phục kết nối mạng, toàn bộ log check-in offline phải được đồng bộ lên Server trong vòng tối đa **60 giây**.
*   **NFR-04: Tính bảo mật thông tin (Security)**:
    *   Toàn bộ luồng kết nối API giữa Client và Server bắt buộc phải mã hóa bằng giao thức HTTPS (TLS 1.3).
    *   Thông tin mật khẩu người dùng phải được mã hóa bằng thuật toán băm bảo mật một chiều trước khi ghi xuống database.
    *   Mã xác thực giao dịch tài chính (Idempotency Key) phải được tự động làm sạch khỏi Redis sau 10 phút để tránh tấn công phát lại.
    *   Mỗi Delivery Agent được cấp **Shared Secret Key riêng biệt (Per-driver Key)** thay vì một khóa chung toàn hệ thống. Key được tự động xoay vòng (Key Rotation) mỗi 24 giờ. Khi tài xế mất thiết bị, Admin thu hồi key ngay lập tức; key bị vô hiệu hóa sẽ khiến toàn bộ mã QR đang lưu trên thiết bị đó không còn hiệu lực.
    *   Hệ thống áp dụng **Rate Limiting** theo Agency ID: tối đa 10 yêu cầu thanh toán/phút và 100 yêu cầu tìm kiếm/phút trên mỗi tài khoản đại lý. Mã PIN thanh toán bị khóa sau **5 lần nhập sai liên tiếp**.
*   **NFR-05: Tính toàn vẹn dữ liệu (Data Integrity)**:
    *   Tất cả các giao dịch tài chính liên quan đến biến động số dư ví đại lý phải đảm bảo tính chất **ACID** (Atomicity, Consistency, Isolation, Durability) tuyệt đối.
    *   Sổ cái lịch sử ví phải lưu trữ dưới dạng chỉ cho phép thêm mới (Append-Only), không hỗ trợ thao tác cập nhật (Update) hoặc xóa vật lý (Delete).
    *   Sau mỗi giao dịch biến động ví, hệ thống thực hiện **kiểm tra nhất quán tức thời (Real-time Balance Assertion)**: Tính lại `balance` từ toàn bộ Ledger và so sánh với giá trị `balance` đang lưu trong bảng tài khoản. Nếu phát hiện lệch, hệ thống tự động khóa ví và gửi cảnh báo khẩn cấp ngay lập tức mà không chờ đến tiến trình đối soát ban đêm.
*   **NFR-06: Tích hợp bên thứ ba (Third-party Integration SLA)**:
    *   Tỷ lệ thành công giữ chỗ GDS (PNR Hold Success Rate) phải duy trì tối thiểu **95%** trong điều kiện vận hành bình thường.
    *   Circuit Breaker tự động kích hoạt sau **5 lỗi liên tiếp trong 1 phút**, ngắt kết nối API đối tác trong **30 giây** trước khi thử lại. Hệ thống không được báo lỗi sập toàn bộ giao diện — chỉ ẩn kết quả của nhà cung cấp đang gặp sự cố.

---

## 4. RÀNG BUỘC THIẾT KẾ & GIẢ THUYẾT HỆ THỐNG

### 4.1 Ràng buộc thiết kế (Design Constraints)
1.  **Ràng buộc cơ sở dữ liệu quan hệ**: Hệ thống bắt buộc phải sử dụng cơ sở dữ liệu quan hệ mã nguồn mở PostgreSQL để thiết lập các ràng buộc khóa ngoại (Foreign Key) chặt chẽ cho luồng tài chính, hỗ trợ kiểu dữ liệu JSONB cho việc lưu trữ payload phản hồi không cấu trúc của API hãng bay.
2.  **Ràng buộc thời gian đệm (Buffer Time)**: Thời gian hiển thị đếm ngược giữ chỗ (Hold countdown) hiển thị trên màn hình ứng dụng của đại lý luôn luôn phải được thiết lập ngắn hơn thời gian hold thực tế trên hệ thống giữ chỗ của hãng hàng không tối thiểu là 5 phút. Khoảng thời gian đệm này dùng để dự phòng cho độ trễ truyền gói tin thanh toán và xử lý xuất vé thực tế.

### 4.2 Giả thuyết và Phụ thuộc (Assumptions & Dependencies)
1.  **Phụ thuộc cổng thanh toán**: Giả định rằng API của cổng thanh toán trung gian VNPay hoạt động ổn định và tài liệu tích hợp kỹ thuật không thay đổi đột ngột trong suốt quá trình phát triển dự án.
2.  **Giả thuyết đồng bộ thời gian thiết bị**: Giả định rằng các thiết bị di động quét offline của tài xế được bật chế độ tự động đồng bộ thời gian hệ thống qua mạng di động (Network Time Protocol - NTP) trước khi đi vào vùng mất sóng, bảo đảm việc kiểm tra mốc thời gian động của QR code được chính xác.
