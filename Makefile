# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# Docker Image related
name = iibdemo/iibdemo
version = 10.0.710.0

# - Environment file
iibadmin=iibadm
iibnode=NSW
configpath=/home/$(iibadmin)/configuration/$(iibnode)
envfile=$(configpath)/iibnode-nsw.properties
configure=/home/$(iibadmin)/configuration/configure_iib

# - Container related
cname = grumpy_koala
webgui = 4414
mqtt = 11883
http = 7800
soap = 7080
debug = 49001
 
.PHONY: build configure spinup start runivt status logs stop clean cleanall console admin

build:
	sudo docker build --rm --force-rm=true -t $(name):$(version) .

#configure: spinup 
#	sudo docker exec -it $(cname) /sbin/cinitd --command="$(configure) $(envfile)"
# 	TIMESTUFF -v /etc/localtime:/etc/localtime:ro \

spinup:
	sudo docker run -d \
				-e IIBNODE=$(iibnode) \
				-v /etc/localtime:/etc/localtime:ro \
				-v /dev/log:/dev/log \
				-p $(webgui):$(webgui) \
				-p $(mqtt):$(mqtt) \
				-p $(http):$(http) \
				-p $(soap):$(soap) \
				-p $(debug):$(debug) \
				--name=$(cname) \
				$(name):$(version)
	echo sleeping for 15 seconds until the container is alive...
	sleep 15
	sudo docker logs $(cname)

start:
	sudo docker start $(cname)
	sudo docker logs $(cname)


runivt:
	./ivt run

status:
	sudo docker images
	sudo docker port $(cname)
	sudo docker exec -i $(cname) /sbin/cinitd --command="ps -ef"

logs:
	sudo docker logs $(cname)

stop:
	sudo docker stop $(cname)
 
clean: stop
	sudo docker rm -f $(cname)

cleanall: clean
	sudo docker rmi $(name):$(version)
 
console:
	sudo docker exec -it $(cname) /bin/bash

admin:
	xdg-open http://127.0.0.1:4414/
