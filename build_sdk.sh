#!/bin/sh

cd sdk/.dotnet
tar zxfv ../../runtime/artifacts/packages/Release/Shipping/dotnet-runtime-6.0.0-freebsd-x64.tar.gz
cd ../..

sdk/build.sh -ci /p:OfficialBuildId=20211105.99 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=20211105.99 -c Release
