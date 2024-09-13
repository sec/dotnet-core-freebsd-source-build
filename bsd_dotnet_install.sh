#!/bin/csh

# Fake .NET Core Installer for FreeBsd ;)
# $1 - SDK BIN for FreeBSD
# $2 - dest dir

echo Extracting .NET Core SDK into $2...

mkdir -p $2/.dotnet
tar zxf $1 --directory $2/.dotnet
elfctl -e +noaslr $2/.dotnet/dotnet

if (`uname -m` == "arm64") then
    setenv ARCH arm64
else
    setenv ARCH x64
endif

sed -i '' -e 's/linux-$ARCH/freebsd-$ARCH/g' $2/.dotnet/sdk/9.0.100-preview.7.24407.12/Microsoft.NETCoreSdk.BundledVersions.props

echo 'exit 0' > $2/.dotnet/dotnet-install.sh
