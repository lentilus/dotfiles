FROM ubuntu:22.04

RUN apt update

run apt install -y \
        git \
        curl \
        unzip \
        autoconf \
        automake \
        cmake \
        g++ \
        libtool \
        libtool-bin \
        ninja-build \
        pkg-config \
        unzip \
        gettext \
        npm

RUN git clone https://github.com/neovim/neovim.git

RUN cd neovim \
    && git checkout stable \
    && make install

run apt install -y ranger

ARG cache=2
RUN mkdir /root/.config
COPY ./ /root/.config/nvim

RUN nvim --headless # config should quit automatically

