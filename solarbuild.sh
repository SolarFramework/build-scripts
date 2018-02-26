#!/bin/bash
set -e
GREEN='\033[0;32m\033[1m'  # green bold
NC='\033[0m' # No Color
SOLARPATH=$PWD

function makeAndInstallDebug()
{
  cd $BUILDPATH
  mkdir -p $1
  cd $1
  if [ ! -f $SOLARPATH/$2 ]; then
    echo "Error: $SOLARPATH/$2 can not be found"
    exit
  fi
  $QMAKE_DEBUG "$SOLARPATH/$2"
  $MAKE $3
  $INSTALL
  cd $SOLARPATH
}

function makeAndInstallRelease()
{
  cd $BUILDPATH
  mkdir -p $1
  cd $1
  if [ ! -f $SOLARPATH/$2 ]; then
    echo "Error: $SOLARPATH/$2 can not be found"
    exit
  fi
  $QMAKE_RELEASE "$SOLARPATH/$2"
  $MAKE $3
  $INSTALL
  cd $SOLARPATH
}

function makeRelease()
{
  cd $BUILDPATH
  mkdir -p $1
  cd $1
  if [ ! -f $SOLARPATH/$2 ]; then
    echo "Error: $SOLARPATH/$2 can not be found"
    exit
  fi
  $QMAKE_RELEASE "$SOLARPATH/$2"
  $MAKE $3
  cd $SOLARPATH
}


if [ "$#" -ne 2 ]; then
  echo "Usage: build.sh <mode> <what to build>"
  echo "mode: debug or release"
  echo what to build : "framework", "moduleopencv", "modulenonfreeopencv", "moduleopencvtests", "moduletools", "xpcf", "unittests", "buildall"
  exit
fi

