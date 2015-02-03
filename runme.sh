#!/bin/sh

INPUT_FILE_NAME='Skype  4.4.507.41401'
WORK_FILE_NAME='1'
EYSTORE_PATH='/Users/niko/androidKeys/ReleaseChillingo.keystore'
KEYSTORE_PASS='anouk1234'
KEYSTORE_KEY='chillingo'
ZIPALIGN_PATH='/Users/niko/adt-bundle-mac-x86_64-20140702/sdk/build-tools/android-4.4W/zipalign'


################################################################################################
if [ ! -z $1 ]; then
    INPUT_FILE_NAME=$1
else
    echo workinng file - $INPUT_FILE_NAME
fi

LEN=${#INPUT_FILE_NAME}
TST=${INPUT_FILE_NAME:$LEN-4:4}
if [ $TST = '.apk' ]; then
    INPUT_FILE_NAME=${INPUT_FILE_NAME:0:$LEN-4}
fi

if [ ! -e "$INPUT_FILE_NAME"'.apk' ]; then 
    echo File $INPUT_FILE_NAME not found
    exit 1;
fi

cp "$INPUT_FILE_NAME"'.apk' "$WORK_FILE_NAME"'.apk'
mv "$INPUT_FILE_NAME"'.apk' "$INPUT_FILE_NAME"'_original.apk'

java -jar apktool_2.0.0rc2.jar d -s -b -m "$WORK_FILE_NAME"'.apk'
mcedit "$WORK_FILE_NAME"/AndroidManifest.xml
java -jar apktool_2.0.0rc2.jar b "$WORK_FILE_NAME"
cp "$WORK_FILE_NAME"/dist/"$WORK_FILE_NAME"'.apk' "$WORK_FILE_NAME"'.apk'

jarsigner -sigalg MD5withRSA -digestalg SHA1  -keystore $KEYSTORE_PATH -storepass $KEYSTORE_PASS -keypass $KEYSTORE_PASS -sigfile CERT   $WORK_FILE_NAME'.apk' $KEYSTORE_KEY
exit 22
$ZIPALIGN_PATH  4 "$WORK_FILE_NAME"'.apk' "$WORK_FILE_NAME"'_SIGNED_ALIGNED.apk'


mv "$WORK_FILE_NAME"'_SIGNED_ALIGNED.apk' "$INPUT_FILE_NAME"'.apk'
