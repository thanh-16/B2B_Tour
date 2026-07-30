# TÀI LIỆU 4: BỘ KỊCH BẢN GIẢ LẬP HỎI ĐÁP HỘI ĐỒNG BẢO VỆ
## DỰ ÁN: B2B TRAVEL PLATFORM — END-TO-END BOOKING & DELIVERY

---

## 1. HƯỚNG DẪN CHUẨN BỊ BẢO VỆ ĐỒ ÁN MÔN SWR / THUYẾT TRÌNH

### 1.1 Checklist trước ngày bảo vệ
*   [ ] **Đầy đủ bộ tài liệu phân tích thiết kế**: Đảm bảo 3 tài liệu cơ bản được in ấn hoặc chuẩn bị file trình chiếu gọn gàng:
    1.  [Tài liệu 1: Tầm nhìn & Phạm vi Dự án](file:///d:/Đồ%20Án/Tài_liệu_1_Tầm_nhìn_&_Phạm_vi_Dự_án.md)
    2.  [Tài liệu 2: Đặc tả Yêu cầu Phần mềm (SRS)](file:///d:/Đồ%20Án/Tài_liệu_2_Đặc_tả_Yêu_cầu_Phần_mềm_SRS.md)
    3.  [Tài liệu 3: Mô tả Chi tiết Dự án & Giải pháp Logic](file:///d:/Đồ%20Án/Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md)
*   [ ] **Lưu đồ nghiệp vụ (Activity/Sequence Diagrams)**: Vẽ rõ ràng các sơ đồ luồng đi của giỏ hàng, giữ chỗ combo và check-in QR offline trên slide để demo trực quan thay vì giải thích bằng chữ.
*   [ ] **Dữ liệu mẫu và Kịch bản Demo**: Thiết lập sẵn các ca kiểm thử (Test Cases) tương ứng với các Acceptance Criteria trong SRS để hội đồng thấy rõ hệ thống hoạt động khớp 100% với đặc tả.

---

### 1.2 Bí quyết thuyết trình dành cho SV môn Software Requirements / Design
1.  **Tập trung vào phần "Đặc tả đặc thù"**: Chứng minh nhóm hiểu sâu sắc nghiệp vụ du lịch B2B tại Việt Nam (các quy định về thời gian giữ chỗ - Hold Time Buffer, quy trình duyệt tour của nhà cung cấp local - On-Request, và luật phạt khi hủy phòng/hủy tour đột xuất).
2.  **Trả lời câu hỏi dựa trên Phân tích hệ thống (System Analysis)**: Khi thầy cô hỏi về lỗi hoặc các trường hợp đặc biệt (Edge Cases), hãy bắt đầu câu trả lời bằng cách dẫn chiếu đến các **Business Rules (Quy tắc nghiệp vụ)** hoặc **System Flows** đã mô tả trong SRS. Điều này chứng minh bạn thiết kế hệ thống có tính toán trước và bao quát mọi trường hợp.
3.  **Hạn chế nói về code chi tiết**: Đây là môn học về Đặc tả yêu cầu và Thiết kế hệ thống (SWR). Hội đồng sẽ chấm điểm khả năng phân tích logic, luồng đi dữ liệu, cách tổ chức Use Case và xử lý xung đột nghiệp vụ chứ không chấm dòng code C# hay Flutter cụ thể.

---

## 2. BỘ 10 KỊCH BẢN HỎI ĐÁP GIẢ LẬP (DEFENSE Q&A SCENARIOS)

---

### Kịch bản 1: Concurrency cập nhật số dư ví đại lý (Credit Limit Breach)
*   **Câu hỏi hội đồng**: 
    > *"Đại lý của em có hạn mức nợ tối đa là -50 triệu. Số dư hiện tại đang ở mức -49 triệu (còn hạn mức nợ khả dụng 1 triệu). Hai nhân viên đại lý mở 2 máy tính khác nhau, cùng nhấn xác nhận đặt 2 đơn hàng có giá 2 triệu và 3 triệu vào cùng một thời điểm. Hệ thống làm thế nào để ngăn chặn tình trạng tổng nợ vượt quá hạn mức -50 triệu?"*
*   **Mục đích câu hỏi**: Đánh giá kỹ năng thiết kế giao dịch an toàn tài chính, chống lỗi cập nhật đồng thời (Concurrency Update) ở tầng thiết kế logic database.
*   **Câu trả lời đề xuất**:
    *   *Mức độ nghiệp vụ*: Hệ thống kiểm tra số dư khả dụng theo công thức: Số dư ví + Hạn mức nợ tín dụng.
    *   *Mức độ thiết kế hệ thống*: Để tránh hiện tượng tranh chấp dòng dữ liệu làm cả hai luồng xử lý đều đọc ra hạn mức khả dụng bằng 1 triệu và cho phép thanh toán (gây nợ âm vượt hạn mức), chúng em áp dụng cơ chế **Khóa bi quan cấp dòng (Pessimistic Locking)** ở mức transaction của database. Khi có request thanh toán gửi lên, hệ thống sẽ thực thi câu lệnh truy vấn có kèm theo khóa độc quyền `FOR UPDATE` cho dòng thông tin ví của đại lý đó. Luồng giao dịch nào đến trước sẽ giữ khóa, đọc số dư, thực hiện trừ ví và ghi log lịch sử. Luồng giao dịch thứ hai đến sau bắt buộc phải dừng lại xếp hàng chờ. Khi luồng một hoàn tất và giải phóng khóa, luồng hai mới được đọc dữ liệu mới và lúc này hệ thống sẽ thấy số dư khả dụng không còn đủ nên sẽ từ chối thanh toán và rollback. Chi tiết giải pháp logic đã được trình bày tại [Tài liệu 3 - Mục 2.3](file:///d:/Đồ%20Án/Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md#vấn-đề-3-đảm-bảo-tính-nhất-quán-ví-tài-chính--chống-tiêu-trùng-double-spending-prevention).

---

### Kịch bản 2: Sự cố mất kết nối mạng của đối tác (IPN Webhook Timeout)
*   **Câu hỏi hội đồng**: 
    > *"Đại lý nạp 10 triệu vào ví qua quét mã cổng thanh toán VNPay. Ngân hàng đã trừ tiền của họ thành công, nhưng do sự cố mạng kết nối, gói tin IPN Webhook báo thanh toán thành công từ VNPay gửi về Backend API của em bị mất hoặc bị chậm trễ. Lúc này ví đại lý trên hệ thống chưa được cộng tiền. Hệ thống xử lý tự động thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra khả năng thiết kế chịu lỗi và thiết lập cơ chế đối soát tích hợp bên thứ ba (Fault-tolerant Integration).
*   **Câu trả lời đề xuất**:
    *   Chúng em không chỉ phụ thuộc duy nhất vào luồng Webhook IPN từ cổng thanh toán gửi về (Push model). Hệ thống thiết kế bổ sung một tác vụ ngầm chạy định kỳ **Active Query Reconciliation Job (đối soát chủ động)**.
    *   Mỗi khi đại lý khởi tạo yêu cầu nạp tiền, hệ thống ghi nhận một giao dịch trạng thái `PENDING`. Nếu sau 10 phút trạng thái vẫn chưa được chuyển sang thành công, tác vụ ngầm sẽ tự động quét và chủ động gọi API truy vấn trạng thái giao dịch (`QueryDR API`) của VNPay để hỏi kết quả thực tế. Nếu VNPay trả về trạng thái giao dịch đã thành công ở ngân hàng, hệ thống sẽ thực hiện cập nhật số dư ví cho đại lý và chuyển trạng thái yêu cầu sang thành công. Chi tiết giải pháp logic được mô tả tại [Tài liệu 3 - Mục 3.3](file:///d:/Đồ%20Án/Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md#vấn-đề-phát-sinh-3-sự-cố-webhook-từ-cổng-thanh-toán-vnpay-bị-mất-gói-tin-vnpay-ipn-webhook-failure).

---

### Kịch bản 3: Chống gian lận dùng trùng lặp Voucher (Double Spend / Replay Attack)
*   **Câu hỏi hội đồng**: 
    > *"Voucher gửi cho khách hàng ở dạng file ảnh hoặc PDF. Khách hàng hoàn toàn có thể sao chép tệp tin này gửi cho nhiều người khác cùng sử dụng check-in tour đón khách của ngày hôm đó. Làm thế nào hệ thống phát hiện và ngăn chặn việc quét trùng lặp?"*
*   **Mục đích câu hỏi**: Kiểm tra tính bảo mật thông tin vé điện tử và cách quản lý trạng thái vé thời gian thực.
*   **Câu trả lời đề xuất**:
    *   Mỗi mã QR E-Voucher sinh ra là duy nhất và được quản lý trạng thái chặt chẽ trên cơ sở dữ liệu Platform.
    *   Khi nhân viên đón khách thực hiện quét mã check-in lần đầu tiên, hệ thống sẽ ngay lập tức thay đổi trạng thái voucher từ `Confirmed` sang `Delivered` (Đã sử dụng) trên database trực tuyến. Nếu có người đưa ảnh chụp voucher đó quét lần thứ hai, hệ thống sẽ kiểm tra database thấy trạng thái đã là `Delivered` và báo lỗi vé đã được sử dụng.
    *   Ngoài ra, trên ứng dụng di động dành cho khách hàng, mã QR hiển thị là **QR động (Dynamic QR)** tự động tạo lại mã hóa hash kèm mốc thời gian OTP sau mỗi 30 giây để ngăn chặn tuyệt đối việc sử dụng ảnh chụp màn hình cũ gửi qua các ứng dụng tin nhắn.

---

### Kịch bản 4: Quét QR check-in khi tài xế mất sóng mạng di động (Offline Scan)
*   **Câu hỏi hội đồng**: 
    > *"Điểm đón khách đi tàu ra vịnh hoặc lên núi Fansipan hoàn toàn không có sóng 3G/4G. Tài xế không thể kết nối mạng gọi API verify voucher lên server. Làm thế nào tài xế vẫn quét check-in đón khách được?"*
*   **Mục đích câu hỏi**: Đánh giá tính thực tế của thiết kế ngoại tuyến (Offline Architecture) và chữ ký số.
*   **Câu trả lời đề xuất**:
    *   Chúng em thiết kế giải pháp **Xác thực offline bằng Chữ ký số đối xứng mật mã** dựa trên thuật toán **HMAC-SHA256** và bộ lưu trữ cơ sở dữ liệu local trên điện thoại của tài xế.
    *   Đầu ngày khi có mạng Wifi tại văn phòng, tài xế mở app đồng bộ hành trình để tải danh sách voucher hợp lệ của ngày hôm đó cùng với khóa bảo mật hệ thống (Shared Secret Key) về lưu cục bộ.
    *   Khi mất mạng ngoài hiện trường, camera quét QR của khách sẽ bóc tách chuỗi JSON chứa thông tin voucher và Signature. App di động tự tính toán lại Signature từ thông tin voucher quét được kết hợp với Shared Secret Key trong máy. Nếu trùng khớp chữ ký, chứng minh vé này nguyên bản do Server cấp và không bị sửa đổi. App lưu log check-in kèm tọa độ GPS offline vào bộ nhớ và tự động đồng bộ lên Server khi thiết bị có mạng trở lại. Chi tiết lưu đồ và giải thuật logic được đặc tả tại [Tài liệu 3 - Mục 2.4](file:///d:/Đồ%20Án/Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md#vấn-đề-4-xác-thực-e-voucher-ngoại-tuyến-offline-qr-code-verification-cho-tài-xế-ở-vùng-mất-sóng).

---

### Kịch bản 5: Đóng bán nhanh & Chế tài xử phạt lỗi quá kho (Overbooking)
*   **Câu hỏi hội đồng**: 
    > *"Nhà cung cấp đối tác (Supplier) hết chỗ thực tế bên ngoài nhưng quên không cập nhật lên hệ thống của em. Đại lý đặt chỗ thành công trên sàn nhưng sau đó bị đối tác từ chối phục vụ. Điều này gây mất uy tín cho Platform. Em xử lý thế nào?"*
*   **Mục đích câu hỏi**: Kiểm tra tư duy thiết kế luật kinh doanh (Business Rules) kết hợp giải pháp kỹ thuật để tự động chế tài đối tác.
*   **Câu trả lời đề xuất**:
    *   *Kỹ thuật*: Hệ thống thiết kế nút gạt "Đóng bán nhanh (Stop Selling)" trên màn hình chính của ứng dụng dành riêng cho nhà cung cấp, cho phép họ khóa nhanh kho chỗ trong vòng 3 giây khi xảy ra sự cố hết chỗ đột xuất.
    *   *Luật nghiệp vụ (Business Rules)*: Để nâng cao trách nhiệm cập nhật kho chỗ của Supplier, hệ thống áp dụng chế tài tài chính số hóa tự động: Nếu Supplier từ chối đơn hàng hợp lệ của đại lý với lý do hết phòng/hết chỗ thực tế (Double Booking), hệ thống sẽ tự động phạt trừ 20% giá trị đơn hàng từ tài khoản công nợ của Supplier đó chuyển thành mã giảm giá đền bù bồi thường cho đại lý đặt đơn.

---

### Kịch bản 6: Bài toán mồ côi dịch vụ trong Combo Booking
*   **Câu hỏi hội đồng**: 
    > *"Đại lý đặt combo gồm: Vé máy bay (hệ thống hãng bay xuất ngay) và Tour du lịch (Supplier duyệt thủ công). Nếu hãng bay đã trừ tiền xuất vé thành công nhưng sau đó đối tác Tour lại từ chối đơn hàng vì hết xe, đại lý bị rơi vào tình thế có vé bay nhưng không có tour đi. Hệ thống giải quyết thế nào?"*
*   **Mục đích câu hỏi**: Đánh giá thiết kế luồng giao dịch phân tán phức tạp (Composite Transaction).
*   **Câu trả lời đề xuất**:
    *   Hệ thống áp dụng cơ chế **Saga Orchestrator với chiến lược Tour-First** để quản lý trạng thái chuỗi giao dịch phân tán.
    *   Khi đại lý bấm thanh toán combo, hệ thống **không gọi GDS hold vé máy bay ngay**. Thay vào đó, **bước 1** là gửi yêu cầu duyệt tour sang đối tác Supplier trước tiên. Thời gian duyệt tối đa được tính theo công thức: **MIN(giờ gửi + 3h, 21:00 đêm hôm trước ngày đi)**. Trong thời gian này, số tiền tương ứng giá trị đơn hàng được khóa tạm trong `reserved_balance` của ví đại lý để đại lý không thể dùng số tiền đó vào giao dịch khác.
    *   **Bước 2**: Chỉ khi Supplier xác nhận duyệt tour thành công, hệ thống mới gọi API GDS để Hold PNR vé máy bay. Vì GDS thường giữ PNR từ 30 phút đến 24 giờ — nhiều hơn nhiều so với thời gian thực thu và xuất vé tiếp theo (chỉ cần vài giây) — nên không có rủi ro PNR hết hạn.
    *   Nếu Supplier từ chối tour hoặc hết thời gian chờ duyệt, hệ thống giải phóng `reserved_balance` về ví đại lý ngay lập tức, không có mã GDS nào bị mắc kẹt. Nếu đợi GDS hold vé thành công xong mà Supplier lại từ chối tour, hệ thống kích hoạt Compensating Action: gọi API GDS hủy PNR và giải phóng `reserved_balance`. Chi tiết luồng Saga được vẽ sơ đồ tại [Tài liệu 3 - Mục 2.5](file:///d:/Đồ%20Án/Tài_liệu_3_Mô_tả_Chi_tiết_Dự_án_&_Giải_pháp_Logic.md#vấn-đề-5-xử-lý-đơn-hàng-combo-phức-tạp-distributed-transactions--saga-pattern).

---

### Kịch bản 7: Xử lý sự cố Nhà cung cấp hủy dịch vụ sát giờ đi (Incident Handling)
*   **Câu hỏi hội đồng**: 
    > *"Tour du lịch đã thanh toán thành công, khách đang đứng đợi ở điểm đón lúc 07:30 sáng. Bất ngờ nhà xe đối tác báo xe hỏng động cơ không chạy được. Quy trình xử lý sự cố này trên hệ thống của em diễn ra tự động như thế nào?"*
*   **Mục đích câu hỏi**: Đánh giá luồng xử lý sự cố nghiệp vụ (Exception Handling Workflow).
*   **Câu trả lời đề xuất**:
    *   Khi xảy ra sự cố hỏng xe sát giờ đi, đối tác thực hiện khai báo sự cố khẩn cấp trên portal chọn lý do "Lỗi vận hành". Hệ thống lập tức dừng bán tour này trên sàn để tránh đại lý khác đặt thêm.
    *   **Auto-rerouting (Định tuyến lại tự động)**: Hệ thống tự động quét database tìm các đối tác cung cấp khác chạy cùng lịch trình, có điểm đón tương tự và còn chỗ trống. Hệ thống tự động chuyển đơn hàng sang đối tác mới, phần chênh lệch giá dịch vụ phát sinh (nếu có) sẽ tự động khấu trừ vào tài khoản ví đối soát của đối tác gặp sự cố hỏng xe.
    *   Nếu không tìm thấy dịch vụ thay thế phù hợp, hệ thống tự động hủy đơn hàng, hoàn trả 100% tiền về ví đại lý, đồng thời phạt trừ 50% giá trị đơn hàng từ ví của đối tác bị lỗi để đền bù code giảm giá bồi thường cho khách hàng.

---

### Kịch bản 8: Luồng đặt Tour đêm muộn & Cut-off thời gian duyệt đơn
*   **Câu hỏi hội đồng**: 
    > *"Đại lý đặt tour đêm lúc 23:00 đi vào sáng sớm mai lúc 07:00. Nhà cung cấp lúc này đang ngủ không thể duyệt đơn. Sáng ra khách đến điểm đi mới biết tour chưa được duyệt thì đã quá muộn. Em xử lý mốc thời gian này ra sao?"*
*   **Mục đích câu hỏi**: Kiểm tra tư duy thiết kế mốc thời gian khóa sổ (Cut-off Time) trong nghiệp vụ lữ hành thực tế.
*   **Câu trả lời đề xuất**:
    *   Hệ thống áp dụng cơ chế **Dynamic Cut-off Time (Mốc khóa sổ động)** để ngăn chặn rủi ro này từ đầu vào.
    *   **Công thức Cut-off Time thống nhất**: Thời gian duyệt hiệu lực = **MIN(giờ gửi yêu cầu + 3 tiếng, 21:00 đêm hôm trước ngày đi)**. Điều này có nghĩa:
        *   Nếu đại lý gửi lúc **15:00** → cut-off = MIN(18:00, 21:00) = **18:00** (chỉ còn 3 tiếng).
        *   Nếu đại lý gửi lúc **20:30** → cut-off = MIN(23:30, 21:00) = **21:00** (chỉ còn 30 phút để duyệt, hệ thống cảnh báo rõ cho đại lý).
    *   Mọi yêu cầu gửi **sau 21:00 cho tour khởi hành sáng hôm sau** bị API từ chối tiếp nhận ngay lập tức với thông báo: *"Hệ thống đã đóng nhận đơn cho tour ngày mai. Vui lòng đặt cho ngày sau."*
    *   Nếu đến mốc 21:00 mà Supplier chưa duyệt bất kỳ đơn nào còn đang `PENDING_SUPPLIER_APPROVAL`, hệ thống tác vụ ngầm tự động quét và thực hiện lệnh **hủy đơn tự động**, giải phóng `reserved_balance` vào ví đại lý, gửi cảnh báo vi phạm tỷ lệ duyệt cho Supplier để đại lý kịp thông báo cho khách hàng thay đổi lịch trình từ tối hôm trước.

---

### Kịch bản 9: Đối soát lệch tiền giữa Cổng thanh toán, Sàn và Ví đại lý
*   **Câu hỏi hội đồng**: 
    > *"Cuối tháng thực hiện đối soát tài chính, số tiền sàn nhận thực tế từ cổng thanh toán bị lệch giảm 50 triệu so với số tiền hệ thống tự động cộng vào ví đại lý. Em làm thế nào để phát hiện lỗi?"*
*   **Mục đích câu hỏi**: Đánh giá thiết kế cơ chế đối soát tài chính 3 bên (Reconciliation) và nhật ký Audit Trail.
*   **Câu trả lời đề xuất**:
    *   Hệ thống thiết kế cấu trúc ghi nhận giao dịch tài chính độc lập theo chuẩn kế toán kép (Double-entry Ledger) và lưu trữ mã tham chiếu chéo với cổng thanh toán (`GatewayTransactionId`).
    *   Kế toán dùng công cụ đối soát tài chính tải file đối soát giao dịch CSV từ portal của VNPay lên Admin Panel. Hệ thống tự động so khớp mã giao dịch của cổng thanh toán với trường dữ liệu trong database. Hệ thống tự động lọc ra các giao dịch bị lệch trạng thái (ví dụ: VNPay báo giao dịch thất bại/hủy tiền nhưng ví đại lý trên sàn lại được ghi nhận cộng tiền) và truy vấn trang **Audit Log** lưu vết hoạt động của tài khoản để tìm ra lỗi logic hoặc hành vi gian lận.

---

### Kịch bản 10: Xử lý tranh chấp chất lượng dịch vụ giữa Đại lý và Supplier
*   **Câu hỏi hội đồng**: 
    > *"Khách đặt phòng khách sạn ghi rõ 'Bao gồm ăn sáng'. Khi đến nơi, khách sạn báo không có ăn sáng do Supplier khai báo sai thông tin trên sàn. Đại lý bồi thường cho khách và đòi sàn bồi thường. Làm thế nào em giải quyết tranh chấp tài chính này?"*
*   **Mục đích câu hỏi**: Kiểm tra luồng xử lý tranh chấp khiếu nại (Dispute Resolution Flow) trong thiết kế hệ thống B2B.
*   **Câu trả lời đề xuất**:
    *   Hệ thống hiện thực hóa quy trình này qua Module **After-sales & Claim Management**.
    *   Đại lý gửi yêu cầu khiếu nại (Claim) kèm hình ảnh bằng chứng phòng không có dịch vụ đi kèm. Đơn hàng chuyển sang trạng thái tranh chấp (`Disputed`).
    *   Platform Admin kiểm tra thông tin mô tả sản phẩm của Supplier đăng trên sàn có đúng chứa thông tin "Bao gồm ăn sáng" tại thời điểm đặt phòng hay không. Nếu đúng, Admin nhấn nút duyệt "Resolve - Supplier Fault". Hệ thống tự động trích 10% giá trị phòng từ tài khoản ví đối soát của Supplier đó hoàn trả trực tiếp về ví đại lý.
    
---
--- KẾT THÚC TÀI LIỆU 4 ---
