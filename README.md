# kjyw 快捷运维


## 项目简介
- 快捷运维 kjyw，运维脚本工具库，项目基于shell开发
- 实现快速安装nginx、mysql、php、redis、nagios运维经常使用的脚本等等... 
- 相关使用文档：https://bbs.aqzt.com/forum-39-1.html
- 简单 高效 快捷！
- Linux下很多操作都可以脚本化，脚本化后，可以结合一些自动化工具，批量部署，比如可以用ansible来批量执行脚本，就可以批量部署服务器业务。
- 这里面的脚本是运维经常使用的脚本，方便大家使用！


## 使用场景
- 某天，某人，因某业务，有redis部署需求，需要批量部署一组redis服务，端口从8001到8009，
- 简单，马上开始部署，拷贝redis执行文件，配置文件，8001，再拷贝redis执行文件，修改配置文件，8002…………
- 半小时后部署好了，完成！

- 如果用脚本部署，只需要1分钟搞定，主要是编译redis时间，大大提高效率，快捷，快捷，快捷啊！
- 第一步 编译redis
- curl -s https://git.oschina.net/aqztcom/kjyw/raw/master/redis/install.sh | sh
- 第二步 拷贝redis执行文件，修改配置文件，并启动
- curl -s https://git.oschina.net/aqztcom/kjyw/raw/master/redis/redis_port.sh | sh -s  install 8001 8009
- 完成！

- 批量关闭redis端口 8001到8009
- curl -s https://raw.githubusercontent.com/aqzt/kjyw/master/redis/redis_port.sh  | sh -s  stop 8001 8009
- 批量启动redis端口 8001到8009
- curl -s https://raw.githubusercontent.com/aqzt/kjyw/master/redis/redis_port.sh  | sh -s  start 8001 8009
- 还有其他运维经常使用的脚本，方便使用，提高效率！

## 适合使用的职业
- 运维工程师  （方便运维工程师搭建业务生产环境）
- 开发工程师  （方便开发工程师搭建开发环境）
- 测试工程师  （方便测试工程师搭建测试环境）


## 一起来参与，分享或是交流
- 一起参与完善快捷运维脚本工具库，很多脚本都可以复用，或者改改就可以适用某业务需求，提高工作效率！
- 如果想分享或是交流的话，请加 QQ 群： 7652650 （安全运维）
- Email：ppabc@qq.com


## 微信关注

![image](https://git.oschina.net/aqztcom/kjyw/raw/master/images/aqzt.jpg)

- 运维就是踩坑，踩坑的最高境界就是：踩遍所有的坑，让别人无坑可踩！
- 做事的宗旨是：一条命令的事，一个脚本的事！

