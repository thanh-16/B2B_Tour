# CẨM NANG HƯỚNG DẪN THỰC HIỆN ĐỒ ÁN TỐT NGHIỆP
## ĐỀ TÀI: NỀN TẢNG DU LỊCH B2B (B2B TRAVEL PLATFORM)
## Hạ tầng Backend: .NET 8 (C#) | Ứng dụng Di động: Flutter (Dart)

---

## QUY TRÌNH PHÁT TRIỂN THỰC TẾ (ORDERED DEVELOPMENT WORKFLOW)
Để tránh tình trạng "code đến đâu hay đến đó" dẫn tới vỡ kiến trúc ở tháng thứ 3, sinh viên cần tuân thủ lộ trình triển khai dưới đây:

```
[ Phase 1: DB & API Design ] ──> [ Phase 2: Auth Backend ] ──> [ Phase 3: Core Business APIs ]
              │                                                               │
              v                                                               v
[ Phase 6: Integration Tests ] <── [ Phase 5: Flutter App Screens ] <── [ Phase 4: Flutter State Setup ]
              │
              v
[ Phase 7: DevOps & Demo Prep ]
```

1.  **Giai đoạn 1 (Tuần 1-2)**: Phác thảo lược đồ cơ sở dữ liệu (Database Schema) và định nghĩa tài liệu API Mockup trên Swagger.
2.  **Giai đoạn 2 (Tuần 3-4)**: Phát triển cấu trúc Clean Architecture của Backend .NET, hiện thực hóa module Xác thực (Authentication) và Phân quyền (RBAC) với JWT + Refresh Token.
3.  **Giai đoạn 3 (Tuần 5-8)**: Code logic nghiệp vụ cốt lõi của Backend: Search Engine, Booking System, ví đại lý và Markup Engine.
4.  **Giai đoạn 4 (Tuần 9-10)**: Thiết lập dự án Flutter, triển khai kiến trúc BLoC, cài đặt Dio HTTP Client với Interceptor bảo mật.
5.  **Giai đoạn 5 (Tuần 11-14)**: Cắt giao diện Flutter các màn hình chính (Tìm kiếm, Giỏ hàng, Quét QR) và kết nối trực tiếp với Backend API.
6.  **Giai đoạn 6 (Tuần 15-16)**: Viết Integration Tests, thực hiện Load test và hoàn thiện tài liệu thuyết minh.

---

## PHẦN 1: FUNCTIONAL REQUIREMENTS (YÊU CẦU CHỨC NĂNG CHI TIẾT)

> [!NOTE]
> **GIẢNG VIÊN THƯỜNG CHẤM KỸ**: Cách sinh viên mô tả User Story và Acceptance Criteria. Giảng viên muốn thấy tư duy nghiệp vụ chặt chẽ, lường trước các trường hợp lỗi (Edge Cases) chứ không chỉ mô tả luồng chạy thành công (Happy Path).

---

### M01 - Đăng nhập & Phân quyền (Authentication & RBAC)
*   **Mô tả**: Module quản lý việc đăng ký, đăng nhập và phân quyền truy cập hệ thống bằng JWT Token hỗ trợ 4 vai trò: Admin, Manager, Agent, Supplier.
*   **Bảng danh sách yêu cầu M01**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M01-01** | *As an* Agent Staff, *I want to* đăng nhập bằng email và mật khẩu, *so that* tôi có thể truy cập hệ thống để đặt dịch vụ. | **Given** người dùng ở trang đăng nhập. **When** họ nhập email đúng và mật khẩu đúng. **Then** hệ thống đăng nhập thành công, trả về JWT Access Token (hạn 15p) và Refresh Token (hạn 7 ngày). | **Must Have** |
| **FR-M01-02** | *As a* Người dùng, *I want* hệ thống tự động gia hạn phiên đăng nhập khi token hết hạn, *so that* tôi không bị đăng xuất đột ngột khi đang làm việc. | **Given** Access Token đã hết hạn nhưng Refresh Token còn hiệu lực. **When** app gọi API cần auth. **Then** Interceptor của Dio tự động gọi API `/refresh-token` để lấy Access Token mới và thực hiện tiếp API cũ mà người dùng không biết. | **Must Have** |
| **FR-M01-03** | *As an* Agent Manager, *I want to* tạo tài khoản nhân viên và gán quyền `Agent Staff`, *so that* họ chỉ thực hiện đặt phòng mà không sửa được hạn mức tiền ví. | **Given** Manager đang đăng nhập. **When** họ tạo tài khoản mới và tích chọn vai trò `Agent Staff`. **Then** tài khoản được tạo và gán đúng quyền tương ứng trong bảng trung gian. | **Must Have** |
| **FR-M01-04** | *As an* Admin, *I want to* khóa tài khoản người dùng vi phạm chính sách, *so that* ngăn chặn họ tiếp tục thực hiện đặt chỗ bất hợp pháp. | **Given** Admin đang ở Admin Panel. **When** Admin nhấn "Lock Account" của user A. **Then** thuộc tính `IsActive` chuyển sang `false`, toàn bộ JWT hiện tại của user A bị vô hiệu hóa lập tức. | **Must Have** |
| **FR-M01-05** | *As a* Người dùng, *I want to* đăng xuất tài khoản trên ứng dụng di động, *so that* thông tin đặt phòng của tôi được bảo mật khi người khác dùng máy. | **Given** Người dùng đang đăng nhập. **When** họ nhấn "Logout". **Then** Refresh Token bị xóa khỏi Database và thiết bị di động, chuyển hướng về màn hình Login. | **Must Have** |

---

### M02 - Onboarding Đại lý (Agent Onboarding)
*   **Mô tả**: Quản lý vòng đời đăng ký doanh nghiệp đại lý du lịch, kiểm duyệt KYC pháp lý và thiết lập hạn mức tín dụng công nợ (Credit Line).
*   **Bảng danh sách yêu cầu M02**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M02-01** | *As an* Agency Owner, *I want to* đăng ký tài khoản doanh nghiệp trực tuyến, *so that* tôi được cấp tài khoản để mua dịch vụ giá sỉ. | **Given** Trang đăng ký B2B. **When** nhập Tên doanh nghiệp, MST, CCCD và nhấn Đăng ký. **Then** Hồ sơ được lưu trạng thái `Pending Approval`. | **Must Have** |
| **FR-M02-02** | *As an* Admin, *I want to* duyệt hồ sơ đại lý mới đăng ký, *so that* đảm bảo chỉ các đại lý du lịch hợp pháp mới được tham gia sàn. | **Given** Danh sách đăng ký mới. **When** Admin xác thực MST và nhấn "Approve". **Then** Trạng thái đại lý đổi thành `Active` và hệ thống tự khởi tạo ví tài khoản. | **Must Have** |
| **FR-M02-03** | *As an* Admin, *I want to* thiết lập hạn mức công nợ (Credit Limit) cho đại lý, *so that* cấp cho họ một số tiền nợ tối đa để đặt dịch vụ trả sau. | **Given** Hồ sơ của Agency A. **When** Admin nhập credit limit là `50,000,000 VND`. **Then** Thuộc tính `CreditLimit` được cập nhật trong DB và ghi nhận lịch sử vào bảng Audit. | **Must Have** |
| **FR-M02-04** | *As a* Manager, *I want to* upload giấy phép kinh doanh lữ hành, *so that* hoàn tất thủ tục KYC theo yêu cầu pháp lý của sàn. | **Given** Trang cập nhật hồ sơ đại lý. **When** Manager tải lên file PDF giấy phép lữ hành. **Then** File được lưu trữ thành công lên AWS S3 và cập nhật đường dẫn URL trong DB. | **Should Have** |
| **FR-M02-05** | *As an* Admin, *I want to* cấu hình hạn mức tín dụng động theo điểm uy tín đại lý, *so that* tự động tăng/giảm hạn mức nợ mà không cần can thiệp tay. | **Given** Đại lý có lịch sử thanh toán nợ đúng hạn 3 tháng liên tiếp. **When** Hệ thống chạy job quét cuối tháng. **Then** Tự động tăng 10% hạn mức nợ cho đại lý đó. | **Could Have** |

---

### M03 - Quản lý Sản phẩm (Inventory Management)
*   **Mô tả**: Cho phép nhà cung cấp (Supplier) quản lý thông tin phòng khách sạn, vé xe, tour lữ hành và điều chỉnh số lượng tồn kho theo ngày.
*   **Bảng danh sách yêu cầu M03**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M03-01** | *As a* Supplier, *I want to* tạo mới sản phẩm phòng khách sạn, *so that* hiển thị sản phẩm lên sàn cho đại lý đặt chỗ. | **Given** Supplier Portal. **When** nhập tên khách sạn, giá Net sỉ, tải ảnh lên và nhấn Save. **Then** Sản phẩm được tạo với trạng thái `Active`. | **Must Have** |
| **FR-M03-02** | *As a* Supplier, *I want to* cập nhật số lượng phòng trống (Inventory) cho ngày lễ, *so that* đại lý biết số lượng chính xác để bán. | **Given** Lịch quản lý kho phòng. **When** sửa số lượng phòng trống của ngày 15/07 từ 5 thành 2. **Then** Số lượng mới được cập nhật trên database Postgres và clear cache Redis liên quan. | **Must Have** |
| **FR-M03-03** | *As a* Supplier, *I want to* cấu hình giá sỉ (Net Rate) tăng 20% vào cuối tuần, *so that* tối ưu doanh thu theo quy luật thị trường. | **Given** Bảng cài đặt giá theo ngày. **When** Chọn thứ 7 và Chủ nhật, nhập tỷ lệ tăng giá 20%. **Then** Hệ thống tự động tính giá mới khi đại lý tìm kiếm trúng các ngày cuối tuần này. | **Must Have** |
| **FR-M03-04** | *As a* Supplier, *I want to* tạm dừng bán sản phẩm (Inactive), *so that* ẩn sản phẩm khỏi kết quả tìm kiếm khi sửa chữa/bảo trì dịch vụ. | **Given** Danh sách sản phẩm của Supplier. **When** nhấn nút "Deactivate". **Then** Sản phẩm không còn xuất hiện khi đại lý gọi API search nhưng không ảnh hưởng đến các booking cũ. | **Must Have** |
| **FR-M03-05** | *As a* Supplier, *I want* hệ thống tự động đồng bộ kho phòng từ phần mềm quản lý khách sạn PMS, *so that* tôi không phải cập nhật tay. | **Given** Khách sạn có kết nối PMS. **When** PMS gọi webhook update kho phòng. **Then** Hệ thống tự động đồng bộ số lượng tồn kho tương ứng trong DB. | **Could Have** |
| **FR-M03-06** | *As a* Supplier, *I want to* gạt nút đóng bán nhanh trên app hoặc Zalo/Telegram bot, *so that* cập nhật kho về 0 ngay lập tức khi hết chỗ đột xuất ngoài thực tế. | **Given** Supplier đang trên xe. **When** gạt nút "Đóng bán nhanh" cho ngày đi. **Then** Kho hàng tự động cập nhật về 0 và xóa cache Redis tức thời. | **Must Have** |

---

