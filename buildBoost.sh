#!/bin/bash -e

set -x

echo "LET'S BUILD BOOST"
pkgDirName="boost"
pkgVersion="1.68.0"

# git clone --recursive -b develop https://github.com/boostorg/boost.git
# taken from https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz

# prepare
#git clone -b develop ssh://gitolite@forge.b-com.com/sft/SCRIPTS/sft-tools.git sft-tools
mkdir -p build
mkdir -p install/$pkgDirName/debug &&  mkdir -p install/$pkgDirName/release

#cp sources/bcom-boost.pc install/$pkgDirName/debug
#cp sources/bcom-boost.pc install/$pkgDirName/release
mkdir -p packages
#mkdir -p artifactory

# build
cd boost
./bootstrap.sh --prefix=../install/$pkgDirName/debug --libdir=../install/$pkgDirName/debug/lib --includedir=../install/$pkgDirName/debug/include
./b2 cxxflags="-std=c++14" --build-dir=../build/ -j 8 variant=debug link=shared --layout=system install
./b2 --clean
./bootstrap.sh --prefix=../install/$pkgDirName/release --libdir=../install/$pkgDirName/release/lib --includedir=../install/$pkgDirName/release/include
./b2 cxxflags="-std=c++14" --build-dir=../build -j 8 link=shared --layout=system install
./b2 --clean


# package
cd ..
#sft-tools/xplatform/bcom-packager.pl -s install/$pkgDirName/debug -d packages -p $pkgDirName -v $pkgVersion -m debug -i install/$pkgDirName/debug/include -l install/$pkgDirName/debug/lib -u
#sft-tools/xplatform/bcom-packager.pl -s install/$pkgDirName/release -d packages -p $pkgDirName -v $pkgVersion -m release -i install/$pkgDirName/release/include -l install/$pkgDirName/release/lib -
