# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM ubuntu:14.04

MAINTAINER Ashley Fernandez <ashley.fernandez@au.ibm.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    IIB_URL=http://192.168.187.1:8081/iib-10.0.710.0.tar.gz && \
    echo "iib:10.0.710.0" > /etc/debian_chroot && \
    apt-get update -y && \
    apt-get install -y curl tar bash bc && \
    mkdir -p /tmp/iib && \
    mkdir -p /opt/ibm && \
    cd /tmp/iib && \
    curl -LO $IIB_URL && \
    tar --exclude="tools" -xf ./*.tar.gz --directory /opt/ibm && \
    /opt/ibm/iib-10.0.710.0/iib make registry global accept license silently && \
    usermod -G mqbrkrs root &&\
    rm -rf /tmp/iib

COPY *.sh /usr/local/bin/
COPY *.bar /tmp/

# Make sure the MQ environment is available for "docker exec" under non-interactive Bash
ENV BASH_ENV=/usr/local/bin/iib-env.sh

RUN chmod +x /usr/local/bin/*.sh

# Exposed Ports : webadmin(4414) soap(7800) debug(49001) httplis(7080) mqtt(11883)"
EXPOSE 4414 11883 7080 7800 49001

VOLUME /var/mqsi

ENTRYPOINT ["iib.sh"]