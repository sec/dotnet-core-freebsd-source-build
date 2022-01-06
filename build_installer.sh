#!/bin/sh

mkdir -p installer/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

if [ ! -f installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-6.0.101-servicing.21569.16.zip ]; then
        wget https://dotnetcli.blob.core.windows.net/dotnet/Sdk/6.0.101-servicing.21569.16/dotnet-toolset-internal-6.0.101-servicing.21569.16.zip -O installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-6.0.101-servicing.21569.16.zip
fi

installer/build.sh -c Release -ci -pack --runtime-id freebsd-x64 /p:OSName=freebsd /p:OfficialBuildId=20211229.99 -v d
