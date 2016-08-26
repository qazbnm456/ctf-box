FROM phusion/baseimage:latest
MAINTAINER Boik Su <boik@tdohacker.org>

WORKDIR /root

RUN dpkg --add-architecture i386 && apt-get update \
    && apt-get install build-essential -y \
    && apt-get install -y \
    autojump \
    git \
    libc6-i386 \
    libc6-dev-i386 \
    libssl-dev \
    libssl-dev:i386 \
    libgmp-dev \
    libevent-dev \
    libffi-dev \
    gcc \
    g++ \
    gdb \
    ncurses-dev \
    ltrace \
    strace \
    make \
    man \
    nasm \
    nmap \
    python2.7 \
    python2.7-dev \
    python-pip \
    virtualenvwrapper \
    python-lzma \
    wget \
    vim \
    sudo

# binwalk
RUN git clone https://github.com/devttys0/binwalk.git \
    && cd binwalk/ \
    && python setup.py install

# qira
RUN git clone https://github.com/BinaryAnalysisPlatform/qira.git \
    && cd qira/ \
    && ./install.sh \
    && ./fetchlibs.sh

# tmux 2.0
RUN wget -qO- https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz | gunzip | tar x \
    && cd tmux-2.2 && ./configure && make -j && make install \
    && cd && rm -rf tmux-2.2

# peda
RUN git clone https://github.com/longld/peda.git ~/.peda

# pwngdb
RUN git clone https://github.com/scwuaptx/Pwngdb.git ~/.pwngdb

# ipython
RUN pip install ipython

# pwntools
RUN pip install --upgrade pwntools

# ROPgadget
RUN git clone -b master https://github.com/JonathanSalwan/ROPgadget.git \
    && cd ROPgadget \
    && python setup.py install

# z3
RUN git clone https://github.com/Z3Prover/z3 \
    && cd z3 \
    && python scripts/mk_make.py --python \
    && cd build \
    && make \
    && make install

# angr
RUN pip install angr

# dotfiles by L4ys
RUN touch ~/.bash_history \
    && git clone https://github.com/L4ys/dotfiles.git ~/.dotfiles \
    && cd ~/.dotfiles \
    && make all

# qira
EXPOSE 3002 3003 4000
