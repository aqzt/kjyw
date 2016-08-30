#!/bin/bash
## git 2016-08-30
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

#安装git图形化工具GitExtensions
#安装的时候请将msysgit 和 kdiff 这两个选项勾选，ssh 选择 OpenSSH
#安装下一步Global Settings 为 Checkout as-is, commit as-is
#打开你的 git Extensions, 打开 Menu/Settings, 选择Global Settings, 并设置以下选项

#请大家打开自己的 msys.bat 然后在里面输入 
#ssh-keygen -t rsa -C "你的email地址" 

#生产KEY默认路径c:\Documents and Settings\你的目录夹\.ssh\id_rsa.pub
#比如用户robert2016则路径为C:\Users\robert2016\.ssh\id_rsa.pub

1.安装Git 
yum install git git-daemon

2.生成SSH公钥
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
测试登陆 ssh localhost：
　　$ ssh localhost
　　正常情况下会登陆成功
调试步骤
　　配置登陆失败了，按照以上步骤依旧提示要输入密码。用ssh -v 显示详细的登陆信息查找原因：
　　$ ssh -v localhost
修改文件authorized_keys的权限
　　$ chmod 600 ~/.ssh/authorized_keys

3.创建Git用户
useradd git
passwd git

4.初始化仓库
$ cd /home/git/
$ mkdir project.git
$ chown -R git:git /home/git
$ cd project.git
$ git --bare init

5.在工作机上提交首个文件
cd myproject
git init
touch README
git add .
git commit -m 'initial commit'
git remote add origin git@127.0.0.1:/home/git/project.git
git push origin master

6.在某目录克隆项目
cd /home/gittest
git clone git://git@127.0.0.1:/home/git/project.git

cd xinproject.git
git init
    git remote add -f origin git@127.0.0.1:/home/git/project.git
    git remote add -f origin git@127.0.0.1:/home/git/project.git
    git remote add -f origin git@127.0.0.1:/data/git/project.git 
    git remote add -f origin git@127.0.0.1:/home/git/project.git
    git remote add -f origin git@127.0.0.1:/home/git/project.git
    git remote add -f origin git@127.0.0.1:/home/git/project.git

    git config branch.master.remote origin  
    git config branch.master.merge refs/heads/master 
git pull

已存在项目提交
cd existing_git_repo
git remote add origin git@localhost:mechanist.git
git add .
git commit -m "test"
git push -u origin master


初始化：
git init

添加当前目录所有内容：
git add .

查看状态：
git status

 
添加commit：
git commit -am "first commit."

版本对比：
git diff

查看历史记录：
git log

看一下每一次版本的大致变动情况，可以使用
git log –stat –summary

用git show命令查看

$ git show dfb02e6e4f2f7b573337763e5c0013802e39281

此方法可能使用的时候感觉特别的麻烦，其实可以用另外一种方便的方法．

$ git show dfb02 # 一般只使用版本号的前几个字符即可
$ git show HEAD # 显示当前分支的最新版本的更新细

GIT硬模式
$ git reset --hard "a9f2ba791d6654eace41f5a9da4b69680bca4ee9"

GIT软模式
$ git reset --soft "a9f2ba791d6654eace41f5a9da4b69680bca4ee9"

GIT reset TAG
$ git reset  --hard aaa

分支操作

查看分支：$ git branch

创建分支：$ git branch 分支名称 （注意：请不要在服务端建立分支）

切换分支：$ git checkout 分支名称

删除分支：$ git branch -d 分支名称


加入服务器
git remote add 用户名@计算机名或IP:~/某个目录

推送数据
git push master master #本地master推送到远端master

如果想快捷的使用git push就推送到默认远端分支master，可以做个一次性设置：
git remote add origin <实际的ssl用户名>@<IP地址>:<Git在远端的path>
做完以上设置，以后直接使用git push 就会自动推送到上述设置地址了，但如果要推送到其他分支，还是需要加参数的，这个设置只是相当于一个默认参数而已。

 
接收数据
git pull origin master

如果想直接使用git pull直接接收，同样需要提前做一个一次性设置（同样也是不能应用多分支pull情况）：
git branch --set-upstream master origin/master

 
本地库设置个人姓名和邮件
git config --global user.name "你的姓名，最好由没有符合和空格的英文字母组成"
git config --global user.email <邮件名>@<邮箱服务商后缀>

如果不设置个人信息，提交的信息将不会有更改者信息，这样会加大项目管理的难度。

#回退所有内容到上一个版本  
git reset HEAD^  

#回退a.py这个文件的版本到上一个版本  
git reset HEAD^ a.py  

#向前回退到第3个版本  
git reset –soft HEAD~3  

#将本地的状态回退到和远程的一样  
git reset –hard origin/master  

#回退到某个版本  
git reset 057d  

#回退到上一次提交的状态，按照某一次的commit完全反向的进行一次commit  
git revert HEAD  

#新建old_master分支做备份  
git branch old_master  

#push到远程  
git push origin old_master:old_master 
 
#本地仓库回退到某个版本  
git reset –hard bae168  

#删除远程的master分支  
git push origin :master  

#重新创建master分支  
git push origin master