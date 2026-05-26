# BÁO CÁO CHI TIẾT HOẠT ĐỘNG HỆ THỐNG WEBSITE QUAMONHAI

Hệ thống **QuaMonHaiShop** được xây dựng trên nền tảng **ASP.NET Core MVC (8.0)**, sử dụng hệ quản trị cơ sở dữ liệu **Microsoft SQL Server** thông qua **Entity Framework Core** (EF Core). Hệ thống tích hợp các cơ chế bảo mật nâng cao (phân quyền claims, OTP qua email, mã hóa MD5 có muối) và tối ưu hóa trải nghiệm người dùng bằng kỹ thuật **AJAX**, xử lý đồ họa động qua thư viện **SkiaSharp** (nén hình ảnh WebP và sinh Avatar tự động).

Dưới đây là tài liệu chi tiết giải thích toàn bộ kiến trúc, cơ chế hoạt động, các **Controller**, **View**, **ViewComponent**, **Helper** và luồng nghiệp vụ trong dự án.

---

## MỤC LỤC
1. [Kiến Trúc & Các Luồng Nghiệp Vụ Chính](#1-kiến-trúc--các-luồng-nghiệp-vụ-chính)
2. [Chi Tiết Các Controller (Bộ Điều Khiển)](#2-chi-tiết-các-controller-bộ-điều-khiển)
   - [HomeController](#homecontroller)
   - [HangHoasController](#hanghoascontroller)
   - [CartController](#cartcontroller)
   - [CustomerController](#customercontroller)
   - [AdminController](#admincontroller)
   - [AvatarController](#avatarcontroller)
   - [ChatController](#chatcontroller)
   - [SocialController](#socialcontroller)
3. [Chi Tiết Các View (Giao Diện)](#3-chi-tiết-các-view-giao-diện)
   - [Thư mục Views/Home](#thư-mục-viewshome)
   - [Thư mục Views/HangHoas](#thư-mục-viewshanghoas)
   - [Thư mục Views/Cart](#thư-mục-viewscart)
   - [Thư mục Views/Customer](#thư-mục-viewscustomer)
   - [Thư mục Views/Admin](#thư-mục-viewsadmin)
   - [Thư mục Views/Social](#thư-mục-viewssocial)
   - [Thư mục Views/Shared (Giao diện dùng chung & Partial)](#thư-mục-viewsshared-giao-diện-dùng-chung--partial)
4. [Các Helpers & View Components (Thành Phần Trợ Giúp)](#4-các-helpers--view-components-thành-phần-trợ-giúp)
   - [ProductQueryHelper](#productqueryhelper)
   - [MyUtil](#myutil)
   - [CartViewComponent](#cartviewcomponent)
   - [DataEncryptionExtensions & SessionExtensions](#dataencryptionextensions--sessionextensions)
5. [Cấu Hình Hệ Thống (Program.cs)](#5-cấu-hình-hệ-thống-programcs)

---

## 1. KIẾN TRÚC & CÁC LUỒNG NGHIỆP VỤ CHÍNH

### 1.1 Sơ đồ Luồng Dữ Liệu MVC (Client-Server Flow)
Hệ thống sử dụng mô hình MVC chuẩn:
1. **Client (Trình duyệt)** gửi yêu cầu thông qua HTTP Request (hoặc các yêu cầu AJAX bất đồng bộ).
2. **Routing (Bộ định tuyến)** ánh xạ URL tới Action tương ứng của Controller.
3. **Controller** tiếp nhận yêu cầu, tương tác với Database thông qua **DbContext** để lấy/ghi dữ liệu, sử dụng thêm các ViewModel để ràng buộc dữ liệu đầu vào.
4. Dữ liệu xử lý được gán vào **View** dưới dạng các Model có định kiểu mạnh (Strongly-typed Model) hoặc truyền dữ liệu động qua `ViewBag`, `ViewData` hoặc `TempData`.
5. **View (Razor engine)** biên dịch mã HTML-Razor, nhúng kèm các script AJAX để trả về giao diện hoàn thiện cho Client.

### 1.2 Luồng Nghiệp Vụ Mua Hàng & Giỏ Hàng (Cart & Checkout Flow)
- **Khi chưa đăng nhập**: Giỏ hàng được lưu trữ trong **Session** thông qua JSON Serialization (`HttpContext.Session.Set`).
- **Khi đăng nhập thành công**: Hệ thống gọi hàm `MergeSessionCartToDatabase` để gộp toàn bộ sản phẩm từ giỏ hàng Session vào bảng `GioHang` dưới database của tài khoản khách hàng, sau đó dọn dẹp Session.
- **Tại trang Giỏ hàng**: AJAX được áp dụng để tăng/giảm số lượng sản phẩm, kiểm tra tồn kho tức thời (Stock Constraints) và tính lại tổng tiền mà không tải lại trang.
- **Đặt hàng (Checkout)**: Khách hàng điền thông tin và áp dụng **Voucher** giảm giá (nếu đạt giá trị đơn tối thiểu). Hệ thống kiểm tra số lượng tồn kho của từng sản phẩm trong giao dịch gốc. Nếu hợp lệ, hệ thống tạo bản ghi `HoaDon` cùng danh sách `ChiTietHd`, trừ số lượng sản phẩm trong kho, giảm số lần sử dụng của Voucher và xóa giỏ hàng trong database.

### 1.3 Luồng Xác Thực OTP & Đăng Ký Tài Khoản
- **Đăng ký**: Nhập thông tin -> Click "Gửi mã" -> Hệ thống gửi OTP 6 số qua Gmail (sử dụng thư viện MailKit) và lưu OTP vào Session -> Người dùng nhập OTP -> Nếu khớp, hệ thống băm mật khẩu và lưu tài khoản vào CSDL.
- **Quên mật khẩu**: Nhập tài khoản & email khớp -> Gửi OTP -> Xác thực OTP -> Chuyển đến trang ResetPassword để sinh RandomKey mới và băm mật khẩu mới cập nhật vào database.

---

## 2. CHI TIẾT CÁC CONTROLLER (BỘ ĐIỀU KHIỂN)

### HomeController
Bộ điều khiển chính điều phối các trang tĩnh và trang thông tin chung.
- **`Index`**: Trang chủ hiển thị danh sách sản phẩm. Sử dụng `ProductQueryHelper` để thực hiện tìm kiếm lọc và phân trang các sản phẩm đang có hiệu lực bán.
- **`AboutUs`** & **`Blog`**: Hiển thị trang giới thiệu cửa hàng và các bài viết tin tức công nghệ. Sử dụng `ViewData` để tùy biến thanh điều hướng Breadcrumb.
- **`AccessDenied`**: Trả về giao diện khi người dùng không đủ quyền truy cập (ví dụ: khách thường cố vào trang quản trị).
- **`Error`**: Xử lý ngoại lệ toàn hệ thống và hiển thị mã lỗi Request ID.

### HangHoasController
Bộ điều khiển quản lý toàn bộ vòng đời của Sản phẩm (Hàng hóa), tích hợp phân quyền rõ ràng giữa khách hàng thông thường và Admin/Nhân viên.
- **`Index`**: Mở cho mọi đối tượng. Nếu người dùng là Admin/Staff và kích hoạt tham số `manage=true`, hệ thống sẽ bật **ManageMode** để hiển thị cả các mặt hàng đã hết hàng hoặc đã ngưng bán (`HieuLuc = false`).
- **`Details`**: Xem chi tiết sản phẩm.
  - Lấy các đánh giá (bình luận) từ khách hàng, tính điểm sao trung bình (`AvgStars`) và tổng số lượng đã bán của sản phẩm này.
  - Gợi ý 4 sản phẩm liên quan (cùng danh mục loại sản phẩm).
  - Tải danh sách 3 Voucher ngẫu nhiên đang còn hiệu lực để khách hàng thu thập.
  - Tính toán số lượt đánh giá tối đa (`MaxReviews`) dựa trên số lượng sản phẩm này mà khách hàng đã thực sự mua và giao dịch thành công (nhằm tránh tình trạng spam đánh giá ảo).
- **`SendReview`** *(POST - AJAX)*: Đăng bình luận/đánh giá sản phẩm.
  - Kiểm tra đăng nhập.
  - Xác thực số lượt mua sản phẩm của khách hàng thông qua bảng chi tiết hóa đơn.
  - Đảm bảo số lượng review đã viết (`writtenReviews`) chưa vượt quá số lượng đã mua (`maxReviews`).
  - Thêm mới `BinhLuan` và trả về JSON chứa thông tin review cùng liên kết ảnh đại diện để hiển thị tức thời lên màn hình.
- **`Create`** & **`Edit`** *(Chỉ Admin, Staff)*: Thêm mới hoặc chỉnh sửa sản phẩm. Upload hình ảnh thông qua hàm `LuuFileHinh`.
- **`Delete`** *(Chỉ Admin)*: Thực hiện **Xóa mềm** (Soft Delete) sản phẩm bằng cách đổi cờ `HieuLuc = false` và đưa `SoLuong = 0`, đảm bảo toàn vẹn dữ liệu cho các đơn hàng cũ trong quá khứ.
- **`Reactivate`** *(Chỉ Admin, Staff)*: Kích hoạt lại sản phẩm đã bị ngưng hoạt động, đặt lại tồn kho mặc định.

### CartController
Bộ điều khiển quản lý giỏ hàng, lịch sử mua hàng và toàn bộ quy trình thanh toán.
- **`Index`**: Hiển thị danh sách sản phẩm trong giỏ. Đối với tài khoản đã đăng nhập, hệ thống sẽ tự động gộp giỏ hàng Session vào DB.
- **`AddToCartAjax`** *(POST - AJAX)*: Thêm sản phẩm vào giỏ.
  - Thực hiện kiểm tra tồn kho khắt khe (`SoLuong` trong CSDL).
  - Ngăn chặn thêm vào giỏ nếu số lượng yêu cầu cộng với số lượng đã có sẵn trong giỏ vượt quá số lượng tồn kho thực tế.
- **`DeleteAjax`** & **`ClearCartAjax`** *(POST - AJAX)*: Xóa từng sản phẩm hoặc làm sạch toàn bộ giỏ hàng (áp dụng cho cả Session và DB tùy thuộc trạng thái đăng nhập).
- **`UpdateQuantityAjax`** *(GET - AJAX)*: Tăng/giảm số lượng trực tiếp trong giỏ hàng. Kiểm tra tồn kho trước khi thực hiện thay đổi và trả về JSON chứa giá trị mới để cập nhật giao diện.
- **`Check_Out`**: Trang thanh toán.
  - Nhận danh sách `selectedIds` để hỗ trợ tính năng **thanh toán các sản phẩm được chọn**.
  - Tự động điền thông tin cá nhân khách hàng (Họ tên, SĐT, Địa chỉ).
  - Lấy danh sách Voucher thỏa mãn điều kiện áp dụng cho tổng tiền đơn hàng.
- **`PlaceOrder`** *(POST)*: Thực hiện chốt đơn hàng.
  - Kiểm tra biểu mẫu thông tin người nhận.
  - Truy vấn database lấy lại thông tin giỏ hàng của các sản phẩm được chọn để đối chiếu (tránh giả mạo giá/số lượng từ client).
  - Kiểm tra tồn kho lần cuối ngay trước khi chốt đơn.
  - Khởi tạo thực thể `HoaDon` cùng danh sách `ChiTietHd`. Áp dụng giảm giá của Voucher trực tiếp lên đơn giá dòng hàng (Line Item).
  - Cập nhật giảm số lượng tồn kho sản phẩm trong CSDL.
  - Giảm lượt sử dụng Voucher. Lưu thay đổi và điều hướng tới trang thành công.
- **`OrderSuccess`**: Hiển thị tóm tắt thông tin đơn hàng vừa mua.
- **`OrderHistory`**: Hiển thị lịch sử mua hàng của khách. Cho phép tìm kiếm đơn hàng theo ID, tên người nhận hoặc lọc theo trạng thái đơn hàng.

### CustomerController
Chịu trách nhiệm quản lý tài khoản thành viên, đăng ký, đăng nhập hệ thống và đồng bộ đăng nhập Google OAuth2.
- **`Register`** *(GET/POST)*: Đăng ký thành viên. So sánh mã xác thực OTP lưu trong Session được gửi qua email. Mật khẩu được mã hóa MD5 kết hợp với một chuỗi `RandomKey` riêng biệt cho từng tài khoản.
- **`SendVerificationCode`** *(POST - AJAX)*: Tạo mã OTP gồm 6 số, lưu vào Session, biên soạn email dạng HTML và gửi cho khách hàng bằng SMTP Gmail bảo mật TLS qua thư viện MailKit.
- **`Login`** *(GET/POST)*: Kiểm tra thông tin đăng nhập, xác thực reCAPTCHA robot (hiện tạm ẩn để test tự động), thiết lập các Claims cho phiên đăng nhập bao gồm: Email, HoTen, CustomerID và VaiTro động (Admin, Staff, Customer).
- **`Profile`** *(GET/POST)*: Hiển thị và cập nhật thông tin cá nhân.
  - Tích hợp hàm `MyUtil.UploadAvatar` để xử lý tối ưu hóa ảnh đại diện của khách hàng (crop vuông, giảm kích thước và nén dạng WebP).
  - Cập nhật lại Claims Cookie ngay lập tức để đồng bộ ảnh đại diện trên thanh Navbar/Sidebar mà không cần đăng nhập lại.
- **`ChangePassword`**: Cho phép đổi mật khẩu sau khi so khớp mật khẩu cũ hợp lệ.
- **`ForgotPassword`** & **`ResetPassword`**: Quy trình cấp lại mật khẩu thông qua OTP Email.
- **`ToggleFavorite`** *(POST - AJAX)*: Thêm hoặc loại bỏ sản phẩm khỏi danh sách yêu thích (`YeuThich`).
- **`Wishlist`**: Hiển thị danh sách sản phẩm yêu thích của người dùng kèm số lượng đã bán của từng mặt hàng đó.
- **`GoogleLogin`** & **`GoogleResponse`**: Tích hợp đăng nhập bên thứ ba thông qua Google OAuth2.
  - Đọc claims trả về từ Google (Email, Tên, Ảnh đại diện).
  - Nếu email chưa tồn tại trong hệ thống, hệ thống sẽ tự động tạo tài khoản mới với mật khẩu ngẫu nhiên, tên tài khoản lấy từ tiền tố email và kích hoạt ngay lập tức.
  - Thiết lập phiên đăng nhập chính thức bằng Claims của ứng dụng.

### AdminController
Bộ điều khiển trung tâm quản trị toàn bộ hoạt động của hệ thống, chỉ cho phép vai trò `Admin` hoặc `Staff` truy cập thông qua bộ lọc quyền `[Authorize(Roles = "Admin,Staff")]`.
- **`UserManagement`**: Danh sách người dùng, sắp xếp tài khoản quản trị lên đầu.
- **`ToggleHieuLuc`** *(POST - Chỉ Admin)*: Khóa hoặc mở khóa tài khoản người dùng. Hệ thống chặn tuyệt đối việc quản trị viên tự khóa tài khoản của chính mình.
- **`ChangeRole`** *(POST - Chỉ Admin)*: Thay đổi phân quyền tài khoản (Admin, Staff, Customer). Chặn việc tự hạ quyền của chính mình.
- **`DeleteUser`** *(POST - Chỉ Admin)*: Thực hiện xóa mềm tài khoản bằng cách tắt hiệu lực hoạt động.
- **`OrderHistory`** & **`UpdateOrderStatus`**: Quản lý đơn hàng toàn hệ thống, cập nhật trạng thái đơn (Chờ xử lý, Đang giao, Đã giao, Hủy đơn).
- **`ReviewManagement`** & **`DeleteReview`**: Tìm kiếm lọc và xóa các bình luận/đánh giá vi phạm tiêu chuẩn cộng đồng.
- **`ChatDashboard`**: Giao diện tổng đài tư vấn khách hàng dành cho Admin.
- **`GetActiveRooms`** *(GET)*: Lấy danh sách các phòng chat đang hoạt động, sắp xếp theo thời gian tin nhắn mới nhất, tính số lượng tin nhắn chưa đọc của từng phòng để hiển thị dạng badge.
- **`GetRoomMessages`** *(GET)*: Lấy toàn bộ lịch sử tin nhắn của một phòng chat cụ thể, đồng thời đánh dấu toàn bộ tin nhắn chưa đọc từ khách hàng gửi trong phòng đó thành đã đọc (`IsRead = true`).
- **`ReplyMessage`** *(POST)*: Admin gửi tin nhắn trả lời tới khách hàng.
- **`GetTotalUnreadCount`** *(GET)*: Lấy tổng số tin nhắn chưa đọc trên toàn hệ thống để hiển thị thông báo đỏ trên biểu tượng Navbar của Admin.

### AvatarController
Một Web API chuyên biệt (`api/avatar`) dùng để tự động tạo ảnh đại diện PNG động cho người dùng.
- **`GenerateAvatar`**: Tiếp nhận tham số `name` (tên người dùng) và kích thước `size`.
  - Trích xuất ký tự đầu tiên của tên và chuyển thành chữ in hoa.
  - Tính mã băm (Hash Code) của tên để chọn ngẫu nhiên 1 trong 15 mã màu nền được phối sẵn nhằm đảm bảo tính thẩm mỹ cao.
  - Sử dụng thư viện đồ họa **SkiaSharp** tạo một Canvas bitmap, vẽ vòng tròn nền, đo đạc kích thước phông chữ và vẽ ký tự màu trắng nằm căn giữa hoàn hảo.
  - Mã hóa kết quả dưới dạng PNG và trả về dòng dữ liệu (File Stream) trực tiếp cho trình duyệt hiển thị.

### ChatController
Bộ điều khiển xử lý nhắn tin hỗ trợ trực tuyến phía khách hàng.
- **`GetOrCreateChatRoomId`**: Xác định phòng chat.
  - Nếu là thành viên đã đăng nhập, ID phòng chat chính là mã khách hàng (`MaKh`).
  - Nếu là khách vãng lai (Guest), hệ thống sinh một mã duy nhất (`Guest_` + 8 ký tự ngẫu nhiên) và lưu trữ vào Cookie trình duyệt với thời hạn 30 ngày để duy trì cuộc hội thoại khi tải lại trang.
- **`GetMessages`**: Tải tin nhắn của khách hàng hiện tại và tự động đánh dấu tin nhắn phản hồi của Admin thành đã đọc.
- **`SendMessage`**: Lưu tin nhắn mới của khách hàng gửi vào CSDL.
- **`GetUnreadCount`**: Lấy số lượng tin nhắn phản hồi chưa đọc từ Admin để hiển thị thông báo trên nút bong bóng chat.

### SocialController
Điều hướng hiển thị các trang tích hợp/giả lập mạng xã hội (Facebook, Instagram, LinkedIn, X, QuaMonGroup). Lấy ngẫu nhiên từ 3 đến 9 sản phẩm nổi bật để trình diễn tích hợp sản phẩm lên mạng xã hội.

---

## 3. CHI TIẾT CÁC VIEW (GIAO DIỆN)

Hệ thống sử dụng các thư mục View tương ứng với cấu trúc Controller, kết hợp với Razor View Engine để sinh HTML động.

### Thư mục Views/Home
- **`Index.cshtml`**: Trang chủ hiển thị banner lớn, danh mục nổi bật, danh sách sản phẩm phân trang. Nhúng mã AJAX gọi giỏ hàng và yêu thích.
- **`AboutUs.cshtml`**: Trang giới thiệu về cửa hàng QuaMonHai với thiết kế hiện đại, các thông tin cam kết chất lượng sản phẩm.
- **`Blog.cshtml`**: Danh sách bài viết, tin tức công nghệ và mẹo sử dụng thiết bị.
- **`AccessDenied.cshtml`**: Giao diện thông báo lỗi 403 khi cố tình truy cập khu vực cấm.

### Thư mục Views/HangHoas
- **`Index.cshtml`**: Trang danh sách sản phẩm của cửa hàng.
  - Nhúng thanh lọc bên trái (`_Sidebar.cshtml`).
  - Hiển thị danh sách sản phẩm dạng thẻ lưới (Grid). Mỗi thẻ tích hợp nút Yêu thích nhanh và nút Thêm giỏ hàng (nếu là khách thường) hoặc nút Sửa/Xóa/Kích hoạt (nếu là Admin/Staff).
  - Hỗ trợ công tắc "Quản lý" (Manage Mode) để hiển thị/ẩn sản phẩm ngưng bán.
- **`Details.cshtml`**: Trang chi tiết sản phẩm.
  - Trình chiếu ảnh sản phẩm zoom lớn, thông tin giá gốc và giá sau giảm.
  - Hiển thị thông số chi tiết, lượt xem và số lượng đã bán.
  - Phần Đánh giá sản phẩm: Hiển thị các sao đánh giá và nội dung bình luận của khách hàng khác. Nhúng form gửi đánh giá bằng AJAX. Nếu chưa mua hoặc đã đánh giá hết lượt mua, form sẽ ẩn hoặc hiển thị cảnh báo.
  - Hiển thị băng chuyền (Carousel) các sản phẩm liên quan.
- **`Create.cshtml`** & **`Edit.cshtml`**: Biểu mẫu thêm/sửa sản phẩm trực quan cho ban quản trị, có hỗ trợ xem trước ảnh tải lên và kiểm tra tính hợp lệ dữ liệu (Validation).
- **`Delete.cshtml`**: Xác nhận ngưng bán sản phẩm.

### Thư mục Views/Cart
- **`Index.cshtml`**: Hiển thị bảng chi tiết giỏ hàng.
  - Cho phép chọn/bỏ chọn từng sản phẩm để thanh toán thông qua checkbox.
  - Hỗ trợ nút tăng/giảm số lượng kết nối AJAX.
  - Cập nhật tổng tiền đơn hàng động dựa trên các sản phẩm được tick chọn.
- **`Check_Out.cshtml`**: Biểu mẫu nhập thông tin giao hàng và chọn phương thức vận chuyển (tiêu chuẩn / nhanh).
  - Hiển thị danh sách Voucher đủ điều kiện áp dụng. Khách hàng bấm chọn Voucher để giảm trực tiếp tổng tiền hóa đơn ngay trên giao diện.
- **`OrderSuccess.cshtml`**: Hiển thị hóa đơn điện tử đẹp mắt sau khi đặt hàng thành công.
- **`OrderHistory.cshtml`**: Trang lịch sử đơn hàng cá nhân của khách hàng.

### Thư mục Views/Customer
- **`Login.cshtml`**: Trang đăng nhập đẹp mắt sử dụng hiệu ứng chuyển màu (Gradient), tích hợp nút Đăng nhập bằng Google.
- **`Register.cshtml`**: Trang đăng ký thành viên. Tích hợp nút "Gửi mã OTP" kết nối AJAX và đồng hồ đếm ngược thời gian gửi lại mã để tối ưu hóa bảo mật.
- **`Profile.cshtml`**: Trang thông tin cá nhân. Hiển thị thông tin thành viên, tích hợp tải ảnh đại diện trực tiếp và cập nhật tức thì.
- **`ChangePassword.cshtml`**: Form đổi mật khẩu bảo mật.
- **`ForgotPassword.cshtml`** & **`ResetPassword.cshtml`**: Các trang xác thực phục hồi mật khẩu bằng OTP email.
- **`Wishlist.cshtml`**: Hiển thị bộ sưu tập sản phẩm yêu thích của khách hàng.

### Thư mục Views/Admin
- **`UserManagement.cshtml`**: Giao diện bảng quản trị người dùng.
  - Hiển thị thông tin tài khoản, email, số điện thoại, trạng thái hoạt động và quyền hạn.
  - Hỗ trợ nút Khóa/Mở khóa, nút thay đổi phân quyền (chuyển đổi giữa Admin, Nhân viên và Khách hàng) bằng các Form POST an toàn kèm mã xác thực Token.
- **`OrderHistory.cshtml`**: Quản lý danh sách toàn bộ hóa đơn của cửa hàng. Tích hợp chọn lọc trạng thái đơn hàng và nút thay đổi trạng thái đơn hàng nhanh qua Modal/Dropdown.
- **`ReviewManagement.cshtml`**: Quản lý và kiểm duyệt bình luận, đánh giá của khách hàng.
- **`ChatDashboard.cshtml`**: Trung tâm điều hành tư vấn khách hàng.
  - Thiết kế chia làm 2 cột: Cột bên trái hiển thị danh sách phòng chat khách hàng (có hiển thị ảnh đại diện theo tên, nhãn phân biệt Khách/Thành viên, tin nhắn cuối cùng và số lượng tin nhắn chưa đọc).
  - Cột bên phải hiển thị cửa sổ nội dung hội thoại chi tiết với khách hàng đang chọn. Nội dung tự động cuộn xuống dưới cùng khi có tin nhắn mới. Hỗ trợ gửi tin bằng AJAX.

### Thư mục Views/Social
Chứa các view mô phỏng mạng xã hội hiển thị bài đăng sản phẩm của QuaMonHai bao gồm: `Facebook.cshtml`, `Instagram.cshtml`, `LinkedIn.cshtml`, `QuaMonGroup.cshtml` và `X.cshtml`.

### Thư mục Views/Shared (Giao diện dùng chung & Partial)
- **`_Layout.cshtml`**: File bố cục chính (Master Page) chứa các liên kết CSS/JS chung, cấu trúc chuẩn HTML5 và nhúng các Partial Page.
- **`_Navbar.cshtml`**: Thanh menu điều hướng phía trên cùng. Tự động kiểm tra đăng nhập Claims để hiển thị tên và avatar khách hàng, hiển thị menu Admin cho người dùng có quyền quản trị và nhúng ViewComponent giỏ hàng.
- **`_Sidebar.cshtml`**: Thanh bên lọc sản phẩm trong trang cửa hàng. Lấy danh sách danh mục từ Database và hiển thị số lượng sản phẩm tương ứng, tích hợp các bộ lọc khoảng giá và thanh tìm kiếm sản phẩm.
- **`_CustomerSidebar.cshtml`**: Thanh menu bên trái dành riêng cho các trang cài đặt tài khoản của khách hàng (Hồ sơ, Đổi mật khẩu, Lịch sử mua hàng, Sản phẩm yêu thích).
- **`_ChatBubble.cshtml`**: Bong bóng chat hỗ trợ trực tuyến hiển thị ở góc dưới cùng bên phải màn hình.
  - Chỉ hiển thị ở trang chủ hoặc trang chi tiết sản phẩm.
  - Ở trang chi tiết sản phẩm, bong bóng chat tự động mở thêm biểu ngữ tư vấn sản phẩm đang xem, cho phép khách hàng bấm nhanh nút "Hỏi tư vấn" để gửi thông tin sản phẩm trực tiếp vào cuộc chat.
  - Nhúng script tự động kiểm tra số tin nhắn chưa đọc cứ mỗi 10 giây khi đóng chat, và tự động đồng bộ tin nhắn mới cứ mỗi 3 giây khi mở cửa sổ chat.
- **`_NumberBar.cshtml`**: Thanh phân trang sản phẩm thông minh.
- **`_Header.cshtml`** & **`_Footer.cshtml`**: Đầu trang và chân trang của website.
- **`_ValidationScriptsPartial.cshtml`**: Nhúng các thư viện xác thực phía client-side của Microsoft JQuery Validation.

---

## 4. CÁC HELPERS & VIEW COMPONENTS (THÀNH PHẦN TRỢ GIÚP)

### ProductQueryHelper
Một lớp tĩnh Helper đa năng dùng để chia sẻ logic lọc, tìm kiếm và phân trang sản phẩm giữa `HomeController` và `HangHoasController`, giúp loại bỏ mã lặp thừa (DRY Principle):
- Tham số nhận vào: DbContext, ClaimsPrincipal (để lấy danh sách sản phẩm yêu thích), ViewBag, các tiêu chí lọc (`loaiId`, `searchQuery`, `priceRange`, `sortBy`) và trang hiện tại.
- Tự động kiểm tra vai trò người dùng để xác định có kích hoạt chế độ quản lý sản phẩm ngưng bán hay không.
- Phân loại lọc khoảng giá: dưới $50, từ $50 đến $100, trên $100 hoặc lọc giá trị tùy biến tối đa.
- Sắp xếp giá tăng dần / giảm dần.
- Tính toán phân trang khoa học (bỏ qua `(page - 1) * pageSize` bản ghi và lấy tối đa 9 sản phẩm).
- Thống kê lượng sản phẩm đã bán cho từng mặt hàng hiển thị trên trang hiện tại.

### MyUtil
Lớp tiện ích hệ thống chứa các phương thức xử lý ảnh và sinh mã ngẫu nhiên:
- **`UploadAvatar`**: Nhận tệp hình ảnh tải lên và tên thư mục đích.
  - Sử dụng thư viện đồ họa **SkiaSharp** để giải mã ảnh gốc.
  - Thực hiện thuật toán **Center Crop**: Cắt ảnh gốc thành hình vuông từ chính giữa để không làm méo mó chân dung người dùng.
  - Thay đổi kích thước (Resize) ảnh vuông vừa cắt về độ phân giải chuẩn **300x300 pixel** với bộ lọc chất lượng cao.
  - Mã hóa hình ảnh thành định dạng **WebP** với tỷ lệ nén 75% để giảm tối đa dung lượng tải trang mà vẫn giữ độ sắc nét tối ưu.
- **`GenerateRandomKey`**: Sinh chuỗi ngẫu nhiên dài 5 ký tự dùng làm muối (Salt Key) để băm mật khẩu khách hàng.

### CartViewComponent
Một thành phần giao diện đặc biệt dùng để hiển thị tổng số lượng sản phẩm hiện có trong giỏ hàng trên thanh Navbar:
- Đọc Claims đăng nhập của khách hàng.
- Lấy số lượng từ giỏ hàng Session (nếu có).
- Nếu đã đăng nhập, truy vấn thêm số lượng sản phẩm trong bảng `GioHang` của database.
- Trả về tổng số lượng để hiển thị lên huy hiệu (Badge) màu đỏ trên biểu tượng giỏ hàng.

### DataEncryptionExtensions & SessionExtensions
- **`DataEncryptionExtensions`**: Cung cấp các phương thức mở rộng băm dữ liệu mật khẩu bao gồm: `ToMd5Hash` (sử dụng băm MD5 kết hợp muối), `ToSHA256Hash` và `ToSHA512Hash`.
- **`SessionExtensions`**: Hỗ trợ tuần tự hóa và giải tuần tự hóa đối tượng phức tạp (như danh sách `CartItem`) sang định dạng JSON để lưu trữ trực tiếp vào Session của ASP.NET Core (`Set<T>` và `Get<T>`).

---

## 5. CẤU HÌNH HỆ THỐNG (PROGRAM.CS)

Tệp `Program.cs` cấu hình toàn bộ vòng đời khởi chạy và các Middleware của ứng dụng:
1. **Đăng ký dịch vụ**:
   - `AddControllersWithViews()`: Kích hoạt mô hình MVC.
   - `AddHttpContextAccessor()`: Đăng ký dịch vụ truy cập HttpContext trong các View tĩnh.
   - `AddDbContext`: Kết nối cơ sở dữ liệu SQL Server thông qua chuỗi kết nối đọc từ `appsettings.json`.
   - `AddAutoMapper`: Cấu hình ánh xạ dữ liệu tự động giữa ViewModel và Entity Model.
   - **Xác thực & Ủy quyền (Authentication & Authorization)**: Cấu hình Cookie mặc định hướng tới `/Customer/Login`. Đồng thời cấu hình xác thực ngoại sinh **Google OAuth2** với `ExternalCookie` làm cookie đệm để lấy thông tin tài khoản Google.
   - **Session**: Cấu hình bộ nhớ đệm và thiết lập thời gian hết hạn của giỏ hàng Session là 30 phút.
2. **Thiết lập Pipeline Middleware**:
   - `UseExceptionHandler` & `UseHsts`: Xử lý lỗi bảo mật môi trường Production.
   - `UseHttpsRedirection` & `UseStaticFiles`: Tự động chuyển hướng HTTPS và cho phép truy cập tài nguyên tĩnh trong thư mục `wwwroot`.
   - `UseRouting`: Kích hoạt định tuyến.
   - `UseSession`: Kích hoạt bộ nhớ phiên (phải nằm trước UseAuthentication).
   - `UseAuthentication` & `UseAuthorization`: Bật cơ chế xác thực và phân quyền tài khoản dựa trên các Claims.
   - `MapControllerRoute`: Cấu hình tuyến mặc định dẫn vào `Home/Index`.
3. **Database Seeding & Migration**:
   - Tự động chạy lệnh SQL kiểm tra và thêm cột tính toán `GiaSauGiam` (`GiaSauGiam = DonGia * (1 - GiamGia/100)`) vào bảng sản phẩm nếu bảng chưa có cột này để tối ưu hóa việc truy vấn tính giá.
   - Tự động nạp (Seed) 7 mã giảm giá (Voucher) chuẩn vào bảng `GiamGia` nếu bảng trống khi ứng dụng bắt đầu khởi chạy lần đầu tiên.
