#!/bin/bash


git clone https://github.com/CESNET/libyang.git &&
    cd libyang &&
    git checkout v2.0.0 &&
    mkdir build
cd build &&
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
    make -j $(nproc) &&
    sudo make install
