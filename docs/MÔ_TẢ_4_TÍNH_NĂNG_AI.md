# MÔ TẢ CHI TIẾT 4 TÍNH NĂNG AI ĐỘT PHÁ
## Nền Tảng Đặt Chỗ Du Lịch B2B (B2B Travel Platform)

> **File tổng hợp dành cho xem duyệt & trình bày**  
> **Đường dẫn lưu trữ:** `docs/MÔ_TẢ_4_TÍNH_NĂNG_AI.md`  
> **Cập nhật lần cuối:** 2026-07-30

---

## TỔNG QUAN

Để biến dự án **B2B Travel Platform** từ một hệ thống CRUD/Transaction thông thường thành một **Hệ Thống Điều Hành Du Lịch B2B Thông Minh Tự Trị (Autonomous AI-Powered B2B Travel Operating System)**, 4 tính năng AI đột phá dưới đây đã được lựa chọn và thiết kế kiến trúc chuẩn Doanh nghiệp.

---

## 1. AI B2B COMBO CO-PILOT & DYNAMIC ITINERARY BUILDER

### Bài Toán Nghiệp Vụ
Đại lý du lịch nhỏ/vừa (Agency) mất **2-3 tiếng** thủ công để:
- Tra cứu vé máy bay, phòng khách sạn, và tour lẻ địa phương trên nhiều giao diện khác nhau.
- Tính toán mức lợi nhuận (Markup margin) và kiểm tra tính sẵn có của kho tồn.
- Soạn thảo thủ công file PDF báo giá có gắn logo riêng gửi cho khách hàng cuối.

### Giải Pháp AI
Đại lý chỉ cần nhập yêu cầu dưới dạng câu thoại hoặc văn bản tự nhiên:
> *"Khách gia đình 4 người đi Đà Nẵng 3N2Đ từ Hà Nội, ngân sách 18 triệu, thích nghỉ dưỡng 4 sao biển, trẻ em 5 tuổi."*

### Cách Vận Hành Kỹ Thuật
1. **Intent Parsing & Parameter Extraction:** Engine AI (Semantic Kernel) phân tích và bóc tách dữ liệu: `Destination = Đà Nẵng`, `Duration = 3N2Đ`, `Pax = 4`, `Budget = 18M`, `Star = 4`.
2. **Parallel Tool Calling:** Kích hoạt đồng thời 3 hàm API tra cứu kho tồn:
   - `SearchFlights(HAN -> DAD)`
   - `SearchHotels(DAD, 4-Star Beach)`
   - `SearchTours(DAD, Family Friendly)`
3. **Knapsack Optimization & Markup Calculation:** Tự động chọn phương án kết hợp tối ưu ngân sách và đảm bảo mức lợi nhuận cho đại lý.
4. **Saga Combo Hold Draft:** Tự động giữ chỗ Combo trên hệ thống trong **15 phút**.
5. **Branded PDF Export:** Xuất file Proposal PDF chứa đầy đủ lịch trình, điều khoản và **Logo riêng của Đại lý** chỉ trong **5 giây**.

---

## 2. AI DYNAMIC PRICING & DEMAND FORECASTING CHO SUPPLIER (YIELD MANAGEMENT)

### Bài Toán Nghiệp Vụ
Các Nhà cung cấp lẻ (Supplier - Khách sạn, Nhà xe local) không có bộ phận Analytics chuyên nghiệp. Họ thường đặt giá cố định quanh năm, dẫn đến:
- **Cháy phòng quá sớm:** Giá sỉ quá rẻ vào mùa cao điểm, bỏ lỡ doanh thu tối đa.
- **Trống phòng diện rộng:** Giá quá cao vào ngày thấp điểm, không cạnh tranh được.

### Giải Pháp AI
AI liên tục thu thập và phân tích 4 nguồn dữ liệu:
- Dữ liệu booking lịch sử trên sàn.
- Mật độ tìm kiếm & lượt xem sản phẩm (Impressions Log).
- Yếu tố thời tiết và ngày lễ/cuối tuần.
- Sự kiện lớn tại địa phương (Ví dụ: Festival pháo hoa Đà Nẵng).

### Cách Vận Hành Kỹ Thuật
AI tự động tính toán mô hình dự báo nhu cầu (Yield Management) và gửi **Push Notification 1-click** tới Supplier Portal:
> *"Cảnh báo: Tuần sau có Festival pháo hoa Đà Nẵng, nhu cầu tìm kiếm phòng khu vực Mỹ Khê tăng 250%. Đề xuất tăng giá sỉ dòng phòng Deluxe Sea View thêm 15% (từ 1.200.000 VNĐ lên 1.380.000 VNĐ) từ ngày 15/06 đến 18/06 để tối đa hóa doanh thu."*