### M04 - Tìm kiếm & Lọc (Search & Filter Engine)
*   **Mô tả**: Bộ máy tìm kiếm tổng hợp thời gian thực cho phép đại lý tìm kiếm vé máy bay, khách sạn, tour lẻ và áp dụng các bộ lọc nâng cao.
*   **Bảng danh sách yêu cầu M04**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M04-01** | *As an* Agent Staff, *I want to* tìm phòng khách sạn theo địa điểm và ngày, *so that* tìm được phòng trống chính xác cho khách. | **Given** Thanh tìm kiếm khách sạn. **When** nhập "Nha Trang", check-in 10/07, check-out 12/07. **Then** Hệ thống trả về danh sách khách sạn đáp ứng với tốc độ phản hồi dưới 500ms. | **Must Have** |
| **FR-M04-02** | *As an* Agent Staff, *I want to* lọc kết quả tìm kiếm theo tầm giá và xếp hạng sao, *so that* nhanh chóng thu hẹp các lựa chọn phù hợp túi tiền của khách. | **Given** Giao diện kết quả tìm kiếm. **When** tick chọn bộ lọc "4 sao" và khoảng giá dưới 2 triệu. **Then** Danh sách hiển thị ngay lập tức các khách sạn thỏa mãn điều kiện. | **Must Have** |
| **FR-M04-03** | *As an* Agent Staff, *I want to* xem giá phòng đã bao gồm hoa hồng Markup của đại lý, *so that* tôi có thể báo giá trực tiếp cho khách không lộ giá Net gốc. | **Given** Đại lý cài Markup là 10% cho phòng. **When** Gọi API tìm kiếm. **Then** Giá hiển thị trên màn hình = Giá Net + 10%. | **Must Have** |
| **FR-M04-04** | *As an* Agent Staff, *I want* hệ thống gợi ý các địa điểm du lịch hot khi tôi gõ từ khóa, *so that* tôi không phải gõ đầy đủ tên địa danh. | **Given** Ô tìm kiếm. **When** nhập "Da n". **Then** Hệ thống gợi ý danh sách: "Đà Nẵng", "Đà Lạt" dựa trên dữ liệu tìm kiếm nhiều nhất. | **Should Have** |
| **FR-M04-05** | *As an* Agent Staff, *I want to* tìm kiếm vé máy bay kết hợp khách sạn cùng lúc, *so that* tạo nhanh gói combo du lịch cho khách hàng. | **Given** Tab tìm kiếm Combo. **When** nhập hành trình bay và ngày ở khách sạn. **Then** Hệ thống hiển thị các combo đề xuất có giá rẻ nhất ghép từ vé rẻ nhất và phòng rẻ nhất. | **Could Have** |

---

### M05 - Giỏ hàng & Giữ chỗ (Shopping Cart & Price Lock)
*   **Mô tả**: Cho phép đại lý đưa nhiều dịch vụ vào giỏ hàng và thực hiện khóa giữ chỗ, khóa giá bán tạm thời trước khi tiến hành thanh toán.
*   **Bảng danh sách yêu cầu M05**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M05-01** | *As an* Agent Staff, *I want to* thêm vé máy bay và phòng khách sạn vào giỏ hàng, *so that* tích hợp thanh toán chung một hành trình. | **Given** Trang chi tiết khách sạn. **When** nhấn "Add to Cart". **Then** Sản phẩm được lưu trữ tạm thời vào giỏ hàng và hiển thị badge số lượng ở icon giỏ hàng trên app bar. | **Must Have** |
| **FR-M05-02** | *As an* Agent Staff, *I want* hệ thống khóa giá dịch vụ trong giỏ hàng trong 15 phút, *so that* giá bán không bị hãng bay tăng lên đột ngột lúc tôi đang xin tiền khách cọc. | **Given** Giỏ hàng đang checkout. **When** Chuyển sang màn hình điền tên khách. **Then** Hệ thống kích hoạt Price Lock trên Redis trong 15 phút. | **Must Have** |
| **FR-M05-03** | *As a* Khách hàng, *I want* hệ thống tự động giải phóng phòng trong giỏ hàng khi hết 15 phút đếm ngược mà đại lý chưa trả tiền, *so that* trả phòng lại cho người khác mua. | **Given** Giỏ hàng ở trạng thái khóa giá. **When** Hết 15 phút đếm ngược và chưa thanh toán. **Then** Hệ thống tự động xóa khóa giá trên Redis, trả lại số lượng phòng trống vào kho bán lẻ. | **Must Have** |
| **FR-M05-04** | *As an* Agent Staff, *I want* hệ thống cảnh báo khi thời gian giữ chỗ của giỏ hàng chỉ còn 2 phút, *so that* tôi kịp thời xử lý nạp tiền nốt. | **Given** Màn hình checkout đang đếm ngược còn 2 phút. **When** Thời gian về mốc 02:00. **Then** Hệ thống nhấp nháy đỏ trên app di động và phát âm thanh cảnh báo bíp nhẹ. | **Should Have** |
| **FR-M05-05** | *As a* Manager, *I want to* cài đặt cấu hình thời gian khóa giá cho từng loại sản phẩm khác nhau, *so that* tối ưu hóa thời gian giữ chỗ (ví dụ: vé bay 15p, tour 2 tiếng). | **Given** Admin Panel cấu hình. **When** sửa thời gian hold của tour thành 120 phút. **Then** Quy tắc mới được áp dụng cho toàn bộ các lượt đặt tour tiếp theo. | **Should Have** |
| **FR-M05-06** | *As an* Agent Staff, *I want* hệ thống tự động giữ chỗ/khóa giá đồng bộ cho vé bay và xe đi kèm khi đặt Tour chờ xác nhận, *so that* tránh việc bị mồ côi vé bay. | **Given** Đại lý đặt combo Tour + Vé máy bay. **When** Tiến hành đặt. **Then** Hệ thống khóa giá vé bay và chờ tour xác nhận, nếu tour hủy thì tự nhả vé bay hoàn tiền ví. | **Must Have** |

---

### M06 - Đặt chỗ / Booking Workflow
*   **Mô tả**: Quản lý vòng đời đầy đủ của một booking từ bước khởi tạo giữ chỗ (PNR Creation), xem chi tiết, sửa đổi thông tin cho đến hủy đặt vé.
*   **Bảng danh sách yêu cầu M06**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M06-01** | *As an* Agent Staff, *I want to* xác nhận đặt chỗ chính thức sau khi giữ chỗ tạm thời thành công, *so that* hoàn tất giao dịch với nhà cung cấp. | **Given** Booking đang ở trạng thái `Held`. **When** nhấn "Confirm Book". **Then** Hệ thống đổi trạng thái booking thành `Confirmed` và lưu thông tin vào bảng lịch sử. | **Must Have** |
| **FR-M06-02** | *As an* Agent Staff, *I want to* xem chi tiết booking, *so that* kiểm tra lại thời gian đi, mã vé và họ tên của hành khách. | **Given** Danh sách booking của tôi. **When** nhấn vào mã booking `BK-8902`. **Then** Hiển thị màn hình chi tiết chứa lịch trình bay, tên khách sạn, mã PNR gốc và tình trạng thanh toán. | **Must Have** |
| **FR-M06-03** | *As an* Agent Manager, *I want to* sửa thông tin tên khách hàng (sai chính tả) trước ngày bay 24 giờ, *so that* tránh việc khách bị hãng bay từ chối check-in. | **Given** Booking trạng thái `Paid`. **When** Manager sửa tên "Nguyn Van A" thành "Nguyen Van A" và nhấn Save. **Then** Yêu cầu được gửi lên API Supplier để đổi tên và cập nhật DB. | **Must Have** |
| **FR-M06-04** | *As an* Agent Manager, *I want to* yêu cầu hủy toàn bộ booking phòng khách sạn, *so that* nhận lại tiền hoàn dựa trên chính sách hoàn hủy. | **Given** Booking khách sạn khởi hành sau 5 ngày. **When** nhấn "Request Cancel". **Then** Hệ thống tính toán phí phạt hủy, đổi trạng thái booking sang `Cancelled` và hoàn tiền ví đại lý. | **Must Have** |
| **FR-M06-05** | *As an* Agent Manager, *I want to* hủy một phần (ví dụ: hủy 1 phòng trong đoàn 5 phòng), *so that* giảm thiểu thiệt hại cho những khách trong đoàn không đi được nữa. | **Given** Booking đoàn 5 phòng. **When** nhấn chọn hủy 1 phòng cụ thể. **Then** Hệ thống gửi yêu cầu hủy 1 phòng lên Supplier, tính toán hoàn tiền và cập nhật số lượng phòng booking về 4. | **Should Have** |
| **FR-M06-06** | *As a* Người dùng, *I want* hệ thống tự xếp đơn đặt tour đêm 21h-6h vào hàng đợi và nhắc nhở Supplier mỗi tiếng 1 lần trong giờ hoạt động, *so that* Supplier không bị làm phiền lúc ngủ và phản hồi sớm khi thức dậy. | **Given** Đại lý đặt tour lúc 23:00. **When** Đơn gửi lên. **Then** Hệ thống lưu trạng thái Pending và đợi đến 06:00 sáng hôm sau mới gửi và nhắc nhở Supplier mỗi tiếng 1 lần. | **Must Have** |
| **FR-M06-07** | *As a* Người dùng, *I want* hệ thống cảnh báo trễ cho tôi (Đại lý) và gọi IVR tự động cho Supplier sau 3 tiếng trễ, *so that* thúc giục xác nhận nhanh. | **Given** Supplier không duyệt đơn sau 3 tiếng. **When** Đến mốc giờ thứ 3. **Then** Đại lý nhận cảnh báo trễ, hệ thống thực hiện cuộc gọi robot IVR tới Supplier. | **Must Have** |
| **FR-M06-08** | *As a* Khách hàng, *I want* hệ thống tự hủy tour sớm nếu chưa duyệt (21h hôm trước đối với tour đi sáng sớm; trước giờ đi 2 tiếng đối với tour khác), *so that* tránh việc bị hủy tour sát giờ trước 2 tiếng gây khó chịu. | **Given** Tour đi sáng sớm đặt trước 18:00. **When** Đến 21:00 tối hôm trước vẫn chưa được duyệt. **Then** Hệ thống tự hủy đơn, giải phóng tiền ví đại lý và vé máy bay/xe đi kèm. | **Must Have** |

---

### M07 - Thanh toán (B2B Payment)
*   **Mô tả**: Xử lý thanh toán các đơn hàng bằng hạn mức công nợ đại lý, ví số dư, chuyển khoản trực tuyến qua cổng thanh toán VNPay.
*   **Bảng danh sách yêu cầu M07**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M07-01** | *As an* Agent Staff, *I want to* thanh toán booking bằng tài khoản ví đại lý, *so that* giao dịch được xử lý ngay tức thì. | **Given** Số dư ví đại lý là 5 triệu, booking giá 3 triệu. **When** nhấn "Thanh toán bằng ví" và nhập mã PIN. **Then** Ví bị trừ 3 triệu, trạng thái booking chuyển thành `Paid` lập tức. | **Must Have** |
| **FR-M07-02** | *As an* Agent Staff, *I want to* dùng hạn mức công nợ nợ âm để đặt phòng khi ví hết tiền, *so that* không lỡ mất phòng đẹp của khách. | **Given** Hạn mức nợ là 20 triệu, số dư ví là 0đ. **When** Thanh toán booking 5 triệu. **Then** Giao dịch thành công, số dư ví hiển thị âm `-5,000,000 VND`. | **Must Have** |
| **FR-M07-03** | *As an* Agent Manager, *I want to* nạp tiền vào ví qua quét mã QR VNPay, *so that* tiền được tự động cộng vào tài khoản ví mà không cần gọi điện xác nhận. | **Given** Giao diện nạp tiền. **When** nhập 10 triệu và quét mã VietQR chuyển khoản. **Then** Hệ thống nhận IPN từ VNPay, tự động cộng 10 triệu vào ví trong 5 giây. | **Must Have** |
| **FR-M07-04** | *As a* Finance User, *I want* hệ thống tự động khóa tính năng thanh toán của đại lý khi họ nợ quá hạn hạn mức công nợ cho phép, *so that* giảm thiểu rủi ro nợ xấu. | **Given** Đại lý quá hạn thanh toán nợ 15 ngày. **When** Họ nhấn thanh toán booking mới. **Then** Hệ thống chặn và báo lỗi "Tài khoản của bạn đã bị khóa do nợ quá hạn. Vui lòng thanh toán công nợ". | **Must Have** |
| **FR-M07-05** | *As an* Agent Staff, *I want* hệ thống hiển thị thông báo lỗi chi tiết khi thanh toán thất bại (sai mã PIN, lỗi cổng kết nối), *so that* tôi biết cách xử lý tiếp theo. | **Given** Thanh toán nhập sai PIN. **When** Nhấn xác nhận. **Then** Hệ thống báo đỏ "Mã PIN không chính xác. Bạn còn 4 lần thử". | **Must Have** |

