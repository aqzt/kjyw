# kjyw 快捷运维


## 快捷运维redis cluster搭建
- 安装ruby-2.4.5，redis-4.0.12
```
bash redis.sh install
```

- 初始化配置
```
使用方法: bash redis.sh init 开始端口  结束端口  IP (未指定端口默认为30011 30016 192.168.56.101)
bash redis.sh init  30021 30026 192.168.56.101
或者
curl -s https://gitee.com/aqztcom/kjyw/raw/master/redis/redis_cluster/redis.sh | sh -s init
```

- 启动redis进程
```
使用方法: bash redis.sh start 开始端口  结束端口  IP
bash redis.sh start 30021 30026 192.168.56.101
或者
curl -s https://gitee.com/aqztcom/kjyw/raw/master/redis/redis_cluster/redis.sh | sh -s start
```

- 创建redis cluster集群
```
/opt/redis/bin/redis-trib.rb create --replicas 1 192.168.56.101:30021 192.168.56.101:30022 192.168.56.101:30023 192.168.56.101:30024 192.168.56.101:30025 192.168.56.101:30026
```

- 检查redis cluster集群状态
```
/opt/redis/bin/redis-cli -c -h 192.168.56.101 -p 30021 -a test20200316 cluster nodes
```

- 停止redis集群
```
bash redis.sh stop 30021 30026 192.168.56.101
```

- 卸载redis集群配置
```
bash redis.sh uninstall
```



## 一起来参与，分享或是交流
- 一起参与完善快捷运维脚本工具库，很多脚本都可以复用，或者改改就可以适用某业务需求，提高工作效率！
- 如果想分享或是交流的话，请加 QQ 群： 7652650 （安全运维）
- Email：ppabc@qq.com


## 微信关注

![image](https://raw.githubusercontent.com/aqzt/kjyw/master/images/aqzt.jpg)

- 运维就是踩坑，踩坑的最高境界就是：踩遍所有的坑，让别人无坑可踩！
- 做事的宗旨是：一条命令的事，一个脚本的事！

