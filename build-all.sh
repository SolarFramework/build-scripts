#!/bin/sh

# function to build all targets
function buildTargets() 
{
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

}

mkdir -p build

# build release mode
cd build
mkdir -p release
cd release
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ../../build-scripts/
buildTargets


# back to build/ directory
cd ..

# build debug mode
mkdir -p debug
cd debug
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Debug ../../build-scripts/
buildTargets

cd ../..

