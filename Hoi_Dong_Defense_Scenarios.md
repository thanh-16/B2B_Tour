# BỘ KỊCH BẢN GIẢ LẬP CÂU HỎI PHẢN BIỆN HỘI ĐỒNG TỐT NGHIỆP
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

Tài liệu này tổng hợp các kịch bản câu hỏi hóc búa nhất mà Hội đồng chấm đồ án tốt nghiệp (đặc biệt là giảng viên phản biện) thường sử dụng để chất vấn sinh viên. Các câu hỏi được thiết kế đi sâu vào logic nghiệp vụ đặc thù (Business Cases), kiến trúc hệ thống và cách xử lý lỗi hệ thống du lịch thời gian thực.

---

## NHÓM 1: NGHIỆP VỤ VÍ ĐẠI LÝ & QUẢN LÝ CÔNG NỢ (B2B CREDIT & WALLET)

### Gịch bản 1.1: Quản lý rủi ro hạn mức nợ (Credit Limit Breach)
*   **Câu hỏi hội đồng**: 
    > *"Trong hệ thống của em, đại lý được cấp hạn mức tín dụng âm (ví dụ: cho phép nợ tối đa -50 triệu). Giả sử số dư hiện tại của đại lý đang là -49 triệu. Nhân viên đại lý thực hiện đặt đồng thời 2 booking: một booking 3 triệu và một booking 5 triệu trong cùng một giây. Hệ thống của em xử lý thế nào để ngăn chặn tổng nợ vượt quá -50 triệu?"*
*   **Mục đích câu hỏi**: Kiểm tra tư duy thiết kế bảo mật giao dịch tài chính, chống lỗi cập nhật đồng thời (Concurrency Update) tầng database.
*   **Cách trả lời chuẩn chỉnh**:
    *   **Về mặt Nghiệp vụ (BA)**: Hệ thống phải tuân thủ quy tắc kiểm tra hạn mức khả dụng trước khi trừ tiền. Hạn mức khả dụng được tính bằng công thức: 
        $$\text{Số dư khả dụng} = \text{Số dư ví thực tế} + \text{Hạn mức tín dụng được cấp} - \text{Số tiền đang bị tạm khóa (Blocked Balance)}$$
        Tại thời điểm nhận yêu cầu, nếu booking nào chạy trước sẽ trừ vào hạn mức khả dụng. Booking chạy sau khi kiểm tra thấy số dư khả dụng không đủ sẽ bị hệ thống từ chối thanh toán ngay lập tức.
    *   **Về mặt Kỹ thuật (Solution Architect)**: Để tránh tình trạng race condition ở tầng database khiến cả 2 booking đều được duyệt (gây nợ -57 triệu, vượt hạn mức cho phép), em áp dụng cơ chế **Pessimistic Locking (Khóa bi quan)**. 
    *   Khi có request thanh toán, câu lệnh SQL truy vấn số dư ví sẽ sử dụng cú pháp `SELECT ... FOR UPDATE` trong EF Core (hoặc transaction với isolation level là `Serializable`). Lệnh này sẽ khóa dòng dữ liệu của ví đại lý đó lại. Request đầu tiên sẽ được xử lý trước, cập nhật số dư thành -52 triệu (vượt hạn mức khả dụng là 1 triệu nợ còn lại) -> hệ thống ném ra lỗi `InsufficentBalanceException` và rollback. Request thứ hai cũng sẽ bị từ chối tương tự.

---

### Kịch bản 1.2: Lỗi mất gói tin thông báo từ Cổng thanh toán (IPN Webhook Timeout)
*   **Câu hỏi hội đồng**:
    > *"Khi đại lý quét QR thanh toán qua VNPay để nạp tiền vào ví. Tiền ngân hàng của đại lý đã bị trừ, nhưng do sự cố đứt cáp, gói tin IPN (Instant Payment Notification) từ VNPay không gửi được đến Backend API của em, hoặc gửi đến bị timeout. Lúc này số dư ví của đại lý chưa được cộng tiền, đại lý khiếu nại. Hệ thống của em giải quyết bài toán này tự động như thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra khả năng thiết kế hệ thống có tính chịu lỗi (Fault-tolerant) và cơ chế đối soát tự động khi tích hợp bên thứ ba.
