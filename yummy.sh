#!/bin/bash

## Tra la la la la!

### just hope this makes my work easier :)
#### Make this as close as possible to manual patching, so that we don't
##### have to worry about upstream changes :)

WORKING_DIR=`basename $PWD`
ACTUAL_DIR=cyanogenmod-11.0;

if [ $WORKING_DIR != $ACTUAL_DIR ]
then
cd ../../../;
fi;

if [ "$1" == "init" ]; then

cd build;

#TMP_FLAG=`git remote -v | grep -q legacy && echo $?`
if `git remote -v | grep -q legacy`
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
if `git remote -v | grep -q legacy`
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
if `git remote -v | grep -q legacy`
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


TMP_LINE=`grep -n "        rc = camera->sendCommand(CAMERA_CMD_LONGSHOT_ON, 0, 0);" frameworks/base/core/jni/android_hardware_Camera.cpp | cut -f1 -d:`
TMP_LINE=$(($TMP_LINE-1))
awk -v n=$TMP_LINE -v s="#if 0" 'NR == n {print s} {print}' frameworks/base/core/jni/android_hardware_Camera.cpp > frameworks/base/core/jni/android_hardware_Camera1.cpp
rm frameworks/base/core/jni/android_hardware_Camera.cpp

TMP_LINE=`grep -n "        rc = camera->sendCommand(CAMERA_CMD_LONGSHOT_OFF, 0, 0);" frameworks/base/core/jni/android_hardware_Camera1.cpp | cut -f1 -d:`
TMP_LINE=$(($TMP_LINE+2))
awk -v n=$TMP_LINE -v s="#endif" 'NR == n {print s} {print}' frameworks/base/core/jni/android_hardware_Camera1.cpp > frameworks/base/core/jni/android_hardware_Camera2.cpp
rm frameworks/base/core/jni/android_hardware_Camera1.cpp

TMP_LINE=`grep -n "        rc = camera->sendCommand(CAMERA_CMD_METADATA_ON, 0, 0);" frameworks/base/core/jni/android_hardware_Camera2.cpp | cut -f1 -d:`
TMP_LINE=$(($TMP_LINE-1))
awk -v n=$TMP_LINE -v s="#if 0" 'NR == n {print s} {print}' frameworks/base/core/jni/android_hardware_Camera2.cpp > frameworks/base/core/jni/android_hardware_Camera3.cpp
rm frameworks/base/core/jni/android_hardware_Camera2.cpp

TMP_LINE=`grep -n "        rc = camera->sendCommand(CAMERA_CMD_METADATA_OFF, 0, 0);" frameworks/base/core/jni/android_hardware_Camera3.cpp | cut -f1 -d:`
TMP_LINE=$(($TMP_LINE+1))
awk -v n=$TMP_LINE -v s="#endif" 'NR == n {print s} {print}' frameworks/base/core/jni/android_hardware_Camera3.cpp > frameworks/base/core/jni/android_hardware_Camera4.cpp
rm frameworks/base/core/jni/android_hardware_Camera3.cpp

mv frameworks/base/core/jni/android_hardware_Camera4.cpp frameworks/base/core/jni/android_hardware_Camera.cpp

fi;

if [ "$1" == "cleanup" ]; then
cd frameworks/av;
git reset --hard;
cd ../base;
git reset --hard;
cd ../../;
fi;

if [ "$1" == "" ]; then
echo "Nothing to do";
fi;

if [ "$1" == "help" ]; then
echo "yummy.sh [init|cleanup|help]";
fi;
