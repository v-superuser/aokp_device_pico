#!/bin/bash

## Tra la la la la!

### just hope this makes my work easier :)

WORKING_DIR=`basename $PWD`
ACTUAL_DIR=cyanogenmod-11.0;

if [ $WORKING_DIR != $ACTUAL_DIR ]
then
cd ../../../;
fi;

cd build;

if `git remote -v | grep -Fxq "legacy"`
then
#good to go!
echo "Good to go! patching android_build"
else
echo "Adding remote legacy for android_build"
git remote add legacy git@github.com:legaCyMod/android_build.git;
fi;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;

cd ../;

cd frameworks/av;
if `git remote -v | grep -Fxq "legacy"`
then
#good to go!
echo "Good to go! patching android_frameworks_av"
else
echo "Adding remote legacy for android_frameworks_av"
git remote add legacy git@github.com:legaCyMod/android_frameworks_av.git;
fi;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;

cd ../../;

cd vendor/cm;
if `git remote -v | grep -Fxq "legacy"`
then
#good to go!
echo "Good to go! patching android_vendor_cm"
else
echo "Adding remote legacy for android_vendor_cm"
git remote add legacy git@github.com:legaCyMod/android_vendor_cm.git;
fi;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;
cd ../../;