*   **Cách trả lời chuẩn chỉnh**:
    *   **Về mặt vận hành**: Hệ thống không thể chỉ dựa vào một đường truyền duy nhất là Webhook IPN từ VNPay đổ về. Chúng em triển khai cơ chế **Reconciliation Background Job (Job đối soát ngầm)** chạy tự động bằng thư viện **Hangfire** định kỳ 5 phút một lần.
    *   **Quy trình xử lý**:
        1.  Mỗi khi người dùng tạo yêu cầu nạp tiền, hệ thống sinh ra một mã giao dịch duy nhất (`TransactionRef`) lưu ở trạng thái `PENDING`.
        2.  Nếu sau 15 phút giao dịch vẫn ở trạng thái `PENDING` (chưa nhận được IPN gọi về), Hangfire Job sẽ quét qua bản ghi này và chủ động thực hiện một cuộc gọi API ngược lại hệ thống VNPay (`QueryDR API`) truyền vào `TransactionRef` để truy vấn trạng thái thực tế của giao dịch từ phía VNPay.
        3.  Nếu VNPay phản hồi giao dịch đã thành công, Backend tự động thực hiện cộng tiền ví đại lý và chuyển trạng thái giao dịch thành `SUCCESS`. Nếu VNPay báo thất bại, chuyển trạng thái thành `FAILED` để hoàn trả phòng đã giữ chỗ.

---
--- LƯU Ý CHO SINH VIÊN ---
Hội đồng rất ghét câu trả lời: *"Khi bị lỗi thì Admin sẽ vào cơ sở dữ liệu cộng tay cho đại lý"*. Mọi luồng đối soát tài chính bắt buộc phải được thiết kế tự động tối đa và có ghi nhật ký (Audit Log) để chứng minh tính chuyên nghiệp.
--------------------------

---

## NHÓM 2: NGHIỆP VỤ ĐẶT CHỖ & GIỮ KHO (CONCURRENCY BOOKING)

### Kịch bản 2.1: Trùng lặp đặt phòng cuối cùng (Overbooking Race Condition)
*   **Câu hỏi hội đồng**:
    > *"Hai nhân viên của cùng một đại lý (hoặc hai đại lý khác nhau) cùng mở màn hình tìm kiếm và thấy khách sạn còn đúng 1 phòng Deluxe duy nhất. Cả hai cùng nhấn nút thanh toán vào cùng một mili-giây. Hệ thống làm thế nào để đảm bảo chỉ có một bên đặt được phòng và không xảy ra tình trạng bán khống phòng (Overbooking)?"*
*   **Mục đích câu hỏi**: Đánh giá hiểu biết của sinh viên về concurrency control và cách thức vận hành lock ở tầng phân tán.
*   **Cách trả lời chuẩn chỉnh**:
    *   Chúng em giải quyết bài toán này bằng cơ chế **Distributed Lock (Khóa phân tán)** sử dụng **Redis (Redlock)** trước khi request chạm vào Database PostgreSQL.
    *   **Luồng xử lý chi tiết**:
        1.  Khi request thanh toán gửi lên Backend, API sẽ cố gắng tạo một key khóa trong Redis có định dạng `lock:inventory:hotelId:roomId:date` với thời gian hết hạn (TTL) là 10 giây.
        2.  Chỉ có request đầu tiên ghi key thành công vào Redis mới được phép đi tiếp vào database để trừ số lượng phòng trống (`available_qty` - 1) và chuyển trạng thái booking thành `Paid`.
        3.  Request thứ hai gửi lên cùng thời điểm sẽ không thể ghi key vào Redis (vì key đang bị giữ bởi request 1). Request này sẽ bị block, đợi hoặc trả về lỗi ngay lập tức: *"Phòng đang được thanh toán bởi người khác, vui lòng thử lại sau"*.
        4.  Sau khi transaction của request 1 commit thành công hoặc bị rollback, Redis key sẽ được giải phóng.

