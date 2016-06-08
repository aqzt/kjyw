@rem 配置windows2003系统的IP安全策略
@rem version 3.0 time:2014-5-12

netsh ipsec static add policy name=drop
netsh ipsec static add filterlist name=drop_port
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=21 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=22 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=23 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=25 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=53 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=80 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=135 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=139 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=443 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=445 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=1314 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=1433 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=1521 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=2222 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=3306 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=3433 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=3389 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=4899 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=8080 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any dstport=18186 protocol=TCP mirrored=no
netsh ipsec static add filter filterlist=drop_port srcaddr=me dstaddr=any protocol=UDP mirrored=no
netsh ipsec static add filteraction name=denyact action=block
netsh ipsec static add rule name=kill policy=drop filterlist=drop_port filteraction=denyact
netsh ipsec static set policy name=drop assign=y