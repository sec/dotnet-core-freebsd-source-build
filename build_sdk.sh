#!/bin/csh

if (`uname -m` == "arm64") then
    setenv ARCH arm64
else
    setenv ARCH x64
endif

mkdir -p sdk/artifacts/obj/redist/Release/downloads/
mkdir -p sdk/artifacts/obj/redist-installer/Release/downloads/

cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-$ARCH.tar.gz sdk/artifacts/obj/redist/Release/downloads/
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-$ARCH.tar.gz sdk/artifacts/obj/redist-installer/Release/downloads/

cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* sdk/artifacts/obj/redist/Release/downloads/
cp aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* sdk/artifacts/obj/redist-installer/Release/downloads/

setenv TAG `cat sdk.tag`
sdk/build.sh -c Release -ci --pack /p:Rid=freebsd-$ARCH /p:OSName=freebsd /p:OfficialBuildId=`./common.sh $TAG` /p:IncludeAspNetCoreRuntime=true /p:Architecture=$ARCH
