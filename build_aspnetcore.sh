#!/bin/csh

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

setenv PROTOBUF_PROTOC /usr/local/bin/protoc
setenv PROTOBUF_TOOLS_CPU x64
setenv PROTOBUF_TOOLS_OS linux

service linux onestart

TAG=`cat aspnetcore.tag`

aspnetcore/eng/build.sh -ci --os-name freebsd -pack -c Release --all /p:TreatWarningsAsErrors=false /p:OfficialBuildId=`./common.sh $TAG`
