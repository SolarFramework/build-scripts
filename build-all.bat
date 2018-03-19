mkdir build

rem build release mode
cd build
mkdir release
cd release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ../../build-scripts/
call :buildTargets


rem back to build/ directory
cd ../..

rem build debug mode
mkdir debug
cd debug
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../build-scripts/
call :buildTargets


rem function to build all targets
:buildTargets
cd SolARFramework
nmake
nmake install
cd ..

cd Modules/SolARModuleOpenCV
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
cd ..

goto :eof

