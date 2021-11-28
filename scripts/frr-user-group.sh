#!/bin/bash

groupadd -r -g 92 frr
groupadd -r -g 85 frrvty
adduser --system --ingroup frr --home /var/run/frr/ \
    --gecos "FRR suite" --shell /sbin/nologin frr
usermod -a -G frrvty frr