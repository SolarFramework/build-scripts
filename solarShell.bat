rem @echo off
SET CURRENTDIR=%~dp0
SET VCVERSION=%~1
rem call "C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat" amd64
set VS150COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\
set VSVARPATH=%VS150COMNTOOLS:~0,-15%\VC\Auxiliary\Build
set VSVERSION=msvc2017
IF "%~1" EQU "" (call "%VSVARPATH%\vcvarsall.bat" amd64) else (call "%VSVARPATH%\vcvarsall.bat" amd64 -vcvars_ver=%VCVERSION%)
cd "%CURRENTDIR%\.."
"C:\My Program Files\cmder\vendor\git-for-windows\git-bash.exe"