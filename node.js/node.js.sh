#!/bin/bash
##   2016-06-06
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

##访问https://github.com/creationix/nvm查看
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
##Haraka指定版本
nvm install v0.10.33
##指定版本v4.4.4
nvm install v4.4.4
npm install -g pm2
pm2 list
