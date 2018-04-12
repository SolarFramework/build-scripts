set CL=/MP

if not exist "build" mkdir build
cd build

rem build release mode
set BUILDCONFIG="Release"
call :buildTargets

set BUILDCONFIG="Debug"
call :buildTargets


EXIT /B 0
rem function to build all targets
:buildTargets

if not exist "%BUILDCONFIG%" mkdir %BUILDCONFIG%
cd %BUILDCONFIG%

cmake -H../../sources/SolARFramework -B./SolARFramework -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd SolARFramework
nmake install
cd ..

cmake -H../../sources/Modules/SolARModuleOpenCV -B./Modules/SolARModuleOpenCV -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Modules/SolARModuleOpenCV
nmake install
cd ../..

cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV -B./Modules/SolARModuleNonFreeOpenCV -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Modules/SolARModuleNonFreeOpenCV
nmake install
cd ../..

cmake -H../../sources/Modules/SolARModuleTools -B./Modules/SolARModuleTools -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Modules/SolARModuleTools
nmake install
cd ../..

cmake -H../../sources/Samples/NaturalImageMarker/Static -B./Samples/NaturalImageMarker/Static -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/NaturalImageMarker/Static
nmake
cd ../../..

cmake -H../../sources/Samples/FiducialMarker/Static -B./Samples/FiducialMarker/Static -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/FiducialMarker/Static
nmake
cd ../../..
cd ..
EXIT /B 0



