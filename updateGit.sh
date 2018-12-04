#!/bin/bash

CURRENTDIR=`pwd`
export PATH=$CURRENTDIR/build-scripts/:$PATH

# update all sources repositories

# update function
function updateGit()
{
	git fetch origin --prune
	checkout.sh . $1
	git pull origin `git rev-parse --symbolic-full-name --abbrev-ref HEAD`
}

# SolARFramework
cd sources/SolARFramework
updateGit $1
cd $CURRENTDIR

echo ""

# Modules
modules=`find sources/Modules -maxdepth 1 -type d -name "SolAR*"`
for module in $modules
do
	cd $module
	if [ -d .git ]; then
		updateGit $1
		echo ""
	fi
	cd $CURRENTDIR	
done


# Samples
samples=`find sources/Samples/ -mindepth 1 -maxdepth 1 -type d`
for sample in $samples
do
	cd $sample
	if [ -d .git ]; then
		updateGit $1
		echo ""
	fi
	cd $CURRENTDIR
done

# Unit Tests
cd sources/SolARTests
updateGit $1
cd $CURRENTDIR

# Summary to be sure everything is OK
echo ""
echo "### GIT REPOSITORIES AND THEIR CURRENT BRANCH:"

cd sources/SolARFramework
branch=`git rev-parse --abbrev-ref HEAD`
echo "Repository: sources/SolARFramework is on branch $branch"
cd $CURRENTDIR

for module in $modules
do
	cd $module
	if [ -d .git ]; then
		branch=`git rev-parse --abbrev-ref HEAD`
		echo "Repository: $module is on branch $branch"
	fi
	cd $CURRENTDIR
done

for sample in $samples
do
	cd $sample
	if [ -d .git ]; then
		branch=`git rev-parse --abbrev-ref HEAD`
		echo "Repository: $sample is on branch $branch"
	fi
	cd $CURRENTDIR
done

cd sources/SolARTests
branch=`git rev-parse --abbrev-ref HEAD`
echo "Repository: sources/SolARTests is on branch $branch"
cd $CURRENTDIR