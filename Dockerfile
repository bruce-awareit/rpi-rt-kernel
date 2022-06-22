FROM ubuntu:20.04

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y git make gcc bison flex libssl-dev bc ncurses-dev kmod
RUN apt-get install -y crossbuild-essential-arm64
RUN apt-get install -y wget zip unzip fdisk nano

WORKDIR /rpi-kernel
RUN git clone https://github.com/raspberrypi/linux.git -b rpi-5.10.y --depth=1
RUN wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.10/patch-5.10.90-rt61-rc1.patch.gz

WORKDIR /rpi-kernel/linux/

ENV KERNEL=kernel8
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

RUN gzip -cd ../patch-5.10.90-rt61-rc1.patch.gz | patch -p1 --verbose
RUN make bcm2711_defconfig

ADD .config ./
RUN make Image modules dtbs

WORKDIR /raspios
RUN apt -y install 
RUN wget https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2022-04-07/2022-04-04-raspios-bullseye-arm64-lite.img.xz
RUN xz -d 2022-04-04-raspios-bullseye-arm64-lite.img.xz
RUN mkdir /raspios/mnt && mkdir /raspios/mnt/disk && mkdir /raspios/mnt/boot

ADD build.sh ./
ADD config.txt ./