---

### M08 - Hóa đơn & VAT (Invoicing & VAT)
*   **Mô tả**: Tự động tạo và quản lý hóa đơn VAT điện tử dưới dạng file PDF, hỗ trợ kết xuất và gửi email tự động cho đại lý sau giao dịch.
*   **Bảng danh sách yêu cầu M08**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M08-01** | *As an* Agent Manager, *I want* hệ thống tự động xuất hóa đơn VAT PDF khi booking thanh toán thành công, *so that* tôi lưu trữ và làm chứng từ kế toán. | **Given** Booking vừa chuyển trạng thái sang `Paid`. **When** Worker chạy tạo hóa đơn. **Then** Sinh file PDF hóa đơn VAT lưu trữ trên S3 và hiển thị nút "Download Invoice" trên chi tiết booking. | **Must Have** |
| **FR-M08-02** | *As an* Agent Manager, *I want* hệ thống tự động gửi hóa đơn VAT qua email của tôi, *so that* tôi không phải tải thủ công về máy rồi gửi lại. | **Given** Hóa đơn PDF vừa được sinh. **When** Hệ thống gửi email tự động. **Then** Manager nhận được email chứa file hóa đơn VAT đính kèm dạng PDF. | **Must Have** |
| **FR-M08-03** | *As a* Finance User, *I want to* xem lịch sử các hóa đơn đã xuất của toàn hệ thống, *so that* tôi đối soát số thuế VAT phải nộp cuối kỳ. | **Given** Giao diện quản lý hóa đơn của Admin Panel. **When** Lọc hóa đơn theo tháng 06/2026. **Then** Hiển thị danh sách hóa đơn kèm mã số thuế, số tiền trước thuế, tiền thuế và tổng tiền. | **Must Have** |
| **FR-M08-04** | *As an* Agent Manager, *I want to* khai báo thông tin xuất hóa đơn VAT của công ty tôi một lần duy nhất, *so that* hệ thống tự động điền vào các booking sau. | **Given** Cài đặt hồ sơ Agency. **When** nhập MST công ty, địa chỉ và nhấn lưu. **Then** Thông tin được tự động map vào form xuất hóa đơn khi checkout booking mới. | **Should Have** |
| **FR-M08-05** | *As an* Admin, *I want to* hủy và xuất lại hóa đơn thay thế cho hóa đơn bị sai thông tin, *so that* sửa lỗi phát sinh theo yêu cầu của đại lý. | **Given** Hóa đơn bị sai MST. **When** Admin nhấn "Cancel & Re-issue". **Then** Hóa đơn cũ bị đánh dấu hủy, một hóa đơn mới được sinh ra thế chỗ và gửi lại cho đại lý. | **Should Have** |

---

### M09 - Bàn giao dịch vụ (Fulfillment & Voucher Delivery)
*   **Mô tả**: Tự động sinh E-Voucher/E-Ticket chứa mã QR bảo mật mã hóa chữ ký số và hỗ trợ quét camera trên thiết bị di động để verify check-in.
*   **Bảng danh sách yêu cầu M09**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M09-01** | *As an* Agent Staff, *I want* hệ thống tự sinh E-Voucher PDF có chứa mã QR bảo mật của riêng đại lý tôi, *so that* tôi bàn giao trực tiếp cho khách hàng. | **Given** Booking trạng thái `Paid`. **When** Hệ thống sinh voucher. **Then** File PDF được tạo chứa logo đại lý, mã QR bảo mật và gửi link tải cho Agent. | **Must Have** |
| **FR-M09-02** | *As a* Delivery Staff (Tài xế/HDV), *I want to* quét mã QR của khách bằng app di động, *so that* tôi xác nhận khách lên xe nhanh trong 3 giây. | **Given** Khách đưa voucher điện thoại. **When** Nhân viên quét bằng camera app. **Then** App báo bíp xanh "Check-in thành công", cập nhật trạng thái vé sang `Delivered`. | **Must Have** |
| **FR-M09-03** | *As a* Delivery Staff, *I want* app di động kiểm tra được mã QR giả hoặc đã sử dụng, *so that* ngăn chặn thất thoát doanh thu của hãng. | **Given** Voucher đã check-in từ trước. **When** Nhân viên quét lại mã đó. **Then** App hiện popup đỏ báo lỗi "Voucher không hợp lệ - Đã được sử dụng vào lúc [Time]". | **Must Have** |
| **FR-M09-04** | *As a* Delivery Staff, *I want to* quét mã check-in offline khi mất mạng di động, *so that* không làm tắc nghẽn luồng khách lên xe tại điểm đón. | **Given** Thiết bị mất mạng. **When** Nhân viên quét QR. **Then** App giải mã chữ ký số offline, hiển thị hợp lệ, lưu lịch sử quét vào bộ nhớ Hive cục bộ. | **Should Have** |
| **FR-M09-05** | *As an* Admin, *I want to* xem vị trí GPS của tài xế lúc quét QR check-in khách, *so that* đối soát xem tài xế có đón khách đúng điểm hẹn quy định hay không. | **Given** Lịch sử quét QR. **When** Admin xem chi tiết check-in của khách A. **Then** Hệ thống hiển thị thời gian quét và vị trí tọa độ GPS vẽ trực quan trên bản đồ Goong Maps. | **Should Have** |

---

### M10 - Hệ thống Thông báo (Notification System)
*   **Mô tả**: Gửi thông báo tự động (Email, SMS, Web Push) về sự thay đổi trạng thái booking và số dư ví tới đại lý và khách hàng cuối.
*   **Bảng danh sách yêu cầu M10**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M10-01** | *As an* Agent Staff, *I want* nhận được thông báo đẩy (Push Notification) thời gian thực khi trạng thái booking thay đổi thành `Paid` hoặc `Cancelled`, *so that* tôi theo dõi tiến độ công việc ngay tức thì. | **Given** App di động đang mở. **When** Server đổi trạng thái booking. **Then** App nhận tín hiệu WebSocket/SignalR và hiển thị thông báo popup đẩy (toast) trên góc màn hình. | **Must Have** |
| **FR-M10-02** | *As a* Khách hàng, *I want* nhận được SMS chứa link tải vé/voucher ngay sau khi thanh toán thành công, *so that* tôi lưu giữ vé dễ dàng mà không cần internet để check mail. | **Given** Booking hoàn tất. **When** Hệ thống gọi API SMS Gateway. **Then** Khách nhận được SMS: "Trang Travel gui ban vé xe ve/voucher: [Link]". | **Must Have** |
| **FR-M10-03** | *As a* Supplier, *I want* nhận được email thông báo khi có booking mới đặt dịch vụ của tôi, *so that* tôi chủ động kiểm tra và chuẩn bị đón tiếp khách. | **Given** Đại lý vừa đặt dịch vụ. **When** Đơn hàng tạo xong. **Then** Hệ thống tự động gửi email thông báo chi tiết đơn hàng đến Supplier. | **Must Have** |
| **FR-M10-04** | *As an* Agent Staff, *I want* hệ thống gửi thông báo nhắc nhở trước khi booking giữ chỗ (Held) hết hạn 15 phút, *so that* tôi kịp chốt tiền với khách. | **Given** Booking sắp hết hạn hold. **When** Scheduler quét thấy còn 15 phút. **Then** Gửi thông báo đẩy in-app màu vàng cảnh báo cho Agent. | **Should Have** |
| **FR-M10-05** | *As a* Người dùng, *I want to* tắt bớt các thông báo email không cần thiết và chỉ giữ lại thông báo giao dịch, *so that* hộp thư của tôi không bị rác. | **Given** Trang cài đặt thông báo. **When** tắt check-box "Thông báo khuyến mãi". **Then** Hệ thống không gửi email khuyến mãi nữa nhưng vẫn gửi email hóa đơn. | **Could Have** |

---

### M11 - Dịch vụ Sau bán (After-sales & Support)
*   **Mô tả**: Tiếp nhận và xử lý các yêu cầu thay đổi lịch trình du lịch, đổi ngày bay/phòng, yêu cầu hoàn tiền và khiếu nại chất lượng dịch vụ.
*   **Bảng danh sách yêu cầu M11**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M11-01** | *As an* Agent Staff, *I want to* gửi yêu cầu đổi ngày khởi hành của tour trực tuyến, *so that* hỗ trợ nhanh nhu cầu đột xuất của khách hàng. | **Given** Trang chi tiết booking. **When** chọn ngày mới và nhấn "Request Change Date". **Then** Trạng thái booking chuyển sang `Pending Change` và gửi thông tin về Supplier Portal. | **Must Have** |
| **FR-M11-02** | *As a* Supplier, *I want to* báo giá phí chênh lệch khi đổi ngày dịch vụ cho đại lý duyệt, *so that* bù đắp chi phí vận hành phát sinh của tôi. | **Given** Yêu cầu đổi ngày của đại lý. **When** Supplier nhập số tiền chênh lệch là `200,000 VND` và gửi đi. **Then** Đại lý nhìn thấy số tiền chênh lệch cần đóng thêm trên giao diện portal. | **Must Have** |
| **FR-M11-03** | *As an* Agent Staff, *I want to* đồng ý thanh toán tiền chênh lệch đổi ngày từ ví, *so that* hoàn tất thủ tục đổi ngày tự động không cần hỗ trợ tay. | **Given** Đại lý thấy phí chênh lệch 200k. **When** nhấn "Accept & Pay". **Then** Hệ thống trừ ví đại lý 200k, đổi ngày đi trên booking và cập nhật trạng thái về `Paid`. | **Must Have** |
| **FR-M11-04** | *As an* Agent Manager, *I want to* gửi khiếu nại (Claim) kèm hình ảnh dịch vụ thực tế bị kém chất lượng so với quảng cáo, *so that* yêu cầu sàn đền bù tiền. | **Given** Khách sạn thực tế bị hỏng điều hòa. **When** Manager upload ảnh chụp và viết khiếu nại. **Then** Yêu cầu gửi về Admin Panel ở trạng thái `Under Investigation`. | **Should Have** |
| **FR-M11-05** | *As an* Agent Staff, *I want to* chat trực tiếp với nhân viên hỗ trợ của sàn qua Live Chat, *so that* giải quyết các sự cố khẩn cấp phát sinh khi khách đang check-in. | **Given** Màn hình Live Chat. **When** Agent gõ tin nhắn. **Then** Nhân viên support của Admin nhận được tin nhắn thời gian thực và phản hồi hỗ trợ. | **Should Have** |
| **FR-M11-06** | *As a* Supplier, *I want to* khai báo sự cố đột xuất (hỏng phương tiện/bão lũ) trên app di động, *so that* hệ thống dừng bán, hoàn tiền tự động hoặc đổi đối tác đền bù. | **Given** Xe của Supplier bị hỏng đột xuất sáng nay. **When** nhấn "Khai báo sự cố" và upload ảnh phương tiện hỏng. **Then** Hệ thống dừng bán tour hôm nay, hoàn tiền 100% về ví đại lý (hoặc tự định tuyến lại sang tour thay thế). | **Must Have** |

