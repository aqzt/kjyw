echo 创建安全策略
Netsh IPsec static add policy name = APU安全策略

echo 创建筛选器是阻止的操作
Netsh IPsec static add filteraction name = stop action = block

echo 创建筛选器是允许的操作
Netsh IPsec static add filteraction name = open action = permit

echo 建立一个筛选器可以访问的终端列表
Netsh IPsec static add filterlist name = 可访问的终端列表
Netsh IPsec static add filter filterlist = 可访问的终端列表 srcaddr = 203.86.32.248 dstaddr = me dstport = 3389 description = 部门1访问 protocol = TCP mirrored = yes

echo 建立一个筛选器可以访问的终端列表
Netsh ipsec static add filter filterlist = 可访问的终端列表 Srcaddr = 203.86.31.0 srcmask=255.255.255.0 dstaddr = 60.190.145.9 dstport = 0 description = 部门2访问 protocol =any mirrored = yes

echo 建立策略规则
Netsh ipsec static add rule name = 可访问的终端策略规则 Policy = APU安全策略 filterlist = 可访问的终端列表 filteraction = stop

echo 激活策略
netsh ipsec static set policy name = APU安全策略 assign = y
pause