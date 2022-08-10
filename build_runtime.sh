#!/bin/sh

runtime/build.sh --warnAsError false /p:OfficialBuildId=`date +%Y%m%d`.99 -ci -c Release
