#!/bin/sh

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

aspnetcore/eng/build.sh -ci --os-name freebsd -pack /p:OfficialBuildId=20210902.15 -c Release --all