---

### Kịch bản 2.2: Luồng đặt giữ chỗ combo đồng bộ (Synchronized Combo Hold)
*   **Câu hỏi hội đồng**:
    > *"Khách hàng đặt một Combo gồm: Vé máy bay (xuất vé tự động qua API hãng bay) và Tour du lịch (Supplier duyệt thủ công trong 2 tiếng). Nếu hãng bay đã trừ tiền xuất vé thành công nhưng sau đó Supplier Tour từ chối đơn hàng vì hết chỗ thực tế. Đại lý bị rơi vào tình trạng 'mồ côi vé máy bay' (có vé bay nhưng không đi được tour). Hệ thống của em xử lý kịch bản này như thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra tư duy thiết kế chuỗi giao dịch phức tạp (Composite Transaction) đi qua nhiều nhà cung cấp có độ trễ xác nhận khác nhau.
*   **Cách trả lời chuẩn chỉnh**:
    *   Chúng em thiết lập quy tắc **Giữ chỗ tạm thời (Hold PNR) đồng bộ** trước khi tiến hành xuất vé chính thức.
    *   **Luồng nghiệp vụ xử lý**:
        1.  Khi checkout combo, hệ thống **không thực hiện xuất vé máy bay ngay**. Thay vào đó, hệ thống gọi API giữ chỗ vé máy bay (Hold Airline PNR) để khóa giá vé và số lượng ghế trong 20 phút (không mất phí).
        2.  Đồng thời, hệ thống gửi yêu cầu đặt Tour đến Supplier và chuyển trạng thái ví đại lý sang `Blocked Balance` (Tạm khóa số tiền bằng tổng giá trị combo).
        3.  Nếu Supplier Tour xác nhận đồng ý (`Approve`) trong vòng 20 phút: Backend mới gọi API xuất vé máy bay chính thức (`Issue Ticket API`) và chuyển số dư ví đại lý từ tạm khóa sang trừ ví chính thức.
        4.  Nếu quá 20 phút Supplier Tour không phản hồi hoặc Supplier bấm từ chối đơn hàng: Hệ thống tự động gọi API hủy giữ chỗ vé máy bay (Release PNR) để bảo toàn giá trị và tự động mở khóa ví (`Unblock Balance`) trả lại tiền cho đại lý.

---

## NHÓM 3: LUỒNG BÀN GIAO (DELIVERY) & XÁC THỰC QR CODE

### Kịch bản 3.1: Chống gian lận sử dụng lại Voucher (Replay Attack)
*   **Câu hỏi hội đồng**:
    > *"Mã QR Code trên Voucher gửi cho khách hàng ở dạng file PDF. Khách hàng hoàn toàn có thể chụp ảnh màn hình gửi cho bạn bè cùng quét. Hoặc khách hàng đi tour xong rồi, chụp lại mã đó gửi cho người khác đi tiếp vào ngày hôm sau. Làm sao hệ thống của em ngăn chặn được việc này?"*
*   **Mục đích câu hỏi**: Kiểm tra tính an toàn thông tin của mã QR Code, chống sử dụng trùng lặp vé (Double Spend).
*   **Cách trả lời chuẩn chỉnh**:
    *   Hệ thống kiểm soát chặt chẽ bằng cách gắn liền trạng thái Voucher với cơ sở dữ liệu thời gian thực và áp dụng thuật toán ký số.
    *   **Các biện pháp phòng ngừa cụ thể**:
        1.  **Một mã QR chỉ được quét thành công 1 lần**: Khi tài xế quét mã QR lần đầu, hệ thống kiểm tra trạng thái voucher trong database. Nếu là `Confirmed`, hệ thống đổi ngay trạng thái sang `Delivered` (Đã sử dụng). Nếu có người quét lại mã đó lần thứ hai, app quét của tài xế sẽ báo lỗi đỏ ngay lập tức vì trạng thái voucher lúc này đã là `Delivered`.
        2.  **QR động (Dynamic QR)**: Thay vì gửi QR tĩnh qua PDF, đối với khách hàng sử dụng app di động, mã QR hiển thị trên màn hình sẽ liên tục thay đổi cấu trúc mã hóa sau mỗi 30 giây bằng cách nhúng kèm timestamp. Ảnh chụp màn hình quá 30 giây sẽ bị quét báo lỗi hết hạn.
        3.  **Đối soát lịch trình ngày đi**: Mã QR chứa thông tin ngày khởi hành của tour. Hệ thống kiểm tra nếu ngày hiện tại không khớp với ngày đăng ký trên voucher, app quét sẽ báo lỗi không hợp lệ kể cả khi chưa từng được quét.

