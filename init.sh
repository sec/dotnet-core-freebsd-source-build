#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/7.0.102-x64-native/dotnet-sdk-7.0.102-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

if [ `uname -m` = 'arm64' ]; then
    SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/7.0.102-arm64-native/dotnet-sdk-7.0.102-freebsd-arm64.tar.gz"
fi

RUNTIMETAG=`cat runtime.tag`
ASPNETCORETAG=`cat aspnetcore.tag`
INSTALLERTAG=`cat installer.tag`
SDKTAG=`cat sdk.tag`

#needed for openjdk
#mount -t fdescfs fdesc /dev/fd
#mount -t procfs proc /proc

if [ ! -f $SDKZIP ]; then
    echo "Downloading SDK for FreeBSD"
    fetch $SDKBIN --quiet -o $SDKZIP
fi

if [ ! -d runtime ]; then
    git clone https://github.com/dotnet/runtime.git
    git -C runtime checkout $RUNTIMETAG

    ./bsd_dotnet_install.sh $SDKZIP runtime

    runtime/.dotnet/dotnet nuget add source 'https://sec.github.io/dotnet-freebsd-nuget-feed/v3/index.json' --name ghsec --configfile runtime/NuGet.config

    patch -d runtime < patches/runtime.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config
    runtime/.dotnet/dotnet nuget add source 'https://sec.github.io/dotnet-freebsd-nuget-feed/v3/index.json' --name ghsec --configfile aspnetcore/NuGet.config
    
    patch -d aspnetcore < patches/aspnetcore.patch

    cp patches/aspnet.editorconfig aspnetcore/src/.editorconfig
fi

if [ ! -d installer ]; then
    git clone https://github.com/dotnet/installer.git
    git -C installer checkout $INSTALLERTAG

    ./bsd_dotnet_install.sh $SDKZIP installer

    installer/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local1 --configfile installer/NuGet.config
    installer/.dotnet/dotnet nuget add source ../aspnetcore/artifacts/packages/Release/Shipping/ --name local2 --configfile installer/NuGet.config

    patch -d installer < patches/installer.patch
fi

if [ ! -d sdk ]; then
    git clone https://github.com/dotnet/sdk
    git -C sdk checkout $SDKTAG

    ./bsd_dotnet_install.sh $SDKZIP sdk
fi
