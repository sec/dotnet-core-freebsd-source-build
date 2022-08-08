#!/bin/sh

# 20220210.5 - sdk - v7.0.100-preview.1.22110.5
# 20220329.3 - v7.0.100-preview.3.22179.3
# 20220607.7 - preview.5

sdk/build.sh -ci /p:OfficialBuildId=20220701.13 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=20220701.13 -c Release
