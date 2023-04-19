#!/bin/sh

runtime/build.sh --clang14 --warnAsError false /p:OfficialBuildId=`date +%Y%m%d`.99 -ci -c Release
