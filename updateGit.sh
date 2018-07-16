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
	updateGit $1
	cd $CURRENTDIR
	echo ""
done


# Samples
samples=`find sources/Samples/ -mindepth 1 -maxdepth 1 -type d`
for sample in $samples
do
	cd $sample
	updateGit $1
	cd $CURRENTDIR
	echo ""
done

# Unit Tests
cd sources/SolARTests
updateGit $1
cd $CURRENTDIR