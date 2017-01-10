#!/bin/sh
set -e

mkdir -p ${HOME}/workspace
sudo docker run -d -p 2222:22 --privileged=true -v ${HOME}/workspace:/root/workspace lylandris/p4env
