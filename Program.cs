using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// ===================================================
// THÊM DÒNG NÀY ĐỂ KHẮC PHỤC LỖI VIEW Ở _Navbar
builder.Services.AddHttpContextAccessor();
// ===================================================

builder.Services.AddDbContext<Hshop2023Context>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("Hshop2023ConnectionString")));

// https://docs.automapper.org/en/stable/Dependency-injection.html
builder.Services.AddAutoMapper(typeof(AutoMapperProfile));

// Khai báo service authentication
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options => {
    options.LoginPath = "/Customer/Login";
    options.AccessDeniedPath = "/AccessDenied"; // Dang nhap roi chua co quyen se toi dia chi nay
});

// ---------------------------------------------------
// BỔ SUNG CẤU HÌNH SESSION Ở ĐÂY
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options => {
    // ĐÃ SỬA: Đổi từ FromSeconds(10) thành FromMinutes(30) để giỏ hàng không bị xóa quá nhanh
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});
// ---------------------------------------------------

var app = builder.Build();

// ==========================================
// TỰ ĐỘNG TẠO BẢNG BINHLUAN NẾU CHƯA CÓ
// ==========================================
using (var scope = app.Services.CreateScope()) {
    var context = scope.ServiceProvider.GetRequiredService<Hshop2023Context>();
    try {
        context.Database.ExecuteSqlRaw(@"
            IF OBJECT_ID('BinhLuan', 'U') IS NULL
            BEGIN
                CREATE TABLE [dbo].[BinhLuan] (
                    [MaBL] INT IDENTITY(1,1) NOT NULL,
                    [MaHH] INT NOT NULL,
                    [MaKH] NVARCHAR(20) NOT NULL,
                    [Sao] INT NOT NULL,
                    [NoiDung] NVARCHAR(MAX) NULL,
                    [Ngay] DATETIME NOT NULL DEFAULT (GETDATE()),
                    CONSTRAINT [PK_BinhLuan] PRIMARY KEY CLUSTERED ([MaBL] ASC),
                    CONSTRAINT [FK_BinhLuan_HangHoa] FOREIGN KEY ([MaHH]) REFERENCES [dbo].[HangHoa] ([MaHH]) ON DELETE CASCADE,
                    CONSTRAINT [FK_BinhLuan_KhachHang] FOREIGN KEY ([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH]) ON DELETE CASCADE
                );
            END
        ");
    }
    catch (Exception ex) {
        Console.WriteLine("Lỗi khởi tạo bảng BinhLuan: " + ex.Message);
    }
}
// ==========================================

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment()) {
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// ---------------------------------------------------
// BỔ SUNG MIDDLEWARE SESSION Ở ĐÂY (Phải nằm giữa UseRouting và UseAuthentication)
app.UseSession();
// ---------------------------------------------------

app.UseAuthentication();
app.UseAuthorization();

// Đã xóa một dòng app.UseSession() bị dư thừa ở đây

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();