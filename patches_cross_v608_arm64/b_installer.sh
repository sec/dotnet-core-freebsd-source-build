mkdir -p artifacts/obj/redist/Release/downloads/
cp ../runtime/artifacts/packages/Release/Shipping/dotnet-runtime-*-freebsd-arm64.tar.gz artifacts/obj/redist/Release/downloads/
cp ../aspnetcore/artifacts/installers/Release/aspnetcore-runtime-* artifacts/obj/redist/Release/downloads/

./build.sh -c Release -ci -pack --runtime-id freebsd-arm64 /p:OSName=freebsd /p:CrossgenOutput=false /p:OfficialBuildId=`date +%Y%m%d`.99 /p:IncludeAspNetCoreRuntime=True /p:DISABLE_CROSSGEN=True --architecture arm64
