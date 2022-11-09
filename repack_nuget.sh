#!/bin/sh
# usage: ./repack_nuget.sh nupkg old_version new_version
# TODO: rename file

mkdir tmp
cd tmp
unzip ../$1
find . -name '*.nuspec' | xargs sed -i '' "s/$2/$3/"
rm ../$1
zip -r ../$1 *
cd ..
rm -rf tmp/