---

### M12 - Báo cáo & Thống kê (Reporting & Analytics)
*   **Mô tả**: Kết xuất báo cáo phân tích tài chính doanh thu, số lượng booking, tỷ lệ hủy và hiệu suất bán hàng của từng nhân viên lữ hành.
*   **Bảng danh sách yêu cầu M12**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M12-01** | *As an* Agent Manager, *I want to* xem biểu đồ doanh thu theo tháng của đại lý tôi dưới dạng đồ thị, *so that* theo dõi trực quan tăng trưởng kinh doanh. | **Given** Trang thống kê. **When** chọn năm 2026. **Then** Hệ thống hiển thị biểu đồ đường thể hiện doanh thu qua từng tháng. | **Must Have** |
| **FR-M12-02** | *As an* Agent Manager, *I want to* xem bảng xếp hạng hiệu suất đặt phòng của các nhân viên sales, *so that* biết nhân viên nào bán tốt nhất để thưởng KPI. | **Given** Báo cáo nhân viên. **When** lọc dữ liệu tháng hiện tại. **Then** Hiển thị danh sách nhân viên xếp theo thứ tự giảm dần của tổng tiền booking đã thanh toán. | **Must Have** |
| **FR-M12-03** | *As a* Finance User, *I want to* xuất báo cáo công nợ đại lý ra file Excel, *so that* gửi cho chủ đại lý đối chiếu và thu hồi nợ cuối tháng. | **Given** Bảng công nợ. **When** nhấn "Export Excel". **Then** Hệ thống sinh file Excel (.xlsx) tải về chứa dữ liệu công nợ, số ngày nợ quá hạn của từng đại lý. | **Must Have** |
| **FR-M12-04** | *As a* Supplier, *I want to* xem báo cáo tỷ lệ lấp đầy kho phòng khách sạn của tôi theo tháng, *so that* điều chỉnh giá phòng ở các ngày vắng khách. | **Given** Supplier Portal báo cáo. **When** chọn Khách sạn A. **Then** Hiển thị phần trăm phòng đã bán thành công trên tổng số phòng khai báo theo từng ngày. | **Should Have** |
| **FR-M12-05** | *As an* Admin, *I want to* xem biểu đồ tỷ lệ hủy booking (Cancellation Rate) của toàn sàn, *so that* phân tích hành vi người dùng và chất lượng của các Supplier. | **Given** Admin Dashboard. **When** mở trang phân tích rủi ro. **Then** Hiển thị tỷ lệ hủy phòng của từng Supplier, xếp hạng Supplier có tỷ lệ khách hủy cao nhất. | **Should Have** |

---

### M13 - Admin Panel (Quản trị hệ thống)
*   **Mô tả**: Công cụ quản trị trung tâm dành cho Platform Admin để cấu hình tham số hệ thống, mức phí giao dịch, quản lý tài khoản và truy vết nhật ký Audit Log.
*   **Bảng danh sách yêu cầu M13**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M13-01** | *As an* Admin, *I want to* cấu hình phí giao dịch thanh toán trực tuyến, *so that* thay đổi phí nạp ví linh hoạt theo chính sách ngân hàng. | **Given** Cấu hình hệ thống. **When** sửa phí thanh toán qua thẻ quốc tế thành 1.5% và lưu. **Then** Hệ thống áp dụng ngay tỷ lệ phí mới cho mọi giao dịch thanh toán tiếp theo. | **Must Have** |
| **FR-M13-02** | *As an* Admin, *I want to* cấu hình tỷ lệ Markup hoa hồng mặc định toàn sàn cho nhóm đại lý mới, *so that* hệ thống tự động tính giá sỉ cho họ. | **Given** Cài đặt Markup sàn. **When** thiết lập nhóm Bronze có Markup là 5%. **Then** Toàn bộ đại lý nhóm Bronze khi tìm kiếm sẽ thấy giá phòng tự cộng thêm 5%. | **Must Have** |
| **FR-M13-03** | *As an* Admin, *I want to* xem nhật ký hoạt động hệ thống (Audit Log), *so that* điều tra người dùng nào đã can thiệp thay đổi hạn mức nợ của đại lý A. | **Given** Trang Audit Log. **When** tìm kiếm theo hành động "Update Credit Limit". **Then** Hiển thị danh sách: Thời gian, Admin thực hiện, ID đại lý bị tác động, hạn mức cũ, hạn mức mới. | **Must Have** |
| **FR-M13-04** | *As an* Admin, *I want to* khóa quyền truy cập API của một đại lý vi phạm thanh toán nợ quá hạn, *so that* ngăn chặn ngay lập tức thiệt hại tài chính phát sinh. | **Given** Danh sách đại lý. **When** chuyển nút switch tài khoản đại lý A sang block. **Then** Mọi request API từ token của đại lý A đều bị trả về lỗi 403. | **Must Have** |
| **FR-M13-05** | *As an* Admin, *I want to* cấu hình danh mục địa điểm, thành phố du lịch trên hệ thống, *so that* cập nhật các điểm đến mới nổi cho đại lý tìm kiếm. | **Given** Quản lý địa danh. **When** thêm địa điểm mới "Măng Đen" và upload ảnh đại diện. **Then** Địa điểm mới hiển thị trên giao diện tìm kiếm của app di động. | **Should Have** |

---

### M14 - Supplier Portal (Cổng thông tin Nhà cung cấp)
*   **Mô tả**: Giao diện độc lập dành cho nhà cung cấp quản lý đơn hàng nhận được từ sàn, thực hiện đối soát tài chính và cập nhật bảng giá bán sỉ.
*   **Bảng danh sách yêu cầu M14**:

| ID | User Story | Acceptance Criteria | Priority |
| :--- | :--- | :--- | :--- |
| **FR-M14-01** | *As a* Supplier, *I want to* xem danh sách các đơn đặt phòng mới gửi về từ sàn, *so that* chuẩn bị dịch vụ đón tiếp khách hàng chu đáo. | **Given** Supplier Dashboard. **When** Đại lý thanh toán thành công phòng khách sạn của tôi. **Then** Đơn hàng mới hiển thị ở đầu danh sách "Đơn hàng chờ xác nhận" kèm âm thanh báo chuông nhẹ. | **Must Have** |
| **FR-M14-02** | *As a* Supplier, *I want to* xuất hóa đơn đối soát tài chính thu hộ gửi cho sàn cuối tháng, *so that* nhận tiền thanh toán phòng sạch sẽ. | **Given** Kỳ đối soát kết thúc. **When** Supplier nhấn "Generate Statement". **Then** Hệ thống tổng hợp các booking đã hoàn thành, xuất file PDF đối soát chứa tổng tiền Net sàn phải trả. | **Must Have** |
| **FR-M14-03** | *As a* Supplier, *I want to* cập nhật nhanh trạng thái đóng/mở phòng khách sạn khi hết phòng đột xuất trên điện thoại, *so that* tránh lỗi overbooking phạt tiền. | **Given** Trang extranet Supplier. **When** Chọn ngày 20/07, chọn "Close Room". **Then** Đại lý tìm kiếm ngày 20/07 lập tức thấy báo trạng thái "Sold Out". | **Must Have** |
| **FR-M14-04** | *As a* Supplier, *I want to* xem thống kê doanh thu bán sỉ qua sàn theo tháng, *so that* đánh giá mức độ đóng góp doanh số của platform. | **Given** Trang báo cáo Supplier. **When** chọn biểu đồ doanh thu năm nay. **Then** Hiển thị doanh số bán sỉ chia theo từng tháng dưới dạng biểu đồ cột. | **Should Have** |
| **FR-M14-05** | *As a* Supplier, *I want to* chat hỗ trợ trực tiếp với đại lý đặt vé khi cần trao đổi thông tin đón trả khách, *so that* phối hợp bàn giao dịch vụ diễn ra thuận lợi. | **Given** Chi tiết đơn hàng. **When** nhấn icon chat. **Then** Mở phòng chat thời gian thực kết nối với nhân viên đại lý đã thực hiện đặt chỗ. | **Should Have** |

---

> [!TIP]
> **LƯU Ý CHO SINH VIÊN**: 
> - Đối với đồ án tốt nghiệp, các chức năng **Hold Booking (FR-M05-02)** và **Quét QR Code Offline (FR-M09-04)** là những điểm nhấn công nghệ cực kỳ đắt giá. Hãy tập trung làm thật mượt mà hai tính năng này vì hội đồng chấm thi sẽ yêu cầu demo trực tiếp tại chỗ.
> - Đảm bảo rằng mọi bảng yêu cầu chức năng trên đều được map đúng mã ID sang các test case tương ứng trong tài liệu kiểm thử.

---

## PHẦN 2: NON-FUNCTIONAL REQUIREMENTS (YÊU CẦU PHI CHỨC NĂNG)

Dưới đây là các chỉ tiêu phi chức năng ràng buộc kiến trúc hệ thống, kèm theo giải pháp kỹ thuật cụ thể ở tầng .NET và Flutter để sinh viên triển khai:

| Loại NFR | Mô tả chi tiết yêu cầu | Chỉ tiêu kỹ thuật cụ thể | Liên quan đến .NET / Flutter |
| :--- | :--- | :--- | :--- |
| **Performance** | Độ trễ phản hồi API hệ thống và thời gian dựng màn hình ứng dụng di động. | - API Response Time (P95) **< 200ms** cho các tác vụ thông thường.<br>- Tìm kiếm phòng/vé (có cache Redis) **< 500ms**.<br>- Thời gian load màn hình Flutter đầu tiên (FCP) **< 1.5s** trên mạng 3G. | - **.NET**: Sử dụng Asynchronous Programming (`async/await`) cho mọi truy vấn I/O bound. Dùng `InMemory` cache kết hợp Redis.<br>- **Flutter**: Sử dụng widget `ListView.builder` thay cho `ListView` thường để tránh tràn bộ nhớ khi danh sách tìm kiếm lớn. |
| **Scalability** | Khả năng mở rộng chịu tải hệ thống khi có lượng lớn giao dịch đồng thời. | - Hệ thống chịu tải tối thiểu **1.000 người dùng hoạt động đồng thời (CCU)**.<br>- Khả năng xử lý **10.000 bookings/ngày** thành công không nghẽn luồng. | - **.NET**: Cấu hình DB Connection Pool tối đa 100 kết nối. Sử dụng Read/Write splitting DB.<br>- **Flutter**: Quản lý state gọn gàng bằng BLoC, tránh việc rebuild toàn bộ cây widget không cần thiết làm chậm UI thread. |
| **Security** | Đảm bảo tính an toàn dữ liệu giao dịch tài chính đại lý và thông tin khách hàng. | - Tuân thủ **OWASP Top 10**.<br>- JWT Access Token hết hạn sau **15 phút**, Refresh Token hết hạn sau **7 ngày**.<br>- HTTPS bắt buộc qua giao thức **TLS 1.3**. | - **.NET**: Sử dụng thư viện băm mật khẩu `BCrypt`. Cấu hình HTTP-only Cookies để truyền Refresh Token an toàn chống tấn công XSS.<br>- **Flutter**: Sử dụng thư viện `flutter_secure_storage` để lưu Access Token trong phân vùng nhớ mã hóa cứng của thiết bị. |
| **Availability** | Tính hoạt động liên tục 24/7 và khả năng xử lý của thiết bị di động khi mất mạng. | - Uptime tối thiểu đạt **99.9%** hàng năm.<br>- App di động phải hoạt động được chế độ offline cho chức năng quét mã check-in hành khách. | - **.NET**: Triển khai database dạng Multi-AZ cluster tự động failover.<br>- **Flutter**: Sử dụng database nội bộ **Hive** (dạng NoSQL siêu nhanh) để cache danh sách hành khách đón và ghi nhận lịch quét check-in offline. |
| **Usability** | Trải nghiệm người dùng tiện lợi, dễ tiếp cận trên ứng dụng di động ngoài trời. | - Nhân viên đại lý học cách đặt vé thành công trong vòng **< 15 phút** tự tìm hiểu.<br>- Giao diện quét QR của tài xế thiết kế tối ưu độ tương phản cao, nút bấm to dễ thao tác bằng một tay. | - **Flutter**: Hỗ trợ phóng to cỡ chữ (Dynamic Text Size) thích ứng với hệ thống, tương thích kiểm thử khả năng tiếp cận chuẩn WCAG 2.1. |
| **Maintainability** | Quy chuẩn tổ chức thư mục code sạch sẽ giúp bảo trì và nâng cấp dễ dàng. | - Unit Test Coverage trên lớp nghiệp vụ (Domain + Application) đạt **> 80%**.<br>- Tài liệu API OpenAPI/Swagger đầy đủ 100% endpoints. | - **.NET**: Tuân thủ quy tắc kiến trúc Clean Architecture, chia nhỏ dự án thành các Solution Folders riêng biệt.<br>- **Flutter**: Cấu trúc project phân chia theo Feature-first folder structure. |

