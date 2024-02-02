# Build .NET <strike>Core</strike> 8 under FreeBSD

# New News (2024)
- We how have official port under [FreeBSD ports](https://github.com/freebsd/freebsd-ports/tree/main/lang/dotnet) for x64/amd64
- `/usr/ports/lang/dotnet/make install` or `pkg install` will get you up and running
- to speed up port build, use `install_tools.sh` first, unless you like everything from source
- For arm64/aarch64, I have [fork ready](https://github.com/sec/freebsd-ports/tree/lang-dotnet-arm64/lang/dotnet) which I hope will be upstreamed soon

# Old news (out-dated, but still some valid points)

- Just a collection of script and patches put up into one place, to help getting automated builds.
- For other versions, check proper tag with that name (mostly out-dated and not updated).
- For my private nuget feed, check [dotnet-freebsd-nuget-feed](https://github.com/sec/dotnet-freebsd-nuget-feed)

## Usage

1. Run as root `install_tools.sh` - make sure to mount all needed things (add them to /etc/fstab, then mount -a)
1. `init.sh`
1. `build_runtime.sh` - add `-v d` inside if it will fail with SEHExceptions...
1. (try to skip this and goto `build_aspnetcore.sh`) `build_installer_without_aspnet.sh`
1. (try to skip this and goto `build_aspnetcore.sh`) run `tar zxfv ../../installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.101-freebsd-x64.tar.gz` inside `aspnetcore/.dotnet` to extract newly created SDK
1. `build_aspnetcore.sh` - as for now, this one need v7 SDK - grab one and do `./bsd_dotnet_install.sh sdk7.tgz aspnetcore/`
1. `build_installer.sh` - this one also need v7 SDK - do the same as above. Add `-v d` inside build script if it will fail, check the logs (maybe download some zips by hand, as this is common fail)
1. Get and use `installer/artifacts/packages/Release/Shipping/dotnet-sdk-*-freebsd-x64.tar.gz`
1. `clean.sh` if you want to save disk space after use
1. `gather_output.sh` to tar artifacts into one big file, for future use (doesn't make sense to compress this, as it contains compressed files already)

NB: you can use output SDK as seed (instead of the one that was crosscompiled), move it here and rename to `sdk.tgz`

## Errors

## Requirments

1. Working SDK for FreeBSD - at the moment it's using binaries from `https://github.com/Thefrank/dotnet-freebsd-crossbuild` created during crosscompile under Linux
1. Tested under FreeBSD 12.3 and 13.0-STABLE/RELEASE
1. 8GB+ of RAM recommended (with 4GB I saw some parts crashing)
1. To run built SDK `pkg install libunwind icu libinotify` should be enough

## Support

- x64 - [read](https://github.com/dotnet/runtime/issues/14537)
- arm64 - [read]()

## Ready builds, credits, etc

- Check [releases](https://github.com/sec/dotnet-core-freebsd-source-build/releases) (issue me if someting's broken or missing)
- [Crossbuild](https://github.com/Thefrank/dotnet-freebsd-crossbuild) and [native builds](https://github.com/Thefrank/dotnet-freebsd-native-binaries)
- [Azure pipeline](https://github.com/Servarr/dotnet-bsd)
