FROM ubuntu:14.04.5
MAINTAINER lylandris

RUN set -xe \
    && apt-get update \
    && apt-get install -y sudo openssh-server vnc4server \
    && apt-get install -y --no-install-recommends fvwm-crystal \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && mkdir /var/run/sshd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i s/"PermitRootLogin without-password"/"PermitRootLogin yes"/g /etc/ssh/sshd_config \
    && sed -i 's/x-window-manager \&/fvwm2 \&/g' /etc/alternatives/vncserver \
    && sed -i 's/\$cmd \.= " -pn";/&\n$cmd .= " -SecurityTypes None -localhost";/g' /etc/alternatives/vncserver \
    && sed -i 's/\[ -r \\\$HOME\/\.Xresources/#&/' /etc/alternatives/vncserver \
    && mkdir -p /root/.vnc && touch -a /root/.vnc/passwd && chmod 600 /root/.vnc/passwd \
    && mkdir -p /root/.fvwm

ADD .fvwm2rc /root/.fvwm/.fvwm2rc

WORKDIR /root

RUN set -xe \
    && apt-get update \
    && apt-get install -y git net-tools vim wget \
    && git clone https://github.com/lylandris/behavioral-model.git \
    && cd behavioral-model \
    && git checkout 1.4.x \
    && ./install_deps.sh \
    && ./autogen.sh \
    && ./configure \
    && make && make install && make clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && apt-get update \
    && git clone https://github.com/p4lang/p4c-bm.git \
    && cd p4c-bm \
    && pip install -r requirements.txt \
    && python setup.py install \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && apt-get update \
    && git clone https://github.com/p4lang/scapy-vxlan.git \
    && cd scapy-vxlan \
    && python setup.py install \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && apt-get update \
    && git clone https://github.com/lylandris/mininet.git \
    && cd mininet \
    && git checkout for_bmv2 \
    && util/install.sh \
    && mv /usr/sbin/tcpdump /usr/bin/tcpdump \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
