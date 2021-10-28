#!/bin/sh

mkdir -p installer/artifacts/obj/redist/Release/downloads/
mkdir -p aspnetcore/artifacts/packages/Release/Shipping

cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=20211005.57 /p:IncludeAspNetCoreRuntime=false
