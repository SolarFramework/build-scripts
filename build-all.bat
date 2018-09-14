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

cmake -H../../sources/Modules/SolARModuleOpenGL -B./Modules/SolARModuleOpenGL -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Modules/SolARModuleOpenGL
nmake install
cd ../..

cmake -H../../sources/Samples/NaturalImageMarker/Dynamic -B./Samples/NaturalImageMarker/Dynamic -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/NaturalImageMarker/Static
nmake
cd ../../..

cmake -H../../sources/Samples/FiducialMarker/Dynamic -B./Samples/FiducialMarker/Dynamic -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/FiducialMarker/Static
nmake
cd ../../..

cmake -H../../sources/Samples/Sample-Triangulation -B./Samples/Sample-Triangulation -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/Sample-Triangulation
nmake
cd ../..

cmake -H../../sources/Samples/Sample-Slam -B./Samples/Sample-Slam -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%BUILDCONFIG%
cd Samples/Sample-Slam
nmake
cd ../..
cd ..
EXIT /B 0



