#!/bin/sh

mkdir -p installer/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

# 20220210.4 - installer - v7.0.100-preview.1.22110.4
# fetch dotnet-toolset-internal-7.0.100-preview.1.22110.5.zip by hand if fail ?

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=`date +%Y%m%d`.99