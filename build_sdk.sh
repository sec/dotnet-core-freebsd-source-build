#!/bin/sh

sdk/build.sh -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release
