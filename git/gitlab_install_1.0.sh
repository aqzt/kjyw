#!/bin/bash
## gitlab_yum 2018-05-20
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6和centos 7

yum install -y curl policycoreutils-python openssh-server
systemctl enable sshd
systemctl start sshd

yum install -y postfix
systemctl enable postfix
systemctl start postfix

cat >/etc/yum.repos.d/gitlab-ce.repo<<EOF
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7
gpgcheck=0
enabled=1
EOF

yum makecache
yum install -y gitlab-ce


cat >>/etc/yum.repos.d/gitlab-ce.repo<<EOF
[gitlab-runner]
name=gitlab-runner
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-runner/yum/el7
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
EOF

yum makecache
yum install -y  gitlab-runner

echo ok
