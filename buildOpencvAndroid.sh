#!/bin/bash
#set -x
myRepo=$(pwd)

###### CONFIG

TOOLCHAIN="-DCMAKE_TOOLCHAIN_FILE=/home/azdine/Android/android-ndk-r18b/build/cmake/android.toolchain.cmake -DANDROID_NDK_X64=TRUE -DANDROID_SDK=/home/azdine/Android/Sdk/  -DANDROID_NDK_X64=TRUE -DANDROID_ABI=arm64-v8a -DCMAKE_CXX_STANDARD=11 -DANDROID_PLATFORM=android-25 -DCMAKE_ANDROID_STL_TYPE=c++_shared -DBUILD_SHARED_LIBS=TRUE  -DBUILD_opencv_world=TRUE -DBUILD_PERF_TESTS=FALSE -DBUILD_ANDROID_PROJECTS=OFF"

echo "LET'S BUILD OPENCV"
if [ $# -lt 1 ]; then
	echo "Select Release (.e.g \"3.4.3\")"
	read OPENCVRELEASE
else
	OPENCVRELEASE=$1 # first argument is git tag or commit id
fi

echo "FREE or NONFREE ?"
read FREEORNONFREE
if [ "$FREEORNONFREE" == "NONFREE" ]; then
    CMAKE_OPTIONS="$TOOLCHAIN -DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF -DBUILD_opencv_hdf=OFF -DWITH_VTK=OFF -DWITH_CUDA:BOOL=OFF -DWITH_GSTREAMER=OFF -DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_DEBUG_POSTFIX=  -DOPENCV_EXTRA_MODULES_PATH=$myRepo/opencv_contrib/modules -DOPENCV_ENABLE_NONFREE=ON -DBUILD_opencv_sfm=OFF -DWITH_EIGEN=OFF"
else
    CMAKE_OPTIONS="$TOOLCHAIN -DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF  -DBUILD_opencv_hdf=OFF -DWITH_VTK=OFF -DWITH_CUDA:BOOL=OFF -DWITH_GSTREAMER=OFF -DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_DEBUG_POSTFIX="
fi

if [ $# -lt 2 ]; then
	if [ "$OSTYPE" == "msys" ]; then
	    echo "Select Generator"
	    options=("Visual Studio 15 2017 Win64" "Visual Studio 14 2015 Win64" "Visual Studio 12 2013 Win64" "NMake Makefiles" "NMake Makefiles JOM" "Ninja")

	    select opt in "${options[@]}"; do
	        case $opt in
	            "Visual Studio 15 2017 Win64" ) CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64"; break;;
	            "Visual Studio 14 2015 Win64" ) CMAKE_CONFIG_GENERATOR="Visual Studio 14 2015 Win64"; break;;
	            "Visual Studio 12 2013 Win64" ) CMAKE_CONFIG_GENERATOR="Visual Studio 12 2013 Win64"; break;;
	            "NMake Makefiles" ) CMAKE_CONFIG_GENERATOR="NMake Makefiles"; break;;
	            "NMake Makefiles JOM" ) CMAKE_CONFIG_GENERATOR="NMake Makefiles JOM"; break;;
	            "Ninja" ) CMAKE_CONFIG_GENERATOR="Ninja"; break;;
	        esac
	    done
	elif [[ "$OSTYPE" = *"linux"* ]]; then
	    CMAKE_CONFIG_GENERATOR="Unix Makefiles"
	fi
else
	CMAKE_CONFIG_GENERATOR=$2  # second argument as generator, e.g "Ninja"	
fi

rm -rf Build
mkdir -p Build
mkdir -p Build/opencv
mkdir -p Build/opencv_contrib


###### CLONE GIT REPOSITORIES

#CMAKE_CONFIG_GENERATOR="Visual Studio 14 2015 Win64"
if [  ! -d "$myRepo/opencv"  ]; then
    echo "cloning opencv"
    git clone -b $OPENCVRELEASE https://github.com/opencv/opencv.git
else
    cd opencv
    git fetch
    git checkout $OPENCVRELEASE
    cd ..
fi
if [  ! -d "$myRepo/opencv_contrib"  ]; then
    echo "cloning opencv_contrib"
    git clone -b $OPENCVRELEASE  https://github.com/opencv/opencv_contrib.git
else
    cd opencv_contrib
    git fetch
    git checkout $OPENCVRELEASE
    cd ..
fi
RepoSource=opencv



echo "Build debug (y/N)?"
read BUILDDEBUG
if [ "$BUILDDEBUG" == "y" ]; then
    ## DEBUG ################""
    pushd Build/$RepoSource
    #CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF -DWITH_VTK=OFF -DWITH_CUDA:BOOL=OFF WITH_GSTREAMER=OFF-DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_DEBUG_POSTFIX='
    cmake -G"$CMAKE_CONFIG_GENERATOR" $CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="$myRepo"/install/"$RepoSource" "$myRepo/$RepoSource"
    echo "************************* $Source_DIR -->debug"
    cmake --build .  --config debug
    cmake --build .  --target install --config debug
    cmake --build .  --target clean
    popd
    mv install/opencv install/opencv-$FREEORNONFREE-$OPENCVRELEASE-debug
fi


echo "Build release (y/N)?"
read BUILDRELEASE
if [ "$BUILDRELEASE" == "y" ]; then
    ## RELEASE ################""
    pushd Build/$RepoSource
    #CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF -DWITH_VTK=OFF -DWITH_CUDA:BOOL=OFF WITH_GSTREAMER=OFF-DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_DEBUG_POSTFIX='
    cmake -G"$CMAKE_CONFIG_GENERATOR" $CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$myRepo"/install/"$RepoSource" "$myRepo/$RepoSource"
    echo "************************* $Source_DIR -->release"
    cmake --build .  --config release
    cmake --build .  --target install --config release
    cmake --build .  --target clean
    popd
    mv install/opencv install/opencv-$FREEORNONFREE-$OPENCVRELEASE-release
fi
