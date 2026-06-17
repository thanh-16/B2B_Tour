# PROJECT DESCRIPTION DOCUMENT (TÀI LIỆU MÔ TẢ DỰ ÁN)
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

---

## [PHẦN 1 — BỐI CẢNH & CƠ HỘI]

### 1.1 Phân tích thị trường B2B Travel Việt Nam & Đông Nam Á
Thị trường du lịch trực tuyến tại Đông Nam Á (SEA) đang trải qua một chu kỳ phát triển mạnh mẽ sau giai đoạn phục hồi hậu đại dịch. Theo báo cáo thường niên *e-Conomy SEA* của Google, Temasek và Bain & Company, quy mô nền kinh tế số ngành du lịch trực tuyến tại Đông Nam Á dự kiến sẽ vượt mốc 30 tỷ USD. Việt Nam, cùng với Thái Lan và Indonesia, là ba quốc gia dẫn đầu về tốc độ tăng trưởng lưu lượng tìm kiếm và khối lượng giao dịch du lịch.

Tại Việt Nam, cấu trúc phân phối ngành du lịch có sự phân mảnh rất lớn. Mặc dù các OTA (Online Travel Agent) toàn cầu như Agoda, Booking.com hay các OTA nội địa lớn như Traveloka, Mytour chiếm lĩnh thị phần khách lẻ tự túc (B2C), thì phân khúc khách đoàn, khách đi theo tour tùy biến và khách cần tư vấn sâu vẫn phụ thuộc hoàn toàn vào mạng lưới hơn 15.000 doanh nghiệp lữ hành vừa và nhỏ, đại lý truyền thống, đại lý gia đình và hàng vạn cộng tác viên (Freelance Agents) tự do. 

Tuy nhiên, thị trường phân phối bán sỉ (B2B) phục vụ cho đối tượng này hiện chưa có một nền tảng công nghệ nào chiếm lĩnh thế độc tôn. Hầu hết các giao dịch bán buôn phòng khách sạn, vé máy bay và tour lẻ vẫn đang được vận hành bằng các phương pháp thủ công và các kênh liên lạc truyền thống.

---

### 1.2 Pain Points (Nỗi đau nghiệp vụ) của Đại lý du lịch truyền thống
Quy trình vận hành hiện tại của các đại lý du lịch truyền thống gặp phải 4 nút thắt cổ chai lớn:

```
[ Tìm kiếm thủ công ] ──> [ Báo giá chậm (Zalo/Email) ] ──> [ Giữ chỗ thủ công ] ──> [ Chuyển khoản xác nhận ] ──> [ Phát voucher giấy ]
      (Mất 1-2 giờ)               (Khách chờ lâu)            (Dễ bị hủy PNR)          (Rủi ro đối soát chậm)       (Rủi ro giả mạo)
```

1.  **Sự phân mảnh thông tin và Kho hàng (Inventory Fragmentation)**: Để xây dựng một báo giá tour trọn gói cho khách (bao gồm vé máy bay, phòng khách sạn tại Đà Nẵng, vé tham quan Bà Nà và xe đưa đón), nhân viên đại lý phải mở đồng thời 4-5 tab trình duyệt, chat với 3-4 nhà cung cấp qua Zalo/Skype để kiểm tra tình trạng chỗ và giá Net. Quá trình này tiêu tốn từ 30 phút đến 2 giờ của nhân viên.
2.  **Thời gian giữ chỗ quá ngắn (Hold Time Limit Constraints)**: Các hãng hàng không giá rẻ (LCC) chỉ cho phép giữ chỗ vé máy bay trong vòng 15-30 phút mà không cần thanh toán. Khách sạn chỉ giữ chỗ phòng trong vòng 1-2 giờ. Nếu nhân viên đại lý không chốt tiền được với khách hàng kịp thời hoặc kế toán đại lý chậm trễ chuyển khoản cho Supplier, booking sẽ tự động bị hủy trên hệ thống gốc. Khi đại lý cố gắng đặt lại, giá vé có thể đã tăng lên hoặc phòng đã bị bên khác mua mất.
3.  **Tỷ lệ cộng giá (Markup) thủ công dễ sai sót**: Khi gửi thông tin cho khách hàng cuối, đại lý phải tự tính toán số tiền lời (Markup) thủ công. Việc tính toán nhầm lẫn tỷ giá, thuế phí VAT hoặc tính sai hoa hồng của CTV dẫn đến nhiều trường hợp đại lý bị thua lỗ hoặc báo giá quá cao làm mất khách.
4.  **Rủi ro bàn giao dịch vụ và quản lý Voucher**: Việc bàn giao voucher cho khách hàng cuối chủ yếu được thực hiện qua các file ảnh hoặc file PDF thô gửi qua Zalo. Định dạng này không có tính bảo mật, dễ bị sao chép hoặc giả mạo. Tại các điểm đón xe hoặc điểm sử dụng dịch vụ, việc kiểm tra vé của tài xế hoặc hướng dẫn viên thực hiện bằng mắt thường đối chiếu với danh sách giấy, dẫn đến nguy cơ đón nhầm khách, thất thoát doanh thu hoặc khách hàng đã hủy tour vẫn check-in thành công.

---

### 1.3 So sánh Market Gap với các hệ thống hiện có (Competitor Analysis)

| Tiêu chí | GDS Truyền thống (Amadeus, Sabre, Travelport) | B2C OTA (Agoda, Booking.com) | Nền tảng B2B Travel Platform đề xuất |
| :--- | :--- | :--- | :--- |
| **Giao diện & Trải nghiệm (UX)** | Phức tạp, sử dụng các câu lệnh dạng command-line, yêu cầu nhân viên phải qua đào tạo chuyên sâu. | Tối ưu cho khách lẻ mua trực tiếp, không có giao diện quản lý bán buôn. | Giao diện hiện đại, trực quan, hỗ trợ tính toán Markup nhanh cho đại lý. |
| **Giá sỉ (Net Rate) & Công nợ** | Yêu cầu ký quỹ tài chính lớn (từ hàng trăm triệu đồng), phí duy trì cổng kết nối hàng tháng đắt đỏ. | Chỉ thanh toán trực tiếp qua thẻ Credit của khách hàng, không hỗ trợ công nợ B2B. | **Không mất phí duy trì, hỗ trợ nạp ví linh hoạt, cấp hạn mức công nợ (Credit Limit) cho đại lý uy tín.** |
| **Tích hợp dịch vụ nội địa** | Chỉ mạnh về Vé máy bay quốc tế và các chuỗi Khách sạn 4-5 sao. | Yếu về mảng Tour lẻ địa phương, Vé xe khách nội địa và combo tự thiết kế. | **Tích hợp sâu các dịch vụ local (Tours, Vé xe đưa đón, Combo tự thiết kế).** |
| **Luồng bàn giao (Delivery)** | Hoàn toàn bỏ trống khâu bàn giao thực tế cho hành khách. | Khách tự trình diện thông tin đặt phòng tại lễ tân khách sạn. | **Có ứng dụng di động quét mã QR xác thực check-in thời gian thực cho tài xế/HDV tại điểm đón.** |

