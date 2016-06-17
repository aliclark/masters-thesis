FROM fedora:22

RUN dnf install -y git clang cmake make gcc-c++ xz igraph-devel glib2-devel llvm-devel file

RUN useradd shadow
USER shadow

WORKDIR /home/shadow
RUN git clone https://github.com/shadow/shadow.git -b release

WORKDIR /home/shadow/shadow
RUN ./setup build
RUN ./setup install
RUN echo 'export PATH=$PATH:$HOME/.shadow/bin' >>$HOME/.bashrc

WORKDIR /home/shadow
RUN git clone https://github.com/aliclark/shadow-plugin-extras

RUN mkdir $HOME/shadow-plugin-extras/build
WORKDIR /home/shadow/shadow-plugin-extras/build
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake ..
RUN make install

WORKDIR /home/shadow
ENTRYPOINT ["/home/shadow/.shadow/bin/shadow"]
CMD ["/home/shadow/shadow-plugin-extras/quux/example.xml"]
