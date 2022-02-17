#!/bin/sh

runtime/build.sh /p:OfficialBuildId=`date +%Y%m%d`.99 -ci -c Release
