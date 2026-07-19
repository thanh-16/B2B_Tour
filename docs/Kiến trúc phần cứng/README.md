# 🖥️ Thiết Kế Kiến Trúc Phần Cứng Dự Án — B2B Travel Platform

> Tài liệu này mô tả toàn bộ mô hình triển khai hạ tầng phần cứng (Hardware Deployment Architecture) phục vụ cho việc vận hành sàn du lịch B2B Travel Platform, bao gồm: sơ đồ triển khai vật lý, cấu hình phần cứng chi tiết, phương án phòng tránh lỗi hệ thống và đề xuất mô hình triển khai thực tế.

---

## 🗺️ 1. Sơ Đồ Triển Khai Vật Lý (Deployment Diagram)

Sơ đồ bên dưới mô tả đầy đủ luồng đi của request từ người dùng cuối (Mobile App / Web Portal) qua các tầng bảo vệ, xử lý nghiệp vụ, lưu trữ dữ liệu cho đến kết nối với hệ thống đối tác bên ngoài:

```mermaid
graph TD
    %% ────────────────────────────────────────────────────
    %% TẦNG CLIENT (Người dùng cuối)
    %% ────────────────────────────────────────────────────
    subgraph ClientLayer["📱 Client Layer"]
        MobileApp["📱 React Native Mobile App"]
        WebAdmin["🖥️ Web Admin Portal"]
    end

    %% ────────────────────────────────────────────────────
    %% TẦNG BẢO VỆ (Security Gateway)
    %% ────────────────────────────────────────────────────
    MobileApp -->|HTTPS & WebSocket| WAF["🛡️ API Gateway / WAF"]
    WebAdmin -->|HTTPS| WAF
    WAF -->|Chặn DDoS - WebSocket Proxy| LB["⚖️ Load Balancer (Nginx)"]

    %% ────────────────────────────────────────────────────
    %% TẦNG ỨNG DỤNG (Application Layer)
    %% ────────────────────────────────────────────────────
    subgraph AppServers["🖥️ Application Layer"]
        API1["Web API Server 1 - ASP.NET Core"]
        API2["Web API Server 2 - ASP.NET Core"]
    end
    LB -->|HTTPS & WS Round Robin| API1
    LB -->|HTTPS & WS Round Robin| API2

    %% ────────────────────────────────────────────────────
    %% TẦNG DỊCH VỤ BỔ TRỢ (Cache, Queue, Notification)
    %% ────────────────────────────────────────────────────
    subgraph SupportServices["⚡ Support Services Layer"]
        REDIS["⚡ Redis - Cache, Lock & SignalR Backplane"]
        HANGFIRE["⏰ Hangfire - Background Jobs"]
        FCM["🔔 Firebase Cloud Messaging"]
    end
    API1 <-->|Session, Lock & WS Pub/Sub| REDIS
    API2 <-->|Session, Lock & WS Pub/Sub| REDIS
    API1 -->|Enqueue Jobs| HANGFIRE
    API2 -->|Enqueue Jobs| HANGFIRE
    API1 -->|Push Notification| FCM
    API2 -->|Push Notification| FCM
    FCM -->|Notification| MobileApp

    %% ────────────────────────────────────────────────────
    %% TẦNG CƠ SỞ DỮ LIỆU (Database Layer)
    %% ────────────────────────────────────────────────────
    subgraph DatabaseLayer["💾 Database Layer"]
        DB_Master["💾 PostgreSQL Master - Read/Write"]
        DB_Replica["💾 PostgreSQL Replica - Read Only"]
    end
    API1 -->|Write| DB_Master
    API2 -->|Write| DB_Master
    API1 -->|Read| DB_Replica
    API2 -->|Read| DB_Replica
    DB_Master -->|Streaming Replication| DB_Replica
    HANGFIRE -->|Job Store| DB_Master

    %% ────────────────────────────────────────────────────
    %% TẦNG LƯU TRỮ FILE (Object Storage)
    %% ────────────────────────────────────────────────────
    STORAGE["📁 Object Storage - S3 / GCS"]
    API1 -->|Upload File - KYC, Voucher, Quotation| STORAGE
    API2 -->|Upload File - KYC, Voucher, Quotation| STORAGE

    %% ────────────────────────────────────────────────────
    %% HỆ THỐNG BÊN NGOÀI (External Partners & SaaS)
    %% ────────────────────────────────────────────────────
    subgraph ExternalServices["🔌 External Services"]
        VNPAY["💳 VNPay Gateway"]
        CASSO["🏦 Casso / PayOS VietQR Webhook"]
        PARTNER["🚌 Partner APIs"]
        GEMINI["🤖 Google Gemini API (LLM SaaS)"]
    end
    API1 <-->|IPN Callback| VNPAY
    API2 <-->|IPN Callback| VNPAY
    API1 <-->|Bank Webhook| CASSO
    API2 <-->|Bank Webhook| CASSO
    API1 & API2 -->|Function Calling & NLP| GEMINI
    HANGFIRE -->|Auto Sync| PARTNER
```