---

### 1.4 Tại sao đây là thời điểm vàng để xây dựng nền tảng?
1.  **Sự trưởng thành của hạ tầng thanh toán**: Cổng thanh toán quốc gia VNPay, ứng dụng ngân hàng số hỗ trợ VietQR sinh mã chuyển khoản động giúp các đại lý du lịch có thể thực hiện giao dịch nạp tiền và thanh toán booking tức thời (Instant Payment) trong 5 giây với mức phí cực thấp.
2.  **Sự phổ biến của Thiết bị di động & 4G/5G**: Hầu hết các tài xế xe du lịch, hướng dẫn viên địa phương hiện nay đều sử dụng điện thoại thông minh kết nối mạng di động tốc độ cao. Đây là hạ tầng lý tưởng để triển khai ứng dụng quét mã QR bàn giao dịch vụ mà không cần đầu tư thiết bị chuyên dụng đắt tiền.
3.  **Xu hướng tối ưu hóa chi phí vận hành**: Sau đại dịch, các đại lý du lịch bắt buộc phải cắt giảm nhân sự. Họ có nhu cầu cực kỳ cao đối với các công cụ tự động hóa quy trình (SaaS) giúp 1 nhân viên có thể xử lý lượng công việc gấp 3 lần trước đây.

---
--- KẾT THÚC TÀI LIỆU 1 ---

## [PHẦN 2 — TẦM NHÌN & MỤC TIÊU]

### 2.1 Vision & Mission Statement
*   **Tầm nhìn (Vision)**: 
    > "Trở thành cơ sở hạ tầng công nghệ du lịch B2B hàng đầu tại Đông Nam Á, chuyển đổi số toàn diện phương thức kết nối giao dịch lữ hành từ khâu đặt chỗ trực tuyến đến khâu bàn giao dịch vụ thực tế. Chúng tôi kiến tạo một hệ sinh thái minh bạch, tốc độ cao và an toàn tuyệt đối cho mọi đại lý du lịch và nhà cung cấp dịch vụ trong khu vực."
*   **Sứ mệnh (Mission)**:
    > "Dân chủ hóa công nghệ du lịch bằng cách cung cấp cho các đại lý lữ hành nhỏ và vừa (SMEs) một nền tảng SaaS chuyên nghiệp, giúp họ tiếp cận kho hàng giá sỉ thời gian thực, tự động hóa quy trình quản trị tài chính và nâng cao trải nghiệm dịch vụ cho khách hàng cuối thông qua giải pháp xác thực số hóa."

---

### 2.2 Mục tiêu chiến lược phát triển nền tảng

```
[ MVP 6 Tháng ] ──────────────> [ 1 Năm Tiếp Theo ] ──────────────> [ Tầm Nhìn 3 Năm ]
- Hoàn thiện luồng Booking     - Đạt 1.000 đại lý hoạt động        - Phủ rộng 3 nước SEA
- Tích hợp VNPay               - Kết nối 500 khách sạn nội địa     - Ra mắt AI Dynamic Pricing
- Launch App quét QR           - Đạt điểm NPS > 65                 - White-label cho đại lý lớn
```

#### 1. Giai đoạn MVP 6 tháng: Xây dựng nền tảng cốt lõi
*   Hoàn thiện toàn bộ các tính năng nghiệp vụ cơ bản: Tìm kiếm dịch vụ (Khách sạn, Vé xe, Tour), đặt giữ chỗ tự động (Hold Booking), thanh toán qua Ví đại lý nội bộ và tích hợp cổng thanh toán VNPay.
*   Phát triển và đưa lên kho ứng dụng (Google Play, App Store) phiên bản ứng dụng di động Flutter dành cho Delivery Agent thực hiện quét mã QR check-in hành khách.
*   Đưa vào vận hành thử nghiệm với ít nhất 50 đại lý du lịch thân thiết tại khu vực miền Trung Việt Nam để tối ưu hóa quy trình.

#### 2. Giai đoạn 1 năm: Tăng trưởng quy mô mạng lưới
*   Đạt cột mốc 1.000 đại lý du lịch đăng ký và hoạt động thường xuyên trên hệ thống.
*   Kết nối trực tiếp kho phòng (Direct Contract) với ít nhất 500 khách sạn từ 3 đến 5 sao tại các trung điểm du lịch lớn (Đà Nẵng, Nha Trang, Phú Quốc, Sa Pa).
*   Đưa chỉ số đo lường mức độ hài lòng của khách hàng (NPS - Net Promoter Score) đạt trên 65 điểm.

#### 3. Giai đoạn 3 năm: Dẫn đầu thị trường và Mở rộng quốc tế
*   Mở rộng thị trường ra các quốc gia láng giềng trong khu vực Đông Nam Á có mô hình du lịch tương đồng (Thái Lan, Campuchia, Lào).
*   Ứng dụng thuật toán Trí tuệ nhân tạo (AI Engine) để tự động hóa việc phân tích hành vi tìm kiếm, gợi ý lịch trình tour thông minh (AI Dynamic Packaging) và dự báo giá vé máy bay.
*   Cung cấp phiên bản White-label cho phép các đại lý du lịch lớn tự dựng thương hiệu riêng chạy trên nền tảng hạ tầng của platform.

---

### 2.3 Chỉ số đo lường hiệu quả cốt lõi (Core KPIs)

| Mã KPI | Tên chỉ số đo lường | Công thức / Định nghĩa tính toán | Mục tiêu MVP (6M) | Mục tiêu 1 năm |
| :--- | :--- | :--- | :--- | :--- |
| **KPI-GMV** | Gross Merchandise Value | Tổng giá trị giao dịch đặt vé/phòng thành công trên sàn (chưa trừ hoàn/hủy). | 5 Tỷ VND | 50 Tỷ VND |
| **KPI-BVOL** | Booking Volume | Tổng số lượng booking con (Child Bookings) được phát hành thành công. | 2,000 Booking | 25,000 Booking |
| **KPI-ACT** | Active Agent Count | Số lượng đại lý du lịch có phát sinh tối thiểu 3 giao dịch đặt chỗ trong tháng. | 50 Đại lý | 800 Đại lý |
| **KPI-ARR** | Agent Retention Rate | Tỷ lệ đại lý tiếp tục sử dụng dịch vụ trong tháng tiếp theo = (Đại lý cũ quay lại / Tổng đại lý tháng trước) * 100%. | 80% | 92% |
| **KPI-NPS** | Net Promoter Score | Chỉ số đo lường mức độ hài lòng và sẵn sàng giới thiệu nền tảng của đại lý (Scale -100 đến 100). | > 50 Điểm | > 70 Điểm |
| **KPI-ERR** | Booking Error Rate | Tỷ lệ đặt chỗ bị lỗi hệ thống/lỗi overbooking trên tổng số yêu cầu đặt chỗ. | < 0.8% | < 0.2% |

