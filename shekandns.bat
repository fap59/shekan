@echo off
setlocal enabledelayedexpansion


for /f "tokens=1,2,* skip=3" %%a in ('netsh wlan show interfaces') do (
    if /i "%%a"=="Name" (
        set "wifi_name=%%c"
    )
)


if not defined wifi_name (
    echo ❌ Wi-Fi connection not found. Please make sure you're connected to Wi-Fi.
    pause
    exit /b
)

echo ✅ Active Wi-Fi connection found: [%wifi_name%]
echo.
echo Do you want to:
echo [Y] Set DNS to:
echo     185.51.200.2
echo     178.22.122.100
echo [N] Remove custom DNS (set to automatic)
set /p choice=Enter your choice (Y/N): 

if /i "%choice%"=="Y" (
    echo 🔧 Setting DNS for "%wifi_name%"...
    netsh interface ipv4 set dnsservers name="%wifi_name%" static 185.51.200.2 primary
    netsh interface ipv4 add dnsservers name="%wifi_name%" 178.22.122.100 index=2
    echo ✅ DNS has been set successfully.
) else if /i "%choice%"=="N" (
    echo 🔄 Reverting DNS settings for "%wifi_name%" to automatic...
    netsh interface ipv4 set dnsservers name="%wifi_name%" dhcp
    echo ✅ DNS settings reverted to default.
) else (
    echo ❌ Invalid input. Please enter Y or N.
)

pause