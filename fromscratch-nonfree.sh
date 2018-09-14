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
git clone -b develop git@github.com:SolarFramework/SolARModuleOpenGL.git
cd ..

mkdir -p Samples
cd Samples
git clone -b develop git@github.com:SolarFramework/NaturalImageMarker.git
git clone -b develop git@github.com:SolarFramework/FiducialMarker.git
git clone -b develop git@github.com:SolarFramework/Sample-Triangulation.git
git clone -b develop git@github.com:SolarFramework/Sample-Slam.git
cd ..

echo "BUILD SOLAR FRAMEWORK"
echo
../build-scripts/solarbuild.sh release framework
../build-scripts/solarbuild.sh debug framework

echo "BUILD SOLAR MODULE OPENCV"
echo
../build-scripts/solarbuild.sh release moduleopencv
../build-scripts/solarbuild.sh debug moduleopencv

echo "BUILD SOLAR MODULE NON FREE OPENCV"
echo
../build-scripts/solarbuild.sh release modulenonfreeopencv
../build-scripts/solarbuild.sh debug modulenonfreeopencv

echo "BUILD SOLAR MODULE OPENCV TESTS"
echo
../build-scripts/solarbuild.sh release moduleopencvtests
../build-scripts/solarbuild.sh debug moduleopencvtests

echo "BUILD SOLAR MODULE NON FREE OPENCV TESTS"
echo
../build-scripts/solarbuild.sh release modulenonfreeopencvtests
../build-scripts/solarbuild.sh debug modulenonfreeopencvtests


echo "BUILD SOLAR MODULE TOOLS"
echo
../build-scripts/solarbuild.sh release moduletools
../build-scripts/solarbuild.sh debug moduletools

echo "BUILD SOLAR MODULE OPENGL"
echo
../build-scripts/solarbuild.sh release moduleopengl
../build-scripts/solarbuild.sh debug moduleopengl


echo "BUILD SOLAR FIDUCIAL MARKER SAMPLE"
echo
../build-scripts/solarbuild.sh release fiducialmarkersample
../build-scripts/solarbuild.sh debug fiducialmarkersample

echo "BUILD SOLAR NATURAL IMAGE MARKER SAMPLE"
echo
../build-scripts/solarbuild.sh release naturalimagemarkersample
../build-scripts/solarbuild.sh debug naturalimagemarkersample

echo "BUILD SOLAR TRIANGULATION SAMPLE"
echo
../build-scripts/solarbuild.sh release triangulationsample
../build-scripts/solarbuild.sh debug triangulationsample

echo "BUILD SOLAR SLAM SAMPLE"
echo
../build-scripts/solarbuild.sh release slamsample
../build-scripts/solarbuild.sh debug slamsample
