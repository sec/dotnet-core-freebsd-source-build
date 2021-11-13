#!/bin/sh

mkdir -p installer/artifacts/obj/redist/Release/downloads/
mkdir -p aspnetcore/artifacts/packages/Release/Shipping

if [ ! -f installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-6.0.100-rtm.21527.8.zip ]; then
    wget https://dotnetcli.blob.core.windows.net/dotnet/Sdk/6.0.100-rtm.21527.8/dotnet-toolset-internal-6.0.100-rtm.21527.8.zip -O installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-6.0.100-rtm.21527.8.zip
fi

cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=20211105.99 /p:IncludeAspNetCoreRuntime=false
