#!/bin/bash


if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "$0 [path to versions.txt file]"
  exit -1
fi

VERSIONSFILE=$1		# input file : versions.txt
WITHWARNING=0		# 1 to print warnings
DONOTHING=0			# 1 to display current versions only

# read required versions
declare -A ARRAYVER

while read line; do
	componentName=`echo $line | cut -d "|" -f1`
	componentVersion=`echo $line | cut -d "|" -f2`
	ARRAYVER[$componentName]=$componentVersion
	#echo ">>>>> ARRAYVER[$componentName]=$componentVersion"
	echo "$componentName will be set to version $componentVersion"
done < $VERSIONSFILE



# update all sources repositories
# update function
function updateVersion()
{

	repo_fullname=`git rev-parse --show-toplevel`
	repo_name=`basename $repo_fullname`

	# find directories containting a CMakeLists.txt file
	directories=`find . -name "CMakeLists.txt" -printf '%h\n'`
	processedDir=`pwd`
	for directory in $directories
	do
		#echo "##### PROCESSING $directory"
		cd $directory
		current=`pwd`
		# get current version
		if [ -f CMakeLists.txt ]; then
			project=`grep "project(" CMakeLists.txt | cut -d '"' -f2`
			versionline=`grep "set (VERSION_NUMBER" CMakeLists.txt`
			version=`echo $versionline | cut -d'"' -f2`
			if [[ $version == "" ]]; then
				if [[ $WITHWARNING == "1" ]]; then
					echo "(WARN) CMakeLists.txt contains no version number in $current"
				fi
			else
				echo ""
				echo "$project is in version $version"

				# CHANGE VERSION NUMBER HERE - interactive mode if versions.txt does not contain version number for component
				if [[ $DONOTHING == "0" ]]; then


					if [[ ${ARRAYVER[$project]} == "" ]]; then
						echo "enter new version:"
						read newversion
					else
						newversion=${ARRAYVER[$project]}		
						echo ">>>> Changing $project version number to $newversion"
					fi

					# change in CMakeLists.txt
					sed -i -e "s/VERSION_NUMBER\s\"[0-9]\.[0-9]\.[0-9]\"/VERSION_NUMBER \"$newversion\"/g" CMakeLists.txt > /dev/null

					# change in .pc.in
					sed -i -e "s/Version: [0-9]\.[0-9]\.[0-9]/Version: $newversion/g" *.pc.in > /dev/null 
					
					# change in .pro
					sed -i -e "s/VERSION=[0-9]\.[0-9]\.[0-9]/VERSION=$newversion/g" *.pro > /dev/null

					# change in all .xml
					xmlfiles=`find $SOURCEDIR -name "*.xml"`
					for xmlfile in $xmlfiles
					do
						sed -i -e "s/$project\/[0-9]\.[0-9]\.[0-9]/$project\/$newversion/g" $xmlfile
					done

					# change packagedependencies.txt in other repositories
					packagedepfiles=`find $SOURCEDIR -name "packagedependencies.txt"`
					for packagedepfile in $packagedepfiles
					do
						sed -i -e "s/$project|[0-9]\.[0-9]\.[0-9]/$project|$newversion/g" $packagedepfile
					done

				fi		
				# 
				####

			fi
		fi
		cd $processedDir
	done
}


SOURCEDIR=`pwd`
export PATH=$SOURCEDIR/build-scripts/:$PATH

# SolARFramework
cd sources/SolARFramework
updateVersion
cd $SOURCEDIR


# Modules
modules=`find sources/Modules -maxdepth 1 -type d -name "SolAR*"`
for module in $modules
do
	cd $module
	if [ -d .git ]; then
		updateVersion
	fi
	cd $SOURCEDIR	
done

# Samples
samples=`find sources/Samples/ -mindepth 1 -maxdepth 1 -type d`
for sample in $samples
do
	cd $sample
	if [ -d .git ]; then
		updateVersion
		echo ""
	fi
	cd $SOURCEDIR
done

# Unit Tests
cd sources/SolARTests
updateVersion
cd $SOURCEDIR



# ultimate change of all packagedependencies.txt
if [[ $DONOTHING == "0" ]]; then

	for comp in "${!ARRAYVER[@]}"
	do
		vers=${ARRAYVER[$comp]}
		packagedepfiles=`find $SOURCEDIR -name "packagedependencies.txt"`
		for packagedepfile in $packagedepfiles
		do
			sed -i -e "s/$comp|[0-9]\.[0-9]\.[0-9]/$comp|$vers/g" $packagedepfile
		done				
	done
fi