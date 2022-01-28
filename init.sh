#!/bin/sh

SDKBIN="https://github.com/sec/dotnet-core-freebsd-source-build/releases/download/6.0.100/dotnet-sdk-6.0.100-freebsd-x64.tar.gz"
SDKZIP="sdk.tgz"

RUNTIMETAG="v6.0.1"
ASPNETCORETAG="v6.0.1"
INSTALLERTAG="v6.0.101"
SDKTAG="v6.0.101"

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

    # either cherrypick + extra patch or one patch for all
    # 3633a7d0930abaca701385c1059b80ca157e98c6
    # 3e6d492bdf6fbf2d8af3871379f31dcc6e27716b
    # 3c63559029276fea97633ea6115bcb9acb2cffe2

    patch -d runtime < patches/v6.0.0-rc.1.21451.13.runtime.patch
    patch -d runtime < patches/runtime_disable_lttng.patch
fi

if [ ! -d aspnetcore ]; then
    git clone https://github.com/dotnet/aspnetcore.git
    git -C aspnetcore checkout $ASPNETCORETAG
    git -C aspnetcore submodule update --init

    ./bsd_dotnet_install.sh $SDKZIP aspnetcore

    aspnetcore/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local --configfile aspnetcore/NuGet.config

    patch -d aspnetcore < patches/v6.0.0-rc.1.21452.15.aspnetcore.patch
fi

if [ ! -d installer ]; then
    git clone https://github.com/dotnet/installer.git
    git -C installer checkout $INSTALLERTAG

    ./bsd_dotnet_install.sh $SDKZIP installer

    installer/.dotnet/dotnet nuget add source ../runtime/artifacts/packages/Release/Shipping/ --name local1 --configfile installer/NuGet.config
    installer/.dotnet/dotnet nuget add source ../aspnetcore/artifacts/packages/Release/Shipping/ --name local2 --configfile installer/NuGet.config

    patch -d installer < patches/v6.0.100-rc.1.21458.32.installer.patch

    cd installer
    find . -name '*.sh' -type f | xargs sed -i '' 's/\#\!\/bin\/bash/\#\!\/usr\/bin\/env\ bash/'
    cd ..
fi

if [ ! -d sdk ]; then
    git clone https://github.com/dotnet/sdk
    git -C sdk checkout $SDKTAG

    ./bsd_dotnet_install.sh $SDKZIP sdk

    cd sdk
    find . -name '*.sh' -type f | xargs sed -i '' 's/\#\!\/bin\/bash/\#\!\/usr\/bin\/env\ bash/'
    cd ..
fi
