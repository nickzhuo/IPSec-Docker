## IPSec Docker Container (PreSharedKey)
Build it with:
#docker build --tag="ns/ipsec:v1" ./
Execute it:
docker run -d --net host -v /lib/modules/:/lib/modules/  --privileged -t -e USERNAME vpnuser -e PASSWORD ch4ng3m3 -e PRESHAREDKEY y0umustc4ngeme  ns/ipsec:v1
Enjoy :)
