Copyright (c) 2023, iZuhn
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. 

@echo off
mode 80, 28
title Windows Toolbox - iZuhn
chcp 65001 >nul



:check
cls
echo.
ping localhost -n 1 >nul
echo     [90;1m#═╦═══════»[0m [95m[1][0m[0m  [92m[Check Windows version]    
ping localhost -n 1 >nul
echo       [90;1m╚═╦══════»[0m  [95m[2][0m  [92m[IP connected devices]        
ping localhost -n 1 >nul
echo         [90;1m╚═╦═════»[0m   [95m[3][0m[0m  [92m[Program installer] 
echo|set /p=".          [90;1m╚══>[0m"
choice /c 123 >nul
if /I "%errorlevel%" EQU "1" (
  goto :loop
  goto :check
)
if /I "%errorlevel%" EQU "2" (
  goto :ip
  goto :check
)
if /I "%errorlevel%" EQU "3" (
  goto :winget-install
  goto :check
)



:winver
ping localhhost -n 3 >nul
cd %\Windows\System32
start winver.exe
echo Windows version dialog has been started.
echo.
pause
goto :check



:ip
setlocal enabledelayedexpansion
cls

echo Vypisuje zařízení připojená k síti:

REM Získáme seznam zařízení v ARP cache
arp -a

REM Uživatel zadá začáteční a koncovou IP adresu
set /p start_ip=Zadejte začáteční IP adresu: 
set /p end_ip=Zadejte koncovou IP adresu: 

set found=false

REM Zjistíme, jaká zařízení jsou dostupná v zadaném rozmezí IP adres a zobrazíme výstup přímo v CMD
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
REM Pokud nebyla nalezena žádná zařízení s 0% packet loss, vypište zprávu
if "%found%"=="false" (
    echo Nebyla nalezena žádná zařízení s 0% packet loss.
)
endlocal
pause
goto :check



:winget-install
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
    echo Winget již je nainstalován. Níže je napsaná verze Winget.
    %wingetCommand% --version 2>NUL
    echo.
)

endlocal
pause
goto :winget-programs



:winget-programs
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
if "%volba%"=="0" goto :check

pause
goto :winget-programs


