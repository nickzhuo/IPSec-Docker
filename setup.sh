#!/bin/sh
PUBLICIP=`wget -q -O - http://ipecho.net/plain`;

echo "net.ipv4.conf.all.accept_redirects = 0" | tee -a /etc/sysctl.conf

echo "net.ipv4.conf.all.send_redirects = 0" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" | tee -a /etc/sysctl.conf

echo "net.ipv4.conf.default.send_redirects = 0" | tee -a /etc/sysctl.conf

sysctl -p
sysctl -w net.ipv4.ip_forward=1
echo "Replace IP Address"
sed -i "s/left=.*$/left=$PUBLICIP/g" /etc/ipsec.conf
sed -i "s/listen-addr=.*$/listen-addr=$PUBLICIP/g" /etc/xl2tpd/xl2tpd.conf
ifconfig eth0 $PUBLICIP
echo "Init of /etc/ipsec.secrets"
cat > /etc/ipsec.secrets <<EOF
$PUBLICIP  %any  : PSK "$PRESHAREDKEY"
EOF

echo "Creating user"
adduser --quiet --disabled-password -shell /bin/bash --home /home/$USERNAME --gecos "test" $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
echo "Init of /etc/chap-secrets"
cat > /etc/ppp/chap-secrets <<EOF
"$USERNAME" "*" "$PASSWORD" "*"
EOF


/usr/sbin/service ipsec start
/usr/sbin/service xl2tpd start

echo "Impostazione delle regole di firewall"
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -m policy --dir out --pol ipsec -j ACCEPT
echo "VPN impostata sull IP $PUBLICIP"
echo "Username:$USERNAME Password:$PASSWORD"
echo "PSK:$PRESHAREDKEY"

echo "KeepAlive"
ping -i 3600 8.8.8.8 > /dev/null
