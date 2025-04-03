#
# docker build -t h3dema/ns3:0 -f Dockerfile .
# docker run -it h3dema/ns3:0
#
# FROM wirepas/ns3-docker
FROM ubuntu:22.04

# to test
# ./ns3 configure --build-profile=debug --enable-examples --enable-tests
# ./ns3 run hello-simulator
#
# installation based on
# https://www.nsnam.org/docs/installation/html/linux.html#requirements
#
RUN apt update && apt install -y \
    g++ \
    python3 \
    cmake \
    ninja-build \
    git \
    vim \
    ccache \
    clang-format clang-tidy \
    gdb valgrind

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    tcpdump wireshark \
    sqlite sqlite3 libsqlite3-dev \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    doxygen graphviz imagemagick \
    python3-sphinx dia imagemagick texlive dvipng latexmk texlive-extra-utils texlive-latex-extra texlive-font-utils

RUN apt install -y gsl-bin libgsl-dev libgslcblas0 \
    libxml2 libxml2-dev \
    libgtk-3-dev \
    python3-pip python3-dev python3-setuptools

RUN python3 -m pip install --user cppyy==3.1.2

RUN apt install -y gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 wget

RUN mkdir -p /usr/ns3 && \
    cd /usr/ns3 && \
    wget -c https://www.nsnam.org/releases/ns-allinone-3.44.tar.bz2 && \
    tar xfj ns-allinone-3.44.tar.bz2 && rm -f ns-allinone-3.44.tar.bz2 && \
    cd ns-allinone-3.44/ns-3.44 && \
    echo "export PATH=$PATH:`pwd`" >> /root/.bashrc && \
    export PATH=$PATH:`pwd` && \
    echo "alias cdns3='cd `pwd`'" >> /root/.bashrc && \
    git clone https://gitlab.com/nsnam/ns-3-dev.git && \
    cd ns-3-dev && git checkout -b ns-3.44-release ns-3.44 && \
    ns3 configure --enable-examples --enable-tests && \
    ns3 build

RUN cd /usr/ns3/ && \
    git clone https://github.com/imec-idlab/NB-IoT.git && \
    cd NB-IoT && \
    git checkout energy_evaluation

WORKDIR /usr/ns3/ns-allinone-3.44
