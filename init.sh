#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/7.0.100-preview.4/dotnet-sdk-7.0.100-preview.4.22252.9-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

PKGS="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/7.0.100-preview.4/native-packages-7.0.100.preview.4-freebsd-x64.tar"

RUNTIMETAG="v7.0.0-preview.5.22301.12"
ASPNETCORETAG="v7.0.0-preview.5.22303.8"
INSTALLERTAG="v7.0.100-preview.5.22307.18"
SDKTAG="v7.0.100-preview.5.22307.7"

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
    fetch $PKGS --quiet -o temp.tar
    tar xf temp.tar
    rm temp.tar
    cd ..
fi

if [ ! -d runtime ]; then
    git clone https://github.com/dotnet/runtime.git
    git -C runtime checkout $RUNTIMETAG

    ./bsd_dotnet_install.sh $SDKZIP runtime

    runtime/.dotnet/dotnet nuget add source ../nuget --name local --configfile runtime/NuGet.config

    patch -d runtime < patches/runtime_versions.patch
    patch -d runtime < patches/runtime_crossgen2.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config
    aspnetcore/.dotnet/dotnet nuget add source ../nuget --name local2 --configfile aspnetcore/NuGet.config

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
