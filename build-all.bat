mkdir build

rem build release mode
cd build
mkdir release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ../build-scripts/

cd SolARFramework
nmake
nmake install
cd ..

cd Modules/SolARModuleOpenCV
nmake
nmake install
cd ..

cd Modules/SolARModuleNonFreeOpenCV
nmake
nmake install
cd ..

cd Modules/SolARModuleTools
nmake
nmake install
cd ..


rem build debug mode
cd build
mkdir debug
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../build-scripts/

cd SolARFramework
nmake
nmake install
cd ..

cd Modules/SolARModuleOpenCV
nmake
nmake install
cd ..

cd Modules/SolARModuleNonFreeOpenCV
nmake
nmake install
cd ..

cd Modules/SolARModuleTools
nmake
nmake install
cd ..
