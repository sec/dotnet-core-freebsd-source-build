#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-x64-native/dotnet-sdk-8.0.100-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

if [ `uname -m` = 'arm64' ]; then
    SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-arm64-native/dotnet-sdk-8.0.100-freebsd-arm64.tar.gz"
fi

RUNTIMETAG=`cat runtime.tag`
ASPNETCORETAG=`cat aspnetcore.tag`
SDKTAG=`cat sdk.tag`

if [ ! -f $SDKZIP ]; then
    echo "Downloading SDK for FreeBSD"
    fetch $SDKBIN --quiet -o $SDKZIP
fi

if [ ! -d runtime ]; then
    git clone https://github.com/dotnet/runtime.git
    git -C runtime checkout $RUNTIMETAG

    ./bsd_dotnet_install.sh $SDKZIP runtime

    runtime/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile runtime/NuGet.config
    if [ -f local.nuget ]; then
        runtime/.dotnet/dotnet nuget add source `cat local.nuget` --name localdir --configfile runtime/NuGet.config
    fi
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config
    aspnetcore/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile aspnetcore/NuGet.config
    
    if [ -f local.nuget ]; then
        aspnetcore/.dotnet/dotnet nuget add source `cat local.nuget` --name localdir --configfile aspnetcore/NuGet.config
    fi
fi

if [ ! -d sdk ]; then
    git clone https://github.com/dotnet/sdk
    git -C sdk checkout $SDKTAG

    ./bsd_dotnet_install.sh $SDKZIP sdk

    sdk/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local1 --configfile installer/NuGet.config
    sdk/.dotnet/dotnet nuget add source ../aspnetcore/artifacts/packages/Release/Shipping/ --name local2 --configfile installer/NuGet.config

    patch -d sdk < patches9/patch_sdk_net9p5.patch

    sdk/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile sdk/NuGet.config
fi
