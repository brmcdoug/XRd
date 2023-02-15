#/bin/bash

echo "list docker networks"
docker network ls

echo "mapping docker networks to bridge instance files"

docker network ls | awk -F': ' '/xrd_xrd46-host /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd46-host
echo br-"$netinstance"

# brctl show | grep br-"$netinstance" > br.txt 
# veth1to2=$(rev br.txt | cut -c -11 | rev ) 
# sudo tc qdisc add dev $veth1to2 root netem delay 10000


rm net.txt
rm br.txt