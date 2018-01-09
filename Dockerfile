FROM ubuntu:16.04

RUN apt-get update && apt-get -y install python-software-properties software-properties-common
#RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
#RUN apt-get update

RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update
RUN apt-get -y install apt-fast

RUN apt-fast -y install bash bridge-utils ebtables iproute libev4 libev-dev python
RUN apt-fast -y install gcc g++ gdb valgrind
RUN apt-fast -y install gsl-bin libgsl0-dev libgsl0ldbl
RUN apt-fast -y install flex bison libfl-dev
RUN apt-fast -y install tcpdump
RUN apt-fast -y install sqlite sqlite3 libsqlite3-dev
RUN apt-fast -y install libxml2 libxml2-dev
RUN apt-fast -y install uncrustify
RUN apt-fast -y install doxygen graphviz imagemagick
RUN apt-fast -y install texlive texlive-extra-utils texlive-latex-extra
RUN apt-fast -y install python-sphinx dia 
RUN apt-fast -y install python-pygraphviz python-kiwi python-pygoocanvas libgoocanvas-dev
RUN apt-fast -y install libboost-signals-dev libboost-filesystem-dev
RUN apt-fast -y install gcc-multilib
RUN apt-fast -y install gccxml

RUN apt-fast -y install wget 
RUN apt-fast install -y openssh-server
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN echo "root:josh" | chpasswd

RUN apt-fast -y install autoconf automake build-essential
RUN apt-fast -y install mercurial git cvs
RUN apt-fast -y install bzr cmake unzip unrar-free p7zip-full
RUN apt-fast -y install qt4-qmake qt4-dev-tools python-dev python-pygoocanvas python-pygraphviz
RUN cd /tmp && wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py && python get-pip.py
RUN apt-fast -y install gccxml python-pygccxml
#http://www.nsnam.org/wiki/NetAnim


RUN apt-fast -y install python-dev python-pygraphviz python-kiwi python-pygoocanvas \
                     python-gnome2 python-gnomedesktop python-rsvg

RUN apt-fast install -y aptitude
RUN apt-fast install -y checkinstall libpcap-dev

#ns3
RUN cd && mkdir workspace && cd workspace && hg clone http://code.nsnam.org/bake
RUN cd /workspace/bake && ./bake.py configure -e ns-allinone-3.20
RUN cd /workspace/bake && ./bake.py check
RUN cd /workspace/bake && ./bake.py download
RUN cd /workspace/bake && ./bake.py build -vvv
RUN cd /workspace/bake/source/ns-3.20 && ./test.py -c core
RUN cd /workspace/bake/source/ns-3.20 && ./waf --run hello-simulator

#project setup
ADD wscript.dc /wscript.dc
RUN cd /tmp && git clone https://github.com/aravindanbalan/Projects.git
RUN cp -R /tmp/Projects/* /workspace/bake/source/ns-3.20/scratch
RUN mv /workspace/bake/source/ns-3.20/wscript /workspace/bake/source/ns-3.20/wscript.orig
RUN mv /workspace/bake/source/ns-3.20/scratch/wscript.txt /workspace/bake/source/ns-3.20/wscript
RUN mv /wscript.dc /workspace/bake/source/ns-3.20/scratch/wscript
RUN chmod 755 /workspace/bake/source/ns-3.20/wscript && chmod 755 /workspace/bake/source/ns-3.20/scratch/wscript


#cryptopp
RUN cd / && wget http://www.cryptopp.com/cryptopp562.zip 
RUN mkdir -p /cryptopp && mv /cryptopp562.zip /cryptopp/cryptopp562.zip && cd /cryptopp && unzip cryptopp562.zip
RUN cd /cryptopp && make -j 4
RUN cd /cryptopp && make install

RUN cd /tmp/Projects && git pull 
RUN cp /tmp/Projects/wscript.txt /workspace/bake/source/ns-3.20/wscript
RUN cd /tmp/Projects && git pull && cp -R /tmp/Projects/* /workspace/bake/source/ns-3.20/scratch
#RUN cd /workspace/bake/source/ns-3.20 && ./waf --run scratch/SendPacket

#Wireshark
RUN cd /tmp && wget https://2.na.dl.wireshark.org/src/wireshark-1.10.7.tar.bz2
RUN cd /tmp && tar -xvf wireshark-1.10.7.tar.bz2
RUN cd /tmp/wireshark-1.10.7 && ./configure && make -j 5 
RUN cd /tmp/wireshark-1.10.7 && make install

RUN apt-fast -y install astyle vim

RUN cd /tmp/Projects && git pull && git checkout numnodesfix && ./ns3.sh
RUN cd /workspace/bake/source/ns-3.20 && ./waf --run "scratch/SendPacket --numNodes=3"
