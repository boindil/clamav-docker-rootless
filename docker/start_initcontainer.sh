#!/bin/bash -e

set +u

mkdir -p /etc/clamav

cp -a /clamav_config/*.conf /etc/clamav

if ! [ -z $HTTPProxyServer ]; then sed -i -E "s/^#HTTPProxyServer(.*)/HTTPProxyServer $HTTPProxyServer/" /etc/clamav/freshclam.conf; fi
if ! [ -z $HTTPProxyPort ]; then sed -i -E "s/^#HTTPProxyPort(.*)/HTTPProxyPort $HTTPProxyPort/" /etc/clamav/freshclam.conf; fi
if ! [ -z $HTTPProxyUsername ]; then sed -i -E "s/^#HTTPProxyUsername(.*)/HTTPProxyUsername $HTTPProxyUsername/" /etc/clamav/freshclam.conf; fi
if ! [ -z $HTTPProxyPassword ]; then sed -i -E "s/^#HTTPProxyPassword(.*)/HTTPProxyPassword $HTTPProxyPassword/" /etc/clamav/freshclam.conf; fi

if [ -z $MaxFileSize ]; then MaxFileSize=0; fi
if [ -z $MaxScanSize ]; then MaxScanSize=0; fi
if [ -z $StreamMaxLength ]; then StreamMaxLength=0; fi

# remove clamav params limit
sed -i -E "s/^#MaxFileSize(.*)/MaxFileSize $MaxFileSize/" /etc/clamav/clamd.conf
sed -i -E "s/^#MaxScanSize(.*)/MaxScanSize $MaxScanSize/" /etc/clamav/clamd.conf
sed -i -E "s/^#StreamMaxLength(.*)/StreamMaxLength $StreamMaxLength/" /etc/clamav/clamd.conf