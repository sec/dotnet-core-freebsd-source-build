mkdir -p artifacts/obj/Microsoft.AspNetCore.App.Runtime
cp ../runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-arm64.tar.gz artifacts/obj/Microsoft.AspNetCore.App.Runtime

eng/build.sh -c Release -ci --os-name freebsd -pack /p:CrossgenOutput=false /p:OfficialBuildId=`date +%Y%m%d`.99 --arch arm64
