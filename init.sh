#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/6.0.102/dotnet-sdk-6.0.102-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

RUNTIMETAG="v7.0.0-preview.1.22076.8"
ASPNETCORETAG="v7.0.0-preview.1.22109.13"
INSTALLERTAG="v7.0.100-preview.1.22110.4"
SDKTAG="v7.0.100-preview.1.22110.5"

#needed for openjdk
#mount -t fdescfs fdesc /dev/fd
#mount -t procfs proc /proc

if [ ! -f $SDKZIP ]; then
    echo "Downloading SDK for FreeBSD"
    fetch $SDKBIN --quiet -o $SDKZIP
fi

if [ ! -d nuget ]; then
    mkdir nuget
    cd nuget
    for x in `cat ../nuget_list.txt`
    do
        fetch --quiet $x
    done
    cd ..
fi

if [ ! -d runtime ]; then
    git clone https://github.com/dotnet/runtime.git
    git -C runtime checkout $RUNTIMETAG

    ./bsd_dotnet_install.sh $SDKZIP runtime

    runtime/.dotnet/dotnet nuget add source ../nuget --name local --configfile runtime/NuGet.config

    patch -d runtime < patches/runtime_versions.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config

    patch -d aspnetcore < patches/aspnetcore.patch
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
