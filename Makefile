.PHONY: dist test build
dockerCheck:
	cd ./actDocker && docker-compose config -q

dockerSync:
	cd ./actDocker && ./sync_maintain.sh

help:
	@echo "make dockerCheck -> check file ./actDocker/docker-compose"
	@echo "make dockerSync -> sync by ./actDocker/sync_maintain.sh"
