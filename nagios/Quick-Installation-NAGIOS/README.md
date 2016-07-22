# Quick-Installation-NAGIOS
https://github.com/X-Mars/Quick-Installation-NAGIOS
##nagios安装脚本
  
###脚本作者:火星小刘 web:www.huoxingxiaoliu.com email:xtlyk@163.com

本代码为交互代码，个别地方需要手动输入。  
  
####报警邮箱设置方法如下  
  
```bash
vi /etc/mail.rc  
添加你的发件邮箱地址已经smtp，如下  
set from=xtlyk@163.com smtp=smtp.163.com set smtp-auth-user=xtlyk@163.com smtp-auth-password=000000 smtp-auth=login  
可以通过一下命令测试  
echo "Hello World" | mail xtlyk@163.com  
```  
  
####更新日志  
2015.12.07  
1. nagios-4.0.8			升级到	nagios-4.1.1  
2. nagios-plugins-2.0.3	升级到	nagios-plugins-2.1.1  
3. pnp4nagios-0.6.24	升级到	pnp4nagios-0.6.25  
