rem ##http://tilt.lib.tsinghua.edu.cn/node/518
REM =================开始咯================
netsh ipsec static ^
delete policy name=Haishion
netsh ipsec static ^
add policy name=Haishion

REM 添加2个动作，禁止和允许
netsh ipsec static ^
add filteraction name=Perm action=permit
netsh ipsec static ^
add filteraction name=Block action=block

REM 首先干掉所有访问
netsh ipsec static ^
add filterlist name=AllAccess
netsh ipsec static ^
add filter filterlist=AllAccess srcaddr=Me dstaddr=Any
netsh ipsec static ^
add rule name=BlockAllAccess policy=Haishion filterlist=AllAccess filteraction=Block

REM 开放某些IP无限制访问
netsh ipsec static ^
add filterlist name=UnLimitedIP
netsh ipsec static ^
add filter filterlist=UnLimitedIP srcaddr=210.34.0.1 dstaddr=Me
netsh ipsec static ^
add filter filterlist=UnLimitedIP srcaddr=210.34.0.2 dstaddr=Me
netsh ipsec static ^
add rule name=AllowUnLimitedIP policy=Haishion filterlist=UnLimitedIP filteraction=Permit

REM 开放某些端口
netsh ipsec static ^
add filterlist name=OpenSomePort
netsh ipsec static ^
add filter filterlist=OpenSomePort srcaddr=Any dstaddr=Me dstport=20 protocol=TCP
netsh ipsec static ^
add filter filterlist=OpenSomePort srcaddr=Any dstaddr=Me dstport=21 protocol=TCP
netsh ipsec static ^
add filter filterlist=OpenSomePort srcaddr=Any dstaddr=Me dstport=80 protocol=TCP
netsh ipsec static ^
add rule name=AllowOpenSomePort policy=Haishion filterlist=OpenSomePort filteraction=Permit

REM 开放某些ip可以访问某些端口
netsh ipsec static ^
add filterlist name=SomeIPSomePort
netsh ipsec static ^
add filter filterlist=SomeIPSomePort srcaddr=Me dstaddr=Any dstport=53 protocol=UDP
netsh ipsec static ^
add filter filterlist=SomeIPSomePort srcaddr=Me dstaddr=Any dstport=80 protocol=TCP
netsh ipsec static ^
add filter filterlist=SomeIPSomePort srcaddr=210.34.0.3 dstaddr=Me dstport=8080 protocol=TCP
netsh ipsec static ^
add rule name=AllowSomeIPSomePort policy=Haishion filterlist=SomeIPSomePort filteraction=Permit