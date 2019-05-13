#!/bin/bash

set -e

# function to build all targets
function buildTargets() 
{
BUILDCONFIG=$1
GENERATOR="$2"
TARGET=$3
#sous target full ou novice

#voir option cmake pour solar Framework

mkdir -p $BUILDCONFIG
cd $BUILDCONFIG

case "$TARGET" in
	"SolARWrapper")
		cmake -H$BCOMDEVROOT/bcomBuild/SolARWrapper -B$BCOMDEVROOT/bcomBuild/SolARWrapper/build -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd $BCOMDEVROOT/bcomBuild/SolARWrapper/build
		cmake --build . --config $BUILDCONFIG
		#cmake --build . --config $BUILDCONFIG --target install
		cd ..
		;;
	*)
		echo "unknown target"
		return -1
		;;
esac

cd ..

return 0
}


if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "$0 [target to build] [opt: cmake generator]"
  echo "ex : $0 SolARFramework"
  echo "ex : $0 all (to build all targets)"
  echo "ex : $0 clean (to delete build folder)"
  echo "ex : $0 list (to list all targets)"
  echo "ex : $0 all Ninja"
  exit -1
fi

TARGET=$1

if [ $# -lt 2 ]; then
	if [ $TARGET != "clean" ] && [ $TARGET != "list" ]; then
		# select generator
		if [ "$OSTYPE" == "msys" ]; then
			echo "Select Generator"
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
		elif [[ "$OSTYPE" = *"linux"* ]]; then
			generator="Unix Makefiles"	# default generator for unix 
		fi
	fi
else
	generator=$2
fi

mkdir -p build
cd build

case "$TARGET" in
	"all" )
		buildTargets release "$generator" SolARFramework
		buildTargets debug "$generator" SolARFramework

		buildTargets release "$generator" SolARModuleOpenCV
		buildTargets debug "$generator" SolARModuleOpenCV

		buildTargets release "$generator" SolARModuleTools
		buildTargets debug "$generator" SolARModuleTools

		buildTargets release "$generator" SolARModuleFBOW
		buildTargets debug "$generator" SolARModuleFBOW

		buildTargets release "$generator" SolARModuleOpenGL		
		buildTargets debug "$generator" SolARModuleOpenGL				

		buildTargets release "$generator" NaturalImageMarker
		buildTargets debug "$generator" NaturalImageMarker

		buildTargets release "$generator" FiducialMarker
		buildTargets debug "$generator" FiducialMarker

		# tests "free"
		buildTargets release "$generator" SolARCameraCalibration
		buildTargets debug "$generator" SolARCameraCalibration
		buildTargets release "$generator" SolARDescriptorMatcher
		buildTargets debug "$generator" SolARDescriptorMatcher
		buildTargets release "$generator" SolARImageConvertor
		buildTargets debug "$generator" SolARImageConvertor
		buildTargets release "$generator" SolARImageLoader
		buildTargets debug "$generator" SolARImageLoader
		buildTargets release "$generator" SolAROpticalFlow
		buildTargets debug "$generator" SolAROpticalFlow
		
		buildTargets release "$generator" Sample-Triangulation
		buildTargets debug "$generator" Sample-Triangulation

		buildTargets release "$generator" Sample-Slam
		buildTargets debug "$generator" Sample-Slam	
		#buildTargets release "$generator" SolARSVDtriangulation
		# unit tests
		#buildTargets release "$generator" UnitTests

		# tests "free"
		#buildTargets debug "$generator" SolARSVDtriangulation
		# unit tests
		#buildTargets debug "$generator" UnitTests
		;;
	"clean")
		cd ..
		rm -rf build
		;;
	"list")
		echo "Available targets:"
		echo "(Framework) 		SolARFramework,SolARWrapper" 
		echo "(Modules) 		SolARModuleOpenCV, SolARModuleNonFreeOpenCV, SolARModuleTools, SolARModuleOpenGL, SolARModuleFBOW"		
		echo "(Simple Samples)	SolARCameraCalibration, SolARDescriptorMatcher, SolARImageConvertor, SolARImageLoader, SolAROpticalFlow, SolARSVDtriangulation"
		echo "(RA Samples)		NaturalImageMarker, FiducialMarker, Sample-Slam, Sample-Triangulation"
		echo "(Unit Tests)		UnitTests"
		;;
	"nonfree")
		buildTargets release "$generator" SolARModuleNonFreeOpenCV
		buildTargets debug "$generator" SolARModuleNonFreeOpenCV
		# tests "non free"
		buildTargets release "$generator" SolARDescriptorExtractorNonFree
		#buildTargets release "$generator" SolARDescriptorMatcherNonFree
		#buildTargets release "$generator" SolARHomographyEstimationNonFree

		# tests "non free"
		buildTargets debug "$generator" SolARDescriptorExtractorNonFree
		#buildTargets debug "$generator" SolARDescriptorMatcherNonFree
		#buildTargets debug "$generator" SolARHomographyEstimationNonFree		
		;;
		
	"opengv")
		buildTargets release "$generator" SolARModuleOpenGV
		buildTargets debug "$generator" SolARModuleOpenGV
		
		#tests "opengv"
		buildTargets release "$generator" SolARTestModuleOpenGVPnP
		buildTargets debug "$generator" SolARTestModuleOpenGVPnP
		
		buildTargets release "$generator" SolARTestModuleOpenGVTriangulation
		buildTargets debug "$generator" SolARTestModuleOpenGVTriangulation
		;;
	"unity")
		buildTargets release "$generator" SolARWrapper
		buildTargets debug "$generator" SolARWrapper
		;;
	*)
		buildTargets release "$generator" $TARGET
		buildTargets debug "$generator" $TARGET
		;;
esac

