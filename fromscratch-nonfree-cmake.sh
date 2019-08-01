#!/bin/bash

set -e
echo "Do you wish to install 3rd parties libraries?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) answer=yes; break;;
        No ) answer=no; break;;
    esac
done


echo "CLEAN BUILD FILES AND OLD SOURCES"
rm -rf tests tools sources build

echo
if [ "$OSTYPE" == "msys" ]; then
	mkdir -p "C:/SolARFramework/"
	mkdir -p "C:/SolARFramework/SolARLibraries"
	export BCOMDEVROOT="C:/SolARFramework/SolARLibraries"
fi
else
	mkdir -p ~/SolARFramework
	mkdir -p ~/SolARFramework/SolARLibraries
	export BCOMDEVROOT=~/SolARFramework/SolARLibraries
fi
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
git clone -b develop git@github.com:SolarFramework/SolARModuleFBOW.git
git clone -b develop git@github.com:SolarFramework/SolARModuleCeres.git
git clone -b develop git@github.com:SolarFramework/SolARModuleOpenGV.git
git clone -b develop git@github.com:SolarFramework/SolARPipelineManager.git
git clone -b develop git@github.com:SolarFramework/SolARUnityPlugin.git

cd ..

mkdir -p Samples
cd Samples
git clone -b develop git@github.com:SolarFramework/NaturalImageMarker.git
git clone -b develop git@github.com:SolarFramework/FiducialMarker.git
git clone -b develop git@github.com:SolarFramework/Sample-Slam.git
git clone -b develop git@github.com:SolarFramework/Sample-Triangulation.git
cd ..

git clone -b develop git@github.com:SolarFramework/SolARTests.git
cd ..

./build-scripts/cmake-build.sh all
