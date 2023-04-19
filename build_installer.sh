#!/bin/sh

ASPNET="${1:-true}"

mkdir -p installer/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=`date +%Y%m%d`.99 /p:IncludeAspNetCoreRuntime=$ASPNET --warnAsError false