---

## 🎛️ 2. Cấu Hình Phần Cứng Chi Tiết

Bảng dưới đây liệt kê đầy đủ các thành phần hạ tầng cần thiết để vận hành hệ thống B2B Travel Platform, kèm thông số kỹ thuật đề xuất cho môi trường Production:

| # | Thành Phần Hạ Tầng | Số Lượng | Thông Số Kỹ Thuật | Vai Trò Trong Hệ Thống |
| :---: | :--- | :---: | :--- | :--- |
| 1 | **API Gateway / WAF (Cloudflare)** | 01 | Dịch vụ SaaS (Gói Free/Pro) | Chặn DDoS, SQL Injection, Hỗ trợ WebSocket SSL Proxy cho SignalR Chat. |
| 2 | **Load Balancer (Nginx)** | 01 | 2 vCPU, 1 GB RAM | Reverse Proxy phân phối tải đều API & hỗ trợ WebSocket Connection keep-alive. |
| 3 | **Web API Server** | 02 | 2 vCPU, 8 GB RAM mỗi server | Chạy ứng dụng ASP.NET Core (Stateless). Cài đặt font Microsoft để xuất báo giá PDF. |
| 4 | **Redis Server** | 01 | 2 GB RAM (In-memory) | Cache, Distributed Lock, Idempotent Key và **Redis Backplane** đồng bộ tin nhắn WebSocket Chat. |
| 5 | **Hangfire Worker** | 01 | 2 vCPU, 4 GB RAM | Xử lý tác vụ nền: tự động hủy đơn, xuất hóa đơn VAT, đồng bộ đối tác. |
| 6 | **PostgreSQL Master** | 01 | 2 vCPU, 8 GB RAM, SSD 50 GB | CSDL chính xử lý ghi (đơn hàng, ví, chat message, review). |
| 7 | **PostgreSQL Replica** | 01 | 2 vCPU, 8 GB RAM, SSD 50 GB | Bản sao đồng bộ liên tục phục vụ đọc (Tìm kiếm, hiển thị Review/Rating). |
| 8 | **Object Storage (S3 / GCS)** | 01 | 10 GB khởi điểm, tự mở rộng | Lưu trữ file ảnh KYC, PDF Voucher và file PDF báo giá Quotation. |
| 9 | **Firebase Cloud Messaging** | 01 | Dịch vụ SaaS (Miễn phí) | Gửi Push Notification tức thì đến điện thoại đại lý. |
| 10 | **Google Gemini API** | SaaS | Dịch vụ theo lượng token sử dụng | Cung cấp dịch vụ LLM để trợ lý AI phân tích ngôn ngữ tự nhiên và báo giá combo. |
| 11 | **Monitoring (Grafana + Prometheus)**| 01 | Dịch vụ SaaS | Giám sát tài nguyên phần cứng, cảnh báo Telegram. |

---

