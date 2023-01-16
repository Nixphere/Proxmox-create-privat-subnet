echo -e "############################"
echo -e "# Proxmox add local subnet #"
echo -e "#        by DedBash        #"
echo -e "############################"
## Get IP ##
get_Ip(){
    echo -e "Please enter the first 3 blocks of the ip address you want to use for the local subnet. Example: 10.69.5"
    read -p "> " ip
}
get_Ip
if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "IP is valid"
else
    echo "IP is not valid"
    get_Ip
fi
## Get interface name from user input ##
get_Interface(){
    echo -e "Please enter the interface name you want to use for the local subnet. Example: vmbr0"
    read -p "> " interface
}
get_Interface
if ip link show $interface > /dev/null 2>&1; then
    echo "Interface is valid"
else
    echo "Interface is not valid"
    get_Interface
fi
## Get new interface name from user input ##
get_NewInterface(){
    echo -e "Please enter the new interface name you want to use for the local subnet. Example: vmbr2"
    read -p "> " newinterface
}
get_NewInterface
if ip link show $newinterface > /dev/null 2>&1; then
    echo "New interface already exists"
    get_NewInterface
else
    echo "New interface is valid"
fi
## Setup interface ##
echo "auto $newinterface
iface $newinterface inet static
        address  $ip.1
        netmask  255.255.255.0
        bridge_ports none
        bridge_stp off
        bridge_fd 0
        post-up echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   iptables -t nat -A POSTROUTING -s '$ip.0/24' -o $interface -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '$ip.0/24' -o $interface -j MASQUERADE" >> /etc/network/interfaces

## Start interface ##
ifup $newinterface

## Setup DHCP ##
apt-get install dnsmasq -y
systemctl stop systemd-resolved
systemctl disable systemd-resolved
echo "# /etc/dnsmasq.d/vnet
dhcp-range=$ip.20,$ip.200,12h
dhcp-option=option:dns-server,$ip.2" >> /etc/dnsmasq.d/vnet
systemctl start dnsmasq
systemctl enable dnsmasq
