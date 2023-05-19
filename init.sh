#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-preview.3-x64-native/dotnet-sdk-8.0.100-preview.3.23178.7-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

if [ `uname -m` = 'arm64' ]; then
    SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-preview.3-arm64-native/dotnet-sdk-8.0.100-preview.3.23178.7-freebsd-arm64.tar.gz"
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

    if [ `uname -m` = 'arm64' ]; then
        #git -C runtime cherry-pick -n 8582762f5d19d88ee12ef9d61e3a3af3e1a44185
        #git -C runtime cherry-pick -n e2a706e206ba620bffa94cc1c4959cfb82cb3638
        #git -C runtime cherry-pick -n b02f85fae696d3205277640c50b3c71257dcc951
    fi
    
    patch -d runtime < patches8/runtime_preview2.patch
    patch -d runtime < patches8/runtime_84250.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config
    runtime/.dotnet/dotnet nuget add source 'https://sec.github.io/dotnet-freebsd-nuget-feed/v3/index.json' --name ghsec --configfile aspnetcore/NuGet.config
    
    patch -d aspnetcore < patches8/aspnetcore_preview1.patch

    cp patches/aspnet.editorconfig aspnetcore/src/.editorconfig
fi

if [ ! -d installer ]; then
    git clone https://github.com/dotnet/installer.git
    git -C installer checkout $INSTALLERTAG

    ./bsd_dotnet_install.sh $SDKZIP installer

    installer/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local1 --configfile installer/NuGet.config
    installer/.dotnet/dotnet nuget add source ../aspnetcore/artifacts/packages/Release/Shipping/ --name local2 --configfile installer/NuGet.config

    patch -d installer < patches8/installer_preview1.patch
fi

if [ ! -d sdk ]; then
    git clone https://github.com/dotnet/sdk
    git -C sdk checkout $SDKTAG

    ./bsd_dotnet_install.sh $SDKZIP sdk

    patch -d sdk < patches8/sdk_preview1.patch

    sdk/.dotnet/dotnet nuget add source 'https://sec.github.io/dotnet-freebsd-nuget-feed/v3/index.json' --name ghsec --configfile sdk/NuGet.config
fi