---

## 3. NATURAL LANGUAGE BI ANALYTICS — CHAT VỚI DỮ LIỆU DOANH THU (TEXT-TO-SQL)

### Bài Toán Nghiệp Vụ
Chủ đại lý và Admin hệ thống cần xem báo cáo quản trị nhanh nhưng ngại thao tác xuất file Excel hoặc lọc bảng biểu phức tạp.

### Giải Pháp AI
Cho phép người dùng đặt câu hỏi trực tiếp bằng tiếng Việt tự nhiên:
> *"Tour nào đem lại lợi nhuận cao nhất cho đại lý của tôi trong tháng này?"*  
> *"So sánh doanh thu bán vé máy bay quý này với quý trước?"*

### Cách Vận Hành Kỹ Thuật & Bảo Mật AST
1. **Prompt & Context Injection:** AI nhận câu hỏi + Schema thông tin bảng Read-Model.
2. **SQL Generation & AST Security Validation:**
   - Sử dụng bộ lọc AST (Abstract Syntax Tree) để kiểm tra câu lệnh SQL.
   - **Chặn tuyệt đối** các lệnh thay đổi dữ liệu (`DROP`, `ALTER`, `UPDATE`, `DELETE`, `INSERT`).
   - **Bắt buộc tự động chèn điều kiện phân quyền Tenant:** Ép thêm `WHERE agency_id = @CurrentAgencyId` vào mọi câu query để chống rò rỉ dữ liệu giữa các đại lý.
3. **Execution & Visualization:** Chạy câu lệnh trên Read Replica PostgreSQL, chuyển đổi dữ liệu thành biểu đồ trực quan (Recharts / Chart.js) kèm câu tóm tắt Executive Summary.

---

## 4. MULTI-CHANNEL AI MARKETING CONTENT AUTO-PILOT

### Bài Toán Nghiệp Vụ
Các Đại lý du lịch nhỏ (Agency) gặp vấn đề **Sell-Through**: Họ mua sỉ sản phẩm từ sàn nhưng thiếu kỹ năng Marketing để truyền thông và bán lại cho khách hàng cuối (End Customers).

### Giải Pháp AI
Chỉ cần nhấn 1-click **"Tạo Marketing Kit"** tại bất kỳ sản phẩm Tour/Khách sạn nào trên sàn, AI Engine sẽ tự động tạo trọn bộ công cụ truyền thông.

### Thành Phần Sản Phẩm Sinh Ra
1. **Social Copywriting (Facebook/Zalo):** Sinh 3 phiên bản bài viết (Hấp dẫn, Sang trọng, Khuyến mãi ngắn gọn).
2. **TikTok Video Script:** Kịch bản 30 giây phân cảnh chi tiết (Lời thoại Audio + Hình ảnh Visual + Call to Action).
3. **Branded Visual Banner (1080x1080):** Tự động lấy ảnh chất lượng cao của Tour, phủ lớp màu thương hiệu, **chèn Logo, Hotline & Mã QR Đặt Tour riêng của Đại lý** lên Banner sẵn sàng đăng tải.

---

## BẢNG SO SÁNH GIÁ TRỊ VỚI HỘI ĐỒNG TỐT NGHIỆP

| Tiêu Chí Đánh Giá | Sàn B2B Truyền Thống (CRUD) | Hệ Thống B2B Tích Hợp 4 AI Module |
| :--- | :--- | :--- |
| **Trải Nghiệm Đặt Hàng** | Đại lý tự tìm từng dịch vụ lẻ và ghép thủ công (2-3 tiếng). | **AI Combo Co-Pilot tự ghép 3N2Đ & xuất Proposal PDF branded trong 5 giây.** |
| **Tối Ưu Giá Cung Cấp** | Giá sỉ cố định, dễ thất thoát doanh thu hoặc trống phòng. | **AI Demand Forecasting gợi ý tăng/giảm giá sỉ linh hoạt (Yield Management).** |
| **Báo Cáo Quản Trị** | Xem bảng biểu tĩnh, phải xuất file Excel lọc thủ công. | **Text-to-SQL Chat trực tiếp với DB, trả về biểu đồ trực quan tức thì.** |
| **Hỗ Trợ Bán Hàng** | Đại lý tự làm truyền thông bán lại cho khách lẻ. | **AI Content Auto-Pilot tự tạo Banner + Bài viết Marketing chuẩn thương hiệu.** |
| **Đánh Giá Hội Đồng** | Điểm trung bình (Đạt chuẩn đồ án phần mềm). | **Điểm Xuất Sắc / Top 1% (Đạt tiêu chuẩn sản phẩm Doanh nghiệp thực tế).** |
