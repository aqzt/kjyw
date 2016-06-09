# this script was written by diahosting and edited by ctohome, free to use

mkdir -p /backup/www.ctohome.com/
cd /backup/www.ctohome.com/



yum remove -y pptpd ppp
iptables --flush POSTROUTING --table nat
rm -rf /etc/pptpd.conf
rm -rf /etc/ppp

wget http://www.ctohome.com/linux-vps-pack/vpn/dkms-2.0.17.5-1.noarch.rpm
wget http://www.ctohome.com/linux-vps-pack/vpn/kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
wget http://www.ctohome.com/linux-vps-pack/vpn/pptpd-1.3.4-1.rhel5.1.i386.rpm
wget http://www.ctohome.com/linux-vps-pack/vpn/ppp-2.4.4-9.0.rhel5.i386.rpm

yum -y install make libpcap iptables gcc-c++ logrotate tar cpio perl pam tcp_wrappers
rpm -ivh dkms-2.0.17.5-1.noarch.rpm
rpm -ivh kernel_ppp_mppe-1.0.2-3dkms.noarch.rpm
rpm -qa kernel_ppp_mppe
rpm -Uvh ppp-2.4.4-9.0.rhel5.i386.rpm
rpm -ivh pptpd-1.3.4-1.rhel5.1.i386.rpm

mknod /dev/ppp c 108 0 
echo 1 > /proc/sys/net/ipv4/ip_forward 
echo "mknod /dev/ppp c 108 0" >> /etc/rc.local
echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.local
echo "localip 172.16.36.1" >> /etc/pptpd.conf
echo "remoteip 172.16.36.2-254" >> /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd
echo "ms-dns 8.8.4.4" >> /etc/ppp/options.pptpd

pass1=`openssl rand 6 -base64`
if [ "$1" != "" ]
then pass1=$1
fi

pass2=`openssl rand 6 -base64`
if [ "$1" != "" ]
then pass2=$1
fi

echo -e "vpn1 pptpd ${pass1} *\nvpn2 pptpd ${pass2} *" >> /etc/ppp/chap-secrets

iptables -t nat -A POSTROUTING -s 172.16.36.0/255.255.255.0 -j SNAT --to-source `ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1 { print $1}'`
service iptables save

chkconfig iptables on
chkconfig pptpd on

service iptables start
service pptpd start


echo '';
echo '';
echo '';
echo '';
echo '';
echo '**********************************************************';
echo '*******     PPTPD VPN service was installed        *******';
echo '*******                                            *******';
echo '*******    2 VPN username and password created     *******';
echo '*******                                            *******';
echo "*******  VPN username: vpn1   password: ${pass1}   *******";
echo "*******  VPN username: vpn2   password: ${pass2}   *******";
echo '*******                                            *******';
echo '*******                                            *******';
echo "*******    VPN Script usage, note and upgrade:     *******";
echo '*******                                            *******';
echo '*******  http://www.ctohome.com/FuWuQi/8b/291.html *******';
echo '*******                                            *******';
echo "*******      How to use VPN via windows xp:        *******";
echo '*******                                            *******';
echo '*******  http://www.ctohome.com/FuWuQi/92/273.html *******';
echo '*******                                            *******';
echo '**********************************************************';
echo '';
echo '';

