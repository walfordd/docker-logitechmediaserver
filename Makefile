SH=/bin/bash
TAG=$(shell cat lmsdeb.txt | sed 's/.*_\([0-9\.~]*\)_all.deb/\1/')
USER=justifiably

build: 
	docker build $(BUILDARGS) --build-arg LMSDEB=`cat lmsdeb.txt` -t $(USER)/logitechmediaserver:$(TAG) .; docker tag $(USER)/logitechmediaserver:$(TAG) $(USER)/logitechmediaserver:latest

base:
	wget -O - -q "http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb" > lmsdeb.txt

# Grab 7.9.2 latest beta release, can be updated in place without rebuilding image.
update:
	-(LMSLATEST=`wget -O - -q "http://www.mysqueezebox.com/update/?version=7.9.2&revision=1&geturl=1&os=deb"`; if [ "`cat lmsdeb.txt`" = "$$LMSLATEST" ]; then echo "No update available"; exit 1; else /bin/echo -n $$LMSLATEST > lmsdeb.txt; fi)