---

> [!TIP]
> **LƯU Ý CHO SINH VIÊN**: 
> Khi báo cáo đồ án, hội đồng chấm thi rất hay hỏi: *"Em đã tối ưu hiệu năng (Performance) hệ thống như thế nào ở cả 2 đầu Backend và Mobile?"*. 
> Hãy tự tin trả lời bằng cách chỉ ra hai giải pháp: **Redis Cache phân tầng** ở Backend giúp giảm tải cho DB PostgreSQL và cơ chế **Lazy Rendering ListView** kết hợp **BLoC state isolation** ở đầu Flutter.

---

## PHẦN 3: TECH STACK (CƠ SỞ CÔNG NGHỆ CHI TIẾT)

Dưới đây là bảng phân tích chi tiết các thành phần công nghệ lựa chọn cho đồ án tốt nghiệp .NET & Flutter:

### 3.1 Backend Stack (.NET Core 8)

| Thành phần | Công nghệ chọn | Version | Tại sao chọn cho dự án này | Cách nó hoạt động trong dự án |
| :--- | :--- | :--- | :--- | :--- |
| **Backend Core** | ASP.NET Core Web API | .NET 8.0 | Phiên bản LTS mới nhất, hiệu năng cao hàng đầu thế giới, biên dịch JIT tối ưu hóa, hỗ trợ lập trình bất đồng bộ rất mạnh cho các tác vụ I/O. | Đóng vai trò làm Server Engine trung tâm, cung cấp các RESTful API endpoints bảo mật cho Flutter Client gọi dữ liệu. |
| **ORM** | Entity Framework Core | 8.0 | Hỗ trợ lập trình theo hướng đối tượng thông qua cơ chế **Code-first**. Dễ dàng sinh database tự động bằng lệnh Migration, quản lý quan hệ bảng chặt chẽ. | Ánh xạ các Entity C# (như `Booking`, `User`) thành các bảng trong PostgreSQL và thực hiện các câu lệnh LINQ truy vấn DB an toàn chống SQLi. |
| **Authentication** | JWT + Refresh Token | 8.0 | Cơ chế bảo mật Stateless hoàn hảo cho kiến trúc API. Refresh token lưu trong HttpOnly Cookie để chống đánh cắp bởi mã độc JS. | Khi đăng nhập, server trả về Access Token để Flutter gọi API và lưu Refresh Token trong DB/Cookie để gia hạn khi Access Token hết hạn. |
| **In-Memory Cache** | Redis | 7.x | Database dạng khóa-giá trị chạy trên RAM siêu nhanh, hỗ trợ giải quyết bài toán tìm kiếm giá phòng/chuyến bay tĩnh của đại lý. | Lưu trữ dữ liệu lịch bay và giá phòng khách sạn tĩnh trong vòng 5 phút, tránh việc API phải truy vấn trực tiếp vào DB PostgreSQL liên tục. |
| **Real-time Push** | SignalR | 8.0 | Thư viện hỗ trợ truyền thông tin 2 chiều thời gian thực giữa Client và Server thông qua WebSockets. | Tự động đẩy thông báo in-app cảnh báo hết hạn giữ chỗ (Hold Expiration) đến app di động của đại lý mà không cần app phải gọi API liên tục. |
| **Background Jobs** | Hangfire | 1.8 | Bộ máy quản lý hàng đợi và tác vụ chạy ngầm mạnh mẽ, hỗ trợ lưu trữ trạng thái tác vụ qua Database giúp tránh mất mát khi server bị crash. | Tự động quét và giải phóng phòng giữ chỗ quá hạn (Hold Release Job), chạy job tổng hợp báo cáo doanh thu đại lý vào 12h đêm hàng ngày. |
| **File Storage** | AWS S3 (hoặc MinIO) | - | Lưu trữ file hướng đối tượng dung lượng lớn giá rẻ, tính sẵn sàng cao, hỗ trợ sinh đường dẫn URL tạm thời có chữ ký số bảo mật. | Lưu trữ các tệp PDF E-Voucher, PDF hóa đơn VAT do backend tự động sinh và các ảnh chụp giấy phép kinh doanh KYC của đại lý. |

#### Các NuGet Packages bắt buộc phải cài đặt:
1.  `Microsoft.AspNetCore.Authentication.JwtBearer`: Hỗ trợ cấu hình middleware xác thực token JWT.
2.  `Microsoft.EntityFrameworkCore.Design` & `Npgsql.EntityFrameworkCore.PostgreSQL`: ORM kết nối với DB PostgreSQL.
3.  `MediatR`: Hiện thực hóa mô hình CQRS (Command Query Responsibility Segregation) tách biệt lệnh ghi và đọc dữ liệu.
4.  `FluentValidation.DependencyInjectionExtensions`: Tự động hóa việc kiểm tra tính hợp lệ của Request Body đầu vào.
5.  `Hangfire.PostgreSql`: Lưu cấu hình chạy ngầm của Hangfire vào Postgres DB.

---

### 3.2 Mobile Stack (Flutter)

| Thành phần | Công nghệ chọn | Version | Tại sao chọn cho dự án này | Cách nó hoạt động trong dự án |
| :--- | :--- | :--- | :--- | :--- |
| **State Management**| BLoC Pattern | 8.1.x | Tách biệt hoàn toàn phần giao diện (UI) và logic nghiệp vụ (Business Logic). Phù hợp tuyệt đối cho ứng dụng lớn, dễ viết Unit Test cho State. | Giao diện gửi các Event (ví dụ: `HoldBookingRequested`). BLoC xử lý API gọi server và trả về các State (`HoldBookingSuccess` / `HoldBookingFail`) để UI vẽ lại. |
| **HTTP Client** | Dio | 5.x | Thư viện HTTP client mạnh mẽ hỗ trợ thiết lập Interceptors, cấu hình Global Timeout, tự động parse JSON và quản lý hủy request. | Cấu hình Interceptor tự động đính kèm header `Authorization: Bearer <Token>` vào mọi request và tự động bắt lỗi Token hết hạn để call API refresh. |
| **Routing** | GoRouter | 13.x | Thư viện quản lý điều hướng chính thức từ nhóm Flutter, hỗ trợ định cấu hình Route dạng khai báo (Declarative), parse Path Parameters tiện lợi. | Định nghĩa toàn bộ cây màn hình của app, hỗ trợ kiểm tra quyền đăng nhập (Redirection Guard) ngăn không cho user chưa login truy cập màn hình trong. |
| **Local Storage** | Hive | 2.x | Database dạng NoSQL key-value viết bằng Dart thuần túy, tốc độ đọc ghi vào ổ đĩa cực nhanh (vượt trội hơn SQFlite và Shared Preferences). | Lưu trữ token đăng nhập, thông tin cấu hình app và cache tạm danh sách hành khách phục vụ việc quét mã check-in offline của tài xế. |
| **Push Notification**| Firebase Cloud Messaging (FCM) | 14.x | Dịch vụ gửi thông báo đẩy toàn cầu miễn phí của Google, tích hợp sâu vào hệ điều hành Android và iOS ở mức hệ thống. | Thiết bị di động đăng ký Token FCM gửi lên .NET Backend. Khi có sự kiện thanh toán, backend gọi API Firebase gửi thông báo đẩy xuống app. |

---

### 3.3 Database & Indexing Strategy

#### Lựa chọn Database: PostgreSQL
*   *Lý do*: Đồ án chọn PostgreSQL vì đây là hệ quản trị CSDL quan hệ mạnh mẽ nhất trong các dòng mã nguồn mở, không mất chi phí bản quyền thương mại (phù hợp cho sinh viên làm đồ án). Postgres hỗ trợ cực tốt kiểu dữ liệu `JSONB` giúp lưu trữ linh hoạt các payload phản hồi có cấu trúc động từ API của các hãng bay/khách sạn bên thứ ba mà không cần thay đổi schema liên tục.

#### Thiết kế thực thể chính (SQL DDL Core)