---
--- KẾT THÚC TÀI LIỆU 2 ---

## [PHẦN 3 — MÔ TẢ SẢN PHẨM — 7 MODULES]

### 3.1 Module 1: Agent Portal & Onboarding
*   **Góc nhìn người dùng (User Perspective)**: 
    *   Doanh nghiệp lữ hành truy cập vào địa chỉ web hệ thống, thực hiện đăng ký thông tin doanh nghiệp (Tên, MST, Số điện thoại, tải bản scan Giấy phép kinh doanh lữ hành quốc tế/nội địa).
    *   Sau khi gửi đăng ký, hệ thống tự động kiểm tra định dạng dữ liệu và chuyển trạng thái chờ duyệt. Chủ đại lý nhận được email cập nhật tiến trình hồ sơ.
    *   Khi được Platform Admin phê duyệt kích hoạt tài khoản, Chủ đại lý (Agency Owner) đăng nhập vào hệ thống, thực hiện tạo tài khoản phụ cho nhân viên kinh doanh của mình (Agency Staff) và thiết lập mã PIN bảo mật giao dịch cho ví tài khoản.

---

### 3.2 Module 2: Search & Discovery Engine
*   **Góc nhìn người dùng**:
    *   Nhân viên đại lý mở thanh tìm kiếm trung tâm trên dashboard, chọn loại dịch vụ cần tìm (Khách sạn, Chuyến bay hoặc Tour).
    *   Nhập điểm đến (ví dụ: "Nha Trang"), khoảng ngày đi và số lượng hành khách (phân tách người lớn, trẻ em theo độ tuổi).
    *   Hệ thống hiển thị kết quả lọc cực nhanh. Nhân viên có thể tích chọn thêm các bộ lọc nâng cao như: Lọc theo giá Net, lọc theo mức hoa hồng được nhận, lọc theo vị trí địa lý hiển thị trực quan trên bản đồ.
    *   Đặc biệt, hệ thống hỗ trợ tính năng "Agent Mode Toggle" - một nút tắt trên màn hình giúp nhân viên ẩn nhanh toàn bộ thông tin giá Net và chiết khấu nội bộ khi đang mở màn hình tư vấn trực tiếp trước mặt khách hàng cuối.

---

### 3.3 Module 3: Booking & Checkout Workflow
*   **Góc nhìn người dùng**:
    *   Sau khi chọn được dịch vụ ưng ý từ giỏ hàng, nhân viên nhập thông tin cá nhân của hành khách. Hệ thống tự động kiểm tra định dạng số hộ chiếu và số điện thoại.
    *   Nhân viên nhấn nút **"Giữ chỗ tạm thời (Hold Booking)"**. Hệ thống sẽ hiển thị một đồng hồ đếm ngược (Hold Countdown Timer) cho biết chính xác còn bao nhiêu phút để thanh toán trước khi booking tự động hủy.
    *   Mã đặt chỗ nội bộ (PNR Code) được sinh ra để nhân viên gửi thông tin xác nhận cho khách hàng chuyển khoản.
    *   Khi khách chuyển tiền, nhân viên nhấn nút "Xác nhận thanh toán", hệ thống tự động gọi API đến Supplier để xác thực xuất vé chính thức.

---

### 3.4 Module 4: Payment & Invoicing B2B
*   **Góc nhìn người dùng**:
    *   Đại lý thực hiện thanh toán bằng cách sử dụng số dư ví điện tử nội bộ (Agency Wallet). Số dư này có thể được nạp tự động qua cổng thanh toán VNPay bằng cách quét mã VietQR chuyển khoản liên ngân hàng 24/7.
    *   Đối với các đại lý lớn được cấp hạn mức tín dụng (Credit Limit), số dư ví có thể ở trạng thái âm tối đa bằng hạn mức cho phép.
    *   Khi thanh toán thành công, hệ thống tự động ghi nhận biến động số dư và gửi hóa đơn điện tử tạm thời (E-Invoice) chứa chi tiết giá Net, giá bán, phí VAT của dịch vụ để đại lý lưu trữ đối soát nội bộ.

---

### 3.5 Module 5: Fulfillment & Delivery (E-Voucher)
*   **Góc nhìn người dùng**:
    *   Ngay sau khi giao dịch thanh toán được hệ thống ghi nhận thành công, Worker backend tự động sinh file PDF E-Voucher chính thức.
    *   Voucher này được thiết kế theo chuẩn thương hiệu của đại lý đặt (chứa Logo, số hotline của đại lý để tăng nhận diện thương hiệu) kèm theo một **mã QR Code bảo mật**.
    *   Mã QR này được mã hóa bảo mật chứa chữ ký số một chiều (HMAC-SHA256) để ngăn chặn việc chỉnh sửa thông tin bằng các phần mềm đồ họa.
    *   Khách hàng cuối nhận được voucher trực tiếp qua Email hoặc tin nhắn SMS chứa link tải.

---

### 3.6 Module 6: After-sales & Customer Support
*   **Góc nhìn người dùng**:
    *   Khi khách hàng có nhu cầu thay đổi lịch trình hoặc hủy tour, nhân viên đại lý mở chi tiết booking cũ, nhấn chọn "Yêu cầu thay đổi/Hủy dịch vụ".
    *   Hệ thống tự động hiển thị chính sách hủy phòng (Cancellation Policy) và tính toán số tiền phạt thực tế theo thời gian thực (ví dụ: hủy trước 3 ngày phạt 50% tiền phòng).
    *   Nếu đại lý đồng ý, yêu cầu được gửi lên hệ thống. Tiền hoàn lại (sau khi trừ phí phạt) được tự động cộng ngược vào ví đại lý ngay khi Supplier phê duyệt yêu cầu hủy.
    *   Tích hợp tính năng Chat Live kết nối trực tiếp nhân viên đại lý với đội ngũ tổng đài hỗ trợ (Ops Team) của platform để giải quyết các sự cố phát sinh tại điểm check-in.

---

