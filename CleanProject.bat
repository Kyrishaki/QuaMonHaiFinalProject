@echo off
echo Dang don dep cac thu muc rac va build trong du an ASP.NET Core...
echo -----------------------------------------------------------------

:: Xoa thu muc bin va obj
for /d /r %%x in (bin,obj) do (
    if exist "%%x" (
        echo Dang xoa: "%%x"
        rmdir /s /q "%%x"
    )
)

:: Xoa thu muc .vs (cache Visual Studio)
if exist ".vs" (
    echo Dang xoa thu muc cache .vs
    rmdir /s /q ".vs"
)

:: Don dep git repository
if exist ".git" (
    echo Dang toi uu lich su Git...
    git gc --prune=now --aggressive
)

echo -----------------------------------------------------------------
echo Da hoan thanh don dep!
pause
