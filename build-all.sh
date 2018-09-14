#!/bin/bash

# function to build all targets
function buildTargets() 
{
BUILDCONFIG=$1
mkdir -p $BUILDCONFIG
cd $BUILDCONFIG

cmake -H../../sources/SolARFramework -B./SolARFramework -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd SolARFramework
make install
cd ..

cmake -H../../sources/Modules/SolARModuleOpenCV -B./Modules/SolARModuleOpenCV -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
make install
cd ../..

cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV -B./Modules/SolARModuleNonFreeOpenCV -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleNonFreeOpenCV
make install
cd ../..

cmake -H../../sources/Modules/SolARModuleTools -B./Modules/SolARModuleTools -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleTools
make install
cd ../..

cmake -H../../sources/Modules/SolARModuleOpenGL -B./Modules/SolARModuleOpenGL -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenGL
make install
cd ../..

cmake -H../../sources/Samples/NaturalImageMarker/Dynamic -B./Samples/NaturalImageMarker/Dynamic -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/NaturalImageMarker/Dynamic
make
cd ../../..

cmake -H../../sources/Samples/FiducialMarker/Dynamic -B./Samples/FiducialMarker/Dynamic -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/FiducialMarker/Dynamic
make
cd ../../..

cmake -H../../sources/Samples/Sample_Triangulation -B./Samples/Sample_Triangulation -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/Sample_Triangulation
make
cd ../..

cmake -H../../sources/Samples/Sample_Slam -B./Samples/Sample_Slam -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/Sample_Slam
make
cd ../..

cd ..

}

mkdir -p build

# build release mode
cd build
buildTargets Release
buildTargets Debug