### 3.7 Module 7: Admin / Supplier Panel & Reporting
*   **Góc nhìn người dùng**:
    *   **Nhà cung cấp (Supplier)** đăng nhập vào Supplier Portal để xem lịch quản lý phòng trống (Inventory Calendar). Họ có thể tăng/giảm số lượng phòng bán sỉ trong ngày cao điểm chỉ bằng thao tác kéo thả, theo dõi danh sách khách sắp check-in để chuẩn bị tiếp đón.
    *   **Kế toán Platform** mở Admin Panel để theo dõi dòng tiền nạp/rút của toàn bộ hệ thống, xuất báo cáo đối soát công nợ cuối tháng với VNPay và đối soát tiền thu hộ với các khách sạn.
    *   **Ban giám đốc đại lý** mở trang Dashboard phân tích để xem các biểu đồ trực quan về doanh thu của từng nhân viên sales, tỷ lệ chuyển đổi từ giữ chỗ sang đặt vé thành công và các sản phẩm bán chạy nhất trong tháng để tối ưu chiến lược kinh doanh.

---
--- KẾT THÚC TÀI LIỆU 3 ---

## [PHẦN 4 — USER PERSONAS]

### 4.1 Persona 1: Hoàng Thu Trang — Giám đốc điều hành Đại lý (Agency CEO)

```
+-----------------------------------------------------------------------+
|  PERSONA: HOÀNG THU TRANG (34 TUỔI) - AGENCY CEO                      |
|                                                                       |
|  "Tôi cần kiểm soát dòng tiền đại lý và tránh tối đa việc hủy phòng  |
|   ngoài ý muốn của nhân viên."                                        |
|                                                                       |
|  * Mục tiêu: Tối ưu lợi nhuận, quản lý nhân viên, tránh đền booking.  |
|  * Nỗi đau: Nhân viên quên thanh toán hold, khó đối soát công nợ.     |
+-----------------------------------------------------------------------+
```

*   **Thông tin cá nhân**:
    *   **Tên**: Hoàng Thu Trang (34 tuổi)
    *   **Chức vụ**: CEO & Sáng lập công ty TNHH Lữ hành Trang Travel Đà Nẵng.
    *   **Hành vi công nghệ**: Sử dụng thành thạo Macbook, iPhone, ưa thích các phần mềm quản lý có biểu đồ trực quan, tối giản hóa quy trình giấy tờ.
*   **Mục tiêu (Goals)**:
    *   Kiểm soát chặt chẽ toàn bộ dòng tiền thu - chi đặt phòng của 5 nhân viên sales.
    *   Tự động hóa việc cộng hoa hồng Markup cho CTV bên ngoài để tăng doanh thu mà không cần thêm nhân sự kế toán.
    *   Không bao giờ xảy ra tình trạng nhân viên quên thanh toán khiến nhà cung cấp tự động hủy giữ chỗ phòng của đoàn khách lớn.
*   **Nỗi đau (Frustrations)**:
    *   Mất quá nhiều thời gian đối soát công nợ thủ công bằng file Excel cuối tháng với từng nhân viên và nhà cung cấp.
    *   Không kiểm soát được nhân viên có báo giá Net cho khách hay tự ý cộng Markup quá cao làm mất uy tín thương hiệu đại lý.
*   **Kịch bản một ngày sử dụng Platform (Day-in-the-life Scenario)**:
    *   Buổi sáng, bà Trang đăng nhập vào Agent Portal trên máy tính. Việc đầu tiên là kiểm tra số dư ví đại lý và lịch sử giao dịch nạp tiền của ngày hôm trước. 
    *   Bà Trang truy cập trang "Cấu hình Markup", thiết lập quy tắc cộng thêm 7% trên tất cả sản phẩm Khách sạn 3 sao Nha Trang áp dụng cho tài khoản của nhân viên mới thử việc để đảm bảo tỷ suất lợi nhuận an toàn.
    *   Buổi chiều, hệ thống gửi thông báo về điện thoại nhắc nhở có 1 booking đoàn 15 phòng khách sạn sắp hết thời gian giữ chỗ (Hold Expiration) còn 15 phút. Bà Trang nhanh chóng phê duyệt chuyển tiền từ Ví đại lý để thanh toán, xuất voucher gửi trực tiếp cho nhân viên bàn giao khách hàng.

---

### 4.2 Persona 2: Nguyễn Minh Tuấn — Nhân viên tư vấn đặt chỗ (Agency Staff)
*   **Thông tin cá nhân**:
    *   **Tên**: Nguyễn Minh Tuấn (24 tuổi)
    *   **Chức vụ**: Nhân viên đặt chỗ và tư vấn tour (Booking Agent).
    *   **Hành vi công nghệ**: Sử dụng điện thoại Android đời mới liên tục, giao tiếp chủ yếu qua các nhóm chat Zalo, Messenger, thích giao diện ứng dụng tối giản, tốc độ phản hồi nhanh.
*   **Mục tiêu (Goals)**:
    *   Tìm kiếm giá vé máy bay và giá phòng cực nhanh để báo giá cho khách đang chat hỏi mua dịch vụ trực tuyến.
    *   Thực hiện thao tác giữ chỗ (Hold Booking) chính xác tuyệt đối, giữ phòng đẹp cho khách trong thời gian đợi khách chuyển tiền cọc.
*   **Nỗi đau (Frustrations)**:
    *   Phải mở quá nhiều trang web đặt phòng của từng đối tác để so sánh giá, hệ thống cũ thường xuyên bị lag và lỗi tải trang khi mạng yếu.
    *   Sợ bị đền tiền lương cá nhân do gõ sai thông tin họ tên hành khách hoặc chọn nhầm ngày đi khi đặt dịch vụ trên hệ thống của nhà cung cấp.
*   **Kịch bản một ngày sử dụng Platform (Day-in-the-life Scenario)**:
    *   Tuấn nhận được yêu cầu đặt 1 phòng Deluxe Ocean View tại Nha Trang từ khách hàng qua Zalo. Khách yêu cầu báo giá trong vòng 5 phút.
    *   Tuấn mở Agent Portal trên trình duyệt, gõ tìm kiếm nhanh khách sạn. Hệ thống hiển thị ngay kết quả phòng trống kèm giá bán lẻ đã tự động áp dụng Markup của đại lý. Tuấn bật phím nóng "Agent Mode Toggle" để ẩn giá Net đi rồi chụp ảnh màn hình gửi cho khách xem.
    *   Khách đồng ý, Tuấn nhập họ tên khách và nhấn "Hold Booking" để khóa phòng trong 1 tiếng. Khi nhận được ảnh chụp màn hình khách chuyển tiền thành công, Tuấn chỉ cần nhấn "Thanh toán bằng ví đại lý", hệ thống hoàn tất xuất vé trong 3 giây và tự động sinh mã QR voucher gửi thẳng vào email khách hàng.

---

