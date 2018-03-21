if not exist "build" mkdir build

rem build release mode
cd build
if not exist "release" mkdir release
cd release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ../../build-scripts/
call :buildTargets


rem back to build/ directory
cd ..

rem build debug mode
if not exist "debug" mkdir debug
cd debug
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../build-scripts/
call :buildTargets

cd ../..
EXIT /B 0

rem function to build all targets
:buildTargets
cd SolARFramework
nmake
nmake install
cd ..

cd Modules

cd SolARModuleOpenCV
nmake
nmake install
cd ..

cd SolARModuleNonFreeOpenCV
nmake
nmake install
cd ..

cd SolARModuleTools
nmake
nmake install

cd ../..

cd Samples

cd NaturalImageMarker/Static
nmake
nmake install
cd ../..

cd FiducialMarker/Static
nmake
nmake install
cd ../..

cd ..

EXIT /B 0