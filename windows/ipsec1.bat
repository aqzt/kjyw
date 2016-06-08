Netsh ipsec static add policy name = 默认策略名称

Netsh ipsec static add filteraction name = 阻止操作 action = block

Netsh ipsec static add filteraction name = 允许操作 action = permit

Netsh ipsec static add filterlist name = 访问列表

Netsh ipsec static add filterlist name = 阻止列表

Netsh ipsec static add filter filterlist = 访问列表1 srcaddr = 203.86.32.248 dstaddr = me dstport = 3389 description = 部门1访问 protocol = TCP mirrored = yes

Netsh ipsec static add filter filterlist = 访问列表2 srcaddr = 203.86.31.0 srcmask = 255.255.255.0  dstaddr = 60.190.145.9 dstport = 0 description = 部门2访问 protocol = any mirrored = yes

Netsh ipsec static add rule name = 可访问的终端策略规则 Policy = 默认策略名称 filterlist = 访问列表1 filteraction = 阻止操作

Netsh ipsec static add rule name = 可访问的终端策略规则 Policy = 默认策略名称 filterlist = 访问列表2 filteraction = 阻止操作

netsh ipsec static set policy name = 默认策略名称 assign = y

pause