### 4.3 Persona 3: Lê Quốc Huy — Nhân viên bàn giao xe/Tài xế (Delivery Staff)
*   **Thông tin cá nhân**:
    *   **Tên**: Lê Quốc Huy (42 tuổi)
    *   **Chức vụ**: Tài xế xe du lịch kiêm nhân viên điều phối đón khách đi Tour Bà Nà.
    *   **Hành vi công nghệ**: Sử dụng điện thoại thông minh cấu hình trung bình, mắt hơi yếu, thao tác màn hình chậm, làm việc chủ yếu ngoài trời nắng nóng.
*   **Mục tiêu (Goals)**:
    *   Đón khách nhanh chóng tại các sảnh khách sạn đông đúc, không bị đón nhầm khách của nhà xe khác.
    *   Rút ngắn thời gian xác thực danh sách hành khách lên xe để xuất phát đúng giờ quy định.
*   **Nỗi đau (Frustrations)**:
    *   Danh sách khách in trên giấy dễ bị rách, ướt khi trời mưa; chữ in họ tên khách hàng quá nhỏ khó đọc dưới trời nắng.
    *   Nhiều trường hợp khách đưa voucher giả hoặc voucher của ngày hôm trước nhưng cố tình đòi lên xe, rất khó đối soát trực tiếp nếu không gọi điện về tổng đài đại lý.
*   **Kịch bản một ngày sử dụng Platform (Day-in-the-life Scenario)**:
    *   Sáng sớm lúc 07:30 AM, ông Huy mở ứng dụng Flutter trên điện thoại Android cá nhân để xem danh sách đón khách của ngày hôm nay. Danh sách hiển thị rõ ràng thứ tự các điểm đón khách dọc đường.
    *   Đến điểm đón khách đầu tiên, ông Huy nhấn nút "Quét mã QR" trên ứng dụng. Khách hàng trình mã QR E-Voucher trên màn hình điện thoại, ông Huy đưa camera điện thoại quét vào mã QR.
    *   Hệ thống báo bíp lớn, hiển thị dấu tích xanh và thông tin: "Nguyen Van A - Ghế số 4 - Điểm xuống: Cáp treo Bà Nà". Trạng thái của khách hàng tự động chuyển sang `Delivered`. Ông Huy mời khách lên xe và di chuyển đến điểm tiếp theo mà không cần xem giấy tờ đối chiếu.

---
--- KẾT THÚC TÀI LIỆU 4 ---

## [PHẦN 5 — BUSINESS FLOW CHÍNH (NARRATIVE)]

### 5.1 Quy trình đặt dịch vụ đầu cuối (End-to-End Booking Flow)
Quy trình đặt dịch vụ bắt đầu khi đại lý tiếp nhận nhu cầu từ khách hàng cuối. Nhân viên đại lý đăng nhập vào cổng thông tin **Agent Portal** để thực hiện tìm kiếm. Bộ máy tìm kiếm trung tâm của hệ thống sẽ gửi các yêu cầu truy vấn đồng thời đến cơ sở dữ liệu nội bộ (cho các sản phẩm tự phát triển hoặc hợp đồng trực tiếp) và gọi API đồng bộ đến các Supplier hoặc GDS trung gian. Kết quả tìm kiếm trả về sẽ được chạy qua **Markup Engine** để tự động cộng thêm phần trăm lợi nhuận hoặc số tiền lời cố định đã cấu hình trước đó. Nhân viên đại lý nhìn thấy giá bán lẻ và nhấn nút chọn dịch vụ đưa vào giỏ hàng.

Khi tiến hành xác nhận đặt chỗ, nhân viên nhập thông tin cá nhân của khách hàng (Họ tên, giấy tờ định danh). Hệ thống thực hiện một giao dịch **Hold Booking** để giữ chỗ tạm thời. Ở tầng database, hệ thống thực hiện trừ tạm thời số lượng chỗ trống trong bảng `catalog.inventories` và đánh dấu trạng thái booking là `Held`, đồng thời thiết lập thời gian hết hạn giữ chỗ (Hold Time Limit). Nhân viên gửi thông báo xác nhận đặt vé chứa mã PNR nội bộ cho khách để khách thực hiện chuyển khoản thanh toán.

Sau khi nhận được tiền từ khách hàng, nhân viên đại lý thực hiện xác nhận thanh toán bằng số dư ví điện tử của đại lý (**Agency Wallet**). Hệ thống kiểm tra số dư ví, thực hiện trừ tiền trong cơ sở dữ liệu và chuyển trạng thái booking sang `Paid`. Ngay lập tức, hệ thống gọi API xác nhận xuất vé chính thức đến Supplier. Khi Supplier phản hồi mã vé gốc, Worker backend của platform sẽ tự động biên dịch và tạo tệp tin **PDF E-Voucher** chứa thông tin chi tiết dịch vụ và một mã QR Code bảo mật được ký số. Hệ thống tự động gửi Email và tin nhắn chứa mã voucher này đến cho đại lý và khách hàng cuối. Đến ngày khởi hành, khách hàng trình mã QR trên voucher cho tài xế hoặc hướng dẫn viên. Nhân viên bàn giao sử dụng **Mobile App** quét mã QR để đối soát, xác thực trạng thái vé thời gian thực và ghi nhận check-in bàn giao dịch vụ thành công.

---

### 5.2 Quy trình hủy đặt chỗ và hoàn tiền (Cancellation & Refund Flow)
Quy trình hủy đặt chỗ được bắt đầu khi khách hàng cuối yêu cầu hủy dịch vụ và đại lý thực hiện gửi yêu cầu hủy trên cổng Agent Portal. Khi nhận được yêu cầu hủy, hệ thống trước hết sẽ truy vấn thông tin booking và gọi cấu hình chính sách hủy (**Cancellation Policy**) của sản phẩm đó để tự động tính toán số tiền phạt dựa trên khoảng cách thời gian từ thời điểm hiện tại đến ngày khởi hành chuyến đi.

Nếu yêu cầu hủy nằm ngoài thời gian cho phép hủy (ví dụ: hủy sát giờ khởi hành đối với tour không hoàn/hủy), hệ thống sẽ từ chối và hiển thị thông báo phạt 100% chi phí. Nếu yêu cầu hủy hợp lệ và được chấp nhận, hệ thống sẽ gửi lệnh gọi API hủy đặt chỗ tương ứng đến Supplier gốc để giải phóng chỗ trống về kho hàng. 

Sau khi Supplier phản hồi xác nhận hủy thành công, hệ thống sẽ thực hiện cập nhật trạng thái booking thành `Cancelled`, đồng thời cập nhật trạng thái voucher liên quan thành `Cancelled` để vô hiệu hóa mã QR check-in tại điểm đón. Kế toán hệ thống phê duyệt giao dịch hoàn tiền, hệ thống sẽ thực hiện cộng số tiền hoàn lại (đã trừ đi chi phí phạt hủy nếu có) trực tiếp vào số dư ví **Agency Wallet** của đại lý và ghi nhận một bản ghi Transaction loại `Refund` trên Database, hoàn tất quy trình hủy và hoàn trả dòng tiền tự động.

