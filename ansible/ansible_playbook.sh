#!/bin/bash
## ansible_playbook  2016-07-07
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
##centos 6

##测试新建文件a.yml
- name: command
  hosts: centos6
  user: root
  gather_facts: false
  tasks:
  - name: "cmd"
    shell: touch /tmp/playbook.txt

#执行
ansible-playbook  a.yml

##测试新建用户b.yml
- name: create user
  hosts: centos6
  user: root
  gather_facts: false
  vars:
  - user: "xiaoyu"
  tasks:
  - name: create {{ user }}
    user: name="{{ user }}"

#执行
ansible-playbook  b.yml
#查看效果
ansible centos6 -m command -a "id xiaoyu"


##测试替换文件，再追加字符串 c.yml
- name: handlers test
  hosts: centos7
  user: root
  tasks:
    - name: test copy
      copy: src=/etc/passwd dest=/tmp/handlers.txt
      notify: test handlers
  handlers:
    - name: test handlers
      shell: echo "test111" >> /tmp/handlers.txt

#执行
ansible-playbook  c.yml





- hosts: centos7
  user: root
  tasks:
    - name: change mode for files
      file: path=/tmp/{{ item }} mode=600 owner=root group=root
      with_items:
        - 1.txt
        - 2.txt
		
		
- hosts: centos7
  user: root
  gather_facts: True
  tasks:
    - name: use when
      shell: touch /tmp/when.txt
      when: facter_ipaddress == "192.168.10.132"

	  
	  

	  
	  