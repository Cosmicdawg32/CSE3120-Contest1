:: build.bat
:: CSE3120 Contest 1
:: Nicholas Bleeker
:: Helps streamline the build process. Save locally and change the path to your Irvine library location.

@echo off
setlocal
cd /d "%~dp0"

:: This is the path to my Irvine library. If you have installed it in a different location, change this path accordingly.
if not defined IRVINE if exist "%USERPROFILE%\Documents\ASM\Irvine\IRVINE32.inc" set "IRVINE=%USERPROFILE%\Documents\ASM\Irvine"
if not defined IRVINE set "IRVINE=C:\Irvine"
if not exist "%IRVINE%\IRVINE32.inc" (
    echo Irvine32 not found. Set IRVINE to the folder containing IRVINE32.inc
    pause
    exit /b 1
)

where ml.exe >nul 2> nul
if not errorlevel 1 goto haveTools
for /f "usebackq delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -property installationPath`) do set "VSDIR=%%i"
call "%VSDIR%\VC\Auxiliary\Build\vcvars32.bat" >nul 2> nul
:haveTools

if not exist build mkdir build
pushd build

ml /nologo /c /coff /Zi /I "%IRVINE%" /I..\src ^
    ..\src\main.asm ..\src\map.asm ..\src\ui.asm
if errorlevel 1 goto fail

link /nologo /SUBSYSTEM:CONSOLE /DEBUG /SAFESEH:NO /OUT:..\masmTD.exe ^
    main.obj map.obj ui.obj ^
    "%IRVINE%\Irvine32.lib" kernel32.lib user32.lib
if errorlevel 1 goto fail

popd
echo Build successful.
pause
exit /b 0
:fail
popd
echo Build failed.
pause
exit /b 1
