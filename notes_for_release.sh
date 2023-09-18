#!/usr/bin/env sh

strip_tag()
{
    VER=`cat $1.tag | cut -c 2-`
}

echo Compiled under `uname -r -s -m -i`
echo

strip_tag installer
echo SDK $VER

strip_tag runtime
echo .NET Runtime $VER

strip_tag aspnetcore
echo ASP.NET Core Runtime $VER

TAG=`cat sdk.tag| sed s/v// | cut -d '-' -f1`
SUF=''
case "$VER" in
    *-*)
        SUF=-`cat sdk.tag | cut -d '-' -f2 | cut -d '.' -f1-2`
        ;;
    *)
        SUF=''
        ;;
esac

echo
echo Tag name for release: $TAG$SUF-`uname -m | sed s/amd/x/`-native
echo
