#!/bin/sh
set -e

sudo chmod 600 authorized_keys && sudo chown root:root authorized_keys
sudo docker run -d -p 22 --privileged=true -v ${PWD}/authorized_keys:/root/.ssh/authorized_keys lylandris/p4env:base

