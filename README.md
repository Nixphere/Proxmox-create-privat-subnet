# Proxmox create privat subnet
#### This script is for creating a subnet with a local ip address in Proxmox so that vms can communicate with each other without an external ip. (WIP!!)

## How to use 
Autorun:
```bash
sh <(curl https://code.nixphere.de/setproxlocip || wget -O - https://code.nixphere.de/setproxlocip)
```
Manuel dowaload:
```bash
wget https://code.nixphere.de/setproxlocip
chmod +x setproxlocip
./setproxlocip
```
###### First specification: <br>
First you will be asked for the first 3 blocks of an IP which means you should only enter (e.g. 10.69.24) as the rest will be set by the script. You need help with choosing your IP Look here: https://en.wikipedia.org/wiki/Private_network<br>
###### Second specification: <br>
Next you need to specify the main interface for your vms (usually this is `vmbr0`) which is required for the VMs to still have internet and unfortunately cannot be omitted.<br>
###### Third specification: <br>
Next you need to specify a new network interface which does not exist yet (e.g. `vmbr3`) this is needed so that you can assign the network to the VMs and use it in general.<br>
##### Last Step
Now everything necessary is installed and as soon as it is completed you can use the new interface (e.g. `vmbr3`) to specify the ip addresses via DHCP or also statically, but keep in mind that the ip must be correct for static specifications

## VM IP setup
For the example I use the IP address 10.69.24.0/24 and vmbr3 <br>
when you create a VM you have to give it the interface vmbr3 and with static ip 10.69.24.10/24 and as gateway 10.69.24.1 (you can use any ip between 3 and 254 as they are used remotely)