```sql
-- Bảng Agency (Đại lý)
CREATE TABLE auth.agencies (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    tax_code VARCHAR(20) UNIQUE NOT NULL,
    credit_limit DECIMAL(18,2) DEFAULT 0,
    balance DECIMAL(18,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'PENDING'
);

-- Bảng User (Tài khoản người dùng)
CREATE TABLE auth.users (
    id UUID PRIMARY KEY,
    agency_id UUID REFERENCES auth.agencies(id),
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL -- Admin, Manager, Agent, Supplier
);

-- Bảng Booking (Hồ sơ đặt chỗ)
CREATE TABLE booking.bookings (
    id UUID PRIMARY KEY,
    agency_id UUID REFERENCES auth.agencies(id),
    user_id UUID REFERENCES auth.users(id),
    pnr_code VARCHAR(10) UNIQUE NOT NULL,
    status VARCHAR(50) DEFAULT 'HELD', -- HELD, PENDING_CONFIRMATION, PAID, CANCELLED, EXPIRED, COMPLETED
    hold_type VARCHAR(20) DEFAULT 'INSTANT', -- INSTANT, ON_REQUEST
    retry_count INT DEFAULT 0,
    next_retry_at TIMESTAMP WITH TIME ZONE,
    cut_off_at TIMESTAMP WITH TIME ZONE,
    parent_booking_id UUID REFERENCES booking.bookings(id) NULL, -- Nhóm combo Tour + Bay + Xe
    total_net_amount DECIMAL(18,2) NOT NULL,
    total_markup_amount DECIMAL(18,2) NOT NULL,
    hold_expiration TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng BookingItem (Chi tiết sản phẩm dịch vụ đặt)
CREATE TABLE booking.booking_items (
    id UUID PRIMARY KEY,
    booking_id UUID REFERENCES booking.bookings(id),
    product_type VARCHAR(50) NOT NULL, -- HOTEL, FLIGHT, TOUR
    product_id UUID NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    net_price DECIMAL(18,2) NOT NULL,
    markup_price DECIMAL(18,2) NOT NULL
);

-- Bảng Voucher (Mã voucher điện tử & QR Code)
CREATE TABLE booking.vouchers (
    id UUID PRIMARY KEY,
    booking_id UUID REFERENCES booking.bookings(id),
    voucher_code VARCHAR(50) UNIQUE NOT NULL,
    qr_code_hash VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'CONFIRMED', -- CONFIRMED, DELIVERED, CANCELLED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Incident (Báo cáo sự cố khẩn cấp)
CREATE TABLE booking.incidents (
    id UUID PRIMARY KEY,
    booking_id UUID REFERENCES booking.bookings(id) NULL,
    product_id UUID NOT NULL,
    incident_date DATE NOT NULL,
    type VARCHAR(50) NOT NULL, -- FORCE_MAJEURE, OPERATIONAL_FAILURE
    description TEXT NOT NULL,
    evidence_url VARCHAR(500) NULL,
    status VARCHAR(50) DEFAULT 'PENDING', -- PENDING, PROCESSED, REJECTED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Wallet (Ví điện tử đại lý)
CREATE TABLE payment.wallets (
    id UUID PRIMARY KEY,
    agency_id UUID REFERENCES auth.agencies(id) UNIQUE,
    balance DECIMAL(18,2) DEFAULT 0.00,
    blocked_balance DECIMAL(18,2) DEFAULT 0.00,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Transaction (Lịch sử giao dịch ví)
CREATE TABLE payment.transactions (
    id UUID PRIMARY KEY,
    wallet_id UUID REFERENCES payment.wallets(id),
    booking_id UUID REFERENCES booking.bookings(id) NULL,
    amount DECIMAL(18,2) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL, -- DEBIT, CREDIT, HOLD_PENDING, RELEASE_HOLD
    status VARCHAR(50) DEFAULT 'SUCCESS', -- SUCCESS, FAILED, PENDING
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

#### Thiết lập Chỉ mục (Indexes) tối ưu truy vấn hay gặp:
Trong các dự án du lịch, việc tìm kiếm phòng trống theo ngày và tra cứu trạng thái booking theo đại lý diễn ra liên tục. Sinh viên bắt buộc phải cấu hình các chỉ mục sau:
*   `CREATE INDEX idx_bookings_agency_status ON booking.bookings(agency_id, status);`
    *   *Mục đích*: Tối ưu hóa tốc độ tải trang Dashboard danh sách hóa đơn của đại lý (Ledger).
*   `CREATE INDEX idx_inventories_search ON catalog.inventories(product_id, date, available_qty);`
    *   *Mục đích*: Tăng tốc độ API tìm kiếm phòng trống thời gian thực, ngăn tình trạng quét tuần tự toàn bộ bảng (Table Scan) gây chậm database.
*   `CREATE INDEX idx_incidents_product_date ON booking.incidents(product_id, incident_date);`
    *   *Mục đích*: Tối ưu hóa kiểm tra các sự cố ảnh hưởng đến sản phẩm trong ngày cụ thể.
*   `CREATE INDEX idx_transactions_wallet_created ON payment.transactions(wallet_id, created_at);`
    *   *Mục đích*: Tối ưu hiển thị lịch sử giao dịch và đối soát ví của đại lý.

---
--- KẾT THÚC PHẦN 3 ---

## PHẦN 4: SYSTEM ARCHITECTURE (KIẾN TRÚC HỆ THỐNG GỢI Ý)

### 4.1 Sơ đồ kiến trúc tổng thể (ASCII Architecture Diagram)

```
+-------------------------------------------------------------------------------+
|                       PRESENTATION LAYER (Giao diện người dùng)                |
|  [Flutter Mobile App (Tài xế/Đại lý)]       [React.js Web Portal (Admin/Supplier)]|
+-------------------------------------------------------------------------------+
                                        │ (Gọi API qua HTTPS)
                                        ▼
+-------------------------------------------------------------------------------+
|                          API GATEWAY / REVERSE PROXY                          |
|  [Nginx / YARP Gateway] (Cân bằng tải, định tuyến request, giới hạn tần suất)  |
+-------------------------------------------------------------------------------+
                                        │ (Định tuyến nội bộ)
                                        ▼
+-------------------------------------------------------------------------------+
|                     BACKEND ENGINE (ASP.NET Core 8 Web API)                   |
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |   WebAPI Layer (Controllers, Middleware, Swagger, SignalR Hubs)       |   |
|   +-----------------------------------------------------------------------+   |
|                                       │                                       |
|   +-----------------------------------------------------------------------+   |
|   |   Application Layer (CQRS Commands/Queries, MediatR Handlers, DTOs)   |   |
|   +-----------------------------------------------------------------------+   |
|                                       │                                       |
|   +-----------------------------------------------------------------------+   |
|   |   Domain Layer (Entities, Value Objects, Domain Exceptions, Interfaces) |   |
|   +-----------------------------------------------------------------------+   |
|                                       │                                       |
|   +-----------------------------------------------------------------------+   |
|   |   Infrastructure Layer (EF Core DBContext, AWS S3, Redis Client, SMS) |   |
|   +-----------------------------------------------------------------------+   |
+-------------------------------------------------------------------------------+
                                        │ (Kết nối dữ liệu)
                                        ▼
+-------------------------------------------------------------------------------+
|                            DATABASE & STORAGE LAYER                           |
|  [(PostgreSQL DB)]         [(Redis Cache Server)]       [(S3 Object Storage)] |
+-------------------------------------------------------------------------------+
```

---

### 4.2 Luồng xử lý một yêu cầu (Request Flow Step-by-Step)
Quy trình đi của một request từ Flutter app đến khi nhận kết quả từ .NET API:

1.  **Bước 1**: Người dùng mở ứng dụng Flutter, chọn khách sạn và nhấn nút "Đặt giữ chỗ". UI Flutter kích hoạt BLoC Event `HoldBookingRequested`.
2.  **Bước 2**: BLoC gọi hàm trong Repository sử dụng HTTP Client **Dio** để bắn một request POST kèm Body JSON đến `/api/v1/bookings/hold`. Dio Interceptor tự động chèn JWT Token vào Header.
3.  **Bước 3**: Request đi qua **Nginx Reverse Proxy** để check giới hạn tần suất gọi (Rate Limiting), sau đó chuyển tiếp đến cổng HTTP 8080 của ứng dụng ASP.NET Core.
4.  **Bước 4 (WebAPI Layer)**: Middleware xác thực (`JwtBearerMiddleware`) kiểm tra tính hợp lệ của chữ ký Token. Nếu hợp lệ, chuyển tiếp request vào `BookingController`.
5.  **Bước 5 (Application Layer)**: Request được map vào một Command class (`CreateBookingCommand`) và đẩy vào Pipeline thông qua thư viện **MediatR**.
6.  **Bước 6 (Infrastructure Layer)**: Command Handler gọi lớp Repository để truy vấn DB PostgreSQL thông qua Entity Framework Core. Sử dụng Redis Lock để khóa giữ chỗ phòng trống, ghi dữ liệu vào bảng `booking.bookings` và commit transaction.
7.  **Bước 7 (Response)**: Handler trả về DTO chứa mã PNR và thời gian hết hạn hold. Dữ liệu chạy ngược ra Controller, đóng gói thành JSON phản hồi HTTP 201 Created trả về cho Flutter App vẽ lại giao diện thành công.

---

### 4.3 Phân tách các tầng trong Clean Architecture
Kiến trúc chia làm 4 layer đồng tâm, chiều phụ thuộc hướng từ ngoài vào trong:

1.  **Domain Layer (Lõi trung tâm)**:
    *   *Nhiệm vụ*: Chứa các thực thể cốt lõi (Entities), Value Objects và định nghĩa các interface giao tiếp của Domain. Tầng này độc lập hoàn toàn, không reference đến bất kỳ thư viện ngoài nào (không EF Core, không Redis).
    *   *Ví dụ*: Class `Booking.cs` chứa thuộc tính `HoldExpiration` và hàm logic nghiệp vụ `VerifyHoldTime()`.
2.  **Application Layer (Logic ứng dụng)**:
    *   *Nhiệm vụ*: Chứa các nghiệp vụ thực thi (Use Cases). Triển khai CQRS với MediatR.
    *   *Ví dụ*: File `CreateBookingCommandHandler.cs` điều phối việc đọc kho phòng, gọi lưu database, và kích hoạt gửi email thông báo.
3.  **Infrastructure Layer (Hạ tầng kỹ thuật)**:
    *   *Nhiệm vụ*: Hiện thực hóa các interface định nghĩa ở tầng trong. Chứa DBContext, các class kết nối Redis, AWS S3, gửi SMS Gateway.
    *   *Ví dụ*: File `S3FileStorageService.cs` thực hiện upload hóa đơn VAT dạng byte stream lên AWS S3 bucket.
4.  **WebAPI Layer (Giao diện API đầu ra)**:
    *   *Nhiệm vụ*: Điểm đón nhận request đầu vào. Chứa Controllers, cấu hình Dependency Injection (DI) của ứng dụng, Middleware bắt lỗi và Swagger document.
    *   *Ví dụ*: File `BookingController.cs` nhận request HTTP POST và trả về JSON payload.

---

### 4.4 Tại sao chọn Clean Architecture cho đồ án tốt nghiệp CNTT?
*   **Tránh Spaghetti Code**: Tách biệt rõ ràng phần logic nghiệp vụ và phần công nghệ hạ tầng. Ví dụ, nếu sau này hội đồng yêu cầu đổi database từ SQL Server sang PostgreSQL, sinh viên chỉ cần viết lại lớp DbContext ở tầng Infrastructure mà không cần chỉnh sửa một dòng code nào trong tầng Domain và Application.
*   **Dễ dàng viết Unit Test**: Do Domain và Application độc lập với database, ta có thể dễ dàng viết Unit Test để kiểm tra logic tính toán tiền Markup bằng cách dùng thư viện Mock dữ liệu giả lập mà không cần khởi chạy CSDL thực tế.
*   **Portfolio xin việc đắt giá**: Clean Architecture và CQRS là những từ khóa cực kỳ hot trong các buổi tuyển dụng lập trình viên .NET từ trung cấp trở lên. Việc hiện thực hóa thành công mô hình này giúp CV của sinh viên nổi bật hơn hẳn so với các đồ án Monolith truyền thống.

---
--- KẾT THÚC PHẦN 4 ---

## PHẦN 5: API ENDPOINTS (.NET CONTROLLERS SPECIFICATION)

Dưới đây là danh sách đặc tả 30 API Endpoints cốt lõi của hệ thống B2B Travel Engine phục vụ cho nhóm làm app Flutter kết nối kiểm thử:

### 5.1 AuthController (Xác thực người dùng)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/auth/login` | Đăng nhập tài khoản. | Public | `{"email": "...", "password": "..."}` | `{"token": "...", "refreshToken": "..."}` |
| **POST** | `/auth/refresh` | Gia hạn token Access. | Public | `{"refreshToken": "..."}` | `{"token": "...", "refreshToken": "..."}` |
| **POST** | `/auth/logout` | Đăng xuất khỏi hệ thống. | Authorized | Không yêu cầu | `{"success": true}` |
| **POST** | `/auth/register-agency` | Đại lý đăng ký mới. | Public | `{"name": "...", "taxCode": "..."}` | `{"agencyId": "...", "status": "PENDING"}` |
| **POST** | `/auth/reset-password` | Yêu cầu khôi phục mật khẩu. | Public | `{"email": "..."}` | `{"message": "Check your email inbox"}` |

