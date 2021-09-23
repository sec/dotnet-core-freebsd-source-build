# Build .NET Core 6-rc1 under FreeBSD

Just a collection of script and patches put up into one place, to help getting automated builds.

## Usage

1. Run as root `install_tools.sh`
1. `init.sh`
1. `build_runtime.sh`
1. `build_aspnetcore.sh`
1. `build_sdk.sh`
1. `build_installer.sh`
1. Get and use `installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.100-rc.1.21458.32-freebsd-x64.tar.gz`
1. `clean.sh` if you want to save disk space after use

## Requirments

1. Working SDK for FreeBSD - at the moment it's using binaries from `https://github.com/Thefrank/dotnet-freebsd-crossbuild` created during crosscompile under Linux
1. Tested under FreeBSD 12.2, should also work under 13
1. 8GB+ of RAM recommended (with 4GB I saw some parts crashing)

## Support

Go and read - https://github.com/dotnet/runtime/issues/14537
