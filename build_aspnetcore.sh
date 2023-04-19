#!/bin/csh

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

setenv PROTOBUF_PROTOC /usr/local/bin/protoc
setenv PROTOBUF_TOOLS_CPU x64
setenv PROTOBUF_TOOLS_OS linux
setenv GRPC_PROTOC_PLUGIN /usr/local/bin/grpc_csharp_plugin

aspnetcore/eng/build.sh -ci --os-name freebsd -pack /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release --all
