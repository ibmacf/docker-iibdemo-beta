# Docker Image related
name = ibmimages/iibbeta
version = b710

# Container related
cname = tyrions_iibbeta
webgui = 4414
mqtt = 11883
http = 7800
soap = 7080
debug = 49001
 
.PHONY: build spinup start stop clean console

build:
	time sudo docker build --rm --force-rm=true -t $(name):$(version) .
 
spinup:
	sudo docker run -d -e IIBNODE=TESTNODE \
						-e BARFILE=/tmp/echoService.bar \
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

top:
	sudo docker top $(cname)

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
