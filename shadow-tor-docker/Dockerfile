FROM fedora:22

RUN dnf install -y git clang cmake make gcc-c++ xz igraph-devel glib2-devel llvm-devel file tar automake golang zlib-devel

RUN useradd shadow
USER shadow

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/shadow.git

WORKDIR /home/shadow/shadow
RUN ./setup build
RUN ./setup install
ENV PATH $PATH:/home/shadow/.shadow/bin

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/shadow-plugin-tor.git

RUN mkdir /home/shadow/shadow-plugin-tor/build
WORKDIR /home/shadow/shadow-plugin-tor/build

RUN curl -O https://www.openssl.org/source/openssl-1.0.1h.tar.gz
RUN echo 9d1c8a9836aa63e2c6adb684186cbd4371c9e9dcc01d6e3bb447abf2d4d3d093 openssl-1.0.1h.tar.gz | sha256sum -c --strict
RUN tar xaf openssl-1.0.1h.tar.gz
WORKDIR /home/shadow/shadow-plugin-tor/build/openssl-1.0.1h
RUN ./config --prefix=/home/shadow/.shadow shared threads enable-ec_nistp_64_gcc_128 -fPIC
RUN make depend
RUN make -j $(nproc)
RUN make install_sw

WORKDIR /home/shadow/shadow-plugin-tor/build
RUN curl -O https://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
RUN echo 22a530a8a5ba1cb9c080cba033206b17dacd21437762155c6d30ee6469f574f5 libevent-2.0.21-stable.tar.gz | sha256sum -c --strict
RUN tar xaf libevent-2.0.21-stable.tar.gz
WORKDIR /home/shadow/shadow-plugin-tor/build/libevent-2.0.21-stable
RUN ./configure --prefix=/home/shadow/.shadow
RUN make -j $(nproc) install

WORKDIR /home/shadow/shadow-plugin-tor/build
RUN git clone https://github.com/aliclark/libquic
RUN mkdir libquic/build
WORKDIR /home/shadow/shadow-plugin-tor/build/libquic/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make -j $(nproc)

WORKDIR /home/shadow/shadow-plugin-tor/build
RUN git clone https://github.com/aliclark/tor
WORKDIR /home/shadow/shadow-plugin-tor/build/tor
RUN ./autogen.sh
RUN ./configure --disable-transparent --disable-asciidoc CFLAGS="-fPIC -fno-inline -I../libquic/src/quux" --with-libevent-dir=`readlink -f ~`/.shadow --with-openssl-dir=`readlink -f ~`/.shadow
RUN make -j $(nproc) || echo "will fail to link quux due to hard-coded static lib path, but doesn't matter here"

RUN mkdir /home/shadow/shadow-plugin-tor/build/main
WORKDIR /home/shadow/shadow-plugin-tor/build/main
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake ../.. -DTOR_VERSION_A=0 -DTOR_VERSION_B=2 -DTOR_VERSION_C=7 -DTOR_VERSION_D=6
RUN make -j $(nproc) install

WORKDIR /home/shadow/shadow-plugin-tor/resource
RUN tar -xf shadowtor-minimal-config.tar.xz
# Runs out of memory
#RUN tar -xf shadowtor-toy-config.tar.xz

# TODO: Disable logging in the torrc files first?

WORKDIR /home/shadow/shadow-plugin-tor/resource/shadowtor-minimal-config

ENTRYPOINT ["shadow-tor", "-y"]

# TODO: pass out shadow.data and shadow.log (as a tar.gz on stdout?)
# Or copy onto a volume?
