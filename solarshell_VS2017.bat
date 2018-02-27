rem @echo off
SET CURRENTDIR=%~dp0
SET VCVERSION=%~1
IF "%~1" EQU "" SET VCVERSION=14.1x
rem call "C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat" amd64
set VS150COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\
set VSVARPATH=%VS150COMNTOOLS:~0,-15%\VC\Auxiliary\Build
set VSVERSION=msvc2017
call "%VSVARPATH%\vcvarsall.bat" amd64 -vcvars_ver=%VCVERSION%
cd "%CURRENTDIR%\.."
"C:\Program Files\Git\git-bash.exe"


