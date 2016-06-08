REM Windows 2003 IPsec rule for IPSec

REM del all ipsec policy and start (清掉所有ipsec设置，添加IPSec的一个策略）
netsh ipsec static del all
netsh ipsec static add policy name="IPSec" description="default IPsec policy"

REM add two action block and permit (设置二个规则允许和禁止)
netsh ipsec static add filteraction name=Permit action=permit
netsh ipsec static add filteraction name=Block action=block

REM Frist block all （首先设禁止所有入站访问）
netsh ipsec static add filterlist name=othersdeny description="the defalt rule for other access to server"
netsh ipsec static add filter filterlist=othersdeny srcaddr=me dstaddr=any description="the defalt access ‘s deny"
netsh ipsec static add rule name=blockallaccess policy="IPSec" filterlist=othersdeny filteraction=Block

REM allow ip addrss（允许内网192.168.0.1/24 和202.80.19.12这些IP无限制访问）
netsh ipsec static add filterlist name=allowip description="allow the ip access to server"
netsh ipsec static add filter filterlist=allowip srcaddr=127.0.0.1 dstaddr=me description="the local access"
netsh ipsec static add filter filterlist=allowip srcaddr=192.168.0.1 srcmask=255.255.255.0 dstaddr=me description="allow lan access"
netsh ipsec static add filter filterlist=allowip srcaddr=202.80.19.12 dstaddr=me description="the admin access"
netsh ipsec static add rule name=ruleallowip policy="IPSec" filterlist=allowip filteraction=Permit

REM allow tcp/udp port icmp(对外开放80/3389和允许ping)
netsh ipsec static add filterlist name=allowport description="allow all to access the port of server"
netsh ipsec static add filter filterlist=allowport srcaddr=Any dstaddr=Me protocol=icmp description="allow all to ping"
netsh ipsec static add filter filterlist=allowport srcaddr=Any dstaddr=Me dstport=80 protocol=TCP description="allow all to access the server’s web"
netsh ipsec static add filter filterlist=allowport srcaddr=Any dstaddr=Me dstport=3389 protocol=TCP description="allow all to access the server’s RDP"
netsh ipsec static add rule name=allowopenport policy="IPSec" filterlist=allowport filteraction=Permit

REM allow ip and limit tcp/udp port (允许218.209.98.11访问mysql的3306)
REM netsh ipsec static add filterlist name=ipopenport
REM netsh ipsec static add filter filterlist=ipopenport srcaddr=218.209.98.11 dstaddr=Me dstport=3306 protocol=TCP
REM netsh ipsec static add rule name=allowipopenport policy="IPSec" filterlist=ipopenport filteraction=Permit

REM allow icmp/dns resqust/web access(允许服务器上网 可以打开网站 80及443 允许DNS查询)
netsh ipsec static add filterlist name=output description="Out allow rule"
netsh ipsec static add filter filterlist=output srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=80 description="allow web access"
netsh ipsec static add filter filterlist=output srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=443 description="allow https access"
netsh ipsec static add filter filterlist=output srcaddr=me dstaddr=any protocol=tcp mirrored=yes dstport=53 description="allow tcp dns access "
netsh ipsec static add filter filterlist=output srcaddr=me dstaddr=any protocol=udp mirrored=yes dstport=53 description="allow udp dns access "
netsh ipsec static add filter filterlist=output srcaddr=me dstaddr=any protocol=icmp description="allow ping out"
netsh ipsec static add rule name=output policy="IPSec" filterlist=output filteraction=Permit

REM apply ipsec policy "IPSec" (关键的一步，启用ipsec规则）
netsh ipsec static set policy name="IPSec" assign=y