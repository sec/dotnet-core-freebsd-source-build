#!/bin/sh

sdk/build.sh -ci /p:OfficialBuildId=20210908.71 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=20210908.71 -c Release
