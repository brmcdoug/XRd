### create ubuntu VM for linux SRv6

1. create a copy of ubuntu-vpp.img 
```
sudo cp ubuntu-vpp.img ubuntu-linux-srv6.img
```

2. copy ubuntu-linux-srv6.xml to your KVM host and define the VM
```
sudo virsh define ubuntu-linux-srv6.xml
```

3. start the VM
```
sudo virsh start ubuntu-linux-srv6
```

4. the VM will boot as "ubuntu-vpp", so we need to connect to the VM console via VNC and change its hostname and force its DHCP IP to change via these instructions: 

 - finding console port:
```
virsh dumpxml ubuntu-linux-srv6
```
find this line in output:
```
<graphics type='vnc' port='5903' autoport='yes' listen='0.0.0.0'>
```
 - in this example we VNC to host_ip:5903
 - vi /etc/hostname and /etc/hosts
 - edit /etc/netplan/00-installer-config.yaml to look like this:

```
network:
  ethernets:
    ens8:
      dhcp4: true
      dhcp-identifier: mac

    ens7: 
      addresses: 
        - 10.10.66.2/24
      routes:
        - to: 10.0.0.0/24
          via: 10.10.66.1
        - to: 10.10.46.0/24
          via: 10.10.66.1
        - to: 10.11.46.0/24
          via: 10.10.66.1

  version: 2
```
 - apply netplan
```
sudo netplan apply
```
 - ifconfig should show ens8 with an IP different from ubuntu-vpp

5. ssh to the new VM using your normal credentials
6. remove /etc/vpp/startup.conf.orig as its no longer in use, and edit /etc/vpp/startup.conf, remove this line:
```
  dev 0000:00:07.0
```

7. reboot the VM
