#!/bin/csh

if (`uname -m` == "arm64") then
    setenv ARCH arm64
else
    setenv ARCH x64
endif


rm -rf output
mkdir output
find runtime/artifacts/packages/Release -name '*freebsd*.nupkg' -exec cp '{}' output/ \;
find aspnetcore/artifacts/packages/Release -name '*freebsd*.nupkg' -exec cp '{}' output/ \;
cp installer/artifacts/packages/Release/Shipping/* output/

rm output/*.symbols.nupkg

tar --create --file dotnet-sdk-`cat sdk.tag|cut -c 2-`.freebsd-$ARCH-full.tar -C output .
