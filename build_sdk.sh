#!/bin/sh

cd sdk/.dotnet
tar zxfv ../../runtime/artifacts/packages/Release/Shipping/dotnet-runtime-6.0.0-rc.2.21480.5-freebsd-x64.tar.gz
cd ../..

sdk/build.sh -ci /p:OfficialBuildId=20211005.11 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=20211005.11 -c Release
