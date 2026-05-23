using Microsoft.AspNetCore.Mvc;
using SkiaSharp;
using System;
using System.Drawing;
using System.IO;
using static System.Net.Mime.MediaTypeNames;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AvatarController : ControllerBase
    {
        private readonly string[] BackgroundColors = {
            "#1ABC9C", "#2ECC71", "#3498DB", "#9B59B6", "#34495E",
            "#16A085", "#27AE60", "#2980B9", "#8E44AD", "#2C3E50",
            "#F1C40F", "#E67E22", "#E74C3C", "#95A5A6", "#D35400"
        };

        [HttpGet("generate")]
        public IActionResult GenerateAvatar(string name, int size = 200)
        {
            if (string.IsNullOrEmpty(name)) name = "User";

            string initials = name.Trim().Substring(0, 1).ToUpper();
            int colorIndex = Math.Abs(name.GetHashCode()) % BackgroundColors.Length;
            SKColor backgroundColor = SKColor.Parse(BackgroundColors[colorIndex]);

            using (var bitmap = new SKBitmap(size, size))
            using (var canvas = new SKCanvas(bitmap))
            {
                canvas.Clear(SKColors.Transparent);

                using (var paint = new SKPaint { IsAntialias = true, Color = backgroundColor })
                {
                    canvas.DrawCircle(size / 2f, size / 2f, size / 2f, paint);
                }

                using (var paint = new SKPaint
                {
                    Color = SKColors.White,
                    IsAntialias = true,
                    TextSize = size * 0.45f,
                    TextAlign = SKTextAlign.Center,
                    FakeBoldText = true
                })
                {
                    SKRect textBounds = new SKRect();
                    paint.MeasureText(initials, ref textBounds);
                    float yOffset = (size / 2f) - textBounds.MidY;

                    canvas.DrawText(initials, size / 2f, yOffset, paint);
                }

                using (var image = SKImage.FromBitmap(bitmap))
                using (var data = image.Encode(SKEncodedImageFormat.Png, 100))
                {
                    var stream = new MemoryStream();
                    data.SaveTo(stream);
                    stream.Position = 0;
                    return File(stream, "image/png");
                }
            }
        }
    }
}