---

### 5.3 Quy trình thêm mới Nhà cung cấp & Đồng bộ Kho phòng (Supplier Onboarding & Sync Flow)
Quy trình bắt đầu khi một nhà cung cấp mới gửi hồ sơ đăng ký hợp tác cung cấp dịch vụ trên trang chủ của platform. Bộ phận vận hành và kiểm duyệt của platform (Platform Admin) sẽ thực hiện xác minh thông tin pháp lý của Supplier (Giấy phép kinh doanh, tiêu chuẩn chất lượng khách sạn/phương tiện vận chuyển). Sau khi hồ sơ được phê duyệt, Platform Admin tạo tài khoản nhà cung cấp trên hệ thống và cấp quyền truy cập vào **Supplier Panel**.

Supplier đăng nhập vào Supplier Panel, tiến hành cấu hình danh mục sản phẩm (Tên khách sạn, loại phòng, hành trình tour, điểm đón trả). Tiếp theo, Supplier thiết lập số lượng phòng/vé trống ban đầu cho từng ngày cụ thể trên giao diện lịch quản lý kho phòng (Inventory Calendar View) cùng bảng giá sỉ Net Rate. Dữ liệu này được ghi nhận trực tiếp vào cơ sở dữ liệu PostgreSQL.

Để tối ưu hóa hiệu năng và tránh lỗi truy cập chậm khi đại lý thực hiện tìm kiếm, hệ thống chạy một tác vụ nền tự động đồng bộ hóa toàn bộ kho phòng và bảng giá của Supplier từ PostgreSQL lên **Redis Cache** (Redis In-Memory Database). Đối với các Supplier lớn sử dụng phần mềm quản lý phòng riêng (PMS/Channel Manager), hệ thống cung cấp API Key kết nối trực tiếp để phần mềm của họ có thể tự động đẩy các thay đổi về kho phòng (Inventory Webhook) lên platform thời gian thực, đảm bảo dữ liệu hiển thị trên sàn luôn chính xác 100%.

---

### 5.4 Quy trình đối soát tài chính & hoa hồng (Finance & Commission Reconciliation Flow)
Quy trình đối soát tài chính được vận hành tự động định kỳ vào cuối mỗi tháng (hoặc theo chu kỳ 15 ngày một lần) để quyết toán dòng tiền giữa Platform Owner, Travel Agency và Supplier. Kế toán hệ thống kích hoạt Job đối soát trên **Admin Panel**. Hệ thống sẽ tự động quét qua toàn bộ cơ sở dữ liệu giao dịch trong chu kỳ đối soát, lọc ra danh sách các booking có trạng thái `Completed` (Dịch vụ đã được bàn giao thành công và khách hàng đã hoàn thành chuyến đi).

Đối với mỗi booking hợp lệ, hệ thống tự động bóc tách và tính toán 3 con số tài chính:
1.  **Giá Net (Net Rate)**: Số tiền nền tảng phải trả cho Supplier.
2.  **Giá Markup (Markup Rate)**: Số tiền đại lý đã thanh toán cho nền tảng.
3.  **Phí dịch vụ của sàn (Platform Fee)**: Khoản hoa hồng chênh lệch giữ lại cho Platform Owner.

Hệ thống tự động kết xuất biên bản đối soát doanh thu chi tiết (Reconciliation Statement) dưới dạng file PDF/Excel gửi trực tiếp đến cổng thông tin của Travel Agency và Supplier để đối chiếu số liệu. Sau khi các bên nhấn nút xác nhận khớp đúng số liệu trên giao diện Portal, hệ thống sẽ thực hiện lệnh giải ngân tiền hàng tháng: Kế toán thực hiện chuyển khoản ngân hàng số lượng lớn số tiền Net thực tế cho từng Supplier dựa trên hóa đơn VAT dịch vụ nhận được, hoàn tất chu trình đối soát tài chính an toàn và minh bạch.

---
--- KẾT THÚC TÀI LIỆU 5 ---

## [PHẦN 6 — VALUE PROPOSITION & REVENUE MODEL]

### 6.1 Value Proposition (Tuyên ngôn giá trị cho stakeholders)

```
                       [ B2B Travel Platform ]
                                  │
      ┌───────────────────────────┼───────────────────────────┐
      ▼                           ▼                           ▼
[ Travel Agency ]           [ Suppliers ]              [ End Customers ]
- Giá sỉ thời gian thực     - Kênh phân phối rộng       - Voucher điện tử QR
- Hold Booking 30 phút      - Quản lý kho phòng số hóa - Check-in không giấy tờ
- Markup Engine tự động     - Đối soát dòng tiền nhanh  - Đảm bảo có chỗ 100%
```

#### 1. Dành cho Travel Agency (Đại lý du lịch)
*   **Tiết kiệm 80% thời gian tìm kiếm và báo giá**: Không cần truy cập nhiều nguồn riêng lẻ, tất cả giá vé máy bay, phòng khách sạn và tour lẻ được hiển thị đồng bộ trên một màn hình tìm kiếm duy nhất.
*   **Chốt deal nhanh hơn nhờ Markup Engine**: Nhân viên đại lý tự tin tư vấn trực tiếp và xuất file báo giá chuyên nghiệp có logo thương hiệu riêng gửi cho khách hàng ngay trong cuộc gọi.
*   **Tránh rủi ro mất booking**: Công cụ hold booking giữ chỗ an toàn giúp đại lý yên tâm đợi khách hàng chuyển tiền cọc mà không lo bị tăng giá vé hoặc hết chỗ.

#### 2. Dành cho Supplier (Nhà cung cấp dịch vụ)
*   **Giải phóng kho hàng trống nhanh chóng**: Tiếp cận trực tiếp mạng lưới hàng ngàn đại lý nhỏ lẻ và cộng tác viên tự do trên khắp cả nước mà không tốn chi phí xây dựng đội ngũ kinh doanh.
*   **Quản lý tồn kho số hóa**: Loại bỏ hoàn toàn phương pháp lưu trữ lịch đặt phòng bằng sổ sách giấy hoặc file Excel thủ công dễ gây lỗi overbooking.
*   **Đảm bảo dòng tiền**: Tiền đặt dịch vụ được trừ trực tiếp từ ví đại lý trên sàn trước khi xuất vé, loại bỏ hoàn toàn rủi ro công nợ khó đòi từ các đại lý nhỏ.

