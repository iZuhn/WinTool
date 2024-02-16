@echo off
set "currentUser=%USERNAME%"
set "currentTime=%time%"
set "currentDate=%date%"
mode 80, 28
title WinTool - iZuhn
chcp 65001 >nul

:choose
cls
set /p "language=CZ / EN: "

if /i "%language%"=="CZ" (
    cls
    goto :cz
) else (
if /i "%language%"=="EN" (
    cls
    goto :en
) else (
  goto :choose
  )
)



:cz
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo  ┃                          Copyright (c) 2023, iZuhn                         ┃
echo  ┃                             All rights reserved.                           ┃
echo  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
ping localhost -n 3 >nul


:check-cz
cls
echo.
echo [95m   █████   ███   █████  ███             ███████████                   ████ 
echo [95m  ░░███   ░███  ░░███  ░░░             ░█░░░███░░░█                  ░░███ 
echo [95m   ░███   ░███   ░███  ████  ████████  ░   ░███  ░   ██████   ██████  ░███ 
echo [95m   ░███   ░███   ░███ ░░███ ░░███░░███     ░███     ███░░███ ███░░███ ░███ 
echo [95m   ░░███  █████  ███   ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
echo [95m    ░░░█████░█████░    ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
echo [95m      ░░███ ░░███      █████ ████ █████    █████   ░░██████ ░░██████  █████
echo [95m       ░░░   ░░░      ░░░░░ ░░░░ ░░░░░    ░░░░░     ░░░░░░   ░░░░░░  ░░░░░ 
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ [90mPřihlášen: [97m%currentUser%                     [90mDatum: [97m%date%  [90mČas: [97m%time:~0,5%[95m   ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
ping localhost -n 1 >nul
echo     [90;1m#═╦═══════»[0m [95m[1][0m[0m  [92m[Zjistit Windows verzi]    
ping localhost -n 1 >nul
echo       [90;1m╚═╦══════»[0m  [95m[2][0m  [91m[NEDOSTUPNÉ] [92m[Připojené zařízení v sítí]        
ping localhost -n 1 >nul
echo         [90;1m╚═╦═════»[0m   [95m[3][0m[0m  [92m[Generátor hesel] 
ping localhost -n 1 >nul
echo           [90;1m╚═╦═════»[0m   [95m[4][0m[0m [91m[ADMIN] [92m[Čištění systému]
ping localhost -n 1 >nul
echo             [90;1m╚═╦═════»[0m   [95m[5][0m[0m [91m[ADMIN] [92m[Instalátor programů] 
echo|set /p=".              [90;1m╚══>[0m"


choice /c 12345 >nul
if /I "%errorlevel%" EQU "1" (
  goto :winver-cz
  goto :check-cz
)
if /I "%errorlevel%" EQU "2" (
  goto :ip-cz
  goto :check-cz
)
if /I "%errorlevel%" EQU "3" (
  goto :pass-cz
  goto :check-cz
)
if /I "%errorlevel%" EQU "4" (
  goto :clean-před
  goto :check-cz
)
if /I "%errorlevel%" EQU "5" (
  goto :winget-install-cz
  goto :check-cz
)


:winver-cz
cd %\Windows\System32
start winver.exe
goto :check-cz



:ip-disabled-cz
setlocal enabledelayedexpansion
cls

echo Vypisuje zařízení připojená k síti:

REM Získáme seznam zařízení v ARP cache
arp -a

REM Uživatel zadá začáteční a koncovou IP adresu
set /p start_ip=Zadejte začáteční IP adresu: 
set /p end_ip=Zadejte koncovou IP adresu: 

set found=false

REM Zjistíme, jaká zařízení jsou dostupná v zadaném rozmezí IP adres a zobrazíme výstup přímo v CMD.
for /L %%i in (1,1,254) do (
    set ip=192.168.1.%%i
    if %%i geq 1 if %%i leq 254 (
        if "!ip!" geq "!start_ip!" if "!ip!" leq "!end_ip!" (
            ping -n 1 -w 10 !ip! | find "0% ztráta" && (
                echo !ip!
                set found=true
            )
        )
    )
)
cls
REM Pokud nebyla nalezena žádná zařízení s 0% packet loss, vypište zprávu.
if "%found%"=="false" (
    echo Nebyla nalezena žádná zařízení s 0% packetloss.
)
endlocal
pause
goto :check-cz



:winget-install-cz
setlocal
chcp 65001 >nul

:: Definujte cestu k příkazu Winget
set "wingetCommand=winget"

:: Kontrola, zda je Winget již nainstalován
%wingetCommand% --version 2>NUL
cls
if %errorlevel% neq 0 (
    echo Winget není nainstalován. Stahuji a instalace...
    
    :: Stáhněte Winget z oficiálního zdroje
    bitsadmin.exe /transfer "WingetDownload" https://aka.ms/getwinget -q
    bitsadmin.exe /complete "WingetDownload"
    
    :: Spusťte instalační program
    start /wait winget-installer.exe
    
    :: Kontrola, zda byla instalace úspěšná
    %wingetCommand% --version 2>NUL
    if %errorlevel% equ 0 (
        echo Winget byl úspěšně nainstalován.
    ) else (
        echo Instalace Winget selhala.
    )
) else (
    echo Služba Winget již je nainstalována. Níže je uvedená verze.
    echo.
    %wingetCommand% --version 2>NUL
)

endlocal
ping localhost -n 5 >nul
goto :winget-programs



:winget-programs-cz
cls
echo Vyberte možnost:
echo 1 - Mozilla Firefox
echo 2 - TeamSpeak 3
echo 3 - Discord
echo 4 - Brave Browser
echo 5 - Notepad++
echo 6 - Malwarebytes
echo 7 - Steam
echo 8 - MPC-HC (light-weight Video Player)
echo 9 - Aktualizovat vše
echo.
echo 0 - Zpět
set /p volba=Vyberte z možností: 

if "%volba%"=="1" winget install -e --id Mozilla.Firefox
if "%volba%"=="2" winget install -e --id TeamSpeakSystems.TeamSpeakClient
if "%volba%"=="3" winget install -e --id Discord.Discord
if "%volba%"=="4" winget install -e --id Brave.Brave
if "%volba%"=="5" winget install -e --id Notepad++.Notepad++
if "%volba%"=="6" winget install -e --id Malwarebytes.Malwarebytes
if "%volba%"=="7" winget install -e --id Valve.Steam
if "%volba%"=="8" winget install -e --id clsid2.mpc-hc
if "%volba%"=="9" winget upgrade --all
if "%volba%"=="0" goto :check-cz

pause
goto :winget-programs-cz


:pass-cz
:reset-cz
setlocal EnableDelayedExpansion
cls
set /p "length=Zadej považovanou délku hesla (Zpět? Napiš EXIT): "
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "password="

if /i "%length%"=="EXIT" (
    goto :check-cz
)

if /i "%length%"=="0" (
    cls
    echo Neplatná hodnota! Heslo nebylo vygenerováno.
    ping localhost -n 3 >nul
    goto :reset-cz
)

set "isNumber=true"
for /f "delims=0123456789" %%i in ("%length%") do set "isNumber=false"

if not "%isNumber%"=="true" (
    cls
    echo Neplatná hodnota! Zadej numerickou hodnotu.
    ping localhost -n 4 >nul
    goto :reset-cz
)

rem Password generation loop
for /l %%i in (1,1,%length%) do (
    set /a index=!random! %% 62
    for %%j in (!index!) do (
        set "char=!chars:~%%j,1!"
        set "password=!password!!char!"
    )
)

cls
echo Vygenerované heslo: %password%
echo %password% | clip
echo.
echo Heslo bylo automaticky zkopírováno.
echo.
echo.

pause
goto :reset-cz


:clean-před
cls
echo Systémové čištění obsahuje:
echo - Promazání všech souborů ve složce %temp% (bezpečné)
echo - Vyprázdnění koše (před čištěním prosím zkontroluj)
echo.
echo.
choice /C YN /M "Opravdu chcete začít systémové čištění?:"
if errorlevel 2 (
    goto :check-cz
) else (
    goto :clean-cz
)


:clean-cz
set "tempDirs=C:\Windows\Temp %TMP% C:\Windows\Temp\Prefetch"
set "tempSize=0"

for %%D in (%tempDirs%) do (
    if exist "%%D" (
        echo Čístím %%D folder...
        for /d %%A in ("%%D\*") do (
            del /f /s /q "%%A\*.*"
            set /a tempSize+=%%~zA
            rd /s /q "%%A"
        )
        del /f /s /q "%%D\*.*"
        set /a tempSize+=%%~zD
    ) else (
        echo Složka %%D neexistuje.
    )
)

cls
echo Složka TEMP byla vyčištěna.
echo.
ping localhost -n 3 >nul
cls
echo Vyprazdňuji koš...
RD /S /Q %systemdrive%\$Recycle.Bin
cls
echo Koš byl vyčištěn.
ping localhost -n 3 >nul
cls
echo Restartuji Průzkumníka Windows (opraví vizuální chyby ikon na ploše)
taskkill /f /im explorer.exe
timeout 2 >nul
start explorer.exe
cls
echo Čištění systému bylo dokončeno.
echo.
echo.
endlocal
pause
goto :check-cz


--- :ip-closed [IPv4]
for /f "delims=" %%i in ('curl -s ifconfig.me') do set "ip=%%i"


:ip-cz
cls
echo [93mTato služba je momentálně nedostupná.
echo Pro více informací navštivte [91mgithub.com/iZuhn/WinTool/releases
ping localhost -n 5 >nul
goto :check-cz



:en

mode 80, 28
title WinTool - iZuhn
chcp 65001 >nul
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo  ┃                          Copyright (c) 2023, iZuhn                         ┃
echo  ┃                             All rights reserved.                           ┃
echo  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
ping localhost -n 4 >nul


:check-en
cls
echo.
echo [95m   █████   ███   █████  ███             ███████████                   ████ 
echo [95m  ░░███   ░███  ░░███  ░░░             ░█░░░███░░░█                  ░░███ 
echo [95m   ░███   ░███   ░███  ████  ████████  ░   ░███  ░   ██████   ██████  ░███ 
echo [95m   ░███   ░███   ░███ ░░███ ░░███░░███     ░███     ███░░███ ███░░███ ░███ 
echo [95m   ░░███  █████  ███   ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
echo [95m    ░░░█████░█████░    ░███  ░███ ░███     ░███    ░███ ░███░███ ░███ ░███ 
echo [95m      ░░███ ░░███      █████ ████ █████    █████   ░░██████ ░░██████  █████
echo [95m       ░░░   ░░░      ░░░░░ ░░░░ ░░░░░    ░░░░░     ░░░░░░   ░░░░░░  ░░░░░ 
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ [90mLogged in: [97m%currentUser%                     [90mDate: [97m%date%  [90mTime: [97m%time:~0,5%[95m   ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
ping localhost -n 1 >nul
echo     [90;1m#═╦═══════»[0m [95m[1][0m[0m  [92m[Check Windows version]    
ping localhost -n 1 >nul
echo       [90;1m╚═╦══════»[0m  [95m[2][0m  [91m[DISABLED] [92m[IP connected devices]        
ping localhost -n 1 >nul
echo         [90;1m╚═╦═════»[0m   [95m[3][0m[0m  [92m[Password generator] 
ping localhost -n 1 >nul
echo           [90;1m╚═╦═════»[0m   [95m[4][0m[0m [91m[ADMIN] [92m[System cleaning]
ping localhost -n 1 >nul
echo             [90;1m╚═╦═════»[0m   [95m[5][0m[0m [91m[ADMIN] [92m[Program installer] 
echo|set /p=".              [90;1m╚══>[0m"
choice /c 12345 >nul
if /I "%errorlevel%" EQU "1" (
  goto :winver
  goto :check-en
)
if /I "%errorlevel%" EQU "2" (
  goto :ip
  goto :check-en
)
if /I "%errorlevel%" EQU "3" (
  goto :pass
  goto :check-en
)
if /I "%errorlevel%" EQU "4" (
  goto :clean-before
  goto :check-en
)
if /I "%errorlevel%" EQU "5" (
  goto :winget-install
  goto :check-en



:winver
cd %\Windows\System32
start winver.exe
goto :check-en



:ip-disabled
setlocal enabledelayedexpansion
cls

echo Shows connected devices in your network:

REM Gets list of devices in ARP cache
arp -a

REM User inputs IP range
set /p start_ip=Start IP adress: 
set /p end_ip=End IP adress: 

set found=false

REM Finds out, which devices are avaible based of entered IP adresses and shows output in CMD.
for /L %%i in (1,1,254) do (
    set ip=192.168.1.%%i
    if %%i geq 1 if %%i leq 254 (
        if "!ip!" geq "!start_ip!" if "!ip!" leq "!end_ip!" (
            ping -n 1 -w 10 !ip! | find "0% ztráta" && (
                echo !ip!
                set found=true
            )
        )
    )
)
cls
REM If no devices were found with 0% packet loss, tell the user about it.
if "%found%"=="false" (
    echo No devices with 0% packetloss were found.
)
endlocal
pause
goto :check-en



:winget-install
setlocal
chcp 65001 >nul

:: Defines path to Winget command
set "wingetCommand=winget"

:: Checks, if Winget is installed already
%wingetCommand% --version 2>NUL
cls
if %errorlevel% neq 0 (
    echo Winget isn't installed. Downloading a installing...
    
    :: Downloads Winget from official source
    bitsadmin.exe /transfer "WingetDownload" https://aka.ms/getwinget -q
    bitsadmin.exe /complete "WingetDownload"
    
    :: Starts the installer program
    start /wait winget-installer.exe
    
    :: Checks, if the installation was successful
    %wingetCommand% --version 2>NUL
    if %errorlevel% equ 0 (
        echo Winget was installed successfully.
    ) else (
        echo Winget installation failed.
    )
) else (
    echo Service Winget is already installed. Version is shown below.
    echo.
    %wingetCommand% --version 2>NUL
)

endlocal
ping localhost -n 4 >nul
goto :winget-programs



:winget-programs
cls
echo Currently avaible programs
echo.
echo 1 - Mozilla Firefox
echo 2 - TeamSpeak 3
echo 3 - Discord
echo 4 - Brave Browser
echo 5 - Notepad++
echo 6 - Malwarebytes
echo 7 - Steam
echo 8 - MPC-HC (light-weight Video Player)
echo 9 - Update all
echo.
echo 0 - Back
set /p volba=Choose an option: 

if "%volba%"=="1" winget install -e --id Mozilla.Firefox
if "%volba%"=="2" winget install -e --id TeamSpeakSystems.TeamSpeakClient
if "%volba%"=="3" winget install -e --id Discord.Discord
if "%volba%"=="4" winget install -e --id Brave.Brave
if "%volba%"=="5" winget install -e --id Notepad++.Notepad++
if "%volba%"=="6" winget install -e --id Malwarebytes.Malwarebytes
if "%volba%"=="7" winget install -e --id Valve.Steam
if "%volba%"=="8" winget install -e --id clsid2.mpc-hc
if "%volba%"=="9" winget upgrade --all
if "%volba%"=="0" goto :check-en

pause
goto :winget-programs


:pass
:reset-en
setlocal EnableDelayedExpansion
cls
set /p "length=Enter the length of the password: "
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "password="

if /i "%length%"=="EXIT" (
    goto :check-en
)

if /i "%length%"=="0" (
    cls
    echo Invalid input!
    ping localhost -n 3 >nul
    goto :reset-en
)

set "isNumber=true"
for /f "delims=0123456789" %%i in ("%length%") do set "isNumber=false"

if not "%isNumber%"=="true" (
    cls
    echo Invalid input! Enter numeric value.
    ping localhost -n 4 >nul
    goto :reset-en
)

rem Password generation loop
for /l %%i in (1,1,%length%) do (
    set /a index=!random! %% 62
    for %%j in (!index!) do (
        set "char=!chars:~%%j,1!"
        set "password=!password!!char!"
    )
)

echo Generated Password: %password%
echo %password% | clip
echo.
echo Password has been copied to clipboard.
echo.
echo.
pause
goto :reset-en


:clean-before
cls
echo System cleaning involves:
echo - Deleting everything from %temp% file (safe)
echo - Emptying Recycle Bin (check before cleaning)
echo.
echo.
choice /C YN /M "Are you sure you want to begin system cleaning?:"
if errorlevel 2 (
    goto :check-en
) else (
    goto :clean


:clean
set "tempDirs=C:\Windows\Temp %TMP% C:\Windows\Temp\Prefetch"
set "tempSize=0"

for %%D in (%tempDirs%) do (
    if exist "%%D" (
        echo Cleaning %%D folder...
        for /d %%A in ("%%D\*") do (
            del /f /s /q "%%A\*.*"
            set /a tempSize+=%%~zA
            rd /s /q "%%A"
        )
        del /f /s /q "%%D\*.*"
        set /a tempSize+=%%~zD
    ) else (
        echo Folder %%D does not exist.
    )
)

cls
echo TEMP has been cleaned.
echo.
endlocal
ping localhost -n 3 >nul
cls
echo Emptying Recycle Bin...
RD /S /Q %systemdrive%\$Recycle.Bin
cls
echo Recycle Bin has been cleaned.
ping localhost -n 3 >nul
cls
echo Restarting Windows Explorer (fixes visual bugs with icons on desktop)
taskkill /f /im explorer.exe
timeout 2 >nul
start explorer.exe
cls
echo System cleaning has been completed.
echo.
echo.
pause
goto :check-en


:ip
cls
echo [93mThis feature is currently disabled.
echo For more information check [91mgithub.com/iZuhn/WinTool/releases
echo.
echo.
ping localhost -n 5 >nul
goto :check-en
