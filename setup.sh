#!/bin/bash
echo "Installing dextools..."
wget https://github.com/pxb1988/dex2jar/files/1850206/dex-tools-2.1-SNAPSHOT.zip
unzip dex-tools-2.1-SNAPSHOT.zip
mv dex-tools-2.1-SNAPSHOT dextools
rm dex-tools-2.1-SNAPSHOT.zip

echo "Downloading android jar..."
wget https://github.com/Sable/android-platforms/blob/master/android-17/android.jar?raw=true