#### 3. Dành cho End Customer (Khách hàng cuối)
*   **Dịch vụ minh bạch, chính xác**: Khách hàng nhận được voucher chuyên nghiệp chứa đầy đủ thông tin dịch vụ và lộ trình chi tiết.
*   **Trải nghiệm check-in hiện đại**: Không cần in voucher giấy, chỉ cần trình diện mã QR trên điện thoại cho tài xế/lễ tân để quét xác thực trong 3 giây.
*   **Đảm bảo quyền lợi**: Hệ thống kiểm tra chữ ký số chống voucher giả mạo, bảo đảm khách hàng chắc chắn có chỗ 100% tại điểm đón xe/khách sạn.

#### 4. Dành cho Platform Owner (Đơn vị vận hành nền tảng)
*   **Nguồn doanh thu tự động, ổn định**: Hệ thống tự động thu phí dịch vụ trên mỗi giao dịch thành công mà không cần nhiều nhân sự vận hành thủ công.
*   **Sở hữu tập dữ liệu du lịch lớn (Big Data)**: Khả năng khai thác hành vi tìm kiếm, xu hướng đi du lịch của thị trường để cung cấp các dịch vụ gia tăng có giá trị cao khác.

---

### 6.2 Mô hình kinh doanh và Dự báo Doanh thu (3 Kịch bản tài chính)

#### Kịch bản 1: Khởi nghiệp (Conservative Scenario) — Năm thứ 1
*   **Giả định vận hành**:
    *   Tích lũy được 200 đại lý hoạt động thường xuyên (Active Agents).
    *   Tổng giá trị giao dịch (GMV) trung bình đạt 10.000.000 VND / đại lý / tháng.
    *   Doanh số GMV toàn sàn: 2 tỷ VND / tháng (24 tỷ VND / năm).
*   **Nguồn doanh thu**:
    *   *Transaction Fee*: Thu phí 0.5% trên tổng giao dịch thanh toán = 120.000.000 VND / năm.
    *   *Commission*: Chiết khấu 2% từ các nhà cung cấp dịch vụ = 480.000.000 VND / năm.
    *   *SaaS Subscription*: Miễn phí toàn bộ thuê bao để thu hút người dùng.
*   **Tổng doanh thu năm thứ 1**: **600.000.000 VND**. (Đủ chi phí vận hành máy chủ Cloud và duy trì đội ngũ kỹ thuật nhỏ).

#### Kịch bản 2: Tăng trưởng (Realistic Scenario) — Năm thứ 2 - 3
*   **Giả định vận hành**:
    *   Mở rộng mạng lưới đạt 1.000 đại lý hoạt động thường xuyên trên cả nước.
    *   GMV trung bình tăng lên 25.000.000 VND / đại lý / tháng do đại lý tin tưởng đặt các booking đoàn lớn hơn.
    *   Doanh số GMV toàn sàn: 25 tỷ VND / tháng (300 tỷ VND / năm).
*   **Nguồn doanh thu**:
    *   *Transaction Fee*: Thu phí 0.8% trên tổng giao dịch thanh toán = 2.4 tỷ VND / năm.
    *   *Commission*: Chiết khấu tăng lên 4% nhờ sản lượng giao dịch lớn = 12 tỷ VND / năm.
    *   *SaaS Subscription*: Thu phí 150.000 VND/tháng/đại lý áp dụng cho 700 đại lý phiên bản Standard = 1.26 tỷ VND / năm.
*   **Tổng doanh thu năm thứ 3**: **15.66 Tỷ VND**. (Đạt tỷ suất lợi nhuận ròng khoảng 40% sau khi trừ chi phí vận hành, marketing và nhân sự).

#### Kịch bản 3: Thống lĩnh thị trường (Optimistic Scenario) — Năm thứ 5
*   **Giả định vận hành**:
    *   Đạt cột mốc 5.000 đại lý du lịch và CTV hoạt động thường xuyên.
    *   GMV trung bình đạt 50.000.000 VND / đại lý / tháng.
    *   Doanh số GMV toàn sàn: 250 tỷ VND / tháng (3.000 tỷ VND / năm).
*   **Nguồn doanh thu**:
    *   *Transaction Fee*: Thu phí 1% trên các giao dịch nạp/rút tiền = 30 tỷ VND / năm.
    *   *Commission*: Đạt mức chiết khấu trung bình 6% từ các Supplier do độc quyền phân phối = 180 tỷ VND / năm.
    *   *SaaS Subscription*: 80% đại lý sử dụng phiên bản Premium giá 300.000 VND/tháng = 14.4 tỷ VND / năm.
    *   *White-label Solutions*: Cung cấp hệ thống riêng biệt cho 50 đại lý lớn với giá 20.000.000 VND/năm/đối tác = 1 tỷ VND / năm.
*   **Tổng doanh thu năm thứ 5**: **225.4 Tỷ VND**. (Nền tảng trở thành một trong những Travel Tech Unicorn dẫn đầu thị trường B2B du lịch).

---
--- KẾT THÚC TÀI LIỆU 6 ---

## [PHẦN 7 — RỦI RO & GIẢI PHÁP (RISK MATRIX)]

Hệ thống B2B Travel Platform được thiết kế để xử lý lượng lớn dữ liệu giao dịch tài chính và thông tin khách hàng thời gian thực. Do đó, việc xác định và lên phương án quản trị rủi ro là tối quan trọng để bảo đảm tính bền vững của dự án.

