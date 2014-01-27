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

#sed "/cat/ { N; s/    } else if (cmd == CAMERA_CMD_METADATA_ON) {\n/#if 0\n&/ }" frameworks/av/services/camera/libcameraservice/api1/CameraClient.cpp
# frameworks/av patch
## //TODO: Simplify this :\

awk '$0 == "    } else if (cmd == CAMERA_CMD_METADATA_ON) {" && c == 0 {c = 1; print "#if 0"}; {print}' \
	frameworks/av/services/camera/libcameraservice/api1/CameraClient.cpp > frameworks/av/services/camera/libcameraservice/api1/CameraClient1.cpp;

awk '$0 == "        mLongshotEnabled = false;" && c == 0 {c = 1; print "#endif"}; {print}' \
	frameworks/av/services/camera/libcameraservice/api1/CameraClient1.cpp > frameworks/av/services/camera/libcameraservice/api1/CameraClient2.cpp;

rm frameworks/av/services/camera/libcameraservice/api1/CameraClient.cpp;
rm frameworks/av/services/camera/libcameraservice/api1/CameraClient1.cpp;
mv frameworks/av/services/camera/libcameraservice/api1/CameraClient2.cpp frameworks/av/services/camera/libcameraservice/api1/CameraClient.cpp; 
