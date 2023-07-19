#!/bin/csh
# Note for arm64 build, it will (or can) fail with grpc csharp plugin, as there's no binary, when it will fail, simply do something like
# cp /usr/local/bin/grpc_csharp_plugin ~/dotnet-core-freebsd-source-build/aspnetcore/.packages/grpc.tools/2.49.0/tools/linux_x64/grpc_csharp_plugin
# adjust destination path based on error and version of package used

if (`uname -m` == "arm64") then
    setenv ARCH arm64
else
    setenv ARCH x64
endif

mkdir -p aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-$ARCH.tar.gz aspnetcore/artifacts/obj/Microsoft.AspNetCore.App.Runtime

setenv PROTOBUF_PROTOC /usr/local/bin/protoc
setenv PROTOBUF_TOOLS_CPU x64
setenv PROTOBUF_TOOLS_OS linux
setenv GRPC_PROTOC_PLUGIN /usr/local/bin/grpc_csharp_plugin
setenv PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1

service linux onestart

setenv TAG `cat aspnetcore.tag`

aspnetcore/eng/build.sh -ci --os-name freebsd -pack -c Release --all /p:TreatWarningsAsErrors=false /p:OfficialBuildId=`./common.sh $TAG` --arch $ARCH
