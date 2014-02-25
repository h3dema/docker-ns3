FROM ubuntu:precise
MAINTAINER joshjdevl < joshjdevl [at] gmail {dot} com>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get update
RUN apt-get -y install bash bridge-utils ebtables iproute libev4 libev-dev python
RUN apt-get -y install gcc g++ gdb valgrind
RUN apt-get -y install gsl-bin libgsl0-dev libgsl0ldbl
RUN apt-get -y install flex bison libfl-dev
#RUN apt-get -y install g++-3.4 gcc-3.4
RUN apt-get -y install tcpdump
RUN apt-get -y install sqlite sqlite3 libsqlite3-dev
RUN apt-get -y install  libxml2 libxml2-dev
#RUN apt-get -y install libgtk2.0-0 libgtk2.0-dev
RUN apt-get -y install uncrustify
RUN apt-get -y install doxygen graphviz imagemagick
RUN apt-get -y install texlive texlive-extra-utils texlive-latex-extra
RUN apt-get -y install python-sphinx dia 
RUN apt-get -y install python-pygraphviz python-kiwi python-pygoocanvas libgoocanvas-dev
RUN apt-get -y install libboost-signals-dev libboost-filesystem-dev
RUN apt-get -y install gcc-multilib
RUN apt-get -y install gccxml

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
RUN apt-get -y install gccxml python-pygccxml
#http://www.nsnam.org/wiki/NetAnim


#RUN dd if=/dev/zero of=/swapfile bs=1M count=2048
#RUN mkswap /swapfile
#RUN swapon -a

RUN cd && mkdir workspace && cd workspace && hg clone http://code.nsnam.org/bake

RUN cd /workspace/bake && ./bake.py configure -e ns-3.19
RUN cd /workspace/bake && ./bake.py check
#RUN rm -rf /workspace/bake/source/ns-3.19/ 
RUN cd /workspace/bake && ./bake.py download
RUN cd /workspace/bake && ./bake.py build -vvv
RUN cd /workspace/bake/source/ns-3.19 && ./test.py -c core
RUN cd /workspace/bake/source/ns-3.19 && ./waf --run hello-simulator


ADD ns3build.sh /ns3build.sh
RUN cd / && /bin/bash ./ns3build.sh

ADD wscript.dc /wscript.dc
RUN cd /tmp && git clone https://github.com/aravindanbalan/Projects.git
RUN cp -R /tmp/Projects/* /workspace/bake/source/ns-3.19/scratch
RUN mv /workspace/bake/source/ns-3.19/wscript /workspace/bake/source/ns-3.19/wscript.orig
RUN mv /workspace/bake/source/ns-3.19/scratch/wscript.txt /workspace/bake/source/ns-3.19/wscript
RUN mv /wscript.dc /workspace/bake/source/ns-3.19/scratch/wscript
RUN chmod 755 /workspace/bake/source/ns-3.19/wscript && chmod 755 /workspace/bake/source/ns-3.19/scratch/wscript
