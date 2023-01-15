#!/bin/sh

ASPNET="${1:-true}"

mkdir -p installer/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

TAG=6.0.400-rtm.22368.21
TOOLSET=https://dotnetbuilds.blob.core.windows.net/public/Sdk/$TAG/dotnet-toolset-internal-$TAG.zip

if [ ! -f installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-$TAG.zip ]; then
    wget $TOOLSET -O installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-$TAG.zip
fi

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=`date +%Y%m%d`.99 /p:IncludeAspNetCoreRuntime=$ASPNET
