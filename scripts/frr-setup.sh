#!/bin/bash

# wget https://github.com/FRRouting/frr/archive/frr-7.3.1.zip

# unzip frr-7.3.1.zip
# cd frr-frr-7.3.1 || {
#     echo "Failure"
#     exit 1
# }

#sudo apt-get install -y dh-autoreconf
# ./bootstrap.sh



# sudo apt-get install -y \
#     git autoconf automake libtool make libreadline-dev texinfo \
#     pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
#     libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
#     install-info build-essential libsystemd-dev libsnmp-dev perl libcap-dev

git clone https://github.com/frrouting/frr.git frr
cd frr
./bootstrap.sh
./configure \
    --prefix=/usr \
    --includedir=\${prefix}/include \
    --enable-exampledir=\${prefix}/share/doc/frr/examples \
    --bindir=\${prefix}/bin \
    --sbindir=\${prefix}/lib/frr \
    --libdir=\${prefix}/lib/frr \
    --libexecdir=\${prefix}/lib/frr \
    --localstatedir=/var/run/frr \
    --sysconfdir=/etc/frr \
    --with-moduledir=\${prefix}/lib/frr/modules \
    --with-libyang-pluginsdir=\${prefix}/lib/frr/libyang_plugins \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-snmp=agentx \
    --enable-multipath=64 \
    --enable-user=frr \
    --enable-group=frr \
    --enable-vty-group=frrvty \
    --with-pkg-git-version \
    --disable-ripd \
    --disable-ripngd \
    --disable-ospfd \
    --disable-ospf6d \
    --disable-bgpd \
    --disable-ldpd \
    --disable-nhrpd \
    --disable-eigrpd \
    --disable-babeld \
    --disable-watchfrr \
    --disable-pimd \
    --disable-vrrpd \
    --disable-pbrd \
    --disable-bgp-announce \
    --disable-bgp-vnc \
    --disable-bgp-bmp \
    --disable-ospfapi \
    --disable-ospfclient \
    --disable-fabricd \
    --disable-irdp \
    --enable-shell-access \
    --with-pkg-extra-version=-FRR_Rose
make
# sudo make install

cd ..
rm frr-7.3.1.zip
