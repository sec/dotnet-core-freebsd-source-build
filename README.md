# Build .NET Core 6 under FreeBSD

- Just a collection of script and patches put up into one place, to help getting automated builds.
- For `rc-1` and `rc-2` check proper tag with that name.
- For common errors, look below.

## Usage

1. Run as root `install_tools.sh`
1. `init.sh`
1. `build_runtime.sh`
1. `build_installer_without_aspnet.sh`
1. run `tar zxfv ../../installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.100-freebsd-x64.tar.gz` inside `aspnetcore/.dotnet` to extract newly created SDK
1. `build_aspnetcore.sh`
1. `build_installer.sh`
1. Get and use `installer/artifacts/packages/Release/Shipping/dotnet-sdk-6.0.100-freebsd-x64.tar.gz`
1. `clean.sh` if you want to save disk space after use
1. `gather_output.sh` to tar artifacts into one big file, for future use (doesn't make sense to compress this, as it contains compressed files already)

NB: you can use output SDK as seed (instead of the one that was crosscompiled), move it here and rename to `sdk.tgz`

## Errors

If you get error like `The author primary signature validity period has expired` or `The repository countersignature validity period has expired`, this should fix it (run as root):
```
rm /usr/share/certs/blacklisted/VeriSign_Universal_Root_Certification_Authority.pem
certctl rehash
```

Don't do this on your production machine!
More info about this [here](https://bugzilla.mozilla.org/show_bug.cgi?id=1686854)

You can also download `https://dotnetcli.blob.core.windows.net/dotnet/Sdk/6.0.100-rtm.21527.8/dotnet-toolset-internal-6.0.100-rtm.21527.8.zip` to `installer/artifacts/obj/redist/Release/downloads/dotnet-toolset-internal-6.0.100-rtm.21527.8.zip` - as this step sometime fail also during build.

## Requirments

1. Working SDK for FreeBSD - at the moment it's using binaries from `https://github.com/Thefrank/dotnet-freebsd-crossbuild` created during crosscompile under Linux
1. Tested under FreeBSD 12.2 and 13.0-STABLE
1. 8GB+ of RAM recommended (with 4GB I saw some parts crashing)

## Support

- Go and [read](https://github.com/dotnet/runtime/issues/14537)
- List of cherry picked changes needed [listed here](https://github.com/dotnet/runtime/issues/14537#issuecomment-926352045)
