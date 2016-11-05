FROM ubuntu:14.04

MAINTAINER Raffaele Sommese <raffysommy@gmail.com>

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nano lsof iptables ipsec-tools iproute2 openswan openssl xl2tpd wget

RUN mkdir /tmp/setup

WORKDIR /tmp/setup

ENV USERNAME vpnuser
ENV PASSWORD ch4ng3m3
ENV PRESHAREDKEY y0umustc4ngeme
ENV PUBLICIP 0.0.0.0
VOLUME /lib/modules


EXPOSE 500/udp 4500/udp 

COPY setup.sh ./

RUN chmod +x setup.sh

COPY ipsec.conf /etc/ipsec.conf
COPY xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY options.xl2tpd /etc/ppp/options.xl2tpd

CMD ["./setup.sh"]

