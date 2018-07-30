#!/bin/bash

set -e

# function to build all targets
function buildTargets() 
{
BUILDCONFIG=$1
GENERATOR="$2"
TARGET=$3

mkdir -p $BUILDCONFIG
cd $BUILDCONFIG

case "$TARGET" in
	"SolARFramework")
		cmake -H../../sources/SolARFramework -B./SolARFramework -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd SolARFramework
		cmake --build . --config $BUILDCONFIG
		cmake --build . --config $BUILDCONFIG --target install
		cd ..
		;;
	"SolARModuleOpenCV")
		cmake -H../../sources/Modules/SolARModuleOpenCV -B./Modules/SolARModuleOpenCV -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV
		cmake --build . --config $BUILDCONFIG
		cmake --build . --config $BUILDCONFIG --target install	
		cd ../..
		;;
	"SolARModuleNonFreeOpenCV")
		cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV -B./Modules/SolARModuleNonFreeOpenCV -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleNonFreeOpenCV
		cmake --build . --config $BUILDCONFIG
		cmake --build . --config $BUILDCONFIG --target install	
		cd ../..
		;;
	"SolARModuleTools")
		cmake -H../../sources/Modules/SolARModuleTools -B./Modules/SolARModuleTools -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleTools
		cmake --build . --config $BUILDCONFIG
		cmake --build . --config $BUILDCONFIG --target install	
		cd ../..
		;;
	"NaturalImageMarker")
		cmake -H../../sources/Samples/NaturalImageMarker/Static -B./Samples/NaturalImageMarker/Static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Samples/NaturalImageMarker/Static
		cmake --build . --config $BUILDCONFIG
		cd ../../..
		;;
	"FiducialMarker")
		cmake -H../../sources/Samples/FiducialMarker/Static -B./Samples/FiducialMarker/Static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Samples/FiducialMarker/Static
		cmake --build . --config $BUILDCONFIG
		cd ../../..
		;;
	"Sample-Slam")
		cmake -H../../sources/Samples/Sample-Slam -B./Samples/Sample-Slam -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Samples/Sample-Slam
		cmake --build . --config $BUILDCONFIG
		cd ../..
		;;
	"Sample-Triangulation")
		cmake -H../../sources/Samples/Sample-Triangulation -B./Samples/Sample-Triangulation -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Samples/Sample-Triangulation
		cmake --build . --config $BUILDCONFIG
		cd ../..
		;;				
	"SolARCameraCalibration")
		cmake -H../../sources/Modules/SolARModuleOpenCV/tests/SolARCameraCalibration/static -B./Modules/SolARModuleOpenCV/tests/SolARCameraCalibration/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV/tests/SolARCameraCalibration/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARDescriptorMatcher")
		cmake -H../../sources/Modules/SolARModuleOpenCV/tests/SolARDescriptorMatcher/static -B./Modules/SolARModuleOpenCV/tests/SolARDescriptorMatcher/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV/tests/SolARDescriptorMatcher/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARFundamentalMatrixDecomposer")
		;;
	"SolARFundamentalMatrixEstimation")
		;;
	"SolARImageConvertor")
		cmake -H../../sources/Modules/SolARModuleOpenCV/tests/SolARImageConvertor/dynamic -B./Modules/SolARModuleOpenCV/tests/SolARImageConvertor/dynamic -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV/tests/SolARImageConvertor/dynamic
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARImageLoader")
		cmake -H../../sources/Modules/SolARModuleOpenCV/tests/SolARImageLoader/static -B./Modules/SolARModuleOpenCV/tests/SolARImageLoader/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV/tests/SolARImageLoader/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARMatchesFilter")
		;;
	"SolARSVDtriangulation")
		cmake -H../../sources/Modules/SolARModuleOpenCV/tests/SolARSVDtriangulation -B./Modules/SolARModuleOpenCV/tests/SolARSVDtriangulation -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleOpenCV/tests/SolARSVDtriangulation
		cmake --build . --config $BUILDCONFIG
		cd ../../../../
		;;
	"SolARDescriptorExtractorNonFree")
		cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorExtractor/static -B./Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorExtractor/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorExtractor/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARDescriptorMatcherNonFree")
		cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorMatcher/static -B./Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorMatcher/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleNonFreeOpenCV/tests/SolARDescriptorMatcher/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"SolARHomographyEstimationNonFree")
		cmake -H../../sources/Modules/SolARModuleNonFreeOpenCV/tests/SolARHomographyEstimation/static -B./Modules/SolARModuleNonFreeOpenCV/tests/SolARHomographyEstimation/static -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd Modules/SolARModuleNonFreeOpenCV/tests/SolARHomographyEstimation/static
		cmake --build . --config $BUILDCONFIG
		cd ../../../../../
		;;
	"UnitTests")
		cmake -H../../sources/SolARTests/unittests/ModuleLoading -B./SolARTests/unittests/ModuleLoading -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd SolARTests/unittests/ModuleLoading
		cmake --build . --config $BUILDCONFIG	
		cd ../../../
		##
		cmake -H../../sources/SolARTests/unittests/ComponentLoading -B./SolARTests/unittests/ComponentLoading -G "$GENERATOR" -DCMAKE_BUILD_TYPE=$BUILDCONFIG
		cd SolARTests/unittests/ComponentLoading
		cmake --build . --config $BUILDCONFIG
		cd ../../../
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
  echo "$0 [target to build]"
  echo "ex : $0 SolARFramework"
  echo "ex : $0 all (to build all targets)"
  echo "ex : $0 clean (to delete build folder)"
  echo "ex : $0 list (to list all targets)"
  exit -1