## 🛡️ 3. Phương Án Phòng Tránh Lỗi Hệ Thống Kinh Điển

Hệ thống phần cứng được thiết kế để giải quyết triệt để 6 lỗi kỹ thuật nghiêm trọng nhất trong vận hành sàn du lịch B2B:

### Lỗi 1: Tranh chấp giữ chỗ (Race Condition / Overbooking)
*   **Kịch bản lỗi:** 2 đại lý cùng đặt chỗ 1 chiếc vé xe cuối cùng tại cùng 1 mili-giây. Nếu Database xử lý chậm, cả 2 đơn đều được chấp nhận nhưng nhà xe chỉ còn 1 chỗ thực tế.
*   **Giải pháp bằng hạ tầng:**
    *   Tích hợp **Redis Server làm Lock Manager (Quản lý khóa phân tán tập trung)**.
    *   Khi có request đặt giữ chỗ, Web API bắt buộc phải xin cấp khóa duy nhất (ví dụ: `lock:slot:chuyen_xe_102`) lên Redis trước khi kiểm tra kho tồn. Do Redis xử lý lệnh đơn luồng (Single-thread) trên bộ nhớ RAM siêu tốc (< 1ms), nó đảm bảo chỉ cấp khóa cho duy nhất 1 request, request thứ hai sẽ bị từ chối cấp khóa ngay lập tức.
    *   Kết hợp thêm **Optimistic Concurrency Control (OCC)** tại tầng Database bằng cột `version` trên bảng tồn kho, đảm bảo an toàn 2 lớp.

### Lỗi 2: Trùng lặp giao dịch tài chính (Double-Spending / Webhook Retry)
*   **Kịch bản lỗi:** VNPay gọi IPN Webhook báo nạp tiền thành công. Do mạng chập chờn, VNPay tự động gọi lại 2-3 lần liên tiếp, dẫn đến đại lý được cộng tiền gấp đôi/gấp ba.
*   **Giải pháp bằng hạ tầng:**
    *   Sử dụng cơ chế **Idempotent Webhook Receiver** kết hợp **Redis Cache**.
    *   Mỗi giao dịch nạp tiền có một mã Transaction ID duy nhất. Khi Web API nhận IPN từ VNPay, nó lập tức kiểm tra mã này trong Redis Cache. Nếu chưa tồn tại thì xử lý và lưu mã vào Redis với TTL = 5 phút. Nếu VNPay gửi lại request trùng ID, hệ thống sẽ bỏ qua và trả về kết quả thành công mà không cộng tiền lần 2.

### Lỗi 3: Sập hệ thống khi API Đối Tác bị chậm/chết (Cascading Failure)
*   **Kịch bản lỗi:** Web API gọi API Phương Trang để xuất vé nhưng đối tác đang bảo trì. Nhiều luồng xử lý cùng đứng chờ 30 giây (Timeout) làm cạn kiệt Connection Pool, khiến toàn bộ sàn B2B bị nghẽn sập.
*   **Giải pháp bằng hạ tầng:**
    *   Tách biệt hoàn toàn tác vụ gọi API đối tác sang **Hangfire Background Server** chạy trên tiến trình riêng biệt.
    *   Khi thanh toán thành công, Web API chỉ cập nhật trạng thái đơn là `PAID` và đẩy một Background Job vào hàng đợi. Web API phản hồi đại lý ngay trong dưới 1 giây.
    *   Hangfire Worker tự lấy Job ra và gọi API đối tác. Nếu đối tác sập, Hangfire tự động thử lại (**Retry Policy với Exponential Backoff**: thử sau 1 phút → 5 phút → 15 phút → 1 giờ) mà không ảnh hưởng đến bất kỳ luồng xử lý chính nào.

