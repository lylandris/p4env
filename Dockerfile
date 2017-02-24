FROM p4lang/p4c
MAINTAINER lylandris

RUN set -xe \
    && apt-get update \
    && apt-get install -y openssh-server vnc4server \
    && apt-get install -y --no-install-recommends fvwm-crystal \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && mkdir /var/run/sshd \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i s/"PermitRootLogin without-password"/"PermitRootLogin yes"/g /etc/ssh/sshd_config \
    && sed -i 's/x-window-manager \&/fvwm2 \&/g' /etc/alternatives/vncserver \
    && sed -i 's/\$cmd \.= " -pn";/&\n$cmd .= " -SecurityTypes None -localhost";/g' /etc/alternatives/vncserver \
    && sed -i 's/\[ -r \\\$HOME\/\.Xresources/#&/' /etc/alternatives/vncserver \
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh
    && mkdir -p /root/.vnc && touch -a /root/.vnc/passwd && chmod 600 /root/.vnc/passwd \
    && mkdir -p /root/.fvwm

ADD fvwm2rc /root/.fvwm/.fvwm2rc
ADD Xresources /root/.Xresources

WORKDIR /root

RUN set -xe \
    && apt-get update \
    && git clone https://github.com/lylandris/mininet.git \
    && cd mininet \
    && git checkout for_bmv2 \
    && util/install.sh \
    && mv /usr/sbin/tcpdump /usr/bin/tcpdump \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
