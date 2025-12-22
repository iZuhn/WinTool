@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title WinTool - v1.0.0

:: vytvoří neviditelny symbol pro barvičky
for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

:: barvičky
set "M=%ESC%[95m"
set "G=%ESC%[92m"
set "R=%ESC%[91m"
set "W=%ESC%[97m"
set "Gy=%ESC%[90m"
set "Res=%ESC%[0m"

set "currentUser=%USERNAME%"

:: defaultni jazyk (CZ)
set "LANG=CZ"
call :set_lang_cz

:main_menu
cls
call :drawHeader

echo   %M%[1]  %G%%txt_opt1%
echo   %M%[2]  %G%%txt_opt2%
echo   %M%[3]  %G%%txt_opt3%
echo   %M%[4]  %R%%txt_opt4%
echo   %M%[5]  %R%%txt_opt5%
echo   %M%[6]  %G%%txt_opt6%
echo   %M%[9]  %G%%txt_opt9%
echo.
echo  %M%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo    %G%■ - %txt_admin_no%
echo    %R%■ - %txt_admin_yes% %W%

choice /c 123456789 >nul
if "%errorlevel%"=="1" goto :winver
if "%errorlevel%"=="2" goto :sysinfo
if "%errorlevel%"=="3" goto :password_gen
if "%errorlevel%"=="4" goto :clean_warn
if "%errorlevel%"=="5" goto :winget_install
if "%errorlevel%"=="6" goto :network_tools
if "%errorlevel%"=="9" goto :settings

goto :main_menu

:settings
cls
call :drawHeader
echo [1] Čeština (CZ)
echo [2] English (EN)
echo [3] %txt_back%

choice /c 123 /n >nul
if "%errorlevel%"=="1" (
    set "LANG=CZ"
    call :set_lang_cz
    goto :main_menu
)
if "%errorlevel%"=="2" (
    set "LANG=EN"
    call :set_lang_en
    goto :main_menu
)
goto :main_menu

:winver
    cd /d "%SystemRoot%\System32"
    start winver.exe
    goto :main_menu

:sysinfo
    cls
    call :drawHeader
    systeminfo
    echo.
    pause
    goto :main_menu

:password_gen
    cls
    call :drawHeader
    set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    set "password="
    
    echo %W%
    set /p "length=%txt_pass_len% "
    if /i "!length!"=="EXIT" goto :main_menu
    
    :: zkontroluje jestli jsou tam jen čísla a taky nastaví jak dluhe chce vygenerovat heslo
    for /f "delims=0123456789" %%i in ("!length!") do (
        echo %txt_invalid%
        timeout /t 2 >nul
        goto :password_gen
    )

    :: vezme si z %txt_pass_len% délku hesla a podle toho pak generuje
    for /l %%i in (1,1,!length!) do (
        set /a index=!random! %% 62
        for %%j in (!index!) do set "password=!password!!chars:~%%j,1!"
    )
    
	:: ukáže vygenerovane heslo a rovnou ho i zkopiruje
    echo.
    echo %txt_pass_gen%: !password!
    echo !password!| clip
    echo %txt_pass_copy%
    echo.
    pause
    goto :password_gen

:clean_warn :: ukazuje varovny text pred cistenim a pozaduje potvrzeni
    cls
    call :drawHeader
    echo %W%%txt_clean_warn_1%
    echo %txt_clean_warn_2%
    echo.
    choice /C YN /M "%txt_clean_confirm%"
    if errorlevel 2 goto :main_menu

:clean_run
    set "tempDirs=%TEMP% %SystemRoot%\Temp %SystemRoot%\Prefetch"
    
	echo.
    for %%D in (%tempDirs%) do (
        if exist "%%D" (
            echo %txt_cleaning% %%D...
            del /f /s /q "%%D\*.*" >nul 2>&1
            for /d %%A in ("%%D\*") do rd /s /q "%%A" >nul 2>&1
        )
    )
    
	echo.
    echo %txt_empty_bin%...
    rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1
    
    echo %txt_restart_explorer%...
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    
    echo.
    echo %txt_clean_done%
    pause
    goto :main_menu

:winget_install
    set "wingetCommand=winget"
    %wingetCommand% --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Winget not found. Installing...
        bitsadmin.exe /transfer "WingetDownload" https://aka.ms/getwinget -q
        bitsadmin.exe /complete "WingetDownload"
        start /wait winget-installer.exe
    )
    
:winget_menu
    cls
    call :drawHeader
    echo %W%
    echo 1 - Mozilla Firefox
    echo 2 - TeamSpeak 3
    echo 3 - Discord
    echo 4 - Brave Browser
    echo 5 - Notepad++
    echo 6 - Malwarebytes
    echo 7 - Steam
    echo 8 - MPC-HC
    echo 9 - %txt_update_all%
    echo 0 - %txt_back%
    echo.
    set /p "choice=%txt_choose%: "
    
    if "%choice%"=="0" goto :main_menu
    if "%choice%"=="9" (
        winget upgrade --include-unknown
        pause
        goto :winget_menu
    )
    
    set "id="
    if "%choice%"=="1" set "id=Mozilla.Firefox"
    if "%choice%"=="2" set "id=TeamSpeakSystems.TeamSpeakClient"
    if "%choice%"=="3" set "id=Discord.Discord"
    if "%choice%"=="4" set "id=Brave.Brave"
    if "%choice%"=="5" set "id=Notepad++.Notepad++"
    if "%choice%"=="6" set "id=Malwarebytes.Malwarebytes"
    if "%choice%"=="7" set "id=Valve.Steam"
    if "%choice%"=="8" set "id=clsid2.mpc-hc"
    
    if defined id (
        winget install -e --id !id!
        pause
    )
    goto :winget_menu

