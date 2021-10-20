FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  git \
  cmake \
  ninja-build \
  g++ \
  python3 \
  python3-numpy \
  python3-dev \
  autotools-dev \
  autoconf \
  autoconf-archive \
  gnu-standards \
  libtool \
  gettext \
  libdrm-dev \
  pkg-config \
  bison \
  flex \
  libgmp3-dev \
  libmpc-dev \
  libmpfr-dev \
  libz-dev \
  make \
  nasm \
  ccache


VOLUME /workdir
VOLUME /scripts
VOLUME /cache

WORKDIR /workdir