### Lỗi 4: Tấn công từ bên ngoài (DDoS, Brute-force, Injection)
*   **Kịch bản lỗi:** Kẻ tấn công gửi hàng triệu request giả mạo vào API đăng nhập, hoặc chèn mã SQL độc hại vào ô tìm kiếm để đánh cắp dữ liệu tài chính của đại lý.
*   **Giải pháp bằng hạ tầng:**
    *   Đặt lớp **Cloudflare WAF (Web Application Firewall)** ở tuyến đầu tiên trước cả Load Balancer. Cloudflare tự động phát hiện và chặn:
        *   **DDoS attack**: Giới hạn số request/giây từ mỗi IP (Rate Limiting).
        *   **SQL Injection & XSS**: Phân tích pattern request và chặn các payload độc hại trước khi chúng chạm đến Web API Server.
        *   **Brute-force login**: Hiển thị CAPTCHA sau 5 lần đăng nhập sai liên tiếp.
    *   Toàn bộ traffic từ Client đến Load Balancer được mã hóa **TLS 1.3** (HTTPS) do Cloudflare cấp chứng chỉ SSL miễn phí.

### Lỗi 5: Spam khóa kho ảo qua Trợ lý AI (Hold Booking DOS Attack)
*   **Kịch bản lỗi:** Kẻ xấu lạm dụng chatbot AI liên tục yêu cầu báo giá combo, nếu AI tự động giữ chỗ (Hold Booking) thì hàng loạt phòng và vé sỉ bị lock ảo trong 15 phút, gây cạn kiệt kho hàng thực tế của Supplier.
*   **Giải pháp bằng hạ tầng & thiết kế:**
    *   **UI Verification (Xác nhận thủ công):** Chatbot AI (Gemini API) chỉ phân tích NLP và trả về cấu trúc dữ liệu đề xuất combo trên giao diện Chat. Hệ thống **tuyệt đối không cho phép AI tự động gọi API Hold**.
    *   Nút bấm đặt chỗ chỉ mang giá trị chuyển hướng (Redirect Link) về màn hình tạo Booking, buộc nhân viên đại lý (Manager/Staff) phải tự tay click xác nhận.
    *   Kết hợp **Rate Limiting** trên API Chat AI tối đa 10 request/phút/user bằng Redis để chặn script gọi spam.

### Lỗi 6: Mất kết nối WebSocket/Chat trên môi trường Multi-Server (SignalR Connection Loss)
*   **Kịch bản lỗi:** Hệ thống có 2 server API. Đại lý kết nối vào Server 1 qua WebSocket, Supplier kết nối vào Server 2. Khi đại lý gửi tin nhắn chat, Server 1 không thể gửi trực tiếp cho Supplier do kết nối WebSocket của Supplier đang nằm ở tiến trình của Server 2.
*   **Giải pháp bằng hạ tầng:**
    *   Cấu hình **Redis Server làm Backplane (Message Broker)** cho SignalR.
    *   Khi Server 1 nhận tin nhắn từ đại lý, nó gửi tin nhắn lên kênh Pub/Sub của Redis. Server 2 subcribe kênh này sẽ nhận được và chuyển tiếp tin nhắn xuống WebSocket của Supplier tương ứng. Đảm bảo chat hoạt động thông suốt không phụ thuộc client kết nối vào server nào.
    *   Cấu hình Nginx Load Balancer hỗ trợ **Sticky Sessions (hoặc ip_hash)** và các chỉ thị WebSocket (Upgrade, Connection) để duy trì kết nối Socket ổn định.

---

## ☁️ 4. Đề Xuất Mô Hình Triển Khai Thực Tế

Dự án đề xuất sử dụng mô hình **Docker Compose** triển khai trên VPS Cloud để đảm bảo tính đơn giản, dễ demo và tiết kiệm chi phí cho đồ án tốt nghiệp:

### Phương án A: Docker Compose trên VPS Cloud (Đề xuất cho đồ án)

Đóng gói toàn bộ hệ thống thành các Docker Container được quản lý bởi 1 file `docker-compose.yml` duy nhất:

