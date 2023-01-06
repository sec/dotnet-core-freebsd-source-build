#!/bin/csh

if (`uname -m` == "arm64") then
    setenv ARCH arm64
else
    setenv ARCH x64
endif

mkdir -p installer/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-$ARCH.tar.gz installer/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* installer/artifacts/obj/redist/Release/downloads/
cp sdk/artifacts/packages/Release/NonShipping/dotnet-toolset-internal-*.zip installer/artifacts/obj/redist/Release/downloads/

setenv TAG `cat installer.tag`
installer/build.sh -c Release -ci -pack --runtime-id freebsd-$ARCH /p:OSName=freebsd /p:OfficialBuildId=`./common.sh $TAG` /p:IncludeAspNetCoreRuntime=true