| ID | Tên rủi ro | Phân loại | Khả năng xảy ra (1-5) | Mức độ ảnh hưởng (1-5) | Biện pháp phòng ngừa (Mitigation) | Phương án dự phòng (Contingency) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **R-01** | Trùng lặp đặt chỗ (Double Booking) | Kỹ thuật | 3 | 5 | Áp dụng cơ chế **Optimistic Locking** ở tầng DB kết hợp khóa phân tán **Redis Distributed Lock (Redlock)** cho tài nguyên phòng cuối cùng. | Tự động hoàn tiền vào ví đại lý và gửi thông báo khẩn cấp cho Admin điều phối đổi phòng tương đương cho khách. |
| **R-02** | Lỗi kết nối API với Supplier gốc | Kỹ thuật | 4 | 4 | Thiết kế module kết nối theo kiến trúc cô lập (Circuit Breaker Pattern) để tránh làm sập hệ thống chính khi API bên ngoài bị lỗi. | Chuyển trạng thái booking sang `Pending Confirmation` và chuyển luồng xử lý thủ công cho nhân viên Ops. |
| **R-03** | Rò rỉ thông tin cá nhân của khách hàng | Bảo mật | 2 | 5 | Mã hóa một chiều thông tin nhạy cảm (Số hộ chiếu, CCCD) bằng thuật toán AES-256 trước khi ghi vào cơ sở dữ liệu. | Tự động khóa cổng API bị tấn công, gửi cảnh báo bảo mật cho đội ngũ DevSecOps và reset toàn bộ token truy cập. |
| **R-04** | Đại lý nợ đống công nợ quá hạn không trả | Kinh doanh | 3 | 4 | Thiết lập hạn mức tín dụng công nợ (Credit Limit) nghiêm ngặt dựa trên điểm uy tín lịch sử của đại lý. | Tự động khóa tính năng đặt giữ chỗ bằng tài khoản công nợ của đại lý ngay khi nợ quá hạn quá 3 ngày. |
| **R-05** | Giả mạo chữ ký số giao dịch thanh toán | Bảo mật | 1 | 5 | Sử dụng thuật toán SHA256 mã hóa chữ ký (checksum verification) truyền từ cổng thanh toán VNPay về API server. | Khóa tài khoản đại lý liên quan lập tức, thu hồi voucher đã phát hành và chuyển hồ sơ kiểm tra gian lận. |
| **R-06** | Mất kết nối internet tại điểm quét QR | Vận hành | 4 | 3 | Cho phép ứng dụng Flutter lưu trữ dữ liệu quét tạm thời dưới bộ nhớ thiết bị (Hive Database). | Đồng bộ dữ liệu quét ngược lên server tự động ngay khi thiết bị có kết nối 3G/4G trở lại. |
| **R-07** | Tranh chấp pháp lý về hoàn hủy dịch vụ | Pháp lý | 3 | 3 | Bắt buộc đại lý phải nhấn nút tích chọn "Đồng ý với chính sách hoàn hủy của sản phẩm" trước khi tiến hành đặt chỗ. | Lưu trữ log hoạt động click chuột làm bằng chứng pháp lý để giải quyết tranh chấp thông qua đối thoại. |
| **R-08** | Lỗi rò rỉ bộ nhớ máy chủ (Memory Leak) | Kỹ thuật | 2 | 4 | Sử dụng các công cụ phân tích tĩnh mã nguồn (SonarQube) để phát hiện sớm các kết nối database chưa đóng. | Cấu hình Docker tự động khởi động lại container API (Auto-restart) khi lượng tiêu thụ RAM vượt quá 90%. |
| **R-09** | Thay đổi quy định pháp luật về thuế VAT du lịch | Pháp lý | 2 | 3 | Thiết kế module tính thuế (Tax Calculator) dạng động, cho phép thay đổi cấu hình tỷ lệ thuế VAT trên Admin Panel. | Cập nhật cấu hình thuế mới trên hệ thống trong vòng 24 giờ kể từ khi quy định mới của chính phủ có hiệu lực. |
| **R-10** | Rút ruột tiền từ tài khoản ví đại lý | Bảo mật | 1 | 5 | Yêu cầu nhập mã PIN bảo mật giao dịch gồm 6 chữ số và xác thực OTP qua SMS đối với mọi giao dịch trừ tiền ví. | Gửi email thông báo tức thì chứa địa chỉ IP và tên thiết bị thực hiện giao dịch cho chủ đại lý kiểm tra. |

---
--- KẾT THÚC TÀI LIỆU 7 ---

## EXECUTIVE SUMMARY (TÓM TẮT DỰ ÁN)

**Dự án**: Nền tảng du lịch B2B — Đặt chỗ & Bàn giao dịch vụ khép kín (B2B Travel Platform — End-to-End Booking & Delivery).
**Định vị sản phẩm**: Giải pháp phần mềm SaaS cung cấp cổng đặt phòng khách sạn, vé máy bay và tour du lịch giá sỉ dành riêng cho các đại lý lữ hành nhỏ, vừa (SMEs) và cộng tác viên tự do tại thị trường Việt Nam và Đông Nam Á.

### 1. Cơ hội thị trường & Vấn đề giải quyết
Quy trình phân phối du lịch B2B truyền thống hiện tại rất phân mảnh, phụ thuộc vào giao dịch thủ công qua Zalo/Email. Đại lý mất nhiều thời gian tìm giá, báo giá, đối mặt với rủi ro bị hủy giữ chỗ phòng/vé do hết hạn thanh toán (Hold Time Limit), rủi ro sai lệch tính giá hoa hồng (Markup) và rủi ro voucher giấy bị làm giả hoặc mất dấu tại điểm bàn giao dịch vụ cuối cùng (Delivery) đến tay hành khách. 

### 2. Giải pháp công nghệ cốt lõi
Dự án đề xuất xây dựng hệ thống hợp nhất trên nền tảng **Modular Monolith** viết bằng **.NET 8** và **Flutter**, bao gồm:
*   **Agent Portal**: Cổng thông tin cho đại lý tìm kiếm real-time, giữ chỗ tự động (Hold Booking), thanh toán qua ví đại lý (Agency Wallet) được nạp tự động bằng VietQR/VNPay.
*   **Markup Engine**: Bộ máy tự động cộng phí lời hiển thị giá bán lẻ tức thì cho nhân viên đại lý chốt khách.
*   **Fulfillment & Secure E-Voucher**: Tự động xuất voucher PDF có chứa mã QR bảo mật mã hóa chữ ký số HMAC-SHA256 để chống chỉnh sửa thông tin.
*   **Mobile App cho Delivery Staff**: Ứng dụng quét mã QR check-in hành khách thời gian thực trực tiếp tại điểm đón xe/khách sạn, lưu log tọa độ GPS để kiểm soát thất thoát.

### 3. Kế hoạch tài chính & Phát triển MVP 6 tháng
*   **Sprint 1-6 (Tháng 1-3)**: Phát triển Backend API, cấu hình database Postgres, Redis, module giữ chỗ và tích hợp cổng VNPay.
*   **Sprint 7-12 (Tháng 4-6)**: Cắt giao diện React Web Portal, phát triển ứng dụng di động Flutter quét QR cho tài xế và chạy thử nghiệm chịu tải k6.
*   **Dự phóng doanh thu (Kịch bản Khả thi)**: Đạt 1.000 đại lý hoạt động thường xuyên sau 3 năm, doanh số GMV toàn sàn đạt 300 tỷ VND/năm, mang lại doanh thu nền tảng đạt **15.66 Tỷ VND/năm** thông qua phí giao dịch, phí chiết khấu từ nhà cung cấp và phí thuê bao phần mềm SaaS.

Hệ thống bảo đảm các tiêu chuẩn phi chức năng nghiêm ngặt: độ trễ tìm kiếm < 150ms qua Redis cache, SLA hoạt động đạt 99.9%, bảo mật theo tiêu chuẩn OWASP Top 10, sẵn sàng đáp ứng yêu cầu nâng cấp và bảo trì lâu dài của một đồ án tốt nghiệp xuất sắc.
