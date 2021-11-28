#!/bin/bash


source .venv/bin/activate
cd ../mininet/rose-srv6-tutorial/nets/8routers-isis-ipv6 || exit
python isis8d.py