if [ "$OSTYPE" == "msys" ]; then
  # $OSTYPE is msys
  QTKEY1="HKEY_CLASSES_ROOT\Applications\qtcreator.exe\shell\Open\Command"
  QTKEY2="HKEY_CLASSES_ROOT\Applications\QtProject.QtCreator.c\shell\Open\Command"
  QTREG=`reg query $QTKEY1 2>/dev/null`  || QTREG=`reg query $QTKEY2`
  #QTJOMPATH=${QTREG:105:-27}
  QTREG1=${QTREG#*REG_SZ    }
  QTREG2=${QTREG1%.exe*}.exe
  QTREG3=${QTREG2//\"}
  QTJOMPATH=${QTREG3//\\/\/} # replace \ with /
  QTJOMPATH=${QTJOMPATH:0:-13}
  QTROOT=${QTJOMPATH:0: -21}
  QMAKE_EXE=`find "$QTROOT" -wholename *$VSVERSION*/bin/qmake.exe | sort -r -z | head -n 1`
  QMAKE_EXE=${QMAKE_EXE//\\/\/} # replace \ with /
  QMAKE_EXE=${QMAKE_EXE/C:/\/C} # replace C:\ with /C

  JOM_EXE=$QTJOMPATH/jom.exe
  RC_EXE=`find "/c/Program Files (x86)/Windows Kits" -wholename "*x64*rc.exe" | sort -s -r | head -n 1`
  RCPATH=${RC_EXE:0: -6}  
  # test if we have Visual 2015 or 2017
  if [ "${VS140COMNTOOLS}" ]  # VS 2015
  then 
    VISUALROOT=${VS140COMNTOOLS:0: -14}
    VISUALROOT=${VISUALROOT//\\/\/} # replace \ with /
    VISUALROOT=${VISUALROOT/C:/\/C} # replace C:\ with /C
    export PATH="$VISUALROOT/VC/bin/amd64/":"$RCPATH":$PATH # link.exe path    
  elif [ "${VS150COMNTOOLS}" ]  # VS 2017
  then
    VISUALROOT=${VS150COMNTOOLS:0: -14}
    VISUALROOT=${VISUALROOT//\\/\/} # replace \ with /
    VISUALROOT=${VISUALROOT/C:/\/C} # replace C:\ with /C
    LINK_EXE=`find "$VISUALROOT" -wholename "*x64*x64*link.exe" | sort -s -r | head -n 1`
    LINKPATH=${LINK_EXE:0: -8}
    export PATH="$LINKPATH":"$RCPATH":$PATH
  fi
 
  #echo $QMAKE_EXE
  #which link

  #echo $PATH
  QMAKE_SPEC=`"$QMAKE_EXE" -query QMAKE_SPEC`
  #QMAKE_DEBUG="$QMAKE_EXE -spec $QMAKE_SPEC CONFIG+=debug"
  QMAKE_DEBUG='eval "$QMAKE_EXE" -spec $QMAKE_SPEC CONFIG+=debug'
  QMAKE_RELEASE='eval "$QMAKE_EXE" -spec $QMAKE_SPEC CONFIG+=release'
  #QMAKE_RELEASE="$QMAKE_EXE -spec $QMAKE_SPEC CONFIG+=release"
  MAKE='eval "$JOM_EXE"'
  INSTALL='eval "$JOM_EXE" install'
else # a priori linux
  QMAKE_DEBUG='qmake -spec linux-g++ CONFIG+=debug'
  QMAKE_RELEASE='qmake -spec linux-g++ CONFIG+=release'
  MAKE="make -j4" 
  INSTALL="make install"
fi
WHATTOBUILD=$2

pwd
mkdir -p $SOLARPATH/../tests
mkdir -p $SOLARPATH/../build
mkdir -p $SOLARPATH/../build/debug
mkdir -p $SOLARPATH/../build/release
mkdir -p $SOLARPATH/../build/debug/bin
mkdir -p $SOLARPATH/../build/release/bin

if [ "$1" == "release" ]; then
  BUILDPATH="../build/release"
  #cd build/release
  makeAndInstall="makeAndInstallRelease"
  MAKEFILE="-f Makefile.Release"
  export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.2.0/lib/x86_64/shared/release/:$BCOMDEVROOT/thirdParties/boost/1.64.0/lib/x86_64/shared/release/:$LD_LIBRARY_PATH
  echo "export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.2.0/lib/x86_64/shared/release/:$BCOMDEVROOT/thirdParties/boost/1.64.0/lib/x86_64/shared/release/:$LD_LIBRARY_PATH" > $BUILDPATH/bin/README

else
  #cd build/debug
  BUILDPATH="../build/debug"
  makeAndInstall="makeAndInstallDebug"
  MAKEFILE="-f Makefile.Debug"
  export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.2.0/lib/x86_64/shared/debug/:$BCOMDEVROOT/thirdParties/boost/1.64.0/lib/x86_64/shared/debug/:$LD_LIBRARY_PATH
  echo "export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.2.0/lib/x86_64/shared/debug/:$BCOMDEVROOT/thirdParties/boost/1.64.0/lib/x86_64/shared/debug/:$LD_LIBRARY_PATH" > $BUILDPATH/bin/README
fi



case "$WHATTOBUILD" in
  "framework")
echo
echo "##### BUILDING SOLAR FRAMEWORK"
$makeAndInstall "SolARFramework" "SolARFramework/SolARFramework.pro"
echo -e "${GREEN} SolARFramework $1 is successfully built${NC}"
;;
"moduleopencv")
echo
echo "##### BUILDING SOLAR MODULE OPENCV"
$makeAndInstall "SolARModuleOpenCV" "Modules/SolARModuleOpenCV/SolARModuleOpenCV.pro"
echo -e "${GREEN} SolARModuleOpenCV $1 is successfully built${NC}"
;;
"modulenonfreeopencv")
echo
echo "##### BUILDING SOLAR MODULE OPENCV"
$makeAndInstall "SolARModuleNonFreeOpenCV" "Modules/SolARModuleNonFreeOpenCV/SolARModuleNonFreeOpenCV.pro"
echo -e "${GREEN} SolARModuleNonFreeOpenCV $1 is successfully built${NC}"
;;
"moduleopencvtests")
echo
echo "##### BUILDING SOLAR MODULE OPENCV TESTS"
$makeAndInstall "SolARCameraCalibration" "Modules/SolARModuleOpenCV/tests/SolARCameraCalibration/static/SolARCameraCalibration.pro"
echo -e "${GREEN} SolARCameraCalibration static $1 is successfully built${NC}"
$makeAndInstall "SolARDescriptorExtractorDynamic" "Modules/SolARModuleOpenCV/tests/SolARDescriptorExtractor/dynamic/SolARDescriptorExtractorOpenCVDynTest.pro"
echo -e "${GREEN} SolARDescriptorExtractor dynamic $1 is successfully built${NC}"
$makeAndInstall "SolARDescriptorExtractorStatic" "Modules/SolARModuleOpenCV/tests/SolARDescriptorExtractor/static/SolARDescriptorExtractorOpenCVStaticTest.pro"
echo -e "${GREEN} SolARDescriptorExtractor static $1 is successfully built${NC}"
$makeAndInstall "SolARDescriptorMatcherDynamic" "Modules/SolARModuleOpenCV/tests/SolARDescriptorMatcher/dynamic/SolARDescriptorMatcherOpenCVDynTest.pro"
echo -e "${GREEN} SolARDescriptorMatcher dynamic $1 is successfully built${NC}"
$makeAndInstall "SolARDescriptorMatcherStatic" "Modules/SolARModuleOpenCV/tests/SolARDescriptorMatcher/static/SolARDescriptorMatcherOpenCVStaticTest.pro"
echo -e "${GREEN} SolARDescriptorMatcher static $1 is successfully built${NC}"
$makeAndInstall "SolARFiducialMarkerStatic" "Modules/SolARModuleOpenCV/tests/SolARFiducialMarker/static/SolARMarker2DFiducialOpenCVStaticTest.pro"
echo -e "${GREEN} SolARFiducialMarkerStatic static $1 is successfully built${NC}"
$makeAndInstall "SolARImageConvertorDynamic" "Modules/SolARModuleOpenCV/tests/SolARImageConvertor/dynamic/SolARImageConvertorOpencvTest.pro"
echo -e "${GREEN} SolARImageConvertor dynamic $1 is successfully built${NC}"
$makeAndInstall "SolARImageLoaderDynamic" "Modules/SolARModuleOpenCV/tests/SolARImageLoader/dynamic/SolARImageOpenCVDynTest.pro"
echo -e "${GREEN} SolARImageLoader dynamic $1 is successfully built${NC}"
$makeAndInstall "SolARImageLoaderStatic" "Modules/SolARModuleOpenCV/tests/SolARImageLoader/static/SolARImageOpenCVStaticTest.pro"
echo -e "${GREEN} SolARImageLoader static $1 is successfully built${NC}"
$makeAndInstall "SolARNaturalImageMarkerDynamic" "Modules/SolARModuleOpenCV/tests/SolARNaturalImageMarker/dynamic/SolARNaturalImageMarkerOpenCVDynTest.pro"
echo -e "${GREEN} SolARNaturalImageMarker dynamic $1 is successfully built${NC}"
$makeAndInstall "SolARNaturalImageMarkerStatic" "Modules/SolARModuleOpenCV/tests/SolARNaturalImageMarker/static/SolARNaturalImageMarkerOpenCVStaticTest.pro"
echo -e "${GREEN} SolARNaturalImageMarker static $1 is successfully built${NC}"
$makeAndInstall "SolARHomographyEstimationStatic" "Modules/SolARModuleOpenCV/tests/SolARHomographyEstimation/static/SolARHomographyEstimationStaticTest.pro"
echo -e "${GREEN} SolARHomographyEstimation static $1 is successfully built${NC}"
;;
"moduletools")
echo
echo "##### BUILDING SOLAR MODULE TOOLS"
$makeAndInstall "SolARModuleTools" "Modules/SolARModuleTools/SolARModuleTools.pro"
echo -e "${GREEN} SolARModuleTools $1 is successfully built${NC}"
;;
"xpcf")
echo
echo "##### BUILDING XPCF"
$makeAndInstall "xpcf" "xpcf/xpcf.pro"
echo -e "${GREEN} xpcf is successfully built${NC}"
;;
"unittests")
echo
makeRelease unittests Modules/SolARModuleOpenCV/unittests/SolARModuleOpenCVUnitTests.pro
cd $SOLARPATH/../build/release/unittests
    # copy all images in unittests folder before running tests
    cp $SOLARPATH/Modules/SolARModuleOpenCV/tests/data/* .
    ./SolARModuleOpenCVUnitTests --log_format=JUNIT --log_level=all --report_level=no --log_sink=$SOLARPATH/../tests/SolARModuleOpenCVUnitTests.xml > /dev/null
    ;;
    "fiducialmarkersample")
echo
echo "##### BUILDING FIDUCIAL MARKER SAMPLE"
$makeAndInstall "Samples/FiducialMarkerDynamic" "Samples/FiducialMarker/Dynamic/SolARFiducialMarkerSampleDynamic.pro"
echo -e "${GREEN} Fiducial Marker Dynamic sample $1 is successfully built${NC}"
$makeAndInstall "Samples/FiducialMarkerStatic" "Samples/FiducialMarker/Static/SolARFiducialMarkerSampleStatic.pro"
echo -e "${GREEN} Fiducial Marker Static sample $1 is successfully built${NC}"
$makeAndInstall "Samples/FiducialMarkerSimple" "Samples/FiducialMarker/Simple/SolARFiducialMarkerSampleSimple.pro"
echo -e "${GREEN} Fiducial Marker Simple sample $1 is successfully built${NC}"
;;
"naturalimagemarkersample")
echo
echo "##### BUILDING NATURAL IMAGE MARKER SAMPLE"
$makeAndInstall "Samples/NaturalImageMarkerDynamic" "Samples/NaturalImageMarker/Dynamic/SolARNaturalImageMarkerDyn.pro"
echo -e "${GREEN} Natural Image Marker Dynamic sample $1 is successfully built${NC}"
$makeAndInstall "Samples/NaturalImageMarkerStatic" "Samples/NaturalImageMarker/Static/SolARNaturalImageMarkerStatic.pro"
echo -e "${GREEN} Natural Image Marker Static sample $1 is successfully built${NC}"
$makeAndInstall "Samples/NaturalImageMarkerSimple" "Samples/NaturalImageMarker/Simple/SolARNaturalImageMarkerSimple.pro"
echo -e "${GREEN} Natural Image Marker Simple sample $1 is successfully built${NC}"
;;
"buildall")
$0 $1 xpcf
$0 $1 framework
$0 $1 moduleopencv
$0 $1 modulenonfreeopencv
$0 $1 moduleopencvtests
$0 $1 moduletools
$0 $1 fiducialmarkersample
$0 $1 naturalimagemarkersample

find $BUILDPATH/ -name "lib*so*" -exec cp {}  $BUILDPATH/bin/ \;
find $BUILDPATH/ -name "*.dll" -exec cp {}  $BUILDPATH/bin/ \;
find $BUILDPATH -perm -u=x -type f -name "SolAR*" -exec cp {}  $BUILDPATH/bin/ \;
;;
*)
echo "###########################"
;;
esac