---

### Kịch bản 3.2: Quét mã check-in trong vùng không có sóng mạng di động (Offline Verification)
*   **Câu hỏi hội đồng**:
    > *"Nhiều điểm đón khách du lịch ở vùng sâu vùng xa hoặc trên núi (như Măng Đen, trạm đón cáp treo) hoàn toàn không có sóng 3G/4G. Tài xế không thể kết nối mạng để gọi API verify trạng thái voucher lên server. Ứng dụng di động Flutter của em xử lý kịch bản ngoại tuyến này thế nào mà vẫn đảm bảo tính an toàn?"*
*   **Mục đích câu hỏi**: Đánh giá tính thực tế của ứng dụng di động trong điều kiện vận hành khắc nghiệt, cách thiết kế cơ chế lưu trữ offline (Local Caching) và chữ ký mã hóa.
*   **Cách trả lời chuẩn chỉnh**:
    *   Chúng em thiết kế tính năng **Xác thực offline bằng Chữ ký số mã hóa** trên app Flutter của tài xế sử dụng database nội bộ **Hive**.
    *   **Cơ chế hoạt động**:
        1.  **Đồng bộ dữ liệu trước khi đi (Active Sync)**: Sáng sớm khi có mạng, tài xế mở app đồng bộ hành trình. App Flutter tự động tải danh sách khách và mã voucher hợp lệ của ngày hôm đó về lưu trữ vào database Hive cục bộ trên điện thoại.
        2.  **Xác thực không cần mạng**: Khi quét QR offline, app Flutter không gọi API. Nó tự động bóc tách chuỗi mã QR, lấy ra `VoucherId` và chuỗi `Signature` (hmac-sha256). App sử dụng public key đã lưu sẵn để verify chữ ký số này. Nếu chữ ký số hợp lệ và `VoucherId` khớp với danh sách trong Hive local, app báo "Hợp lệ" cho khách lên xe.
        3.  **Ghi nhận log offline**: Trạng thái check-in cùng vị trí tọa độ GPS (lấy trực tiếp từ cảm biến GPS của điện thoại không cần mạng) được lưu tạm vào Hive Box `offline_checkins`. Khi phát hiện thiết bị có mạng trở lại, app tự động đồng bộ hàng loạt các bản ghi này lên server để cập nhật DB trung tâm.

---
> [!IMPORTANT]
> **GIẢNG VIÊN THƯỜNG CHẤM KỸ**: Khả năng giải thích cơ chế mã hóa offline. Hãy nhấn mạnh rằng: *"Chúng em không lưu password hay key bảo mật dưới dạng text thô trong app Flutter, mà dùng thuật toán chữ ký công khai để verify tính toàn vẹn của mã QR"*.

---

## NHÓM 4: QUẢN LÝ SỰ CỐ & ĐỀN BÙ TỰ ĐỘNG (INCIDENT HANDLING)

### Kịch bản 4.1: Supplier đột ngột hủy dịch vụ sát giờ khởi hành
*   **Câu hỏi hội đồng**:
    > *"Tour du lịch đã được đại lý đặt và thanh toán thành công. Khách hàng đã có mặt tại điểm đón. Tuy nhiên, lúc 07:30 sáng, Supplier báo xe bị hỏng động cơ không thể khởi hành. Hệ thống xử lý thế nào để bảo vệ quyền lợi của đại lý và khách hàng?"*
