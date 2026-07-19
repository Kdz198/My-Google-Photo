# TÀI LIỆU YÊU CẦU SẢN PHẨM (PRD)
**Tên dự án:** Personal Photo Homelab (Giải pháp thay thế Google Photos tự lưu trữ)
**Nền tảng mục tiêu:** Mobile (Android dùng Flutter) & Web Desktop.
**Kiến trúc hệ thống:** 
- **Frontend:** Flutter (Mobile/Web).
- **Backend:** Java Spring Boot.
- **Database:** PostgreSQL.
- **Lưu trữ (Storage):** File System cục bộ trên Homelab.
**Người dùng chính:** Cá nhân (Sử dụng cá nhân, không cần phân quyền hay xác thực phức tạp cho bản MVP).

---

## 1. GIAI ĐOẠN 1 - TÍNH NĂNG CỐT LÕI (MVP)
*Mục tiêu: Tạo ra một hệ thống ổn định, đầy đủ chức năng để thay thế thư viện ảnh mặc định trên điện thoại và làm nơi sao lưu an toàn.*

### 1.1. Tải lên (Upload) & Đồng bộ
- **Tải lên thủ công:** Chọn một hoặc nhiều ảnh/video từ thư viện máy và tải lên server.
- **Xử lý Multipart:** Backend nhận và lưu file gốc vào thư mục vật lý theo cấu trúc (VD: `YYYY/MM/DD/`).
- **Xử lý ảnh thu nhỏ (Thumbnails):** 
  - *Bắt buộc chạy bất đồng bộ.* Backend tự động tạo ảnh thu nhỏ (định dạng WebP, dung lượng nhẹ) ngay sau khi tải lên để tránh tràn RAM khi cuộn timeline trên app.

### 1.2. Trích xuất siêu dữ liệu (EXIF Processing)
- Trích xuất dữ liệu trực tiếp từ file gốc ngay khi upload:
  - `Ngày/Giờ chụp` (Cực kỳ quan trọng để sắp xếp Timeline).
  - `Tọa độ GPS` (Vĩ độ, Kinh độ).
  - `Thông tin thiết bị` (Dòng máy ảnh, điện thoại).
  - `Độ phân giải & Dung lượng`.
- **Dự phòng:** Sử dụng ngày tạo file (Creation Date) nếu ảnh không có dữ liệu EXIF.

### 1.3. Giao diện Timeline (Phía Client)
- Lưới ảnh cuộn vô hạn, tự động gom nhóm theo Ngày/Tháng/Năm.
- **Tải chậm (Lazy Loading):** App chỉ tải thumbnail của những ảnh đang hiển thị trên màn hình.
- **Xem chi tiết:** Chạm vào thumbnail để tải và xem ảnh/video gốc ở độ phân giải cao.
- Hỗ trợ phát mượt mà cả Ảnh và Video.

### 1.4. Quản lý thủ công (Albums)
- Khả năng tạo các Album tùy chỉnh (VD: "Giấy tờ tùy thân", "Du lịch Đà Lạt 2026").
- Thêm ảnh/video vào Album (Quan hệ Nhiều-Nhiều - một ảnh có thể ở nhiều Album).
- Xóa ảnh khỏi Album mà không làm mất file gốc trong kho lưu trữ.

### 1.5. Giải phóng dung lượng (Free Up Space)
- **Mục tiêu:** Sao lưu ảnh lên server, sau đó xóa ảnh gốc trên điện thoại để tiết kiệm bộ nhớ.
- **Quy trình an toàn nghiêm ngặt:**
  1. Client tải file lên.
  2. Server xác minh file toàn vẹn và lưu thành công vào ổ cứng/DB.
  3. Server trả về trạng thái `200 OK`.
  4. Client nhận được xác nhận, SAU ĐÓ mới được phép gọi API của hệ điều hành để xóa file trên máy.

### 1.6. Tác vụ định kỳ (Cronjobs)
- **Dọn rác:** Tự động xóa các file mồ côi, file upload bị lỗi giữa chừng hoặc file tạm.
- **Quét thư mục cục bộ:** Định kỳ quét ổ cứng server để tự động thêm vào Database những file được copy thẳng qua mạng LAN/FTP (không upload qua app).

---

## 2. GIAI ĐOẠN 2 - TÍNH NĂNG NÂNG CAO ("Thư viện thông minh")
*Mục tiêu: Nâng cấp app từ một nơi lưu trữ đơn thuần thành một thư viện thông minh, có khả năng tìm kiếm mạnh mẽ như Google Photos.*

### 2.1. Tìm kiếm thông minh (AI Tự động gắn tag)
- **Xử lý AI cục bộ:** Tích hợp một model Machine Learning nhỏ (VD: thông qua microservice Python) để quét nội dung ảnh.
- **Tự động phân loại:** Nhận diện vật thể/ngữ cảnh (VD: `chó`, `biển`, `đồ ăn`, `tài liệu`) và lưu tag vào Database.
- **Tìm kiếm tự nhiên:** Người dùng có thể gõ "chó trên bãi biển" để lọc ra các bức ảnh tương ứng.

### 2.2. Bản đồ ảnh (Reverse Geocoding)
- Chuyển đổi tọa độ GPS thô từ EXIF thành địa danh dễ hiểu (VD: "Quận 1, TP.HCM") sử dụng API miễn phí (như OpenStreetMap).
- **Giao diện Bản đồ:** Hiển thị một tab bản đồ trong app, với các cụm ghim (pins) chỉ ra vị trí những nơi bạn đã chụp ảnh.

### 2.3. Hệ thống lọc ảnh trùng lặp (Deduplication)
- Tính toán mã băm (pHash hoặc MD5) cho mỗi bức ảnh tải lên.
- Nhận diện các bức ảnh giống hệt nhau hoặc gần giống hệt nhau (do bấm chụp liên tục).
- Cung cấp giao diện "Dọn ảnh trùng", gợi ý người dùng giữ lại tấm nét nhất và xóa các tấm thừa để tiết kiệm ổ cứng homelab.

### 2.4. Trình xử lý Video (Video Transcoding)
- Tự động dùng `FFmpeg` chạy ngầm để nén các video 4K/nặng thành định dạng chuẩn web (1080p H.264/H.265).
- Stream bản đã nén để xem mượt mà trên điện thoại/web, nhưng vẫn giữ nguyên file video gốc chất lượng cao để sao lưu.