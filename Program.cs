using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;

using LTWEB_QuaMonHai_CuoiKy.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// ===================================================
// Cấu hình HttpContextAccessor phục vụ View _Navbar
builder.Services.AddHttpContextAccessor();
// ===================================================

// Cấu hình DbContext đọc chuỗi kết nối từ appsettings.json
builder.Services.AddDbContext<Hshop2023Context>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("Hshop2023ConnectionString")));

// Cấu hình AutoMapper
builder.Services.AddAutoMapper(typeof(AutoMapperProfile));

// Khai báo dịch vụ Authentication Cookie và Google External Login
builder.Services.AddAuthentication(options => {
    options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
})
.AddCookie(options => {
    options.LoginPath = "/Customer/Login";
    options.AccessDeniedPath = "/AccessDenied";
})
.AddCookie("ExternalCookie") // Cookie đệm chứa claims tạm thời từ Google
.AddGoogle(options => {
    options.SignInScheme = "ExternalCookie"; // Ghi claims Google vào cookie đệm
    options.ClientId = builder.Configuration["Google:ClientId"] ?? "YOUR_GOOGLE_CLIENT_ID_HERE.apps.googleusercontent.com";
    options.ClientSecret = builder.Configuration["Google:ClientSecret"] ?? "YOUR_GOOGLE_CLIENT_SECRET_HERE";
});

// Cấu hình Session (Bộ nhớ đệm giỏ hàng)
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options => {
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment()) {
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

// Middleware Session (Bắt buộc nằm giữa UseRouting và UseAuthentication)
app.UseSession();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// ===================================================
// Seed database với 7 voucher khác nhau
// ===================================================
using (var scope = app.Services.CreateScope())
{
    try
    {
        var context = scope.ServiceProvider.GetRequiredService<Hshop2023Context>();

        // Tự động kiểm tra và thêm cột tính toán GiaSauGiam vào bảng HangHoa nếu chưa có
        try
        {
            context.Database.ExecuteSqlRaw(@"
                IF NOT EXISTS (
                    SELECT 1 
                    FROM sys.columns 
                    WHERE object_id = OBJECT_ID(N'[dbo].[HangHoa]') 
                      AND name = N'GiaSauGiam'
                )
                BEGIN
                    ALTER TABLE [dbo].[HangHoa] 
                    ADD [GiaSauGiam] AS (CONVERT([decimal](18,2),round(isnull([DonGia],(0))*((1)-isnull([GiamGia],(0))/(100.0)),(2)))) PERSISTED;
                END
            ");
            Console.WriteLine("Computed column 'GiaSauGiam' successfully verified/added to database.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error verifying/adding GiaSauGiam computed column: {ex.Message}");
        }

        if (!context.GiamGias.Any())
        {
            context.GiamGias.AddRange(
                new GiamGia { TenMa = "WELCOME5", PhanTramGiam = 5, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 20, SoLanSuDung = 1000, TrangThai = true },
                new GiamGia { TenMa = "SUMMER10", PhanTramGiam = 10, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 50, SoLanSuDung = 500, TrangThai = true },
                new GiamGia { TenMa = "QMHVIP15", PhanTramGiam = 15, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 100, SoLanSuDung = 200, TrangThai = true },
                new GiamGia { TenMa = "BIGDEAL20", PhanTramGiam = 20, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 150, SoLanSuDung = 150, TrangThai = true },
                new GiamGia { TenMa = "MEGA50", PhanTramGiam = 50, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 300, SoLanSuDung = 50, TrangThai = true },
                new GiamGia { TenMa = "HAPPYWEEKEND", PhanTramGiam = 8, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 40, SoLanSuDung = 300, TrangThai = true },
                new GiamGia { TenMa = "FREESHIP", PhanTramGiam = 10, NgayBatDau = new DateTime(2026, 1, 1), NgayKetThuc = new DateTime(2028, 12, 31), GiaTriDonToiThieu = 30, SoLanSuDung = 2000, TrangThai = true }
            );
            context.SaveChanges();
            Console.WriteLine("Successfully seeded 7 vouchers into the database.");
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error seeding vouchers: {ex.Message}");
    }
}

app.Run();