fi


TARGET=$1
if [ $TARGET != "clean" ] && [ $TARGET != "list" ]; then
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
	elif [[ "$OSTYPE" = *"linux"* ]]; then
		generator="Unix Makefiles"
	fi

fi
mkdir -p build
cd build

case "$TARGET" in
	"all" )
		# release
		buildTargets release "$generator" SolARFramework
		buildTargets release "$generator" SolARModuleOpenCV
		buildTargets release "$generator" SolARModuleNonFreeOpenCV
		buildTargets release "$generator" SolARModuleTools
		buildTargets release "$generator" NaturalImageMarker
		buildTargets release "$generator" FiducialMarker
		buildTargets release "$generator" Sample-Slam
		buildTargets release "$generator" Sample-Triangulation
		# tests "free"
		buildTargets release "$generator" SolARCameraCalibration
		buildTargets release "$generator" SolARDescriptorMatcher
		buildTargets release "$generator" SolARImageConvertor
		buildTargets release "$generator" SolARImageLoader
		#buildTargets release "$generator" SolARSVDtriangulation
		# tests "non free"
		buildTargets release "$generator" SolARDescriptorExtractorNonFree
		buildTargets release "$generator" SolARDescriptorMatcherNonFree
		buildTargets release "$generator" SolARHomographyEstimationNonFree
		# unit tests
		buildTargets release "$generator" UnitTests

		# debug
		buildTargets debug "$generator" SolARFramework
		buildTargets debug "$generator" SolARModuleOpenCV
		buildTargets debug "$generator" SolARModuleNonFreeOpenCV
		buildTargets debug "$generator" SolARModuleTools
		buildTargets debug "$generator" NaturalImageMarker
		buildTargets debug "$generator" FiducialMarker
		buildTargets debug "$generator" Sample-Slam		
		buildTargets debug "$generator" Sample-Triangulation
		# tests "free"
		buildTargets debug "$generator" SolARCameraCalibration
		buildTargets debug "$generator" SolARDescriptorMatcher
		buildTargets debug "$generator" SolARImageConvertor
		buildTargets debug "$generator" SolARImageLoader
		#buildTargets debug "$generator" SolARSVDtriangulation
		# tests "non free"
		buildTargets debug "$generator" SolARDescriptorExtractorNonFree
		buildTargets debug "$generator" SolARDescriptorMatcherNonFree
		buildTargets debug "$generator" SolARHomographyEstimationNonFree		
		# unit tests
		buildTargets debug "$generator" UnitTests
		;;
	"clean")
		cd ..
		rm -rf build
		;;
	"list")
		echo "Available targets:"
		echo "(Framework) 		SolARFramework" 
		echo "(Modules) 		SolARModuleOpenCV, SolARModuleNonFreeOpenCV, SolARModuleTools"		
		echo "(Simple Samples)	SolARCameraCalibration, SolARDescriptorMatcher, SolARImageConvertor, SolARImageLoader, SolARSVDtriangulation"
		echo "(RA Samples)		NaturalImageMarker, FiducialMarker, Sample-Slam, Sample-Triangulation"
		echo "(Unit Tests)		UnitTests"
		;;
	*)
		buildTargets release "$generator" $TARGET
		buildTargets debug "$generator" $TARGET
		;;
esac

