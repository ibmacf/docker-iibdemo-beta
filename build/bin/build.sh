#!/bin/bash
# -*- mode: sh -*-
# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

# Globals
export DEBIAN_FRONTEND=noninteractive
IIB_VERSION=iib-10.0.710.0
HOST="192.168.187.1:8081"
IIB_URL=http://ec2-52-64-15-230.ap-southeast-2.compute.amazonaws.com/${IIB_VERSION}.tar.gz
#IIB_URL=http://${HOST}/${IIB_VERSION}.tar.gz
BUILDDIR=/tmp/build
 
#:: Main
echo "${IIB_VERSION}" > /etc/debian_chroot

#-
echo "apt-get -q -y update > /dev/null"
apt-get -q -y update > /dev/null

echo "apt-get -q -y install curl tar rsyslog > /dev/null"
apt-get -q -y install curl tar rsyslog > /dev/null

# -
mkdir -p /opt/ibm
mv --verbose ${BUILDDIR}/configure /root/

# -
cd ${BUILDDIR}/software
echo " Downloading, may take a while [curl -LO ${IIB_URL}]"
curl -LO ${IIB_URL}

echo "[I] tar --exclude="tools" -xf ./${IIB_VERSION}.tar.gz --directory /opt/ibm"
tar --exclude="tools" -xf ./${IIB_VERSION}.tar.gz --directory /opt/ibm

/opt/ibm/${IIB_VERSION}/iib make registry global accept license silently

# -
usermod -G mqbrkrs root

# -
mkdir -p /etc/cinit.d
cp -v ${BUILDDIR}/bin/waiting_to_configure /etc/cinit.d
cp -v ${BUILDDIR}/bin/iib-env.sh /usr/local/bin
cp -v ${BUILDDIR}/bin/cinitd /sbin/

# -
rm -rf /tmp/build