### 5.2 BookingController (Quản lý giao dịch Đặt chỗ)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/bookings/hold` | Giữ chỗ phòng/vé tạm thời. | Agent Staff | `{"productId": "...", "qty": 1}` | `{"bookingId": "...", "pnrCode": "HELD"}` |
| **POST** | `/bookings/{id}/confirm` | Xác nhận đặt vé chính thức. | Agent Manager | Không yêu cầu | `{"bookingId": "...", "status": "CONFIRMED"}` |
| **GET** | `/bookings/{id}` | Lấy chi tiết lịch trình. | Agent Staff | Không yêu cầu | `{"bookingId": "...", "items": [...]}` |
| **GET** | `/bookings` | Lấy danh sách hóa đơn đặt. | Agent Staff | Query Params | `{"items": [...], "totalCount": 10}` |
| **POST** | `/bookings/{id}/cancel` | Hủy toàn bộ booking. | Agent Manager | `{"reason": "Customer cancelled"}` | `{"bookingId": "...", "refundAmount": 0}` |
| **POST** | `/bookings/{id}/partial-cancel` | Hủy một phần booking đoàn. | Agent Manager | `{"itemIds": ["id1", "id2"]}` | `{"bookingId": "...", "newTotal": 1000}` |
| **PUT** | `/bookings/{id}/passenger` | Sửa thông tin hành khách. | Agent Staff | `{"passengers": [...]}` | `{"success": true}` |

### 5.3 SearchController (Bộ máy tìm kiếm & Cấu hình giá)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/search/flights` | Tìm kiếm chuyến bay sỉ. | Agent Staff | Query Params | `{"flights": [...]}` |
| **GET** | `/search/hotels` | Tìm phòng khách sạn còn trống. | Agent Staff | Query Params | `{"hotels": [...]}` |
| **GET** | `/search/tours` | Tìm kiếm tour lữ hành lẻ. | Agent Staff | Query Params | `{"tours": [...]}` |
| **GET** | `/products/{id}` | Lấy chi tiết mô tả sản phẩm. | Agent Staff | Không yêu cầu | `{"productId": "...", "details": {...}}` |
| **POST** | `/search/markup/config` | Cấu hình Markup của đại lý. | Agent Manager | `{"productId": "...", "markupPercent": 8}`| `{"success": true}` |

### 5.4 PaymentController (Quản lý ví tài chính & Cổng thanh toán)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/payments/wallet-pay` | Trừ tiền ví thanh toán booking. | Agent Staff | `{"bookingId": "...", "pin": "..."}` | `{"txId": "...", "status": "SUCCESS"}` |
| **POST** | `/payments/vnpay/create` | Tạo link thanh toán VNPay. | Agent Manager | `{"amount": 10000000}` | `{"paymentUrl": "https://vnpay.vn/..."}` |
| **GET** | `/payments/vnpay/callback` | Endpoint nhận kết quả trả về. | Public | Query Params | Chuyển hướng hoặc trả về HTML kết quả |
| **POST** | `/payments/vnpay/ipn` | Webhook cập nhật tiền từ VNPay. | Public | Query Params | `{"RspCode": "00", "Message": "Confirm"}` |
| **GET** | `/payments/wallet/balance` | Lấy số dư ví đại lý hiện tại. | Agent Staff | Không yêu cầu | `{"balance": 15000000, "creditLimit": 50}` |
| **POST** | `/payments/refund` | Kế toán duyệt hoàn tiền hủy. | Finance | `{"bookingId": "...", "amount": 100}` | `{"success": true}` |

### 5.5 VoucherController (Sinh & Phân phối vé)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **POST** | `/vouchers/generate` | Kích hoạt sinh PDF voucher. | Authorized | `{"bookingId": "..."}` | `{"voucherUrl": "https://s3.amazonaws/..."}` |
| **POST** | `/vouchers/send-email` | Gửi email đính kèm voucher. | Agent Staff | `{"email": "customer@gmail.com"}` | `{"success": true}` |
| **GET** | `/vouchers/{code}/verify` | Quét và xác thực QR check-in. | Delivery Staff | `{"lat": 16.05, "lng": 108.20}` | `{"valid": true, "passengerName": "..."}` |

### 5.6 ReportController (Báo cáo & Giám sát)