:network_tools
    cls
    call :drawHeader
    echo %W%[1] %txt_net_1%
    echo [2] %txt_net_2%
    echo [3] %txt_back%
    
    choice /c 123 /n >nul
    if "%errorlevel%"=="3" goto :main_menu
    
    if "%errorlevel%"=="1" (
        netsh wlan show profile
        pause
        goto :network_tools
    )
    
    if "%errorlevel%"=="2" (
        :: WiFi Password Reveal
        for /f "tokens=2 delims=:" %%a in ('netsh wlan show profile ^| findstr "All User Profile"') do (
            set "wifi_name=%%a"
            set "wifi_name=!wifi_name:~1!"
            set "wifi_pwd=OPEN/UNKNOWN"
            
            for /f "tokens=2 delims=:" %%b in ('netsh wlan show profile name^="!wifi_name!" key^=clear ^| findstr "Key Content"') do (
                set "wifi_pwd=%%b"
                set "wifi_pwd=!wifi_pwd:~1!"
            )
            echo SSID: !wifi_name!  %Gy%Pass: %W%!wifi_pwd! %M%
        )
        pause
        goto :network_tools
    )

:set_lang_cz
    set "txt_opt1=[Zjistit Windows verzi]"
    set "txt_opt2=[Systémové informace]"
    set "txt_opt3=[Generátor hesel]"
    set "txt_opt4=[Čištění systému]"
    set "txt_opt5=[Instalátor programů]"
    set "txt_opt6=[Síťové nástroje]"
    set "txt_opt9=[Jazyk / Language]"
    set "txt_admin_no=Není potřeba Admin"
    set "txt_admin_yes=Potřeba Admin"
    set "txt_user=Přihlášen:"
    set "txt_date=Datum:"
    set "txt_back=Zpět"
    set "txt_pass_len=Zadej délku hesla (nebo EXIT):"
    set "txt_invalid=Neplatná hodnota!"
    set "txt_pass_gen=Vygenerované heslo"
    set "txt_pass_copy=Heslo zkopírováno."
    set "txt_clean_warn_1=- Promazání složek TEMP (bezpečné)"
    set "txt_clean_warn_2=- Vyprázdnění koše"
    set "txt_clean_confirm=Opravdu začít?"
    set "txt_cleaning=Čistím"
    set "txt_empty_bin=Vyprazdňuji koš"
    set "txt_restart_explorer=Restartuji Explorer"
    set "txt_clean_done=Hotovo."
    set "txt_update_all=[Aktualizovat vše]"
    set "txt_choose=Vyberte možnost"
    set "txt_net_1=Zobrazit Wifi sítě"
    set "txt_net_2=Zobrazit hesla (Admin)"
    set "txt_net_3=IP Scanner"
    set "txt_net_scan_msg=Zadejte rozsah (např. 192.168.1.X):"
    set "txt_ip_start=Start IP:"
    set "txt_ip_end=End IP:"
    set "txt_net_none=Žádná zařízení nenalezena."
exit /b

:set_lang_en
    set "txt_opt1=[Check Windows version]"
    set "txt_opt2=[System information]"
    set "txt_opt3=[Password generator]"
    set "txt_opt4=[System cleaning]"
    set "txt_opt5=[Program installer]"
    set "txt_opt6=[Network tools]"
    set "txt_opt9=[Language / Jazyk]"
    set "txt_admin_no=No Admin needed"
    set "txt_admin_yes=Admin needed"
    set "txt_user=Logged in:"
    set "txt_date=Date:"
    set "txt_back=Back"
    set "txt_pass_len=Enter password length (or EXIT):"
    set "txt_invalid=Invalid input!"
    set "txt_pass_gen=Generated password"
    set "txt_pass_copy=Password copied."
    set "txt_clean_warn_1=- Deleting TEMP files (safe)"
    set "txt_clean_warn_2=- Emptying Recycle Bin"
    set "txt_clean_confirm=Start cleaning?"
    set "txt_cleaning=Cleaning"
    set "txt_empty_bin=Emptying Bin"
    set "txt_restart_explorer=Restarting Explorer"
    set "txt_clean_done=Done."
    set "txt_update_all=[Update all]"
    set "txt_choose=Choose option"
    set "txt_net_1=Show Wifi networks"
    set "txt_net_2=Show Wifi passwords (Admin)"
exit /b

:drawHeader
    cls
    echo.
    echo  %M%   █████   ███   █████  ███             ███████████                   ████ 
    echo  %M%  ░░███   ░███  ░░███  ░░░             ░█░░░███░░░█                  ░░███ 
    echo  %M%   ░███   ░███   ░███  ████  ████████  ░   ░███  ░   ██████   ██████  ░███ 
    echo  %M%   ░███   ░███   ░███ ░░███ ░░███░░███     ░███     ███░░███ ███░░███ ░███ 
    echo  %M%   ░░███  █████  ███   ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
    echo  %M%    ░░░█████░█████░    ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
    echo  %M%      ░░███ ░░███      █████ ████ █████    █████   ░░██████ ░░██████  █████
    echo  %M%       ░░░   ░░░      ░░░░░ ░░░░ ░░░░░    ░░░░░     ░░░░░░   ░░░░░░  ░░░░░ 
    echo.
    echo %Res%┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    echo    %Gy%%txt_user%  %W%%currentUser%                                 %Gy%%txt_date%  %W%%date%  %M%
    echo %Res%┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    echo.
exit /b
