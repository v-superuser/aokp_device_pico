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
echo "Good to go! patching build"
else
echo "Adding remote legacy for android_build"
git remote add legacy git@github.com:legaCyMod/android_build.git;
fi;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;

cd ../;

cd frameworks/av;
git remote add legacy git@github.com:legaCyMod/android_frameworks_av.git;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;

cd ../../;

cd vendor/cm;
git remote add legacy git@github.com:legaCyMod/android_vendor_cm.git;
git fetch legacy cm-11.0;
git merge FETCH_HEAD;
cd ../../;