*   **Mục đích câu hỏi**: Đánh giá quy trình xử lý ngoại lệ nghiệp vụ (Exception Handling Workflow) và chế tài tài chính tự động trên sàn B2B.
*   **Cách trả lời chuẩn chỉnh**:
    *   Hệ thống cung cấp tính năng **Khai báo sự cố khẩn cấp (Incident Report)** trên Supplier App và kích hoạt chuỗi xử lý tự động.
    *   **Quy trình xử lý tự động**:
        1.  Supplier chọn booking bị ảnh hưởng, bấm "Báo sự cố khỏng xe" (Operational Failure). Hệ thống dừng bán tour này ngay lập tức để tránh phát sinh đơn mới.
        2.  **Tự động tìm đối tác thay thế (Auto-rerouting)**: Hệ thống quét trong cơ sở dữ liệu xem có Supplier B nào chạy cùng tuyến đường, cùng giờ khởi hành ngày hôm đó còn chỗ trống hay không. Nếu có, tự động chuyển đơn sang Supplier B. Phần chênh lệch giá vé (nếu có) sẽ tự động trừ vào số dư ví đối soát của Supplier A bị hỏng xe.
        3.  **Tự động phạt & hoàn tiền**: Nếu không có tour thay thế, hệ thống hủy đơn, hoàn **100% tiền** về ví đại lý. Đồng thời thực hiện lệnh phạt trừ **30% giá trị đơn hàng** từ ví công nợ của Supplier A để đền bù mã giảm giá (Discount Code) tự động gửi cho đại lý xoa dịu khách hàng.

---

### Kịch bản 4.2: Luồng đặt tour đêm muộn & Hủy tự động (Dynamic Cut-off)
*   **Câu hỏi hội đồng**:
    > *"Hệ thống của em có tính năng Khung giờ Yên lặng (Quiet Hours) cho phép đại lý đặt tour từ 21h tối đến 6h sáng hôm sau mà không làm phiền Supplier. Giả sử 23h đêm đại lý đặt một tour khởi hành lúc 07:00 sáng mai. Đến 06:30 sáng mai Supplier mới ngủ dậy mở app duyệt đơn thì đã quá sát giờ đi của khách, gây vỡ trận. Luồng này xử lý thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra tư duy thiết kế mốc thời gian tới hạn (Cut-off Time) hợp lý trong nghiệp vụ lữ hành thực tế.
*   **Cách trả lời chuẩn chỉnh**:
    *   Để giải quyết trường hợp này, chúng em áp dụng quy tắc **Dynamic Cut-off Time (Khóa sổ đặt tour linh hoạt)**.
    *   **Quy tắc áp dụng**:
        1.  Đối với các tour khởi hành sáng sớm hôm sau (từ 06:00 đến 12:00 trưa), hệ thống thiết lập giờ khóa sổ nhận đơn là **18:00 tối ngày hôm trước**. Mọi đơn đặt combo tour sáng sớm gửi sau 18:00 sẽ bị hệ thống từ chối nhận và báo lỗi để đại lý chọn tour khởi hành buổi chiều.
        2.  Đối với các đơn gửi trước 18:00 tối: Nếu đến **21:00 tối cùng ngày** (trước khi bước vào Khung giờ Yên lặng) mà Supplier vẫn chưa bấm duyệt xác nhận đơn, hệ thống Hangfire Job sẽ chạy quét và **tự động hủy đơn đặt chỗ**, mở khóa tiền ví hoàn trả cho đại lý.
        3.  *Kết quả*: Tránh hoàn toàn việc đơn hàng bị treo qua đêm dẫn đến hủy sát giờ vào sáng hôm sau. Khách hàng và đại lý biết rõ kết quả bị hủy từ 21h tối hôm trước để kịp thay đổi phương án.

---

## NHÓM 5: ĐỐI SOÁT & COMMISSION SPLIT

