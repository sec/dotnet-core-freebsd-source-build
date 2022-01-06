# Build .NET Core 6 under FreeBSD

- Just a collection of script and patches put up into one place, to help getting automated builds.
- For `rc-1`, `rc-2`, `6.0.100` check proper tag with that name.
- For common errors, look below.

## Usage

1. Run as root `install_tools.sh`
1. `init.sh`
1. `build_runtime.sh`
1. (try to skip this and goto `build_aspnetcore.sh`) `build_installer_without_aspnet.sh`
1. run `tar zxfv ../../installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.101-freebsd-x64.tar.gz` inside `aspnetcore/.dotnet` to extract newly created SDK
1. `build_aspnetcore.sh`
1. `build_installer.sh`
1. Get and use `installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.101-freebsd-x64.tar.gz`
1. `clean.sh` if you want to save disk space after use
1. `gather_output.sh` to tar artifacts into one big file, for future use (doesn't make sense to compress this, as it contains compressed files already)

NB: you can use output SDK as seed (instead of the one that was crosscompiled), move it here and rename to `sdk.tgz`

## Errors

If you get error like `The author primary signature validity period has expired` or `The repository countersignature validity period has expired`, this should fix it (run as root):
```
mv /usr/share/certs/blacklisted/VeriSign_Universal_Root_Certification_Authority.pem /usr/share/certs/trusted
certctl rehash
```

Don't do this on your production machine!
More info about this [here](https://bugzilla.mozilla.org/show_bug.cgi?id=1686854)

## Requirments

1. Working SDK for FreeBSD - at the moment it's using binaries from `https://github.com/Thefrank/dotnet-freebsd-crossbuild` created during crosscompile under Linux
1. Tested under FreeBSD 12.2, 12.3 and 13.0-STABLE/RELEASE
1. 8GB+ of RAM recommended (with 4GB I saw some parts crashing)
1. To run built SDK `pkg install libunwind icu libinotify` should be enough

## Support

- Go and [read](https://github.com/dotnet/runtime/issues/14537)
- List of cherry picked changes needed [listed here](https://github.com/dotnet/runtime/issues/14537#issuecomment-926352045)

## Ready builds, credits, etc

- Check [releases](https://github.com/sec/dotnet-core-freebsd-source-build/releases) (issue me if someting's broken or missing)
- [Crossbuild](https://github.com/Thefrank/dotnet-freebsd-crossbuild) and [native builds](https://github.com/Thefrank/dotnet-freebsd-native-binaries)
- [Azure pipeline](https://github.com/Servarr/dotnet-bsd)
