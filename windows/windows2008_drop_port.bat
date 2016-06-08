@rem 配置windows2008系统的IP安全策略
@rem version 3.0 time:2014-5-12

@rem 重置防火墙使用默认规则
netsh firewall reset
netsh firewall set service remotedesktop enable all

@rem 配置高级windows防火墙
netsh advfirewall firewall add rule name="drop" protocol=TCP dir=out remoteport="21,22,23,25,53,80,135,139,443,445,1433,1314,1521,2222,3306,3433,3389,4899,8080,18186" action=block
netsh advfirewall firewall add rule name="dropudp" protocol=UDP dir=out remoteport=any action=block