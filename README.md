# MCPE patch
Script to patch MCPE for android to allow access to XBOX login in patched APK.

Actual MCPE version: 1.4.1

## Setup
Before using you need to setup it:
```
./setup.sh
```
This will download the needed dependencies:
 - [dextools](https://github.com/pxb1988/dextools)
 - android.jar

## Patching
To patch:
```
./patch.sh [pre-patched apk file name]
```

"pre-patched" means that the APK does not need license in play market to work.

It will replace class in APK: "com.microsoft.onlineid.internal.Application".

## Licensing
```
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

Tarik02/mcpe-patch are not affiliated with Mojang. All brands and trademarks belong to their respective owners. mcpe-patch is not a Mojang-approved software, nor is it associated with Mojang.

