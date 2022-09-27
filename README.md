## Launch an XRd topology on a VM or AWS instance 
### Ubuntu 20.04 in both cases

If using AWS I recommend EC2 instance t3a.xlarge or larger for a 6 node topology

1. Copy files from this repo to your AWS VM
2. Upload an XRd image to your VM
      CCO download site: https://software.cisco.com/download/home/286331236/type/280805694/release/7.7.1
5. Install docker https://docs.docker.com/engine/install/ubuntu/
6. Install docker-compose: sudo apt install docker-compose
7. docker without sudo:  sudo usermod -aG docker $USER
      
      Then logout/login
7. Load your image:
```
docker load -i xrd-control-plane-container-x64.7.7.1.tgz
```
7. check image status: docker images
8. add these lines to the end of /etc/sysctl.conf 
```
net.bridge.bridge-nf-call-iptables=0
net.bridge.bridge-nf-call-ip6tables=0
fs.inotify.max_user_instances=65536
```
9. Reload sysctl:  sudo sysctl -p
10. Host check:  sudo ./host-check 
   
   You may see hugepages and IOMMU errors/warnings. I proceeded without addressing these.
  
11. Dry run then launch topology
```
./launch-xrd --dry-run localhost/ios-xr:7.7.1
  
./xr-compose -f docker-compose-6-node.yml -i localhost/ios-xr:7.7.1 -l

or

./xr-compose -f docker-compose-4-node.yml -i localhost/ios-xr:7.7.1 -l
  
```
12. check containers: docker ps
13. access XR cli:
```
docker exec -it xrd-27 /pkg/bin/xr_cli.sh
```

14. Cleanup:
```
docker-compose down
docker volume rm xrd-25
docker volume rm xrd-26
docker volume rm xrd-27
docker volume rm xrd-28
docker volume rm xrd-29
docker volume rm xrd-30
```

14. Cleanup if running 4-node topology:
```
docker-compose down
docker volume rm xrd-31
docker volume rm xrd-32
docker volume rm xrd-33
docker volume rm xrd-34

```
