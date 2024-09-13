# Build .NET <strike>Core</strike> 9 under FreeBSD

# Hacky way for native build, tested with v9.preview.7
- for cross build sdk, patch needed for runtime to output proper ilc - https://patch-diff.githubusercontent.com/raw/dotnet/runtime/pull/105004.patch
- also this one might be needed https://github.com/dotnet/runtime/pull/105587.patch
- ---
- aspnet runtime nuget with 6.0.32
- app host both runtime and aspnet with 6.0.32
- I use some old v6 versions and repack them with new version, scripts in repo, maybe there's better way for that
- eng/Versions.props, line 217 with MicrosoftDotNetILCompilerVersion, put 9.0.0-preview.7.24405.7 or the one you have with SDK
- add nuget source for SDK nuget's your compile with
- adjust global.json versions to SDK version
- for runtime, app host error could happen - this need sed linux-arch to freebsd-arc - ex. `sed -i '' -e 's/linux-arm64/freebsd-arm64/g' runtime/.dotnet/sdk/9.0.100-preview.7.24407.12/Microsoft.NETCoreSdk.BundledVersions.props`
- ---
- build runtime (ILC can/will fail due to missing symbols, copy from crossbuild, but final SDK/nuget will also be broken)
- build aspnet (do not build with node/npm installed)
- build sdk

# New News (2024)
- We how have **community made** port under [FreeBSD ports](https://github.com/freebsd/freebsd-ports/tree/main/lang/dotnet) for x64/amd64 and aarch64
- `/usr/ports/lang/dotnet/make install` or `pkg install` will get you up and running
- to speed up port build, use `install_tools.sh` first, unless you like everything from source

# Old news (out-dated, but still some valid points)

- Just a collection of script and patches put up into one place, to help getting automated builds.
- For other versions, check proper tag with that name (mostly out-dated and not updated).
- For my private nuget feed, check [dotnet-freebsd-nuget-feed](https://github.com/sec/dotnet-freebsd-nuget-feed)

## Usage

1. Run as root `install_tools.sh` - make sure to mount all needed things (add them to /etc/fstab, then mount -a)
1. `init.sh`
1. `build_runtime.sh` - add `-v d` inside if it will fail with SEHExceptions...
1. `build_aspnetcore.sh`
1. `build_installer.sh` - this one can fail with downloaing some things, copy URL and try to manualy fetch it into `installer/artifacts/obj/redist/Release/downloads/`
1. Check `installer/artifacts/packages/Release/Shipping/` or
1. `gather_output.sh` will create one archive with everything you should need on target system
1. `clean.sh` if you want to save disk space after use

### Extra info
- some steps can fail, some patches can fail to apply, mostly due to numbers, this needs to be handed by hand, as I don't update all the patches with every release
- sometime some step can fail, due to zombie dotnet processes left, simple `killall -9 dotnet` will do the trick
- when building under jail, `mlock` is required

## Requirments

1. Working SDK for FreeBSD
1. Tested under FreeBSD 13 and 14
1. 8GB+ of RAM recommended (with 4GB I saw some parts crashing)
1. To run SDK and/or apps `pkg install libunwind icu libinotify` should be enough on another box, maybe `openssl` too
1. Under `14` also `pkg install misc/compat13x` might be needed if using builds directly

## Support

- x64 - [read](https://github.com/dotnet/runtime/issues/14537)
- arm64 - [read](https://github.com/dotnet/runtime/issues/71338)
- nice [summary from @Thefrank](https://github.com/dotnet/source-build/issues/1139#issuecomment-1943360539)

## Ready builds, credits, etc

- Check [releases](https://github.com/sec/dotnet-core-freebsd-source-build/releases) (issue me if someting's broken or missing)
- [Crossbuild](https://github.com/Thefrank/dotnet-freebsd-crossbuild) and [native builds](https://github.com/Thefrank/dotnet-freebsd-native-binaries)
- [Azure pipeline](https://github.com/Servarr/dotnet-bsd)
