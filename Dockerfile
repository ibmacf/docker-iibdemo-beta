# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM ubuntu:14.04

MAINTAINER Ashley Fernandez <ashley.fernandez@au.ibm.com>

COPY build/ /tmp/build
RUN /tmp/build/bin/build

# webadmin(4414) soap(7800) debug(49001) http(7080) mqtt(11883)"
EXPOSE 4414 11883 7080 7800 49001

VOLUME /var/mqsi

ENTRYPOINT ["/sbin/cinitd"]