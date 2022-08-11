#!/bin/sh

TAG=`cat sdk.tag`

sdk/build.sh -ci /p:OfficialBuildId=`./common.sh $TAG` -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=`./common.sh $TAG` -c Release
