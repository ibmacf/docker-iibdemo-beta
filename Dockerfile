# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM ubuntu:14.04

MAINTAINER Ashley Fernandez <ashley.fernandez@au.ibm.com>

# - environment variables
ENV IIBADMIN=iibadm \
	IIBVERSION=10.0.710.0 \
	IIBBUILDDIR=/tmp/build \
	IIBUTILITYSOFTWARE=curl\ tar\ rsyslog

# - more env
ENV IIBIMAGENAME=iib-${IIBVERSION}.tar.gz \
	IIBCONFIGURELOC=/home/${IIBADMIN}

#ENV IIBMEDIAURL=http://192.168.187.1:8081/${IIBIMAGENAME}
ENV IIBMEDIAURL=http://ec2-52-64-38-157.ap-southeast-2.compute.amazonaws.com/${IIBIMAGENAME}

# - build script folder
COPY build/ ${IIBBUILDDIR}
RUN ${IIBBUILDDIR}/bin/build

# - webadmin(4414) soap(7800) debug(49001) http(7080) mqtt(11883)"
EXPOSE  4414 \
		7080 \
		7800 \
		49001 \
		11883

# - Configuration space can be mapped elsewhere
VOLUME /var/mqsi

ENTRYPOINT ["/sbin/cinitd", "--trace"]