#!/bin/sh

# Fake .NET Core Installer for FreeBsd ;)
# $1 - SDK BIN for FreeBSD
# $2 - dest dir

echo Extracting .NET Core SDK into $2...

mkdir -p $2/.dotnet
tar zxf $1 --directory $2/.dotnet
echo 'exit 0' > $2/.dotnet/dotnet-install.sh
