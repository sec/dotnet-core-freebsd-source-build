#!/bin/sh

# 20220210.5 - sdk - v7.0.100-preview.1.22110.5
# 20220329.3 - v7.0.100-preview.3.22179.3

sdk/build.sh -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=`date +%Y%m%d`.99 -c Release
