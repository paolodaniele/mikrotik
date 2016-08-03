###Server
 
/interface pptp-server server
set authentication=pap,chap,mschap1,mschap2 keepalive-timeout=disabled
 
/ppp secret
add local-address=172.16.200.1 name=sito2 password=sito2 remote-address=172.16.200.2 service=l2tp
 
/ip ipsec peer
add address=172.16.200.2/32 comment=Sito1_ipsec dpd-interval=10s enc-algorithm=3des nat-traversal=no secret=1234567
 
/ip ipsec policy
add comment="Sito2 > Sito1" dst-address=192.168.1.0/24 level=unique sa-dst-address=172.16.200.2 sa-src-address=172.16.200.1 src-address=192.168.2.0/24 tunnel=yes
 
/ip route
add check-gateway=ping comment=ReteSito1 distance=1 dst-address=192.168.1.0/24 gateway=172.16.200.2
 
/ip firewall nat
add chain=srcnat comment="Nat Bypass Sito1 > Sito2" dst-address=192.168.1.0/24
 
 
###Client
 
/interface l2tp-client
add allow=mschap2 connect-to=xx.xx.xx.x disabled=no name=l2tp-sito2 password=sito1 user=sito1
 
/ip ipsec peer
add address=172.16.200.1/32 comment=Sito2 dpd-interval=10s enc-algorithm=3des nat-traversal=no secret=1234567
 
/ip ipsec policy
add comment="Sito2 > Sito1" dst-address=192.168.2.0/24 level=unique sa-dst-address=172.16.200.1 sa-src-address=172.16.200.2 src-address=192.168.1.0/24 tunnel=yes
 
/ip route
add check-gateway=ping comment=ReteSito2 distance=1 dst-address=192.168.2.0/24 gateway=172.16.200.1
 
/ip firewall nat
add chain=srcnat comment="Nat Bypass Sito2 > Sito1" dst-address=192.168.2.0/24
