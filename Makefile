# Docker Image related
name = iibdemo/iibdemo
version = 10.0.710.0

# Container related
cname = tyrions_iibbeta
webgui = 4414
mqtt = 11883
http = 7800
soap = 7080
debug = 49001
 
.PHONY: build spinup start stop clean console logs admin ps

build:
	sudo docker build --rm --force-rm=true -t $(name):$(version) .

configure: spinup 
	sudo docker exec -it $(cname) /sbin/cinitd --command=/root/configure/echoService/configure.sh
 
spinup:
	sudo docker run -d \
				-p $(webgui):$(webgui) \
				-p $(mqtt):$(mqtt) \
				-p $(http):$(http) \
				-p $(soap):$(soap) \
				-p $(debug):$(debug) \
				--name=$(cname) \
				$(name):$(version) 
 
start:
	sudo docker start $(cname)

runivt:
	./ivt run

ps:
	sudo docker exec -i $(cname) /sbin/cinitd --command="ps -ef"

showports:
	sudo docker port $(cname)

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

logs:
	sudo docker logs $(cname)
