rem 恢复防火墙到默认值
netsh advfirewall reset
	 
rem 设置变量offices_vpn与internal_servers
set offices_vpn=203.208.11.200/32,119.75.211.56/32,131.253.11.32/32
set internal_servers=192.168.11.0/16,218.30.118.211/32
 
rem 开放端口3389到offices_vpn
netsh advfirewall firewall add rule name="自定义规则_port3389_from_offices_vpn" dir=in protocol=tcp localport=3389 remoteip=%offices_vpn% action=allow

rem 建立对internal_servers之间的相互信任
netsh advfirewall firewall add rule name="自定义规则_trust_all_internal_servers" dir=in remoteip=%internal_servers% action=allow

rem 开放端口80到所有地址
netsh advfirewall firewall add rule name="自定义规则_port80_from_anywhere" dir=in protocol=tcp localport=80 action=allow