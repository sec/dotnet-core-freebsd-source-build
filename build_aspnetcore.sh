#!/bin/sh

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

# 20220209.13 - aspnet core - v7.0.0-preview.1.22109.13
aspnetcore/eng/build.sh -maxcpucount:1 /p:maxcpucount=1 -ci --os-name freebsd -pack /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release --all