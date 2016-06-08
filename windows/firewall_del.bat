echo off 
cls 
set var=30000 
set end=30010 
:continue
set /a var+=1 
echo del port %var% 
netsh firewall delete portopening TCP %var% 
if %var% lss %end% goto continue 

netsh firewall delete portopening all 80 
netsh firewall delete portopening all 443 
netsh firewall delete portopening all 3399 
netsh firewall delete portopening all 3299 

echo complete 
pause