#!/bin/sh
set -e

mkdir -p ${HOME}/workspace
dockerId=$(docker run -d -p 2222:22 --privileged=true -v ${HOME}/workspace:/root/workspace lylandris/p4env)
docker cp ${HOME}/.ssh/authorized_keys ${dockerId}:/root/.ssh/.
