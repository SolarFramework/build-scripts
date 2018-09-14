#!/bin/bash
set -e
GREEN='\033[0;32m\033[1m'  # green bold
NC='\033[0m' # No Color
ARGOPATH=$PWD

function makeAndInstallDebug()
{
  cd $BUILDPATH
  mkdir -p $1
  cd $1
  echo "$QMAKE_DEBUG "$ARGOPATH/$2""
  $QMAKE_DEBUG "$ARGOPATH/$2"
  $MAKE $3
  $INSTALL
  cd $ARGOPATH
}

function makeAndInstallRelease()
{
  cd $BUILDPATH
  mkdir -p $1
  cd $1
  $QMAKE_RELEASE "$ARGOPATH/$2"
  $MAKE $3
  $INSTALL
  cd $ARGOPATH
}


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <mode> <what to build> <path to .pro>"
    echo "mode: debug or release"
    echo "path to .pro : relative path to .pro file"
    exit
fi

mkdir -p build
mkdir -p build/debug
mkdir -p build/release
if [ "$1" == "release" ]; then
  BUILDPATH="build/release"
  #cd build/release
  makeAndInstall="makeAndInstallRelease"
  MAKEFILE="-f Makefile.Release"
  export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.4.3/lib/x86_64/shared/release/:$BCOMDEVROOT/thirdParties/boost/1.68.0/lib/x86_64/shared/release/:$LD_LIBRARY_PATH
  #echo "export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.4.3/lib/x86_64/shared/release/:$BCOMDEVROOT/thirdParties/boost/1.68.0/lib/x86_64/shared/release/:$LD_LIBRARY_PATH" > $BUILDPATH/bin/README

else
  #cd build/debug
  BUILDPATH="build/debug"
  makeAndInstall="makeAndInstallDebug"
  MAKEFILE="-f Makefile.Debug"
  export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.4.3/lib/x86_64/shared/debug/:$BCOMDEVROOT/thirdParties/boost/1.68.0/lib/x86_64/shared/debug/:$LD_LIBRARY_PATH
  #echo "export LD_LIBRARY_PATH=./:$BCOMDEVROOT/thirdParties/opencv/3.4.3/lib/x86_64/shared/debug/:$BCOMDEVROOT/thirdParties/boost/1.68.0/lib/x86_64/shared/debug/:$LD_LIBRARY_PATH" > $BUILDPATH/bin/README
fi


if [ "$OSTYPE" == "msys" ]; then
  # $OSTYPE is msys
  QTKEY="HKEY_CLASSES_ROOT\Applications\QtProject.QtCreator.c\shell\Open\Command"
  QTREG=`reg query $QTKEY`
  QTJOMPATH=${QTREG:105:-27}
  QTJOMPATH=${QTJOMPATH//\\/\/} # replace \ with /
  QTROOT=${QTJOMPATH:0: -19}
  QMAKE_EXE=`find "$QTROOT" -wholename *qmake.exe | sort -r -z | head -n 1`
  QMAKE_EXE=${QMAKE_EXE//\\/\/} # replace \ with /
  QMAKE_EXE=${QMAKE_EXE/C:/\/C} # replace C:\ with /C


  JOM_EXE=$QTJOMPATH/jom.exe
  VISUALROOT=${VS140COMNTOOLS:0: -14}
  VISUALROOT=${VISUALROOT//\\/\/} # replace \ with /
  VISUALROOT=${VISUALROOT/C:/\/C} # replace C:\ with /C
  RC_EXE=`find "/c/Program Files (x86)/Windows Kits" -wholename "*x64*rc.exe" | sort -s -r | head -n 1`
  RCPATH=${RC_EXE:0: -6}  
  export PATH="$VISUALROOT/VC/bin/amd64/":"$RCPATH":$PATH # link.exe path
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
  MAKE="make" 
  INSTALL="make install"
fi

echo "${GREEN} ##### BUILDING $2 ####${NC} "
echo "$makeAndInstall $2 $3"
$makeAndInstall $2 $3
