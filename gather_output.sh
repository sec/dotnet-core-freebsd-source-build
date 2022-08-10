#!/bin/sh

rm -rf output
mkdir output
find runtime/artifacts/packages/Release -name '*.nupkg' -exec cp '{}' output/ \;
find aspnetcore/artifacts/packages/Release -name '*.nupkg' -exec cp '{}' output/ \;
cp installer/artifacts/packages/Release/Shipping/* output/

rm output/*.symbols.nupkg

tar --create --file dotnet-sdk-7.0.100.preview.7-freebsd-x64-full.tar -C output .
