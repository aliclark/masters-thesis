FROM fedora:22

RUN dnf install -y git clang cmake make gcc-c++ xz igraph-devel glib2-devel llvm-devel file

RUN useradd shadow
USER shadow

WORKDIR /home/shadow
RUN git clone https://github.com/shadow/shadow.git -b release

WORKDIR /home/shadow/shadow
RUN ./setup build
RUN ./setup install
ENV PATH $PATH:/home/shadow/.shadow/bin

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/shadow-plugin-extras

RUN mkdir $HOME/shadow-plugin-extras/build
WORKDIR /home/shadow/shadow-plugin-extras/build
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake ..
RUN make install

USER root
RUN dnf install -y tar findutils openssl
USER shadow

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/proto-quic
ENV PATH $PATH:/home/shadow/proto-quic/depot_tools

WORKDIR /home/shadow/proto-quic/src/
RUN gclient runhooks
RUN ninja -C out/Debug quic_server quic_client

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/masters-thesis

WORKDIR /home/shadow/masters-thesis/basic-c-program/certs
RUN ./generate-certs.sh

WORKDIR /home/shadow/masters-thesis/basic-c-program
RUN ./make-server.sh
RUN ./make-client.sh

# Hack, just to initialize ~/.pki database properly
RUN ./build/test_client --host=127.0.0.1 https://www.example.org/ || echo expected ^

# TODO: Should probably regenerate certs each run using CMD?
RUN certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n QUIC-TEST-3DAYS-$(date +%Y%m%d) -i certs/out/2048-sha256-root.pem

WORKDIR /home/shadow/shadow-plugin-extras
ENTRYPOINT ["shadow"]
CMD ["quux/example.xml"]
