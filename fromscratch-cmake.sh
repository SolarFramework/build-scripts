#!/bin/bash

set -e

echo "CLEAN BUILD FILES AND OLD SOURCES"
rm -rf tests tools sources build
echo
echo "GET DEPENDENCIES"
echo
rm -rf $BCOMDEVROOT/builddefs
rm -rf $BCOMDEVROOT/builddefs/qmake
git clone https://github.com/b-com-software-basis/builddefs-qmake.git $BCOMDEVROOT/builddefs/qmake
mkdir -p tools
mkdir -p sources
cd tools
curl -L https://raw.githubusercontent.com/SolarFramework/binaries/master/packagedependencies.txt -o packagedependencies.txt
curl -L https://github.com/SolarFramework/binaries/releases/download/pkgm-bcom%2F1.0.0%2Fmulti/pkgm-1.0.0-fat.jar -o pkgm-1.0.0-fat.jar
java -jar pkgm-1.0.0-fat.jar install -a x86_64 -c release -m shared -f packagedependencies.txt 
java -jar pkgm-1.0.0-fat.jar install -a x86_64 -c debug -m shared -f packagedependencies.txt
cd ..
cd sources


echo "GET SOURCES"

git clone -b develop git@github.com:SolarFramework/SolARFramework.git
mkdir -p Modules
cd Modules
git clone -b develop git@github.com:SolarFramework/SolARModuleOpenCV.git
git clone -b develop git@github.com:SolarFramework/SolARModuleTools.git
cd ..

mkdir -p Samples
cd Samples
git clone -b develop git@github.com:SolarFramework/NaturalImageMarker.git
git clone -b develop git@github.com:SolarFramework/FiducialMarker.git
cd ../..

./build-scripts/build-all.sh