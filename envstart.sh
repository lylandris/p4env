#!/bin/sh
set -e

mkdir -p ${HOME}/workspace
sudo touch -a authorized_keys && sudo chmod 600 authorized_keys && sudo chown root:root authorized_keys
sudo docker run -d -p 22 --privileged=true -v ${PWD}/authorized_keys:/root/.ssh/authorized_keys -v ${HOME}/workspace:/root/workspace lylandris/p4env:base

