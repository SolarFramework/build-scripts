mkdir build

#### build release mode
mkdir build/release
cd build/release
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../../build-scripts/

cd SolARFramework
make
make install
cd ..

cd Modules/SolARModuleOpenCV
make
make install
cd ..

cd Modules/SolARModuleNonFreeOpenCV
make
make install
cd ..

cd Modules/SolARModuleTools
make
make install
cd ..


#### build debug mode
cd build/debug
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../build-scripts/

cd SolARFramework
make
make install
cd ..

cd Modules/SolARModuleOpenCV
make
make install
cd ..

cd Modules/SolARModuleNonFreeOpenCV
make
make install
cd ..

cd Modules/SolARModuleTools
make
make install
cd ..

