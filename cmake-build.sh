#!/bin/bash

set -x
set -e

# function to build all targets
function buildTargets() 
{
BUILDCONFIG=$1
GENERATOR="$2"

mkdir -p $BUILDCONFIG
cd $BUILDCONFIG

cmake -H../../sources/SolARFramework -B./SolARFramework -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd SolARFramework
cmake --build . --config $BUILDCONFIG
cmake --build . --config $BUILDCONFIG --target install
cd ..

cmake -H../../sources/Modules/SolARModuleOpenCV -B./Modules/SolARModuleOpenCV -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
cmake --build . --config $BUILDCONFIG
cmake --build . --config $BUILDCONFIG --target install	
cd ../..

cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV -B./Modules/SolARModuleNonFreeOpenCV -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
cmake --build . --config $BUILDCONFIG
cmake --build . --config $BUILDCONFIG --target install	
cd ../..

cmake -H../../sources/Modules/SolARModuleTools -B./Modules/SolARModuleTools -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Modules/SolARModuleOpenCV
cmake --build . --config $BUILDCONFIG
cmake --build . --config $BUILDCONFIG --target install	
cd ../..

cmake -H../../sources/Samples/NaturalImageMarker/Static -B./Samples/NaturalImageMarker/Static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/NaturalImageMarker/Static
cmake --build . --config $BUILDCONFIG
cd ../../..

cmake -H../../sources/Samples/FiducialMarker/Static -B./Samples/FiducialMarker/Static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
cd Samples/FiducialMarker/Static
cmake --build . --config $BUILDCONFIG
cd ../../..

cd ..

}

# select generator
echo "Select Generator"
if [ "$OSTYPE" == "msys" ]; then
	options=("Visual Studio 15 2017 Win64" "Visual Studio 14 2015 Win64" "Visual Studio 12 2013 Win64" "NMake Makefiles" "NMake Makefiles JOM" "Ninja")

	select opt in "${options[@]}"; do
	    case $opt in
	        "Visual Studio 15 2017 Win64" ) generator="Visual Studio 15 2017 Win64"; break;;
	        "Visual Studio 14 2015 Win64" ) generator="Visual Studio 14 2015 Win64"; break;;
	        "Visual Studio 12 2013 Win64" ) generator="Visual Studio 12 2013 Win64"; break;;
	        "NMake Makefiles" ) generator="NMake Makefiles"; break;;
	        "NMake Makefiles JOM" ) generator="NMake Makefiles JOM"; break;;
	        "Ninja" ) generator="Ninja"; break;;
	    esac
	done
elif [ "$OSTYPE" == "linux" ]; then
	generator="Unix Makefiles"
fi

mkdir -p build
cd build

buildTargets release "$generator"
buildTargets debug "$generator"