### Kịch bản 5.1: Đối soát lệch tiền giữa VNPay, Sàn và Đại lý
*   **Câu hỏi hội đồng**:
    > *"Cuối tháng thực hiện đối soát tài chính, kế toán phát hiện số tiền thực nhận trong tài khoản ngân hàng của sàn từ VNPay bị lệch giảm 50 triệu so với số tiền hệ thống tự động cộng vào ví đại lý. Em làm thế nào để truy vết ra lỗi này nằm ở đâu?"*
*   **Mục đích câu hỏi**: Kiểm tra kỹ năng thiết kế cơ chế đối soát tài chính 3 bên (Reconciliation) và ghi nhận lịch sử giao dịch (Transaction Logs/Audit Trails).
*   **Cách trả lời chuẩn chỉnh**:
    *   Chúng em thiết kế cấu trúc ghi nhận giao dịch tài chính độc lập theo chuẩn kế toán kép (Double-entry Ledger) và lưu trữ mã tham chiếu chéo (`GatewayTransactionId`).
    *   **Quy trình truy vết**:
        1.  Kế toán sử dụng tính năng **Reconciliation Tool** trên Admin Panel để tải lên file đối soát định dạng CSV xuất từ hệ thống quản trị của VNPay.
        2.  Hệ thống tự động so khớp mã `vnp_TxnRef` của VNPay với cột `gateway_reference_id` trong bảng `payment.transactions` của hệ thống.
        3.  Hệ thống sẽ lọc ra các giao dịch bị lệch trạng thái (ví dụ: VNPay báo giao dịch thất bại/hủy nhưng ví đại lý trên sàn lại được ghi nhận trạng thái `Paid`).
        4.  Xem chi tiết nhật ký hệ thống (**Audit Log** của ví liên quan) để truy vết xem có hành vi can thiệp sửa trực tiếp số dư ví bằng câu lệnh database của Admin hoặc lỗi logic API nạp tiền hay không.

---

### Kịch bản 5.2: Khách hàng yêu cầu hoàn tiền khi Supplier báo sai thông tin dịch vụ
*   **Câu hỏi hội đồng**:
    > *"Khách hàng đặt phòng khách sạn có ghi tiện ích 'Bao gồm bữa ăn sáng'. Khi đến nơi, khách sạn thông báo không có ăn sáng do Supplier khai báo sai thông tin sản phẩm trên sàn. Khách hàng đòi đại lý bồi thường, đại lý đòi sàn bồi thường. Quy trình xử lý tranh chấp tài chính này trên hệ thống của em diễn ra thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra cách thiết kế luồng xử lý tranh chấp khiếu nại (Dispute Resolution Flow) và phân định trách nhiệm tài chính giữa các Actor.
*   **Cách trả lời chuẩn chỉnh**:
    *   Hệ thống hiện thực hóa quy trình này thông qua Module **After-sales & Claim Management (Khiếu nại sau bán)**.
    *   **Luồng xử lý tranh chấp**:
        1.  Nhân viên đại lý mở chi tiết booking, chọn tính năng **"Gửi khiếu nại (Claim)"**, nhập mô tả sự cố hỏng dịch vụ và upload hình ảnh bằng chứng (ảnh phiếu xác nhận phòng của khách sạn không ăn sáng). Trạng thái booking chuyển sang `Disputed`.
        2.  Yêu cầu được đẩy về trang quản lý khiếu nại của **Platform Admin**. Admin kiểm tra thông tin mô tả sản phẩm gốc của Supplier đăng trên sàn có đúng chứa dòng chữ "Bao gồm ăn sáng" hay không.
        3.  **Phán quyết tài chính**: Nếu lỗi thuộc về Supplier khai báo sai, Admin nhấn nút "Resolve - Supplier Fault". 
        4.  Hệ thống tự động thực hiện lệnh **hoàn trả 10% giá trị phòng** (tương đương chi phí ăn sáng) vào ví đại lý, đồng thời thực hiện lệnh **khấu trừ phạt tiền tương ứng** vào ví tiền thu hộ của Supplier đó tại kỳ đối soát cuối tháng.

---
--- KẾT THÚC TÀI LIỆU ---
