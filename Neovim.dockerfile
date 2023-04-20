FROM alpine:latest

RUN apk add --no-cache --update \
  git \
  alpine-sdk build-base\
  libtool \
  automake \
  m4 \
  autoconf \
  linux-headers \
  unzip \
  ncurses ncurses-dev ncurses-libs ncurses-terminfo \
  clang \
  go \
  nodejs \
  xz \
  curl \
  make \
  cmake \
  samurai \
  gperf \
  tree-sitter-dev \
  && rm -rf /var/cache/apk/*

WORKDIR /tmp
ENV CMAKE_EXTRA_FLAGS=-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DENABLE_JEMALLOC=FALSE \
		-DENABLE_LTO=TRUE \
		-DCMAKE_VERBOSE_MAKEFILE=TRUE \
		-DCI_BUILD=OFF

RUN git clone https://github.com/neovim/libtermkey.git && \
  cd libtermkey && \
  make && \
  make install && \
  cd ../ && rm -rf libtermkey

RUN git clone https://github.com/neovim/unibilium.git && \
  cd unibilium && \
  autoreconf -fi && \
  ./configure && \
  make && \
  make install && \
  cd ../ && rm -rf unibilium


RUN  git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
  make && \
  make install && \
  cd ../ && rm -rf nvim

