echo off 
cls 
set var=30000 
set end=30010 
:continue
set /a var+=1 
echo add port %var% 
netsh firewall add portopening TCP %var% ftp_data_%var% 
if %var% lss %end% goto continue 

netsh firewall set portopening all 80 aqzt.com-80 enable 
netsh firewall set portopening all 443 aqzt.com-443 enable 
netsh firewall set portopening all 3399 aqzt.com-3399 enable 
netsh firewall set portopening all 3299 aqzt.com-3299 enable 
netsh firewall set portopening TCP 3389 aqzt.com-3298 enable  CUSTOM 1.1.1.11

echo complete 
pause