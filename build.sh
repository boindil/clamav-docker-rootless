#!/bin/bash -e

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in
SCRIPTPATH=$(dirname "${SCRIPT}")

rm -rf $SCRIPTPATH/docker/tmp
mkdir -p $SCRIPTPATH/docker/tmp

versionline=`cat docker/Dockerfile_main | grep "version="`
version=$(sed -E 's|version="(.*)"(.*)|\1|g' <<< $versionline | xargs)

repo="my-repository"

# build main container
tag="${repo}/clamav-rootless"
versiontag="${tag}:${version}${versionsuffix}"
latesttag="${tag}:latest${versionsuffix}"

docker build --pull \
            --build-arg http_proxy=$HTTP_PROXY \
            --build-arg https_proxy=$HTTPS_PROXY \
            --build-arg no_proxy=$NO_PROXY \
            --no-cache \
            -t $versiontag \
            -t $latesttag \
            -f docker/Dockerfile_main \
            .

# build initcontainer
tag="${repo}/clamav-init"
versiontag="${tag}:${version}${versionsuffix}"
latesttag="${tag}:latest${versionsuffix}"

docker build --pull \
            --build-arg http_proxy=$HTTP_PROXY \
            --build-arg https_proxy=$HTTPS_PROXY \
            --build-arg no_proxy=$NO_PROXY \
            --no-cache \
            -t $versiontag \
            -t $latesttag \
            -f docker/Dockerfile_initcontainer \
            .