#!/bin/bash -e
set -x
myRepo=$(pwd)

echo "LET'S BUILD OPENCV"
echo "Select Release"
read OPENCVRELEASE

echo "Select Generator"
if [ "$OSTYPE" == "msys" ]; then
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

mkdir -p Build
mkdir -p Build/opencv
mkdir -p Install
mkdir -p Install/opencv
mkdir -p Build/opencv_contrib


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

RepoSource=opencv
pushd Build/$RepoSource
CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF  -DWITH_CUDA:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_DEBUG_POSTFIX='
cmake -G"$CMAKE_CONFIG_GENERATOR" $CMAKE_OPTIONS -DCMAKE_INSTALL_PREFIX="$myRepo"/install/"$RepoSource" "$myRepo/$RepoSource"
echo "************************* $Source_DIR -->debug"
#cmake --build .  --config debug
echo "************************* $Source_DIR -->release"
#cmake --build .  --config release
#cmake --build .  --target install --config release
cmake --build .  --target install --config debug
popd

cd Install/opencv
mkdir -p packaging
cd packaging
mkdir -p opencv
cd opencv
mkdir -p $OPENCVRELEASE
cd $OPENCVRELEASE
mkdir -p interfaces
mkdir -p lib
mkdir -p lib/x86_64
mkdir -p lib/x86_64/shared
mkdir -p lib/x86_64/shared/debug
mkdir -p lib/x86_64/shared/release
cd ../../../
cp -r include/opencv* packaging/opencv/3.4.3/interfaces/
if [ "$OSTYPE" == "msys" ]; then
    cp x64/vc15/lib/opencv*.lib packaging/opencv/3.4.3/lib/x86_64/shared/release/
    mv packaging/opencv/3.4.3/lib/x86_64/shared/release/*d.lib packaging/opencv/3.4.3/lib/x86_64/shared/debug/
    cp x64/vc15/bin/opencv_*.dll packaging/opencv/3.4.3/lib/x86_64/shared/release/
    mv packaging/opencv/3.4.3/lib/x86_64/shared/release/*d.dll packaging/opencv/3.4.3/lib/x86_64/shared/debug/

fi




