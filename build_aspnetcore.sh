#!/bin/csh

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-x64.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

# 20220209.13 - aspnet core - v7.0.0-preview.1.22109.13
# 20220328.4 - aspnet core - v7.0.0-preview.3.22178.4
# 20220501.1 - preview.4
# 20220603.8 - preview.5

setenv PROTOBUF_PROTOC /usr/local/bin/protoc
setenv PROTOBUF_TOOLS_CPU x64
setenv PROTOBUF_TOOLS_OS linux

service linux onestart

aspnetcore/eng/build.sh -ci --os-name freebsd -pack -c Release --all /p:TreatWarningsAsErrors=false /p:OfficialBuildId=20220726.6
