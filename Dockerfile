FROM phusion/baseimage:latest
MAINTAINER Boik Su <boik@tdohacker.org>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="MIT" \
    org.label-schema.name="qazbnm456/ctf-box" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/qazbnm456/ctf-box"

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
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# binwalk
RUN git clone https://github.com/devttys0/binwalk.git \
    && cd binwalk/ \
    && python setup.py install

# qira
RUN git clone https://github.com/BinaryAnalysisPlatform/qira.git \
    && cd qira/ \
    && ./install.sh \
    && ./fetchlibs.sh \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# tmux 2.3
RUN wget -qO- https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz | gunzip | tar x \
    && cd tmux-2.3 && ./configure && make -j && make install \
    && cd && rm -rf tmux-2.3

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

# mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian wheezy main" \
    | tee /etc/apt/sources.list.d/mono-xamarin.list \
    && apt-get update \
    && apt-get install -y \
    mono-complete \
    ca-certificates-mono \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# dotfiles by L4ys
RUN touch ~/.bash_history \
    && git clone https://github.com/L4ys/dotfiles.git ~/.dotfiles \
    && cd ~/.dotfiles \
    && make all

# qira
EXPOSE 3002 3003 4000

CMD ["/bin/bash"]