```text
┌─────────────────────────────────────────────────────────┐
│                VPS Cloud (8 vCPU, 16 GB RAM)            │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Nginx   │  │  API #1  │  │  API #2  │              │
│  │  (LB)    │→ │  (.NET)  │  │  (.NET)  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐  │
│  │  Redis   │  │ Hangfire │  │  PostgreSQL (Master)  │  │
│  │  (Cache) │  │ (Worker) │  │  + Replica (Read)     │  │
│  └──────────┘  └──────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────┘
         ↑                              ↑
    Cloudflare                   Cloud Storage
    (WAF + SSL)                  (S3 / GCS)
```

*   **Ưu điểm:** Chỉ cần 1 lệnh `docker-compose up -d` để khởi động toàn bộ hệ thống. Dễ demo trước hội đồng. Chi phí thấp (khoảng 500.000 - 1.000.000 VNĐ/tháng cho 1 VPS).
*   **Dịch vụ bên ngoài (SaaS miễn phí):** Cloudflare Free (WAF + SSL), Firebase Cloud Messaging Free (Push Notification), Cloudinary hoặc S3 Free Tier (Object Storage).

### Phương án B: Google Cloud Run (Serverless — nâng cao, dành cho Production thực tế)

Nếu hệ thống phát triển lên quy mô sản xuất với hàng trăm đại lý sử dụng đồng thời, có thể nâng cấp lên:
*   **Google Cloud Run:** Triển khai Docker Image của ASP.NET Core, tự động co giãn từ 0 đến N container theo lượng tải (Auto-scaling). Chỉ tính tiền khi có request thực tế.
*   **Google Cloud SQL:** PostgreSQL được quản trị hoàn toàn (Auto-backup hàng ngày, Auto-failover khi Master sập chỉ trong 30 giây).
*   **Google Memorystore:** Redis được quản trị, đảm bảo tính sẵn sàng cao 99.9%.

---

## 📊 5. Tổng Kết Công Nghệ Hạ Tầng

| Tầng Hệ Thống | Công Nghệ Sử Dụng | Mục Đích |
| :--- | :--- | :--- |
| **Client (Frontend)** | React Native (Mobile App), React/Next.js (Web Admin) | Giao diện đặt chỗ (App) và quản trị sàn (Web), tích hợp WebSocket SignalR Chat. |
| **Security Gateway** | Cloudflare WAF + SSL/TLS 1.3 | Chặn DDoS, SQL Injection, cấu hình WebSocket SSL Proxy. |
| **Load Balancer** | Nginx (Reverse Proxy) | Phân phối tải, cấu hình Upgrade/Connection headers để proxy WebSocket. |
| **Application** | ASP.NET Core 8 (Stateless, Docker Container) | Xử lý logic nghiệp vụ: Booking, Wallet, KYC, Claims. Font MS hỗ trợ PDF. |
| **Cache & Lock** | Redis 7 (In-memory) | Cache dữ liệu, Distributed Lock, Idempotent Key, SignalR Backplane. |
| **Background Jobs** | Hangfire (Worker Service) | Tự động hủy đơn, xuất hóa đơn VAT điện tử, sync vé. |
| **Push Notification** | Firebase Cloud Messaging (FCM) | Gửi thông báo đẩy tức thì về điện thoại đại lý. |
| **Database** | PostgreSQL 16 (Master-Replica Replication) | Lưu trữ chính: tách biệt đọc/ghi để tối ưu hiệu năng. |
| **File Storage** | AWS S3 / Google Cloud Storage | Lưu ảnh KYC, file PDF Voucher và file PDF báo giá Quotation. |
| **AI LLM Engine** | Google Gemini API (SaaS) | Phân tích ngôn ngữ tự nhiên, gợi ý combo báo giá (NLP). |
| **Monitoring** | Grafana + Prometheus | Giám sát CPU/RAM/Disk 24/7, cảnh báo qua Telegram. |
| **Container Runtime** | Docker + Docker Compose | Đóng gói và triển khai toàn bộ hệ thống bằng 1 lệnh. |
