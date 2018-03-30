#!/bin/bash
function step {
	currentStepName=$1
	echo "$1..."
}

function fail {
	echo "Failed \"$currentStepName\""
	exit -1
}

runindir() { (cd "$1" && shift && eval "$@"); }


apk=$1;

if [[ ! -e $apk ]]; then
	echo "APK does not exist."
	exit 1
fi

tmpDir=$(realpath "tmp")
rm -r $tmpDir
mkdir $tmpDir

step "Copying APK"
cp $apk $tmpDir/original.apk

step "Extracting APK"
unzip $tmpDir/original.apk -d $tmpDir/apk

step "Converting classes.dex into jar"
./dextools/d2j-dex2jar.sh $tmpDir/apk/classes.dex -o $tmpDir/original.jar

step "Extracting JAR"
unzip $tmpDir/original.jar -d $tmpDir/jar

step "JAR stage 1: Modify"
rm $tmpDir/jar/com/microsoft/onlineid/internal/Applications.class

step "JAR stage 2: Compile"
cat << EOF > $tmpDir/Applications.java
package com.microsoft.onlineid.internal;

import android.content.Context;
import android.content.pm.Signature;
import android.util.Base64;
import com.microsoft.onlineid.analytics.ClientAnalytics;
import com.microsoft.onlineid.analytics.IClientAnalytics;
import com.microsoft.onlineid.internal.configuration.Settings;
import com.microsoft.onlineid.sts.Cryptography;
import java.security.MessageDigest;
import java.util.LinkedHashMap;
import java.util.Map;

public class Applications {
    public static String buildClientAppUri(Context paramContext, String paramString) {
        return "android-app://com.mojang.minecraftpe.H62DKCBHJP6WXXIV7RBFOGOL4NAK4E6Y";
    }
}

EOF
javac -classpath $tmpDir/jar:android.jar $tmpDir/Applications.java

step "JAR stage 3: Patch"
cp $tmpDir/Applications.class $tmpDir/jar/com/microsoft/onlineid/internal/Applications.class

step "JAR stage 4: Build"
runindir $tmpDir/jar "zip $tmpDir/patched.jar -r *"

step "Converting jar into classes.dex"
./dextools/d2j-jar2dex.sh $tmpDir/patched.jar -o $tmpDir/patched.dex

step "Patching APK"
cp $tmpDir/patched.dex $tmpDir/apk/classes.dex

step "Unsigning APK"
rm $tmpDir/apk/META-INF

step "Building APK"
runindir $tmpDir/apk "zip $tmpDir/patched.apk -r *"

step "Signing APK"
keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore $tmpDir/patched.apk alias_name

step "Copying APK"
cp $tmpDir/patched.apk patched.apk

step "Clearing"
rm -r $tmpDir
