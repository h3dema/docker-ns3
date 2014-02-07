FROM ubuntu:precise
MAINTAINER joshjdevl < joshjdevl [at] gmail {dot} com>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get update
RUN apt-get -y install bash bridge-utils ebtables iproute libev4 libev-dev python

RUN apt-get -y install wget 
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN echo "root:josh" | chpasswd

RUN apt-get -y install autoconf automake build-essential
RUN apt-get -y install mercurial git cvs
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
#RUN apt-cache policy unrar
#RUN apt-get update && apt-get -y install ubuntu-restricted-extras
RUN apt-get -y install bzr cmake unzip unrar-free p7zip-full
RUN apt-get -y install qt4-qmake qt4-dev-tools python-dev python-pygoocanvas python-pygraphviz
RUN cd /tmp && wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py && python get-pip.py
RUN pip install -e "bzr+https://code.launchpad.net/~gjc/pybindgen/trunk#egg=pybindgen"
#http://www.nsnam.org/wiki/NetAnim


RUN cd && mkdir workspace && cd workspace && hg clone http://code.nsnam.org/bake

RUN cd /workspace/bake && ./bake.py configure -e ns-3.18.1
RUN cd /workspace/bake && ./bake.py check
RUN cd /workspace/bake && ./bake.py download
RUN cd /workspace/bake && ./bake.py build
RUN cd /workspace/bake/source/ns-3.18.1 && ./test.py -c core
RUN cd /workspace/bake/source/ns-3.18.1 && ./waf --run hello-simulator

