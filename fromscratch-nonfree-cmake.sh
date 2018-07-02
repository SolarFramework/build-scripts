#!/bin/bash

set -e
set -x

echo "Do you wish to install 3rd parties libraries? (opencv 3.2.0, boost 1.64.0, eigen 3.3.4, xpcf 1.0, spdlog 0.14.0?)"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) answer=yes; break;;
        No ) answer=no; break;;
    esac
done


echo "CLEAN BUILD FILES AND OLD SOURCES"
rm -rf tests tools sources build

echo
rm -rf $BCOMDEVROOT/builddefs
rm -rf $BCOMDEVROOT/builddefs/qmake
git clone https://github.com/b-com-software-basis/builddefs-qmake.git $BCOMDEVROOT/builddefs/qmake
mkdir -p tools
mkdir -p sources
cd tools

if [ $answer == "yes" ]; then 
	echo
	echo "GET DEPENDENCIES"
	echo "PLEASE ENTER YOUR ARTIFACTORY KEY"
	read artifactoryApiKey 
	curl -L https://raw.githubusercontent.com/SolarFramework/binaries/master/packagedependencies-bcom.txt -o packagedependencies.txt
	curl -L https://github.com/SolarFramework/binaries/releases/download/pkgm-bcom%2F1.0.0%2Fmulti/pkgm-1.0.0-fat.jar -o pkgm-1.0.0-fat.jar
	java -jar pkgm-1.0.0-fat.jar install -a x86_64 -c release -m shared -k $artifactoryApiKey -f packagedependencies.txt 
	java -jar pkgm-1.0.0-fat.jar install -a x86_64 -c debug -m shared -k $artifactoryApiKey -f packagedependencies.txt	
fi

cd ..
cd sources


echo "GET SOURCES"

git clone -b develop git@github.com:SolarFramework/SolARFramework.git
mkdir -p Modules
cd Modules
git clone -b develop git@github.com:SolarFramework/SolARModuleOpenCV.git
git clone -b develop git@github.com:SolarFramework/SolARModuleNonFreeOpenCV.git
git clone -b develop git@github.com:SolarFramework/SolARModuleTools.git
cd ..

mkdir -p Samples
cd Samples
git clone -b develop git@github.com:SolarFramework/NaturalImageMarker.git
git clone -b develop git@github.com:SolarFramework/FiducialMarker.git
cd ..

git clone -b develop git@github.com:SolarFramework/SolARTests.git
cd ..

./build-scripts/cmake-build.sh all