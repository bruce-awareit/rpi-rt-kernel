all:
	rm -fr build
	mkdir -p build
	docker build -t custom-linux .
	docker run --privileged --name tmp-custom-linux custom-linux /raspios/build.sh
	docker cp tmp-custom-linux:/raspios/2022-04-04-raspios-bullseye-arm64-lite-RT.img.zip ./build/2022-04-04-raspios-bullseye-arm64-lite-RT.img.zip
	docker rm tmp-custom-linux

custom:
	docker run --rm --privileged -it custom-linux bash
