#!/bin/sh

./bsd_dotnet_install.sh runtime/artifacts/packages/Release/Shipping/dotnet-runtime-6.0.6-freebsd-x64.tar.gz sdk

sdk/build.sh -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release
