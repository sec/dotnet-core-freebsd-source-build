#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-rc.2-x64-native/dotnet-sdk-8.0.100-rc.2.23502.2-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

if [ `uname -m` = 'arm64' ]; then
    SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/8.0.100-rc.2-arm64-native/dotnet-sdk-8.0.100-rc.2.23502.2-freebsd-arm64.tar.gz"
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

    runtime/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile runtime/NuGet.config
    if [ -f local.nuget ]; then
        runtime/.dotnet/dotnet nuget add source `cat local.nuget` --name localdir --configfile runtime/NuGet.config
    fi
   
    patch -d runtime < patches8/runtime_8.0.0.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config
    runtime/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile aspnetcore/NuGet.config
    
    patch -d aspnetcore < patches8/aspnetcore_preview1.patch

    cp patches/aspnet.editorconfig aspnetcore/src/.editorconfig
fi

if [ ! -d installer ]; then
    git clone https://github.com/dotnet/installer.git
    git -C installer checkout $INSTALLERTAG

    ./bsd_dotnet_install.sh $SDKZIP installer

    installer/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local1 --configfile installer/NuGet.config
    installer/.dotnet/dotnet nuget add source ../aspnetcore/artifacts/packages/Release/Shipping/ --name local2 --configfile installer/NuGet.config

    patch -d installer < patches8/installer_preview7.patch
fi

if [ ! -d sdk ]; then
    git clone https://github.com/dotnet/sdk
    git -C sdk checkout $SDKTAG

    ./bsd_dotnet_install.sh $SDKZIP sdk

    patch -d sdk < patches8/sdk_preview1.patch

    sdk/.dotnet/dotnet nuget add source 'https://fbsdnugetfeed.mooo.com/v3/index.json' --name ghsec --configfile sdk/NuGet.config
fi
