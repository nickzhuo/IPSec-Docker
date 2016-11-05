## IPSec Docker Container 

#Openswan/x2ltpd on Ubuntu 14.04 (PreSharedKey)

Build it with:

*docker build --tag="r4ffy/ipsec:v1" ./*


Execute it:


*docker run -d --net host -v /lib/modules/:/lib/modules/  --privileged -t -e USERNAME vpnuser -e PASSWORD ch4ng3m3 -e PRESHAREDKEY y0umustc4ngeme  r4ffy/ipsec:v1*


Enjoy :)