| Method | Route | Mô tả chức năng | Quyền truy cập | Request Body | Response (200 OK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **GET** | `/reports/revenue` | Báo cáo doanh số đại lý. | Agent Manager | Query Params | `{"chartData": [...], "totalRevenue": 100}` |
| **GET** | `/reports/agents` | Báo cáo hiệu suất bán của CTV. | Admin / Finance| Query Params | `{"rankings": [...]}` |
| **GET** | `/reports/audit-logs` | Xem lịch sử thao tác hệ thống. | Admin | Query Params | `{"logs": [...]}` |

---
--- KẾT THÚC PHẦN 5 ---

## PHẦN 6: FLUTTER APP — CẤU TRÚC VÀ TÍNH NĂNG CHI TIẾT

### 6.1 Danh sách màn hình (Screen List)
Ứng dụng di động Flutter dành cho Agent và Delivery Staff gồm các màn hình chính sau:

1.  `LoginScreen`: Nhập tài khoản và mật khẩu, hỗ trợ lưu trạng thái đăng nhập tự động.
2.  `SearchDashboardScreen`: Thanh tìm kiếm trung tâm chứa 3 Tab lựa chọn dịch vụ (Khách sạn, Chuyến bay, Tour) và bộ lọc nâng cao.
3.  `ProductDetailScreen`: Hiển thị mô tả sản phẩm, ảnh chụp, các tiện ích đi kèm và danh sách phòng trống/lịch bay khả dụng.
4.  `CartCheckoutScreen`: Danh sách giỏ hàng, điền thông tin hành khách, hiển thị đếm ngược giữ chỗ và nút chọn ví thanh toán.
5.  `BookingHistoryScreen`: Bảng Ledger danh sách lịch trình đã đặt, phân lọc theo trạng thái (Held, Paid, Cancelled).
6.  `QRScanCheckinScreen`: Giao diện camera của Delivery Agent để quét mã QR check-in khách hàng, phát tín hiệu bíp rung khi quét trúng.

---

### 6.2 Cấu trúc thư mục Flutter khuyên dùng (Feature-first Structure)
Để quản lý dự án sạch sẽ, dễ mở rộng khi làm đồ án nhóm:

```
lib/
  ├── main.dart                 # Điểm khởi chạy app
  ├── app_router.dart           # Cấu hình GoRouter định tuyến màn hình
  ├── core/                     # Chứa các thành phần dùng chung toàn app
  │     ├── constants/          # Màu sắc, font chữ, đường dẫn ảnh
  │     ├── network/            # Cấu hình Dio Client và Interceptors
  │     └── storage/            # Cấu hình Hive database local
  └── features/                 # Chia thư mục theo từng miền chức năng
        ├── auth/               # Module Xác thực
        │     ├── bloc/         # Quản lý state đăng nhập
        │     ├── data/         # Repository gọi API đăng nhập
        │     └── presentation/ # Giao diện LoginScreen.dart
        ├── search/             # Module Tìm kiếm & Bộ lọc
        ├── booking/            # Module Giỏ hàng & Đặt chỗ
        └── delivery/           # Module Quét QR check-in của tài xế
```

---

### 6.3 Code cấu hình Dio Client và Interceptor xử lý tự động JWT
Đây là đoạn code mẫu cực kỳ quan trọng giúp tự động chèn JWT Token vào mọi request gửi lên server và xử lý refresh token khi hết hạn:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();

  ApiClient() {
    dio.options.baseUrl = "https://api.b2btravelplatform.com/api/v1";
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy token từ secure storage và gắn vào Header
          String? token = await storage.read(key: "access_token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Bắt lỗi 401 Unauthorized (Token hết hạn)
          if (error.response?.statusCode == 401) {
            String? refreshToken = await storage.read(key: "refresh_token");
            if (refreshToken != null) {
              try {
                // Gọi API refresh token
                final refreshResponse = await Dio().post(
                  "${dio.options.baseUrl}/auth/refresh",
                  data: {"refreshToken": refreshToken},
                );
                
                String newAccessToken = refreshResponse.data["token"];
                String newRefreshToken = refreshResponse.data["refreshToken"];
                
                // Lưu token mới
                await storage.write(key: "access_token", value: newAccessToken);
                await storage.write(key: "refresh_token", value: newRefreshToken);
                
                // Thực hiện lại request cũ bị lỗi với token mới
                error.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
                final cloneRequest = await dio.fetch(error.requestOptions);
                return handler.resolve(cloneRequest);
              } catch (e) {
                // Refresh token cũng hết hạn -> Yêu cầu đăng nhập lại
                await storage.deleteAll();
                // Chuyển hướng về màn hình Login (ví dụ: qua GoRouter redirect)
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
```

---

### 6.4 Offline Handling (Xử lý khi thiết bị mất kết nối mạng)
Để ứng dụng di động quét mã QR check-in của tài xế không bị lỗi khi xe đi vào khu vực vùng núi cao mất sóng di động:

1.  **Sử dụng package `connectivity_plus`**: Để lắng nghe trạng thái kết nối internet thời gian thực của điện thoại.
2.  **Lưu trữ cache local bằng Hive**:
    *   Trước khi xuất phát đón khách (nơi có wifi ổn định), tài xế nhấn nút "Đồng bộ chuyến đi". Hệ thống tải danh sách khách hàng đón trong ngày và lưu vào Hive Box local có tên `trip_passengers`.
3.  **Quy trình quét offline**:
    *   Khi quét mã QR, nếu app phát hiện thiết bị đang offline: Nó sẽ không gửi request API xác thực lên .NET Backend.
    *   App tự giải mã chuỗi QR Code, so khớp mã định danh với dữ liệu lưu trong Hive Box `trip_passengers`.
    *   Nếu khớp, đổi trạng thái hành khách sang `Delivered` trong Hive local, ghi nhận thời gian quét và vị trí GPS của điện thoại lúc đó.
    *   Lưu lịch check-in offline này vào một Box riêng tên `offline_checkins`.
4.  **Đồng bộ ngược tự động (Background Sync)**:
    *   Thiết lập một listener theo dõi kết nối mạng. Ngay khi phát hiện trạng thái mạng chuyển từ offline sang online, app tự động lặp qua Box `offline_checkins`, gọi API đẩy dữ liệu lên server để đồng bộ và clear dữ liệu local.

---

### 6.5 Top 5 màn hình nên thiết kế đẹp mắt để demo ghi điểm
Sinh viên cần trau chuốt tối đa UI/UX cho 5 màn hình dưới đây để gây ấn tượng mạnh với hội đồng phản biện đồ án tốt nghiệp:
1.  **SearchDashboardScreen**: Thiết kế bộ Tab lựa chọn chuyến bay/phòng hiện đại, sử dụng hiệu ứng trượt nhẹ (Carousel) hiển thị các địa điểm du lịch hot ở Việt Nam.
2.  **ProductDetailScreen**: Hiển thị ảnh trượt lớn chất lượng cao, các thông tin giá sỉ và nút "Agent Mode Toggle" bật/tắt hiển thị tinh tế.
3.  **CartCheckoutScreen**: Đồng hồ đếm ngược giữ chỗ (Hold Countdown) được làm to, rõ ràng, đổi màu đỏ nhấp nháy tăng tính khẩn cấp kèm theo form nhập thông tin khách hàng thiết kế tối giản, hỗ trợ tự điền tự động.
4.  **QRScanCheckinScreen**: Màn hình quét QR camera chiếm trọn khung hình, tích hợp overlay khung ngắm quét bo tròn phát sáng và popup thông báo check-in thành công màu xanh lục hiện ra mượt mà từ dưới màn hình.
5.  **AgencyDashboardScreen (Báo cáo doanh thu)**: Chứa các đồ thị trực quan (Chart.js / Line & Bar charts) hiển thị lượng tiền bán trong ngày và số tiền trong ví trực quan.

---
--- KẾT THÚC PHẦN 6 ---

## PHẦN 7: SCOPE — PHẠM VI THỰC HIỆN ĐỒ ÁN

> [!IMPORTANT]
> **GIẢNG VIÊN THƯỜNG CHẤM KỸ**: Khả năng tự đánh giá và khoanh vùng phạm vi (Scope Management) của sinh viên. Sinh viên thường mắc lỗi "Over-scope" dẫn đến việc làm quá nhiều tính năng phụ nhưng các luồng cốt lõi lại chạy bị lỗi hoặc sơ sài.

---

### 7.1 IN SCOPE (Bắt buộc phải hoàn thành cho bản MVP)
*   **Backend .NET 8**:
    *   Đăng ký đại lý trực tuyến và phê duyệt thủ công của Admin.
    *   Đăng nhập lấy Token JWT và cơ chế tự gia hạn phiên (Refresh Token).
    *   Tìm kiếm và lọc phòng trống khách sạn thời gian thực.
    *   Luồng đặt phòng giữ chỗ (Hold Booking) tự đếm ngược 15 phút giải phóng kho.
    *   Thanh toán trừ tiền số dư ví đại lý (Wallet Payment) và nạp tiền tự động qua IPN Webhook VNPay.
    *   Sinh file PDF E-Voucher tự động có chứa mã QR bảo mật ký số HMAC.
*   **Flutter App**:
    *   Giao diện tìm kiếm, chọn phòng đưa vào giỏ hàng và thanh toán.
    *   Lịch sử đơn hàng và Ledger biến động số dư tài khoản ví.
    *   Ứng dụng di động quét mã QR check-in khách hàng lên xe/nhận phòng trực tiếp.

---

### 7.2 OUT OF SCOPE (Không thực hiện trong đồ án — Tránh lan man)
*   **Tích hợp GDS thật (Sabre, Amadeus)**: Không tích hợp GDS thật vì chi phí bản quyền và tiền ký quỹ hàng ngàn USD là bất khả thi đối với sinh viên. Tất cả dữ liệu chuyến bay sẽ được kết nối qua một **Mock API Gateway** tự viết để mô phỏng dữ liệu phản hồi của GDS.
*   **Tích hợp Tổng đài cuộc gọi (Call Center API)**: Tính năng gọi điện thoại trực tiếp cho đại lý trên app được loại bỏ, thay vào đó chỉ hiển thị nút bấm gọi hotline thông thường của thiết bị di động để tránh phát sinh chi phí VoIP API.
*   **Thuật toán AI gợi ý lịch trình tự động**: Loại bỏ việc tích hợp mô hình ngôn ngữ lớn để tự động sinh lịch trình tour lữ hành nhằm tập trung tối đa thời gian hoàn thiện luồng thanh toán giao dịch.

---

### 7.3 NICE-TO-HAVE (Tính năng điểm cộng nếu còn thời gian)
*   **Xác thực sinh trắc học (Biometric Authentication)**: Hỗ trợ đăng nhập nhanh trên ứng dụng Flutter bằng vân tay (TouchID) hoặc nhận diện khuôn mặt (FaceID).
*   **White-label Setup**: Thiết lập cho phép một đại lý du lịch cấu hình thay đổi tên miền, màu sắc chủ đạo của trang web portal riêng theo thương hiệu của họ chạy trên nền tảng chính.

---
--- KẾT THÚC PHẦN 7 ---

## PHẦN 8: CHECKLIST VÀ CÂU HỎI BẢO VỆ ĐỒ ÁN

---

### 8.1 Checklist Chuẩn bị trước ngày bảo vệ

#### 1. Code Checklist (.NET + Flutter)
*   [ ] Toàn bộ mã nguồn Backend đã được đẩy lên GitHub nhánh `main`, không chứa file rác `.env` hay mật khẩu thô trong file `appsettings.json`.
*   [ ] Toàn bộ API Controller được cấu hình Global Exception Middleware để không bao giờ trả về lỗi thô (Stack Trace) dạng HTML cho Client.
*   [ ] Ứng dụng Flutter đã được build xuất ra file cài đặt **APK** (cho Android) và đã test chạy ổn định trên 3 dòng điện thoại khác nhau.
*   [ ] Cơ sở dữ liệu PostgreSQL đã được chạy lệnh migration đầy đủ trên server chạy demo, chứa sẵn ít nhất 100 bản ghi dữ liệu mẫu (mẫu khách sạn, vé xe, tài khoản đại lý chạy thử).

#### 2. Documentation Checklist
*   [ ] Thuyết minh đồ án tốt nghiệp định dạng Word/PDF trình bày đúng biểu mẫu quy định của nhà trường, đầy đủ mục lục hình vẽ và bảng biểu.
*   [ ] Sơ đồ lược đồ cơ sở dữ liệu ERD rõ ràng, mô tả đầy đủ các mối quan hệ 1-nhiều, nhiều-nhiều giữa các bảng.
*   [ ] Tài liệu API được tài liệu hóa tự động qua Swagger UI hoạt động tốt và có sẵn link truy cập trực tuyến.

#### 3. Demo & Slide Checklist
*   [ ] Slide thuyết trình khoảng 20-25 trang, tập trung làm rõ: Vấn đề nghiệp vụ du lịch B2B, Kiến trúc phần mềm đề xuất, Sơ đồ cơ sở dữ liệu ERD, Kết quả chạy thử nghiệm và Kết luận.
*   [ ] Chuẩn bị sẵn 2 điện thoại di động chạy app Flutter (1 điện thoại tài khoản Agent Staff dùng đặt vé, 1 điện thoại tài khoản tài xế dùng để quét QR check-in demo trực tiếp).
*   [ ] Chuẩn bị sẵn video ghi lại màn hình chạy luồng chính đề phòng sự cố mất mạng internet đột xuất tại hội trường bảo vệ (Offline Demo Fallback).

---

### 8.2 Top 5 Câu hỏi Hội đồng phản biện hay hỏi nhất & Gợi ý trả lời

#### Câu hỏi 1: Tại sao em lại chọn mô hình kiến trúc Clean Architecture cho đồ án này mà không dùng kiến trúc Monolith 3 lớp thông thường?
*   *Gợi ý trả lời*: 
    > "Thưa hội đồng, dự án B2B Travel Engine đòi hỏi tính độc lập nghiệp vụ cao và tính dễ bảo trì lâu dài do thường xuyên thay đổi tích hợp với các API dịch vụ bên thứ ba (hãng bay, cổng thanh toán). Clean Architecture giúp tách biệt hoàn toàn phần Logic nghiệp vụ (Domain & Application) ra khỏi Công nghệ hạ tầng (Infrastructure như EF Core, Redis, AWS S3). Điều này giúp chúng em dễ dàng viết Unit Test độc lập cho logic tính hoa hồng Markup, đồng thời sẵn sàng thay thế/nâng cấp công nghệ hạ tầng trong tương lai mà không làm ảnh hưởng đến lõi nghiệp vụ cốt lõi của ứng dụng."

#### Câu hỏi 2: Em giải quyết bài toán chống đặt trùng lặp (Double Booking) khi hai đại lý cùng thanh toán mua 1 phòng khách sạn cuối cùng như thế nào?
*   *Gợi ý trả lời*:
    > "Chúng em áp dụng giải pháp bảo mật dữ liệu ở hai tầng độc lập. Tại tầng ứng dụng Backend, khi đại lý bấm giữ chỗ, hệ thống sử dụng thư viện Redis để tạo một khóa phân tán (**Redis Distributed Lock - Redlock**) theo ID của phòng và ngày đặt đó trong vòng 10 giây. Tại tầng Database PostgreSQL, chúng em áp dụng cơ chế **Optimistic Locking (Khóa lạc quan)** bằng cách sử dụng thuộc tính `Version` tăng dần trong bảng `catalog.inventories`. Nếu phát hiện có xung đột version khi update số lượng phòng, EF Core sẽ ném ra lỗi `DbUpdateConcurrencyException`, hệ thống lập tức rollback giao dịch và hoàn tiền ví tự động cho đại lý thanh toán sau."

#### Câu hỏi 3: Refresh Token được lưu trữ ở đâu trên Server và Client để đảm bảo an toàn, phòng chống tấn công XSS và CSRF?
*   *Gợi ý trả lời*:
    > "Trên Server, Refresh Token được băm một chiều và lưu trong DB kèm theo ID của user và thời gian hết hạn. Khi gửi về Client qua trình duyệt Web, chúng em lưu Refresh Token vào **HttpOnly Cookie** có cấu hình thuộc tính `Secure` và `SameSite=Strict` để ngăn không cho mã độc Javascript đọc được (chống XSS) và hạn chế gửi token chéo site (chống CSRF). Trên ứng dụng di động Flutter, chúng em sử dụng thư viện bảo mật phần cứng `flutter_secure_storage` để lưu trữ token trong vùng nhớ an toàn Keychain của hệ điều hành iOS và Android."

#### Câu hỏi 4: Trong app Flutter, em quản lý luồng dữ liệu (State Management) như thế nào? Tại sao lại chọn BLoC Pattern thay vì Provider hay GetX?
*   *Gợi ý trả lời*:
    > "Chúng em sử dụng BLoC (Business Logic Component) vì đây là pattern giúp phân tách triệt để nhất giữa giao diện UI và logic nghiệp vụ. BLoC hoạt động theo luồng dữ liệu một chiều rõ ràng (UI gửi Event -> BLoC xử lý -> Trả về State -> UI render lại). Điều này rất hữu ích cho các dự án du lịch phức tạp có nhiều trạng thái màn hình động như màn hình Checkout (chờ thanh toán, hết hạn hold, nạp tiền thành công). Ngoài ra, BLoC giúp code dễ kiểm thử (Unit Test) và dễ làm việc nhóm do quy định cấu trúc code đồng bộ hơn so với GetX hay Provider vốn dễ viết tự do tự phát sinh spaghetti code ở phía UI."

#### Câu hỏi 5: Cơ chế xác thực mã QR Code trên Voucher của em hoạt động thế nào? Làm sao ngăn chặn việc khách chụp ảnh màn hình gửi cho người khác đi check-in lậu?
*   *Gợi ý trả lời*:
    > "Mã QR Code trên Voucher chứa thông tin mã hóa dạng JSON bao gồm: `BookingId`, `VoucherId` và một chuỗi chữ ký số mật mã `Signature` được tạo từ thuật toán **HMAC-SHA256** sử dụng Secret Key bảo mật lưu trên Backend Server. Khi tài xế quét QR offline bằng app Flutter, app giải mã và verify tính hợp lệ của Signature cục bộ. Để chống việc khách chụp ảnh màn hình gửi cho người khác sử dụng, trên giao diện app của khách hàng cuối, mã QR là mã QR động (**Dynamic QR Code**), tự động thay đổi hash mã hóa cứ sau mỗi 30 giây bằng cách nhúng thêm trường thời gian thực tế vào chuỗi băm."

---
--- KẾT THÚC PHẦN 8 ---
