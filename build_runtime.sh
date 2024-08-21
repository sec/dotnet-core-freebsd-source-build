#!/bin/sh
TAG=`cat runtime.tag`

runtime/build.sh -warnAsError False /p:OfficialBuildId=`./common.sh $TAG` -ci -c Release $1 $2 $3 $4 $5 $6 $7 $8 $9
