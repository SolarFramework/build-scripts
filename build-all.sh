#!/bin/sh

# function to build all targets
function buildTargets() 
{
BUILDCONFIG=$1
cd $BUILDCONFIG

mkdir -p $BUILDCONFIG
cd $BUILDCONFIG

cmake -H../../sources/SolARFramework -B./SolARFramework -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd SolARFramework
make install
cd ..

cmake -H../../sources/Modules/SolARModuleOpenCV -B./Modules/SolARModuleOpenCV -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
make install
cd ../..

cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV -B./Modules/SolARModuleNonFreeOpenCV -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
make install
cd ../..

cmake -H../../sources/Modules/SolARModuleTools -B./Modules/SolARModuleTools -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
make install
cd ../..

cmake -H../../sources/Samples/NaturalImageMarker/Static -B./Samples/NaturalImageMarker/Static -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/NaturalImageMarker/Static
make
cd ../../..

cmake -H../../sources/Samples/FiducialMarker/Static -B./Samples/FiducialMarker/Static -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/FiducialMarker/Static
make
cd ../../..
cd ..

}

mkdir -p build

# build release mode
cd build
buildTargets Release
buildTargets Debug