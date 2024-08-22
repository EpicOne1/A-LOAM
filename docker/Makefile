all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build              - build all images"
	# @echo "   1. make pull             - pull all images"
	@echo "   1. make clean              - remove all images"
	@echo ""

build:
	# @docker build --tag ros:aloam -f ./Dockerfile ..
	@docker build --network host -f Dockerfile -t ros:aloam .

clean:
	@docker rmi -f ros:aloam
