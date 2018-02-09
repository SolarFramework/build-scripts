rem @echo off
SET CURRENTDIR=%~dp0
rem call "C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat" amd64
set VSVARPATH=%VS140COMNTOOLS:~0,-15%\VC
set VSVERSION=msvc2015
call "%VSVARPATH%\vcvarsall.bat" amd64
cd "%CURRENTDIR%\.."
"C:\Program Files\Git\git-bash.exe" 