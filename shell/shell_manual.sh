	shell实例手册

0说明{

	手册制作: 雪松
	更新日期: 2013-12-06
	欢迎系统运维加入Q群: 198173206

	请使用"notepad++"打开此文档,"alt+0"将函数折叠后方便查阅
	请勿删除信息，转载请说明出处，抵制不道德行为。
	错误在所难免，还望指正！

	# shell实例手册最新下载地址:
	http://hi.baidu.com/quanzhou722/item/f4a4f3c9eb37f02d46d5c0d9

	# LazyManage系统批量管理软件下载(shell):
	http://hi.baidu.com/quanzhou722/item/4ccf7e88a877eaccef083d1a
	
	# python实例手册下载地址:
	http://hi.baidu.com/quanzhou722/item/cf4471f8e23d3149932af2a7

}

1文件{
	
	touch file              # 创建空白文件
	rm -rf 目录名           # 不提示删除非空目录(-r:递归删除 -f强制)
	dos2unix                # windows文本转linux文本  
	unix2dos                # linux文本转windows文本
	enca filename           # 查看编码  安装 yum install -y enca 
	md5sum                  # 查看md5值
	ln 源文件 目标文件      # 硬链接
	ln -s 源文件 目标文件   # 符号连接
	readlink -f /data       # 查看连接真实目录
	cat file | nl |less     # 查看上下翻页且显示行号  q退出
	head                    # 查看文件开头内容
	head -c 10m             # 截取文件中10M内容
	split -C 10M            # 将文件切割大小为10M
	tail -f file            # 查看结尾 监视日志文件
	file                    # 检查文件类型
	umask                   # 更改默认权限
	uniq                    # 删除重复的行
	uniq -c                 # 重复的行出现次数
	uniq -u                 # 只显示不重复行
	paste a b               # 将两个文件合并用tab键分隔开
	paste -d'+' a b         # 将两个文件合并指定'+'符号隔开
	paste -s a              # 将多行数据合并到一行用tab键隔开
	chattr +i /etc/passwd   # 设置不可改变位
	more                    # 向下分面器
	locate 字符串           # 搜索
	wc -l file              # 查看行数
	cp filename{,.bak}      # 快速备份一个文件
	\cp a b                 # 拷贝不提示 既不使用别名 cp -i
	rev                     # 将行中的字符逆序排列
	comm -12 2 3            # 行和行比较匹配
	iconv -f gbk -t utf8 原.txt > 新.txt    # 转换编码
	rename 原模式 目标模式 文件             # 重命名 可正则
	watch -d -n 1 'df; ls -FlAt /path'      # 实时某个目录下查看最新改动过的文件
	cp -v  /dev/dvd  /rhel4.6.iso9660       # 制作镜像
	diff suzu.c suzu2.c  > sz.patch         # 制作补丁
	patch suzu.c < sz.patch                 # 安装补丁
	
	sort排序{
	
		-t  # 指定排序时所用的栏位分隔字符
		-n  # 依照数值的大小排序
		-r  # 以相反的顺序来排序
		-f  # 排序时，将小写字母视为大写字母
		-d  # 排序时，处理英文字母、数字及空格字符外，忽略其他的字符
		-c  # 检查文件是否已经按照顺序排序
		-b  # 忽略每行前面开始处的空格字符
		-M  # 前面3个字母依照月份的缩写进行排序
		-k  # 指定域
		-m  # 将几个排序好的文件进行合并
		+<起始栏位>-<结束栏位>   # 以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
		-o  # 将排序后的结果存入指定的文
		n   # 表示进行排序
		r   # 表示逆序

		sort -n               # 按数字排序
		sort -nr              # 按数字倒叙
		sort -u               # 过滤重复行
		sort -m a.txt c.txt   # 将两个文件内容整合到一起
		sort -n -t' ' -k 2 -k 3 a.txt     # 第二域相同，将从第三域进行升降处理
		sort -n -t':' -k 3r a.txt         # 以:为分割域的第三域进行倒叙排列
		sort -k 1.3 a.txt                 # 从第三个字母起进行排序
		sort -t" " -k 2n -u  a.txt        # 以第二域进行排序，如果遇到重复的，就删除

	}

	find查找{

		# linux文件无创建时间
		# Access 使用时间  
		# Modify 内容修改时间  
		# Change 状态改变时间(权限、属主)
		# 时间默认以24小时为单位,当前时间到向前24小时为0天,向前48-72小时为2天
		# -and 且 匹配两个条件 参数可以确定时间范围 -mtime +2 -and -mtime -4
		# -or 或 匹配任意一个条件

		find /etc -name http         # 按文件名查找
		find . -type f               # 查找某一类型文件
		find / -perm                 # 按照文件权限查找
		find / -user                 # 按照文件属主查找
		find / -group                # 按照文件所属的组来查找文件
		find / -atime -n             # 文件使用时间在N天以内
		find / -atime +n             # 文件使用时间在N天以前
		find / -mtime -n             # 文件内容改变时间在N天以内
		find / -mtime +n             # 文件内容改变时间在N天以前
		find / -ctime +n             # 文件状态改变时间在N天前
		find / -ctime -n             # 文件状态改变时间在N天内
		find / -size +1000000c -print                           # 查找文件长度大于1M字节的文件
		find /etc -name "passwd*" -exec grep "xuesong" {} \;    # 按名字查找文件传递给-exec后命令
		find . -name 't*' -exec basename {} \;                  # 查找文件名,不取路径
		find . -type f -name "err*" -exec  rename err ERR {} \; # 批量改名(查找err 替换为 ERR {}文件
		find 路径 -name *name1* -or -name *name2*               # 查找任意一个关键字

	}

	vim编辑器{

		gconf-editor       # 配置编辑器
		/etc/vimrc         # 配置文件路径
		vim +24 file       # 打开文件定位到指定行
		vim file1 file2    # 打开多个文件	
		vim -O2 file1 file2    # 垂直分屏
		vim -on file1 file2    # 水平分屏
		sp filename        # 上下分割打开新文件
		vsp filename       # 左右分割打开新文件
		Ctrl+W [操作]      # 多个文件间操作  大写W  # 操作: 关闭当前窗口c  屏幕高度一样=  增加高度+  移动光标所在屏 右l 左h 上k 下j 中h  下一个w  
		:n                 # 编辑下一个文件
		:2n                # 编辑下二个文件
		:N                 # 编辑前一个文件
		:rew               # 回到首文件
		:set nu            # 打开行号
		:set nonu          # 取消行号
		200G               # 跳转到200
		:nohl              # 取消高亮
		:set autoindent    # 设置自动缩进
		:set ff            # 查看文本格式
		:set binary        # 改为unix格式
		ctrl+ U            # 向前翻页
		ctrl+ D            # 向后翻页
		%s/字符1/字符2/g   # 全部替换	
		X                  # 文档加密
	
	}

	归档解压缩{

		tar zxvpf gz.tar.gz -C 放到指定目录 包中的目录       # 解包tar.gz 不指定目录则全解压
		tar zcvpf /$path/gz.tar.gz * # 打包gz 注意*最好用相对路径
		tar zcf /$path/gz.tar.gz *   # 打包正确不提示
		tar ztvpf gz.tar.gz          # 查看gz
		tar xvf 1.tar -C 目录        # 解包tar
		tar -cvf 1.tar *             # 打包tar
		tar tvf 1.tar                # 查看tar
		tar -rvf 1.tar 文件名        # 给tar追加文件
		tar --exclude=/home/dmtsai -zcvf myfile.tar.gz /home/* /etc      # 打包/home, /etc ，但排除 /home/dmtsai
		tar -N "2005/06/01" -zcvf home.tar.gz /home      # 在 /home 当中，比 2005/06/01 新的文件才备份
		tar -zcvfh home.tar.gz /home                     # 打包目录中包括连接目录
		zgrep 字符 1.gz              # 查看压缩包中文件字符行
		bzip2  -dv 1.tar.bz2         # 解压bzip2
		bzip2 -v 1.tar               # bzip2压缩
		bzcat                        # 查看bzip2
		gzip A                       # 直接压缩文件 # 压缩后源文件消失
		gunzip A.gz                  # 直接解压文件 # 解压后源文件消失
		gzip -dv 1.tar.gz            # 解压gzip到tar
		gzip -v 1.tar                # 压缩tar到gz
		unzip zip.zip                # 解压zip
		zip zip.zip *                # 压缩zip
		# rar3.6下载:  http://www.rarsoft.com/rar/rarlinux-3.6.0.tar.gz
		rar a rar.rar *.jpg          # 压缩文件为rar包
		unrar x rar.rar              # 解压rar包
		7z a 7z.7z *                 # 7z压缩
		7z e 7z.7z                   # 7z解压

	}
	
	文件ACL权限控制{

		getfacl 1.test                      # 查看文件ACL权限
		setfacl -R -m u:xuesong:rw- 1.test  # 对文件增加用户的读写权限 -R 递归

	}
	
	svn更新代码{

		--force # 强制覆盖
		/usr/bin/svn --username user --password passwd co  $Code  ${SvnPath}src/                 # 检出整个项目
		/usr/bin/svn --username user --password passwd export  $Code$File ${SvnPath}src/$File    # 导出个别文件

	}

	恢复rm删除的文件{

		# debugfs针对 ext2   # ext3grep针对 ext3   # extundelete针对 ext4
		df -T   # 首先查看磁盘分区格式
		umount /data/     # 卸载挂载,数据丢失请首先卸载挂载,或重新挂载只读
		ext3grep /dev/sdb1 --ls --inode 2         # 记录信息继续查找目录下文件inode信息
		ext3grep /dev/sdb1 --ls --inode 131081    # 此处是inode
		ext3grep /dev/sdb1 --restore-inode 49153  # 记录下inode信息开始恢复目录

	}
	
}

2软件{

	rpm{

		rpm -ivh lynx          # rpm安装
		rpm -e lynx            # 卸载包
		rpm -e lynx --nodeps   # 强制卸载
		rpm -qa                # 查看所有安装的rpm包
		rpm -qa | grep lynx    # 查找包是否安装
		rpm -ql                # 软件包路径
		rpm -Uvh               # 升级包
		rpm --test lynx        # 测试
		rpm -qc                # 软件包配置文档
		rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6     # 导入rpm的签名信息

	}

	yum{

		yum list                 # 查找所有列表
		yum install 包名         # 安装包和依赖包
		yum -y update            # 升级所有包版本,依赖关系，系统版本内核都升级
		yum -y update 软件包名   # 升级指定的软件包
		yum -y upgrade           # 不改变软件设置更新软件，系统版本升级，内核不改变
		yum search mail          # yum搜索相关包
		yum grouplist            # 软件包组
		yum -y groupinstall "Virtualization"   # 安装软件包组
		
	}

	yum扩展源{

		# 包下载地址:http://download.fedoraproject.org/pub/epel   # 选择版本
		wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
		rpm -Uvh epel-release-5-4.noarch.rpm

	}

	自定义yum源{

		find /etc/yum.repos.d -name "*.repo" -exec mv {} {}.bak \;
		
		vim /etc/yum.repos.d/yum.repo
		[yum]
		#http
		baseurl=http://10.0.0.1/centos5.5
		#挂载iso
		#mount -o loop CentOS-5.8-x86_64-bin-DVD-1of2.iso /data/iso/
		#本地
		#baseurl=file:///data/iso/
		enable=1

		#导入key
		rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

	}

	编译{

		源码安装{

			./configure --help                   # 查看所有编译参数
			./configure  --prefix=/usr/local/    # 配置参数
			make                                 # 编译
			make install                         # 安装包
			make clean                           # 清除编译结果

		}

		perl程序编译{

			perl Makefile.PL
			make
			make test
			make install

		}

		python程序编译{

			python file.py

		}
		
		编译c程序{

			gcc -g hello.c -o hello

		}
	
	}
	
}

3系统{

	wall        　  　          # 给其它用户发消息
	whereis ls                  # 查找命令的目录
	which                       # 查看当前要执行的命令所在的路径
	clear                       # 清空整个屏幕
	reset                       # 重新初始化屏幕
	cal                         # 显示月历
	echo -n 123456 | md5sum     # md5加密
	mkpasswd                    # 随机生成密码   -l位数 -C大小 -c小写 -d数字 -s特殊字符
	netstat -anlp | grep port   # 是否打开了某个端口
	ntpdate stdtime.gov.hk      # 同步时间
	tzselect                    # 选择时区 #+8=(5 9 1 1) # (TZ='Asia/Shanghai'; export TZ)括号内写入 /etc/profile
	/sbin/hwclock -w            # 保存到硬件
	/etc/shadow                 # 账户影子文件
	LANG=en                     # 修改语言
	vim /etc/sysconfig/i18n     # 修改编码  LANG="en_US.UTF-8"
	export LC_ALL=C             # 强制字符集
	vi /etc/hosts               # 查询静态主机名
	alias                       # 别名
	watch uptime                # 监测命令动态刷新
	ipcs -a                     # 查看Linux系统当前单个共享内存段的最大值
	lsof |grep /lib             # 查看加载库文件
	ldconfig                    # 动态链接库管理命令
	dist-upgrade                # 会改变配置文件,改变旧的依赖关系，改变系统版本 
	/boot/grub/grub.conf        # grub启动项配置
	sysctl -p                   # 修改内核参数/etc/sysctl.conf，让/etc/rc.d/rc.sysinit读取生效
	mkpasswd -l 8  -C 2 -c 2 -d 4 -s 0            # 随机生成指定类型密码
	echo 1 > /proc/sys/net/ipv4/tcp_syncookies    # 使TCP SYN Cookie 保护生效  # "SYN Attack"是一种拒绝服务的攻击方式

	开机启动脚本顺序{

		/etc/profile
		/etc/profile.d/*.sh
		~/bash_profile
		~/.bashrc
		/etc/bashrc

	}

	进程管理{

		ps -eaf               # 查看所有进程
		kill -9 PID           # 强制终止某个PID进程
		kill -15 PID          # 安全退出 需程序内部处理信号
		cmd &                 # 命令后台运行
		nohup cmd &           # 后台运行不受shell退出影响
		ctrl+z                # 将前台放入后台(暂停)
		jobs                  # 查看后台运行程序
		bg 2                  # 启动后台暂停进程
		fg 2                  # 调回后台进程
		pstree                # 进程树
		vmstat 1 9            # 每隔一秒报告系统性能信息9次
		sar                   # 查看cpu等状态
		lsof file             # 显示打开指定文件的所有进程
		lsof -i:32768         # 查看端口的进程
		renice +1 180         # 把180号进程的优先级加1
		ps aux |grep -v USER | sort -nk +4 | tail       # 显示消耗内存最多的10个运行中的进程，以内存使用量排序.cpu +3	
		
		top{

			前五行是系统整体的统计信息。
			第一行: 任务队列信息，同 uptime 命令的执行结果。内容如下：
				01:06:48 当前时间
				up 1:22 系统运行时间，格式为时:分
				1 user 当前登录用户数
				load average: 0.06, 0.60, 0.48 系统负载，即任务队列的平均长度。
				三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。

			第二、三行:为进程和CPU的信息。当有多个CPU时，这些内容可能会超过两行。内容如下：
				Tasks: 29 total 进程总数
				1 running 正在运行的进程数
				28 sleeping 睡眠的进程数
				0 stopped 停止的进程数
				0 zombie 僵尸进程数
				Cpu(s): 0.3% us 用户空间占用CPU百分比
				1.0% sy 内核空间占用CPU百分比
				0.0% ni 用户进程空间内改变过优先级的进程占用CPU百分比
				98.7% id 空闲CPU百分比
				0.0% wa 等待输入输出的CPU时间百分比
				0.0% hi
				0.0% si

			第四、五行:为内存信息。内容如下：
				Mem: 191272k total 物理内存总量
				173656k used 使用的物理内存总量
				17616k free 空闲内存总量
				22052k buffers 用作内核缓存的内存量
				Swap: 192772k total 交换区总量
				0k used 使用的交换区总量
				192772k free 空闲交换区总量
				123988k cached 缓冲的交换区总量。
				内存中的内容被换出到交换区，而后又被换入到内存，但使用过的交换区尚未被覆盖，
				该数值即为这些内容已存在于内存中的交换区的大小。
				相应的内存再次被换出时可不必再对交换区写入。

			进程信息区,各列的含义如下:  # 显示各个进程的详细信息

			序号 列名    含义
			a   PID      进程id
			b   PPID     父进程id
			c   RUSER    Real user name
			d   UID      进程所有者的用户id
			e   USER     进程所有者的用户名
			f   GROUP    进程所有者的组名
			g   TTY      启动进程的终端名。不是从终端启动的进程则显示为 ?
			h   PR       优先级
			i   NI       nice值。负值表示高优先级，正值表示低优先级
			j   P        最后使用的CPU，仅在多CPU环境下有意义
			k   %CPU     上次更新到现在的CPU时间占用百分比
			l   TIME     进程使用的CPU时间总计，单位秒
			m   TIME+    进程使用的CPU时间总计，单位1/100秒
			n   %MEM     进程使用的物理内存百分比
			o   VIRT     进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
			p   SWAP     进程使用的虚拟内存中，被换出的大小，单位kb。
			q   RES      进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
			r   CODE     可执行代码占用的物理内存大小，单位kb
			s   DATA     可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
			t   SHR      共享内存大小，单位kb
			u   nFLT     页面错误次数
			v   nDRT     最后一次写入到现在，被修改过的页面数。
			w   S        进程状态。
				D=不可中断的睡眠状态
				R=运行
				S=睡眠
				T=跟踪/停止
				Z=僵尸进程
			x   COMMAND  命令名/命令行
			y   WCHAN    若该进程在睡眠，则显示睡眠中的系统函数名
			z   Flags    任务标志，参考 sched.h

		}

		linux操作系统提供的信号{
			
			kill -l                    # 查看linux提供的信号
			trap "echo aaa"  2 3 15    # shell使用 trap 捕捉退出信号

			# 发送信号一般有两种原因:
			#   1(被动式)  内核检测到一个系统事件.例如子进程退出会像父进程发送SIGCHLD信号.键盘按下control+c会发送SIGINT信号
			#   2(主动式)  通过系统调用kill来向指定进程发送信号                             
			# 进程结束信号 SIGTERM 和 SIGKILL 的区别:  SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。
			# 如果一个进程收到一个SIGUSR1信号，然后执行信号绑定函数，第二个SIGUSR2信号又来了，第一个信号没有被处理完毕的话，第二个信号就会丢弃。

			SIGHUP  1          A     # 终端挂起或者控制进程终止
			SIGINT  2          A     # 键盘终端进程(如control+c)
			SIGQUIT 3          C     # 键盘的退出键被按下
			SIGILL  4          C     # 非法指令
			SIGABRT 6          C     # 由abort(3)发出的退出指令
			SIGFPE  8          C     # 浮点异常
			SIGKILL 9          AEF   # Kill信号  立刻停止
			SIGSEGV 11         C     # 无效的内存引用
			SIGPIPE 13         A     # 管道破裂: 写一个没有读端口的管道
			SIGALRM 14         A     # 闹钟信号 由alarm(2)发出的信号 
			SIGTERM 15         A     # 终止信号,可让程序安全退出 kill -15
			SIGUSR1 30,10,16   A     # 用户自定义信号1
			SIGUSR2 31,12,17   A     # 用户自定义信号2
			SIGCHLD 20,17,18   B     # 子进程结束自动向父进程发送SIGCHLD信号
			SIGCONT 19,18,25         # 进程继续（曾被停止的进程）
			SIGSTOP 17,19,23   DEF   # 终止进程
			SIGTSTP 18,20,24   D     # 控制终端（tty）上按下停止键
			SIGTTIN 21,21,26   D     # 后台进程企图从控制终端读
			SIGTTOU 22,22,27   D     # 后台进程企图从控制终端写
			
			缺省处理动作一项中的字母含义如下:
				A  缺省的动作是终止进程
				B  缺省的动作是忽略此信号，将该信号丢弃，不做处理
				C  缺省的动作是终止进程并进行内核映像转储(dump core),内核映像转储是指将进程数据在内存的映像和进程在内核结构中的部分内容以一定格式转储到文件系统，并且进程退出执行，这样做的好处是为程序员提供了方便，使得他们可以得到进程当时执行时的数据值，允许他们确定转储的原因，并且可以调试他们的程序。
				D  缺省的动作是停止进程，进入停止状况以后还能重新进行下去，一般是在调试的过程中（例如ptrace系统调用）
				E  信号不能被捕获
				F  信号不能被忽略
		}

	}

	日志管理{

		history                      # 历时命令默认1000条
		HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "   # 让history命令显示具体时间
		history  -c                  # 清除记录命令
		cat $HOME/.bash_history      # 历史命令记录文件
		last                         # 查看登陆过的用户信息
		who /var/log/wtmp            # 查看登陆过的用户信息
		lastlog                      # 用户最后登录的时间
		lastb -a                     # 列出登录系统失败的用户相关信息
		/var/log/btmp                # 登录失败二进制日志记录文件
		tail -f /var/log/messages    # 系统日志
		tail -f /var/log/secure      # ssh日志

	}

	selinux{

		sestatus -v                    # 查看selinux状态
		getenforce                     # 查看selinux模式
		setenforce 0                   # 设置selinux为宽容模式(可避免阻止一些操作)
		semanage port -l    # 查看selinux端口限制规则
		semanage port -a -t http_port_t -p tcp 8000  # 在selinux中注册端口类型
		vi /etc/selinux/config         # selinux配置文件
		SELINUX=enfoceing              # 关闭selinux 把其修改为  SELINUX=disabled

	}

	查看剩余内存{

		free -m
		#-/+ buffers/cache:       6458       1649
		#6458M为真实使用内存  1649M为真实剩余内存(剩余内存+缓存+缓冲器)
		#linux会利用所有的剩余内存作为缓存，所以要保证linux运行速度，就需要保证内存的缓存大小

	}
	
	系统信息{

		uname -a              # 查看Linux内核版本信息
		cat /proc/version     # 查看内核版本
		cat /etc/issue        # 查看系统版本
		lsb_release -a        # 查看系统版本  需安装 centos-release
		locale -a             # 列出所有语系
		hwclock               # 查看时间
		who                   # 当前在线用户
		w                     # 当前在线用户
		whoami                # 查看当前用户名
		logname               # 查看初始登陆用户名
		uptime                # 查看服务器启动时间
		sar -n DEV 1 10       # 查看网卡网速流量
		dmesg                 # 显示开机信息
		lsmod	              # 查看内核模块

	}
	
	硬件信息{

		more /proc/cpuinfo                                       # 查看cpu信息
		cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c    # 查看cpu型号和逻辑核心数
		getconf LONG_BIT                                         # cpu运行的位数
		cat /proc/cpuinfo | grep physical | uniq -c              # 物理cpu个数
		cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l     # 结果大于0支持64位
		cat /proc/cpuinfo|grep flags                             # 查看cpu是否支持虚拟化   pae支持半虚拟化  IntelVT 支持全虚拟化
		more /proc/meminfo                                       # 查看内存信息
		dmidecode                                                # 查看全面硬件信息
		dmidecode | grep "Product Name"                          # 查看服务器型号
		dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range       # 查看内存插槽
		cat /proc/mdstat                                         # 查看软raid信息
		cat /proc/scsi/scsi                                      # 查看Dell硬raid信息(IBM、HP需要官方检测工具)
		lspci                                                    # 查看硬件信息
		lspci|grep RAID                                          # 查看是否支持raid
		lspci -vvv |grep Ethernet                                # 查看网卡型号
		lspci -vvv |grep Kernel|grep driver                      # 查看驱动模块
		modinfo tg2                                              # 查看驱动版本(驱动模块)
		ethtool -i em1                                           # 查看网卡驱动版本

	}
	
	终端快捷键{

		Ctrl+A        　    # 行前
		Ctrl+E        　    # 行尾
		Ctrl+S        　    # 终端锁屏
		Ctrl+Q        　　  # 解锁屏
		Ctrl+D      　　    # 退出

	}

	开机启动模式{

		vi /etc/inittab
		id:3:initdefault:    # 3为多用户命令
		#ca::ctrlaltdel:/sbin/shutdown -t3 -r now   # 注释此行 禁止 ctrl+alt+del 关闭计算机

	}

	终端提示显示{

		echo $PS1                   # 环境变量控制提示显示
		PS1='[\u@ \H \w \A \@#]\$'
		PS1='[\u@\h \W]\$'

	}

	定时任务{

		at 5pm + 3 days /bin/ls  # 单次定时任务 指定三天后下午5:00执行/bin/ls
	
		crontab -e               # 编辑周期任务
		#分钟  小时    天  月  星期   命令或脚本
		1,30  1-3/2    *   *   *      命令或脚本  >> file.log 2>&1
		echo "40 7 * * 2 /root/sh">>/var/spool/cron/root    # 直接将命令写入周期任务
		crontab -l                                          # 查看自动周期性任务
		crontab -r                                          # 删除自动周期性任务
		cron.deny和cron.allow                               # 禁止或允许用户使用周期任务
		service crond start|stop|restart                    # 启动自动周期性服务

	}

	date{

		date -s 20091112                     # 设日期
		date -s 18:30:50                     # 设时间
		date -d "7 days ago" +%Y%m%d         # 7天前日期
		date -d "5 minute ago" +%H:%M        # 5分钟前时间
		date -d "1 month ago" +%Y%m%d        # 一个月前
		date +%Y-%m-%d -d '20110902'         # 日期格式转换
		date +%Y-%m-%d_%X                    # 日期和时间
		date +%N                             # 纳秒
		date -d "2012-08-13 14:00:23" +%s    # 换算成秒计算(1970年至今的秒数)
		date -d "@1363867952" +%Y-%m-%d-%T   # 将时间戳换算成日期
		date -d "1970-01-01 UTC 1363867952 seconds" +%Y-%m-%d-%T  # 将时间戳换算成日期
		date -d "`awk -F. '{print $1}' /proc/uptime` second ago" +"%Y-%m-%d %H:%M:%S"    # 格式化系统启动时间(多少秒前)

	}

	最大连接数{

		ulimit -SHn 65535  # 修改最大打开文件数(等同最大连接数)
		ulimit -a          # 查看
		
		/etc/security/limits.conf         # 进程最大打开文件数
		# nofile 可以被理解为是文件句柄数 文件描述符 还有socket数
		* soft nofile 65535
		* hard nofile 65535
		# 最大进程数
		* soft nproc 65535
		* hard nproc 65535

		# 如果/etc/security/limits.d/有配置文件，将会覆盖/etc/security/limits.conf里的配置
		# 即/etc/security/limits.d/的配置文件里就不要有同样的参量设置
		/etc/security/limits.d/90-nproc.conf    # centos6.3的最大进程数文件
		* soft nproc 65535       
		* hard nproc 65535

	}
	
	sudo{

		visudo     # sudo命令权限添加
		用户  别名(可用all)=NOPASSWD:命令1，命令2
		wangming linuxfan=NOPASSWD:/sbin/apache start,/sbin/apache restart
		UserName ALL=(ALL) ALL
		peterli        ALL=(ALL)       NOPASSWD:/sbin/service
		Defaults requiretty             # sudo不允许后台运行,注释此行既允许
		Defaults !visiblepw             # sudo不允许远程,去掉!既允许

	}

	grub开机启动项添加{

		vim /etc/grub.conf
		title ms-dos
		rootnoverify (hd0,0)
		chainloader +1

	}

	stty{

		#stty时一个用来改变并打印终端行设置的常用命令

		stty iuclc          # 在命令行下禁止输出大写
		stty -iuclc         # 恢复输出大写
		stty olcuc          # 在命令行下禁止输出小写
		stty -olcuc         # 恢复输出小写
		stty size           # 打印出终端的行数和列数
		stty eof "string"   # 改变系统默认ctrl+D来表示文件的结束 
		stty -echo          # 禁止回显
		stty echo           # 打开回显
		stty -echo;read;stty echo;read  # 测试禁止回显
		stty igncr          # 忽略回车符
		stty -igncr         # 恢复回车符
		stty erase '#'      # 将#设置为退格字符
		stty erase '^?'     # 恢复退格字符
		
		定时输入{
		
			timeout_read(){
				timeout=$1
				old_stty_settings=`stty -g`　　# save current settings
				stty -icanon min 0 time 100　　# set 10seconds,not 100seconds
				eval read varname　　          # =read $varname
				stty "$old_stty_settings"　　  # recover settings
			}
		
			read -t 10 varname    # 更简单的方法就是利用read命令的-t选项
		
		}

		检测用户按键{

			#!/bin/bash
			old_tty_settings=$(stty -g)   # 保存老的设置(为什么?). 
			stty -icanon
			Keypress=$(head -c1)          # 或者使用$(dd bs=1 count=1 2> /dev/null)
			echo "Key pressed was \""$Keypress"\"."
			stty "$old_tty_settings"      # 恢复老的设置. 
			exit 0

		}

	}

	iptables{

		内建三个表：nat mangle 和 filter
		filter预设规则表，有INPUT、FORWARD 和 OUTPUT 三个规则链
		vi /etc/sysconfig/iptables    # 配置文件
		INPUT    # 进入
		FORWARD  # 转发
		OUTPUT   # 出去
		ACCEPT   # 将封包放行
		REJECT   # 拦阻该封包
		DROP     # 丢弃封包不予处理
		-A	     # 在所选择的链(INPUT等)末添加一条或更多规则
		-D       # 删除一条
		-E       # 修改
		-p	     # tcp、udp、icmp	0相当于所有all	!取反
		-P       # 设置缺省策略(与所有链都不匹配强制使用此策略)
		-s	     # IP/掩码	(IP/24)	主机名、网络名和清楚的IP地址 !取反
		-j	     # 目标跳转，立即决定包的命运的专用内建目标
		-i	     # 进入的（网络）接口 [名称] eth0
		-o	     # 输出接口[名称] 
		-m	     # 模块
		--sport  # 源端口
		--dport  # 目标端口
		
		iptables -F                        # 将防火墙中的规则条目清除掉  # 注意: iptables -P INPUT ACCEPT
		iptables-restore < 规则文件        # 导入防火墙规则
		/etc/init.d/iptables save          # 保存防火墙设置
		/etc/init.d/iptables restart       # 重启防火墙服务
		iptables -L -n                     # 查看规则
		iptables -t nat -nL                # 查看转发

		iptables实例{
			
			iptables -L INPUT                   # 列出某规则链中的所有规则
			iptables -X allowed                 # 删除某个规则链 ,不加规则链，清除所有非内建的
			iptables -Z INPUT                   # 将封包计数器归零
			iptables -N allowed                 # 定义新的规则链
			iptables -P INPUT DROP              # 定义过滤政策
			iptables -A INPUT -s 192.168.1.1    # 比对封包的来源IP   # ! 192.168.0.0/24  ! 反向对比
			iptables -A INPUT -d 192.168.1.1    # 比对封包的目的地IP
			iptables -A INPUT -i eth0           # 比对封包是从哪片网卡进入
			iptables -A FORWARD -o eth0         # 比对封包要从哪片网卡送出 eth+表示所有的网卡
			iptables -A INPUT -p tcp            # -p ! tcp 排除tcp以外的udp、icmp。-p all所有类型
			iptables -D INPUT 8                 # 从某个规则链中删除一条规则
			iptables -D INPUT --dport 80 -j DROP         # 从某个规则链中删除一条规则
			iptables -R INPUT 8 -s 192.168.0.1 -j DROP   # 取代现行规则
			iptables -I INPUT 8 --dport 80 -j ACCEPT     # 插入一条规则
			iptables -A INPUT -i eth0 -j DROP            # 其它情况不允许
			iptables -A INPUT -p tcp -s IP -j DROP       # 禁止指定IP访问
			iptables -A INPUT -p tcp -s IP --dport port -j DROP               # 禁止指定IP访问端口
			iptables -A INPUT -s IP -p tcp --dport port -j ACCEPT             # 允许在IP访问指定端口
			iptables -A INPUT -p tcp --dport 22 -j DROP                       # 禁止使用某端口
			iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP   # 禁止icmp端口
			iptables -A INPUT -i eth0 -p icmp -j DROP                         # 禁止icmp端口
			iptables -t filter -A INPUT -i eth0 -p tcp --syn -j DROP                  # 阻止所有没有经过你系统授权的TCP连接
			iptables -A INPUT -f -m limit --limit 100/s --limit-burst 100 -j ACCEPT   # IP包流量限制
			iptables -A INPUT -i eth0 -s 192.168.62.1/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT  # 除192.168.62.1外，禁止其它人ping我的主机
			iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --rttl --name WEB --rsource -j DROP  # 可防御cc攻击(未测试)

		}

		iptables配置实例文件{

			# Generated by iptables-save v1.2.11 on Fri Feb  9 12:10:37 2007
			*filter
			:INPUT ACCEPT [637:58967]
			:FORWARD DROP [0:0]
			:OUTPUT ACCEPT [5091:1301533]
			# 允许的IP或IP段访问 建议多个
			-A INPUT -s 127.0.0.1 -p tcp -j ACCEPT
			-A INPUT -s 192.168.0.0/255.255.0.0 -p tcp -j ACCEPT
			# 开放对外开放端口
			-A INPUT -p tcp --dport 80 -j ACCEPT
			# 指定某端口针对IP开放
			-A INPUT -s 192.168.10.37 -p tcp --dport 22 -j ACCEPT
			# 拒绝所有协议(INPUT允许)
			-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,URG RST -j DROP
			# 允许已建立的或相关连的通行
			iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
			# 拒绝ping
			-A INPUT -p tcp -m tcp -j REJECT --reject-with icmp-port-unreachable
			COMMIT
			# Completed on Fri Feb  9 12:10:37 2007

		}

		iptables配置实例{

			# 允许某段IP访问任何端口
			iptables -A INPUT -s 192.168.0.3/24 -p tcp -j ACCEPT
			# 设定预设规则 (拒绝所有的数据包，再允许需要的,如只做WEB服务器.还是推荐三个链都是DROP)
			iptables -P INPUT DROP
			iptables -P FORWARD DROP
			iptables -P OUTPUT ACCEPT
			# 注意: 直接设置这三条会掉线
			# 开启22端口
			iptables -A INPUT -p tcp --dport 22 -j ACCEPT
			# 如果OUTPUT 设置成DROP的，要写上下面一条
			iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT 
			# 注:不写导致无法SSH.其他的端口一样,OUTPUT设置成DROP的话,也要添加一条链
			# 如果开启了web服务器,OUTPUT设置成DROP的话,同样也要添加一条链
			iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
			# 做WEB服务器,开启80端口 ,其他同理
			iptables -A INPUT -p tcp --dport 80 -j ACCEPT
			# 做邮件服务器,开启25,110端口
			iptables -A INPUT -p tcp --dport 110 -j ACCEPT
			iptables -A INPUT -p tcp --dport 25 -j ACCEPT
			# 允许icmp包通过,允许ping
			iptables -A OUTPUT -p icmp -j ACCEPT (OUTPUT设置成DROP的话) 
			iptables -A INPUT -p icmp -j ACCEPT  (INPUT设置成DROP的话)
			# 允许loopback!(不然会导致DNS无法正常关闭等问题) 
			IPTABLES -A INPUT -i lo -p all -j ACCEPT (如果是INPUT DROP)
			IPTABLES -A OUTPUT -o lo -p all -j ACCEPT(如果是OUTPUT DROP)

		}

		添加网段转发{

			# 例如通过vpn上网
			echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
			iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE  # 添加网段转发
			iptables -t nat -A POSTROUTING -s 10.0.0.0/255.0.0.0 -o eth0 -j SNAT --to 192.168.10.158  # 原IP网段经过哪个网卡IP出去
			iptables -t nat -nL                # 查看转发

		}
			
		端口映射{
			
			# 内网通过有外网IP的机器映射端口
			echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
			route add -net 10.10.20.0 netmask 255.255.255.0 gw 10.10.20.111     # 内网需要添加默认网关，并且网关开启转发
			iptables -t nat -A PREROUTING -d 192.168.10.158  -p tcp --dport 9999 -j DNAT --to 10.10.20.55:22
			iptables -t nat -nL                # 查看转发

		}

	}

}

4服务{

	/etc/init.d/sendmail start                   # 启动服务  
	/etc/init.d/sendmail stop                    # 关闭服务
	/etc/init.d/sendmail status                  # 查看服务当前状态
	/date/mysql/bin/mysqld_safe --user=mysql &   # 启动mysql后台运行
	vi /etc/rc.d/rc.local                        # 开机启动执行  可用于开机启动脚本
	/etc/rc.d/rc3.d/S55sshd                      # 开机启动和关机关闭服务连接    # S开机start  K关机stop  55级别 后跟服务名
	ln -s -f /date/httpd/bin/apachectl /etc/rc.d/rc3.d/S15httpd   # 将启动程序脚本连接到开机启动目录
	ipvsadm -ln                                  # lvs查看后端负载机并发
	ipvsadm -C                                   # lvs清除规则
	xm list                                      # 查看xen虚拟主机列表
	virsh                                        # 虚拟化(xen\kvm)管理工具  yum groupinstall Virtual*
	./bin/httpd -M                               # 查看httpd加载模块
	httpd -t -D DUMP_MODULES                     # rpm包httpd查看加载模块
	echo 内容| /bin/mail -s "标题" 收件箱 -- -f 发件人       # 发送邮件
	"`echo "内容"|iconv -f utf8 -t gbk`" | /bin/mail -s "`echo "标题"|iconv -f utf8 -t gbk`" 收件箱     # 解决邮件乱码
	/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg   # 检测nagios配置文件

	chkconfig{

		chkconfig 服务名 on|off|set              # 设置非独立服务启状态
		chkconfig --level 35   httpd   off       # 让服务不自动启动
		chkconfig --level 35   httpd   on        # 让服务自动启动 35指的是运行级别
		chkconfig --list                         # 查看所有服务的启动状态
		chkconfig --list |grep httpd             # 查看某个服务的启动状态
		chkconfig –-list [服务名称]              # 查看服务的状态

	}

	httpd{

		编译参数{

			# so模块用来提供DSO支持的apache核心模块
			# 如果编译中包含任何DSO模块，则mod_so会被自动包含进核心。
			# 如果希望核心能够装载DSO，但不实际编译任何DSO模块，则需明确指定"--enable-so=static"

			./configure --prefix=/usr/local/apache --enable-so --enable-mods-shared=most --enable-rewrite --enable-forward  # 实例编译

			--with-mpm=worker # 已worker方式运行
			--with-apxs=/usr/local/apache/bin/apxs  # 制作apache的动态模块DSO rpm包 httpd-devel  #编译模块 apxs -i -a -c mod_foo.c
			--enable-so # 让Apache可以支持DSO模式
			--enable-mods-shared=most # 告诉编译器将所有标准模块都动态编译为DSO模块
			--enable-rewrite # 支持地址重写功能
			--enable-module=most # 用most可以将一些不常用的，不在缺省常用模块中的模块编译进来
			--enable-mods-shared=all # 意思是动态加载所有模块，如果去掉-shared话，是静态加载所有模块
			--enable-expires # 可以添加文件过期的限制，有效减轻服务器压力，缓存在用户端，有效期内不会再次访问服务器，除非按f5刷新，但也导致文件更新不及时
			--enable-deflate # 压缩功能，网页可以达到40%的压缩，节省带宽成本，但会对cpu压力有一点提高
			--enable-headers # 文件头信息改写，压缩功能需要
			--disable-MODULE  # 禁用MODULE模块(仅用于基本模块)
			--enable-MODULE=shared  # 将MODULE编译为DSO(可用于所有模块) 
			--enable-mods-shared=MODULE-LIST   # 将MODULE-LIST中的所有模块都编译成DSO(可用于所有模块) 
			--enable-modules=MODULE-LIST   # 将MODULE-LIST静态连接进核心(可用于所有模块)
			
			# 上述 MODULE-LIST 可以是:
			1、用引号界定并且用空格分隔的模块名列表  --enable-mods-shared='headers rewrite dav'
			2、"most"(大多数模块)  --enable-mods-shared=most 
			3、"all"(所有模块)

		}

		转发{

			#针对非80端口的请求处理
			RewriteCond %{SERVER_PORT} !^80$
			RewriteRule ^/(.*)         http://fully.qualified.domain.name:%{SERVER_PORT}/$1 [L,R]

			RewriteCond %{HTTP_HOST} ^ss.aa.com [NC]
			RewriteRule  ^(.*)  http://www.aa.com/so/$1/0/p0?  [L,R=301]
			#RewriteRule 只对?前处理，所以会把?后的都保留下来
			#在转发后地址后加?即可取消RewriteRule保留的字符
			#R的含义是redirect，即重定向，该请求不会再被apache交给后端处理，而是直接返回给浏览器进行重定向跳转。301是返回的http状态码，具体可以参考http rfc文档，跳转都是3XX。
			#L是last，即最后一个rewrite规则，如果请求被此规则命中，将不会继续再向下匹配其他规则。	

		}

	}

	mysql源码安装{
	
		groupadd mysql
		useradd mysql -g mysql -M -s /bin/false
		tar zxvf mysql-5.0.22.tar.gz
		cd mysql-5.0.22
		./configure  --prefix=/usr/local/mysql \
		--with-client-ldflags=-all-static \
		--with-mysqld-ldflags=-all-static \
		--with-mysqld-user=mysql \
		--with-extra-charsets=all \
		--with-unix-socket-path=/var/tmp/mysql.sock
		make  &&   make  install
		# 生成mysql用户数据库和表文件，在安装包中输入
		scripts/mysql_install_db  --user=mysql
		vi ~/.bashrc
		export PATH="$PATH: /usr/local/mysql/bin"
		# 配置文件,有large,medium,small三个，根据机器性能选择
		cp support-files/my-medium.cnf /etc/my.cnf
		cp support-files/mysql.server /etc/init.d/mysqld
		chmod 700 /etc/init.d/mysqld
		cd /usr/local
		chmod 750 mysql -R
		chgrp mysql mysql -R
		chown mysql mysql/var -R
		cp  /usr/local/mysql/libexec/mysqld mysqld.old
		ln -s /usr/local/mysql/bin/mysql /sbin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /sbin/mysqladmin
		ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc3.d/S15mysql5
		ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc0.d/K15mysql5
		
	}

	mysql常用命令{
		
		./mysql/bin/mysqld_safe --user=mysql &   # 启动mysql服务
		./mysql/bin/mysqladmin -uroot -p -S ./mysql/data/mysql.sock shutdown    # 停止mysql服务
		mysqlcheck -uroot -p -S mysql.sock --optimize --databases account       # 检查、修复、优化MyISAM表
		mysqlbinlog slave-relay-bin.000001              # 查看二进制日志(报错加绝对路径)
		mysqladmin -h myhost -u root -p create dbname   # 创建数据库

		flush privileges;             # 刷新
		show databases;               # 显示所有数据库
		use dbname;	                  # 打开数据库
		show tables;                  # 显示选中数据库中所有的表
		desc tables;                  # 查看表结构
		drop database name;           # 删除数据库
		drop table name;              # 删除表
		create database name;         # 创建数据库
		select 列名称 from 表名称;    # 查询
		show grants for repl;         # 查看用户权限
		show processlist;             # 查看mysql进程
		select user();                # 查看所有用户
		show slave status\G;          # 查看主从状态
		show variables;               # 查看所有参数变量
		show table status             # 查看表的引擎状态
		drop table if exists user                       # 表存在就删除
		create table if not exists user                 # 表不存在就创建
		select host,user,password from user;            # 查询用户权限 先use mysql
		create table ka(ka_id varchar(6),qianshu int);  # 创建表
		SHOW VARIABLES LIKE 'character_set_%';          # 查看系统的字符集和排序方式的设定
		show variables like '%timeout%';                # 查看超时(wait_timeout)
		delete from user where user='';                 # 删除空用户
		delete from user where user='sss' and host='localhost' ;    # 删除用户
		ALTER TABLE mytable ENGINE = MyISAM ;                       # 改变现有的表使用的存储引擎
		SHOW TABLE STATUS from  库名  where Name='表名';            # 查询表引擎
		CREATE TABLE innodb (id int, title char(20)) ENGINE = INNODB                     # 创建表指定存储引擎的类型(MyISAM或INNODB)
		grant replication slave on *.* to '用户'@'%' identified by '密码';               # 创建主从复制用户
		ALTER TABLE player ADD INDEX weekcredit_faction_index (weekcredit, faction);     # 添加索引
		alter table name add column accountid(列名)  int(11) NOT NULL(字段不为空);       # 插入字段
		update host set monitor_state='Y',hostname='xuesong' where ip='192.168.1.1';     # 更新数据
		
		自增表{
		
			create table oldBoy  (id INTEGER  PRIMARY KEY AUTO_INCREMENT, name CHAR(30) NOT NULL, age integer , sex CHAR(15) );  # 创建自增表
			insert into oldBoy(name,age,sex) values(%s,%s,%s)  # 自增插入数据
			
		}

		登录mysql的命令{

			# 格式： mysql -h 主机地址 -u 用户名 -p 用户密码
			mysql -h110.110.110.110 -P3306 -uroot -p
			mysql -uroot -p -S /data1/mysql5/data/mysql.sock -A  --default-character-set=GBK

		}
		
		shell执行mysql命令{

			mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "      
			use $dbname;
			delete from data where date=('$date1');
			"    # 执行多条mysql命令
			mysql -uroot -p -S mysql.sock -e "use db;alter table gift add column accountid  int(11) NOT NULL;flush privileges;"    # 不登陆mysql插入字段

		}

		备份数据库{

			mysqldump -h host -u root -p --default-character-set=utf8 dbname >dbname_backup.sql               # 不包括库名，还原需先创建库，在use 
			mysqldump -h host -u root -p --database --default-character-set=utf8 dbname >dbname_backup.sql    # 包括库名，还原不需要创建库
			/bin/mysqlhotcopy -u root -p    # mysqlhotcopy只能备份MyISAM引擎
			mysqldump -u root -p -S mysql.sock --default-character-set=utf8 dbname table1 table2  > /data/db.sql    # 备份表
			mysqldump -uroot -p123  -d database > database.sql    # 备份数据库结构
			
			innobackupex --user=root --password="" --defaults-file=/data/mysql5/data/my_3306.cnf --socket=/data/mysql5/data/mysql.sock --slave-info --stream=tar --tmpdir=/data/dbbackup/temp /data/dbbackup/ 2>/data/dbbackup/dbbackup.log | gzip 1>/data/dbbackup/db50.tar.gz   # xtrabackup备份需单独安装软件 优点: 速度快,压力小,可直接恢复主从复制

		}
		 
		还原数据库{

			mysql -h host -u root -p dbname < dbname_backup.sql   
			source 路径.sql   # 登陆mysql后还原sql文件

		}
		
		赋权限{

			# 指定IP: $IP  本机: localhost   所有IP地址: %   # 通常指定多条
			grant all on zabbix.* to user@"$IP";             # 对现有账号赋予权限
			grant select on database.* to user@"%" Identified by "passwd";     # 赋予查询权限(没有用户，直接创建)
			grant all privileges on database.* to user@"$IP" identified by 'passwd';         # 赋予指定IP指定用户所有权限(不允许对当前库给其他用户赋权限)
			grant all privileges on database.* to user@"localhost" identified by 'passwd' with grant option;   # 赋予本机指定用户所有权限(允许对当前库给其他用户赋权限)
			grant select, insert, update, delete on database.* to user@'ip'identified by "passwd";   # 开放管理操作指令
			revoke all on *.* from user@localhost;     # 回收权限

		}

		更改密码{

			update user set password=password('passwd') where user='root'
			mysqladmin -u root password 'xuesong'

		}

		mysql忘记密码后重置{

			cd /data/mysql5
			/data/mysql5/bin/mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
			update user set password=password('123123') where user='root';

		}
		
		mysql主从复制失败恢复{

			slave stop;
			reset slave;
			change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
			slave start;

		}
		
		检测mysql主从复制延迟{
			
			1、在从库定时执行更新主库中的一个timeout数值
			2、同时取出从库中的timeout值对比判断从库与主库的延迟
		
		}
	}

	mongodb{

		一、启动{
		
			# 不启动认证
			./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/
			# 启动认证
			./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/ --auth

			# 配置文件方式启动
			cat /opt/mongodb/mongodb.conf
			  port=27017                       # 端口号
			  fork=true                        # 以守护进程的方式运行，创建服务器进程
			  auth=true                        # 开启用户认证
			  logappend=true                   # 日志采用追加方式
			  logpath=/opt/mongodb/mongodb.log # 日志输出文件路径
			  dbpath=/opt/mongodb/data/        # 数据库路径
			  shardsvr=true                    # 设置是否分片
			  maxConns=600                     # 数据库的最大连接数
			./mongod -f /opt/mongodb/mongodb.conf
			
			# 其他参数
			bind_ip         # 绑定IP  使用mongo登录需要指定对应IP
			journal         # 开启日志功能,降低单机故障的恢复时间,取代dur参数
			syncdelay       # 系统同步刷新磁盘的时间,默认60秒
			directoryperdb  # 每个db单独存放目录,建议设置.与mysql独立表空间类似
			repairpath      # 执行repair时的临时目录.如果没开启journal,出现异常重启,必须执行repair操作
			# mongodb没有参数设置内存大小.使用os mmap机制缓存数据文件,在数据量不超过内存的情况下,效率非常高.数据量超过系统可用内存会影响写入性能

		}

		二、关闭{

			# 方法一:登录mongodb
			./mongo
			use admin
			db.shutdownServer()

			# 方法:kill传递信号  两种皆可
			kill -2 pid
			kill -15 pid

		}

		三、开启认证与用户管理{

			./mongo                      # 先登录
			use admin                    # 切换到admin库
			db.addUser("root","123456")                     # 创建用户
			db.addUser('zhansan','pass',true)               # 如果用户的readOnly为true那么这个用户只能读取数据，添加一个readOnly用户zhansan
			./mongo 127.0.0.1:27017/mydb -uroot -p123456    # 再次登录,只能针对用户所在库登录
			#虽然是超级管理员，但是admin不能直接登录其他数据库，否则报错
			#Fri Nov 22 15:03:21.886 Error: 18 { code: 18, ok: 0.0, errmsg: "auth fails" } at src/mongo/shell/db.js:228
			show collections                                # 查看链接状态 再次登录使用如下命令,显示错误未经授权
			db.system.users.find();                         # 查看创建用户信息
			db.system.users.remove({user:"zhansan"})        # 删除用户

			#恢复密码只需要重启mongodb 不加--auth参数

		}

		四、登录{

			192.168.1.5:28017      # http登录后可查看状态
			./mongo                # 默认登录后打开 test 库
			./mongo 192.168.1.5:27017/databaseName      # 直接连接某个库 不存在则创建  启动认证需要指定对应库才可登录

		}

		五、查看状态{

			#登录后执行命令查看状态
			db.runCommand({"serverStatus":1})
				globalLock         # 表示全局写入锁占用了服务器多少时间(微秒)
				mem                # 包含服务器内存映射了多少数据,服务器进程的虚拟内存和常驻内存的占用情况(MB)
				indexCounters      # 表示B树在磁盘检索(misses)和内存检索(hits)的次数.如果这两个比值开始上升,就要考虑添加内存了
				backgroudFlushing  # 表示后台做了多少次fsync以及用了多少时间
				opcounters         # 包含每种主要擦撞的次数
				asserts            # 统计了断言的次数

			#状态信息从服务器启动开始计算,如果过大就会复位,发送复位，所有计数都会复位,asserts中的roolovers值增加

			#mongodb自带的命令
			./mongostat
				insert     #每秒插入量
				query      #每秒查询量
				update     #每秒更新量
				delete     #每秒删除量
				locked     #锁定量
				qr|qw      #客户端查询排队长度(读|写)
				ar|aw      #活跃客户端量(读|写)
				conn       #连接数
				time       #当前时间

		}

		六、常用命令{

			db.listCommands()     # 当前MongoDB支持的所有命令（同样可通过运行命令db.runCommand({"listCommands" : `1})来查询所有命令）

			db.runCommand({"buildInfo" : 1})                # 返回MongoDB服务器的版本号和服务器OS的相关信息。
			db.runCommand({"collStats" : 集合名})           # 返回该集合的统计信息，包括数据大小，已分配存储空间大小，索引的大小等。
			db.runCommand({"distinct" : 集合名, "key" : 键, "query" : 查询文档})     # 返回特定文档所有符合查询文档指定条件的文档的指定键的所有不同的值。
			db.runCommand({"dropDatabase" : 1})             # 清空当前数据库的信息，包括删除所有的集合和索引。
			db.runCommand({"isMaster" : 1})                 # 检查本服务器是主服务器还是从服务器。
			db.runCommand({"ping" : 1})                     # 检查服务器链接是否正常。即便服务器上锁，该命令也会立即返回。
			db.runCommand({"repaireDatabase" : 1})          # 对当前数据库进行修复并压缩，如果数据库特别大，这个命令会非常耗时。
			db.runCommand({"serverStatus" : 1})             # 查看这台服务器的管理统计信息。
			# 某些命令必须在admin数据库下运行，如下两个命令：
			db.runCommand({"renameCollection" : 集合名, "to"：集合名})     # 对集合重命名，注意两个集合名都要是完整的集合命名空间，如foo.bar, 表示数据库foo下的集合bar。
			db.runCommand({"listDatabases" : 1})                           # 列出服务器上所有的数据库

		}

		七、进程控制{

			db.currentOp()                  # 查看活动进程
			db.$cmd.sys.inprog.findOne()    # 查看活动进程 与上面一样
				opid   # 操作进程号
				op     # 操作类型(查询\更新)
				ns     # 命名空间,指操作的是哪个对象
				query  # 如果操作类型是查询,这里将显示具体的查询内容
				lockType  # 锁的类型,指明是读锁还是写锁

			db.killOp(opid值)                         # 结束进程
			db.$cmd.sys.killop.findOne({op:opid值})   # 结束进程

		}

		八、备份还原{

			./mongoexport -d test -c t1 -o t1.dat                 # 导出JSON格式
				-c         # 指明导出集合
				-d         # 使用库
			./mongoexport -d test -c t1 -csv -f num -o t1.dat     # 导出csv格式
				-csv       # 指明导出csv格式
				-f         # 指明需要导出那些例

			db.t1.drop()                    # 登录后删除数据
			./mongoimport -d test -c t1 -file t1.dat                           # mongoimport还原JSON格式
			./mongoimport -d test -c t1 -type csv --headerline -file t1.dat    # mongoimport还原csv格式数据
				--headerline                # 指明不导入第一行 因为第一行是列名

			./mongodump -d test -o /bak/mongodump                # mongodump数据备份
			./mongorestore -d test --drop /bak/mongodump/*       # mongorestore恢复
				--drop      #恢复前先删除
			db.t1.find()    #查看

			# mongodump 虽然能不停机备份,但市区了获取实时数据视图的能力,使用fsync命令能在运行时复制数据目录并且不会损坏数据
			# fsync会强制服务器将所有缓冲区的数据写入磁盘.配合lock还阻止对数据库的进一步写入,知道释放锁为止
			# 备份在从库上备份，不耽误读写还能保证实时快照备份
			db.runCommand({"fsync":1,"lock":1})   # 执行强制更新与写入锁
			db.$cmd.sys.unlock.findOne()          # 解锁
			db.currentOp()                        # 查看解锁是否正常

		}

		九、修复{

			# 当停电或其他故障引起不正常关闭时,会造成部分数据损坏丢失
			./mongod --repair      # 修复操作:启动时候加上 --repair
			# 修复过程:将所有文档导出,然后马上导入,忽略无效文档.完成后重建索引。时间较长,会丢弃损坏文档
			# 修复数据还能起到压缩数据库的作用
			db.repairDatabase()    # 运行中的mongodb可使用 repairDatabase 修复当前使用的数据库
			{"repairDatabase":1}   # 通过驱动程序

		}

		十、python使用mongodb{

			原文: http://blog.nosqlfan.com/html/2989.html
			
			easy_install pymongo      # 安装(python2.7+)
			import pymongo
			connection=pymongo.Connection('localhost',27017)   # 创建连接
			db = connection.test_database                      # 切换数据库
			collection = db.test_collection                    # 获取collection
			# db和collection都是延时创建的，在添加Document时才真正创建

			文档添加, _id自动创建
				import datetime
				post = {"author": "Mike",
					"text": "My first blog post!",
					"tags": ["mongodb", "python", "pymongo"],
					"date": datetime.datetime.utcnow()}
				posts = db.posts
				posts.insert(post)
				ObjectId('...')

			批量插入
				new_posts = [{"author": "Mike",
					"text": "Another post!",
					"tags": ["bulk", "insert"],
					"date": datetime.datetime(2009, 11, 12, 11, 14)},
					{"author": "Eliot",
					"title": "MongoDB is fun",
					"text": "and pretty easy too!",
					"date": datetime.datetime(2009, 11, 10, 10, 45)}]
				posts.insert(new_posts)
				[ObjectId('...'), ObjectId('...')]
			
			获取所有collection
				db.collection_names()    # 相当于SQL的show tables
				
			获取单个文档
				posts.find_one()

			查询多个文档
				for post in posts.find():
					post

			加条件的查询
				posts.find_one({"author": "Mike"})

			高级查询
				posts.find({"date": {"$lt": "d"}}).sort("author")

			统计数量
				posts.count()

			加索引
				from pymongo import ASCENDING, DESCENDING
				posts.create_index([("date", DESCENDING), ("author", ASCENDING)])

			查看查询语句的性能
				posts.find({"date": {"$lt": "d"}}).sort("author").explain()["cursor"]
				posts.find({"date": {"$lt": "d"}}).sort("author").explain()["nscanned"]

		}

	}

	JDK安装{

		chmod 744 jdk-1_5_0_14-linux-i586.bin
		./jdk-1_5_0_14-linux-i586.bin
		vi /etc/profile   # 添加环境变量
		export JAVA_HOME=/usr/local/jdk1.5.0_14 
		export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
		export PATH=$PATH:$JAVA_HOME/bin
		. /etc/profile

	}

}

5网络{

	rz   # 通过ssh上传小文件
	sz   # 通过ssh下载小文件
	ifconfig eth0 down                  # 禁用网卡
	ifconfig eth0 up                    # 启用网卡
	ifup eth0:0                         # 启用网卡
	mii-tool em1                        # 查看网线是否连接
	traceroute www.baidu.com            # 测试跳数
	vi /etc/resolv.conf                 # 设置DNS  nameserver IP 定义DNS服务器的IP地址
	nslookup www.moon.com               # 解析域名IP
	dig -x www.baidu.com                # 解析域名IP
	curl -I www.baidu.com               # 查看网页http头
	tcpdump tcp port 22                 # 抓包
	lynx                                # 文本上网
	wget -P 路径 http地址               # 下载  包名:wgetrc
	curl -d "user=xuesong&pwd=123" http://www.abc.cn/Result    # 提交web页面表单 需查看表单提交地址
	rsync -avzP -e "ssh -p 22" /dir user@$IP:/dir              # 同步目录 # --delete 无差同步 删除目录下其它文件
	ifconfig eth0:0 192.168.1.221 netmask 255.255.255.0        # 增加逻辑IP地址
	mtr -r www.baidu.com                                       # 测试网络链路节点响应时间 # trace ping 结合
	echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all           # 禁ping
	ipcalc -m "$ip" -p "$num"                                  # 根据IP和主机最大数计算掩码
	dig +short txt hacker.wp.dg.cx                             # 通过 DNS 来读取 Wikipedia 的hacker词条
	host -t txt hacker.wp.dg.cx                                # 通过 DNS 来读取 Wikipedia 的hacker词条
	net rpc shutdown -I IP_ADDRESS -U username%password        # 远程关掉一台WINDOWS机器
	wget --random-wait -r -p -e robots=off -U Mozilla www.example.com    # 递归方式下载整个网站
	
	netstat{

		-a     # 显示所有连接中的Socket
		-t     # 显示TCP连接
		-u     # 显示UDP连接
		-n     # 显示所有已建立的有效连接
		netstat -anlp           # 查看链接
		netstat –r              # 查看路由表

	}
	
	ssh{

		ssh -p 22 user@192.168.1.209                            # 从linux ssh登录另一台linux 
		ssh -p 22 root@192.168.1.209 CMD                        # 利用ssh操作远程主机
		scp -P 22 文件 root@ip:/目录                            # 把本地文件拷贝到远程主机
		sshpass -p '密码' ssh -n root@$IP "echo hello"          # 指定密码远程操作
		ssh -o StrictHostKeyChecking=no $IP                     # ssh连接不提示yes
		ssh -t "su -"                                           # 指定伪终端 客户端以交互模式工作
		scp root@192.168.1.209:远程目录 本地目录                # 把远程指定文件拷贝到本地
		ssh -N -L2001:remotehost:80 user@somemachine            # 用SSH创建端口转发通道
		ssh -t host_A ssh host_B                                # 嵌套使用SSH
		ssh -t -p 22 $user@$Ip /bin/su - root -c {$Cmd};        # 远程su执行命令 Cmd="\"/sbin/ifconfig eth0\""
		ssh-keygen -t rsa                                       # 生成密钥
		ssh-copy-id -i xuesong@10.10.10.133                     # 传送key
		vi $HOME/.ssh/authorized_keys                           # 公钥存放位置
		sshfs name@server:/path/to/folder /path/to/mount/point  # 通过ssh挂载远程主机上的文件夹
		fusermount -u /path/to/mount/point                      # 卸载ssh挂载的目录
		ssh user@host cat /path/to/remotefile | diff /path/to/localfile -                # 用DIFF对比远程文件跟本地文件
		su - user -c "ssh user@192.168.1.1 \"echo -e aa |mail -s test mail@163.com\""    # 切换用户登录远程发送邮件

	}

	网卡配置文件{

		vi /etc/sysconfig/network-scripts/ifcfg-eth0

		DEVICE=eth0
		BOOTPROTO=none
		BROADCAST=192.168.1.255
		HWADDR=00:0C:29:3F:E1:EA
		IPADDR=192.168.1.55
		NETMASK=255.255.255.0
		NETWORK=192.168.1.0
		ONBOOT=yes
		TYPE=Ethernet
		GATEWAY=192.168.1.1

	}

	route {

		route                           # 查看路由表
		route add default  gw 192.168.1.1  dev eth0                        # 添加默认路由
		route add -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 添加静态路由网关
		route del -net 172.16.0.0 netmask 255.255.0.0 gw 10.39.111.254     # 删除静态路由网关

	}

	解决ssh链接慢{

		sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
		sed -i '/#UseDNS yes/a\UseDNS no' /etc/ssh/sshd_config
		/etc/init.d/sshd restart

	}

	ftp上传{

		ftp -i -v -n $HOST <<END
		user $USERNAME $PASSWORD
		cd /ftp
		mkdir data
		cd data
		mput *.tar.gz
		bye
END

	}

	nmap{

		nmap -PT 192.168.1.1-111             # 先ping在扫描主机开放端口
		nmap -O 192.168.1.1                  # 扫描出系统内核版本
		nmap -sV 192.168.1.1-111             # 扫描端口的软件版本
		nmap -sS 192.168.1.1-111             # 半开扫描(通常不会记录日志)
		nmap -P0 192.168.1.1-111             # 不ping直接扫描
		nmap -d 192.168.1.1-111              # 详细信息
		nmap -D 192.168.1.1-111              # 无法找出真正扫描主机(隐藏IP)
		nmap -p 20-30,139,60000-             # 端口范围  表示：扫描20到30号端口，139号端口以及所有大于60000的端口
		nmap -P0 -sV -O -v 192.168.30.251    # 组合扫描(不ping、软件版本、内核版本、详细信息)
		
		# 不支持windows的扫描(可用于判断是否是windows)
		nmap -sF 192.168.1.1-111
		nmap -sX 192.168.1.1-111
		nmap -sN 192.168.1.1-111

	}

	流量切分线路{

		# 程序判断进入IP线路，设置服务器路由规则控制返回
		vi /etc/iproute2/rt_tables
		#添加一条策略
		252   bgp2  #注意策略的序号顺序
		ip route add default via 第二个出口上线IP(非默认网关) dev eth1 table bgp2
		ip route add from 本机第二个ip table bgp2
		#查看
		ip route list table 252
		ip rule list
		#成功后将语句添加开机启动

	}

	snmp{
		
		snmptranslate .1.3.6.1.2.1.1.3.0    # 查看映射关系
			DISMAN-EVENT-MIB::sysUpTimeInstance
		snmpdf -v 1 -c public localhost                            # SNMP监视远程主机的磁盘空间
		snmpnetstat -v 2c -c public -a 192.168.6.53                # SNMP获取指定IP的所有开放端口状态
		snmpwalk -v 2c -c public 10.152.14.117 .1.3.6.1.2.1.1.3.0  # SNMP获取主机启动时间
		# MIB安装(ubuntu) 
		# sudo apt-get install snmp-mibs-downloader
		# sudo download-mibs
		snmpwalk -v 2c -c public 10.152.14.117 sysUpTimeInstance   # SNMP通过MIB库获取主机启动时间

	}
	
}

6磁盘{
	
	df -Ph                                # 查看硬盘容量
	df -T                                 # 查看磁盘分区格式
	df -i                                 # 查看inode节点   如果inode用满后无法创建文件
	du -h 目录                            # 检测目录下所有文件大小
	du -sh *                              # 显示当前目录中子目录的大小
	iostat -x                             # 查看磁盘io状态
	mount                                 # 查看分区挂载情况
	fdisk -l                              # 查看磁盘分区状态
	fdisk /dev/hda3                       # 分区 
	mkfs -t ext3  /dev/hda3               # 格式化分区
	fsck -y /dev/sda6                     # 对文件系统修复
	lsof |grep delete                     # 释放进程占用磁盘空间  列出进程后，查看文件是否存在，不存在则kill掉此进程
	tmpwatch -afv 3                       # 删除3小时内的临时文件
	cat /proc/filesystems                 # 查看当前系统支持文件系统
	mount -o remount,rw /                 # 修改只读文件系统为读写
	smartctl -H /dev/sda                  # 检测硬盘状态
	smartctl -i /dev/sda                  # 检测硬盘信息
	smartctl -a /dev/sda                  # 检测所有信息
	e2label /dev/sda5                     # 查看卷标
	e2label /dev/sda5 new-label           # 创建卷标
	ntfslabel -v /dev/sda8 new-label      # NTFS添加卷标
	tune2fs -j /dev/sda                   # ext2分区转ext3分区
	mke2fs -b 2048 /dev/sda5              # 指定索引块大小
	dumpe2fs -h /dev/sda5                 # 查看超级块的信息
	mount -t iso9660 /dev/dvd  /mnt       # 挂载光驱
	mount -t ntfs-3g /dev/sdc1 /media/yidong        # 挂载ntfs硬盘
	mount -t nfs 10.0.0.3:/opt/images/  /data/img   # 挂载nfs
	mount -o loop  /software/rhel4.6.iso   /mnt/    # 挂载镜像文件
	
	创建swap文件方法{

		dd if=/dev/zero of=/swap bs=1024 count=4096000            # 创建一个足够大的文件
		# count的值等于1024 x 你想要的文件大小, 4096000是4G
		mkswap /swap                      # 把这个文件变成swap文件
		swapon /swap                      # 启用这个swap文件
		/swap swap swap defaults 0 0      # 在每次开机的时候自动加载swap文件, 需要在 /etc/fstab 文件中增加一行
		cat /proc/swaps                   # 查看swap
		swapoff -a                        # 关闭swap
		swapon -a                         # 开启swap

	}

	新硬盘挂载{

		fdisk /dev/sdc 
		p	#  打印分区
		d 	#  删除分区
		n	#  创建分区，（一块硬盘最多4个主分区，扩展占一个主分区位置。p主分区 e扩展）
		w	#  保存退出
		mkfs -t ext3 -L 卷标  /dev/sdc1		# 格式化相应分区
		mount /dev/sdc1  /mnt		# 挂载
		vi /etc/fstab               # 添加开机挂载分区
		LABEL=/data            /data                   ext3    defaults        1 2      # 用卷标挂载
		/dev/sdb1              /data4                  ext3    defaults        1 2      # 用真实分区挂载
		/dev/sdb2              /data4                  ext3    noatime,defaults        1 2

		第一个数字"1"该选项被"dump"命令使用来检查一个文件系统应该以多快频率进行转储，若不需要转储就设置该字段为0
		第二个数字"2"该字段被fsck命令用来决定在启动时需要被扫描的文件系统的顺序，根文件系统"/"对应该字段的值应该为1，其他文件系统应该为2。若该文件系统无需在启动时扫描则设置该字段为0
		当以 noatime 选项加载（mount）文件系统时，对文件的读取不会更新文件属性中的atime信息。设置noatime的重要性是消除了文件系统对文件的写操作，文件只是简单地被系统读取。由于写操作相对读来说要更消耗系统资源，所以这样设置可以明显提高服务器的性能.wtime信息仍然有效，任何时候文件被写，该信息仍被更新。

	}

	raid原理与区别{

		raid0至少2块硬盘.吞吐量大,性能好,同时读写,但损坏一个就完蛋
		raid1至少2块硬盘.相当镜像,一个存储,一个备份.安全性比较高.但是性能比0弱
		raid5至少3块硬盘.分别存储校验信息和数据，坏了一个根据校验信息能恢复
		raid6至少4块硬盘.两个独立的奇偶系统,可坏两块磁盘,写性能非常差

	}

}

7用户{

	users                   # 显示所有的登录用户
	groups                  # 列出当前用户和他所属的组
	who -q                  # 显示所有的登录用户
	groupadd                # 添加组
	useradd user            # 建立用户
	passwd 用户             # 修改密码
	userdel -r              # 删除帐号及家目录
	chown -R user:group     # 修改目录拥有者(R递归)
	chown y\.li:mysql       # 修改所有者用户中包含点"."
	umask                   # 设置用户文件和目录的文件创建缺省屏蔽值
	chgrp                   # 修改用户组
	finger                  # 查找用户显示信息
	echo "xuesong" | passwd user --stdin       # 非交互修改密码
	useradd -g www -M  -s /sbin/nologin  www   # 指定组并不允许登录的用户,nologin允许使用服务
	useradd -g www -M  -s /bin/false  www      # 指定组并不允许登录的用户,false最为严格
	usermod -l 新用户名 老用户名               # 修改用户名
	usermod -g user group                      # 修改用户所属组
	usermod -d 目录 -m 用户                    # 修改用户家目录
	usermod -G group user                      # 将用户添加到附加组
	gpasswd -d user group                      # 从组中删除用户
	su - user -c " #命令1; "                   # 切换用户执行
	
	恢复密码{

		# 即进入单用户模式: 在linux出现grub后，在安装的系统上面按"e"，然后出现grub的配置文件，按键盘移动光标到第二行"Ker……"，再按"e"，然后在这一行的结尾加上：空格 single或者空格1回车，然后按"b"重启，就进入了"单用户模式"
	}
	
	特殊权限{

		s或 S （SUID）：对应数值4
		s或 S （SGID）：对应数值2
		t或 T ：对应数值1
		大S：代表拥有root权限，但是没有执行权限
		小s：拥有特权且拥有执行权限，这个文件可以访问系统任何root用户可以访问的资源
		T或T（Sticky）：/tmp和 /var/tmp目录供所有用户暂时存取文件，亦即每位用户皆拥有完整的权限进入该目录，去浏览、删除和移动文件

	}

}

8脚本{
	
	#!/bin/sh         # 在脚本第一行脚本头 # sh为当前系统默认shell,可指定为bash等shell
	sh -x             # 执行过程
	sh -n             # 检查语法
	(a=bbk)           # 括号创建子shell运行
	basename /a/b/c   # 从全路径中保留最后一层文件名或目录
	dirname           # 取路径
	$RANDOM           # 随机数
	$$                # 进程号
	source FileName   # 在当前bash环境下读取并执行FileName中的命令  # 等同 . FileName
	sleep 5           # 间隔睡眠5秒
	trap              # 在接收到信号后将要采取的行动
	trap "" 2 3       # 禁止ctrl+c
	$PWD              # 当前目录
	$HOME             # 家目录
	$OLDPWD           # 之前一个目录的路径
	cd -              # 返回上一个目录路径
	local ret         # 局部变量
	yes               # 重复打印
	yes |rm -i *      # 自动回答y或者其他
	ls -p /home       # 查看目录所有文件夹
	ls -d /home/      # 查看匹配完整路径
	echo -n aa;echo bb                    # 不换行执行下一句话 将字符串原样输出
	echo -e "s\tss\n\n\n"                 # 使转义生效
	echo $a | cut -c2-6                   # 取字符串中字元
	echo {a,b,c}{a,b,c}{a,b,c}            # 排列组合(括号内一个元素分别和其他括号内元素组合)
	echo $((2#11010))                     # 二进制转10进制
	echo aaa | tee file                   # 打印同时写入文件 默认覆盖 -a追加
	echo {1..10}                          # 打印10个字符
	printf '%10s\n'|tr " " a              # 打印10个字符
	pwd | awk -F/ '{ print $2 }'          # 返回目录名
	tac file |sed 1,3d|tac                # 倒置读取文件  # 删除最后3行
	tail -3 file                          # 取最后3行
	outtmp=/tmp/$$`date +%s%N`.outtmp     # 临时文件定义
	:(){ :|:& };:                         # 著名的 fork炸弹,系统执行海量的进程,直到系统僵死
	echo -e "\e[32m....\e[0m"             # 打印颜色
	echo -e "\033[0;31mL\033[0;32mO\033[0;33mV\033[0;34mE\t\033[0;35mY\033[0;36mO\033[0;32mU\e[m"    # 打印颜色
	
	xargs{
	
		# 命令替换
		-t 先打印命令，然后再执行
		-i 用每项替换 {}
		find / -perm +7000 | xargs ls -l                    # 将前面的内容，作为后面命令的参数
		seq 1 10 |xargs  -i date -d "{} days " +%Y-%m-%d    # 列出10天日期

	}  

	正则表达式{
	
		^  	      # 行首定位
		$ 	      # 行尾定位
		. 	      # 匹配除换行符以外的任意字符
		*	      # 匹配0或多个重复字符
		+ 	      # 重复一次或更多次
		? 	      # 重复零次或一次
		?         # 结束贪婪因子 .*? 表示最小匹配
		[]	      # 匹配一组中任意一个字符
		[^]	      # 匹配不在指定组内的字符
		\	      # 用来转义元字符
		<	      # 词首定位符(支持vi和grep)  <love
		>	      # 词尾定位符(支持vi和grep)  love>
		x\{m\}    # 重复出现m次
		x\{m,\}   # 重复出现至少m次
		x\{m,n\}  # 重复出现至少m次不超过n次
		X? 	      # 匹配出现零次或一次的大写字母 X
		X+ 	      # 匹配一个或多个字母 X
		()        # 括号内的字符为一组
		(ab|de)+  # 匹配一连串的（最少一个） abc 或 def；abc 和 def 将匹配
		[[:alpha:]]    # 代表所有字母不论大小写
		[[:lower:]]    # 表示小写字母 
		[[:upper:]]    # 表示大写字母
		[[:digit:]]    # 表示数字字符
		[[:digit:][:lower:]]    # 表示数字字符加小写字母 

		元字符{

			\d 	  # 匹配任意一位数字
			\D 	  # 匹配任意单个非数字字符
			\w 	  # 匹配任意单个字母数字下划线字符，同义词是 [:alnum:]
			\W    # 匹配非数字型的字符

		}

		字符类:空白字符{

			\s 	  # 匹配任意的空白符
			\S    # 匹配非空白字符
			\b 	  # 匹配单词的开始或结束
			\n    # 匹配换行符
			\r    # 匹配回车符
			\t    # 匹配制表符
			\b    # 匹配退格符
			\0    # 匹配空值字符

		}

		字符类:锚定字符{

			\b    # 匹配字边界(不在[]中时)
			\B    # 匹配非字边界
			\A    # 匹配字符串开头
			\Z    # 匹配字符串或行的末尾
			\z    # 只匹配字符串末尾
			\G    # 匹配前一次m//g离开之处

		}

		捕获{

			(exp)                # 匹配exp,并捕获文本到自动命名的组里
			(?<name>exp)         # 匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
			(?:exp)              # 匹配exp,不捕获匹配的文本，也不给此分组分配组号

		}

		零宽断言{

			(?=exp)              # 匹配exp前面的位置
			(?<=exp)             # 匹配exp后面的位置
			(?!exp)              # 匹配后面跟的不是exp的位置
			(?<!exp)             # 匹配前面不是exp的位置
			(?#comment)	         # 注释不对正则表达式的处理产生任何影响，用于注释

		}

		特殊字符{

			http://en.wikipedia.org/wiki/Ascii_table
			^H  \010 \b  
			^M  \015 \r
			匹配特殊字符: ctrl+V ctrl不放在按H或M 即可输出^H,用于匹配

		}
	
	}

	流程结构{
	
		if判断{

			if [ $a == $b ]
			then
				echo "等于"
			else
				echo "不等于"
			fi

		}
		
		case分支选择{

			case $xs in
			0) echo "0" ;;
			1) echo "1" ;;
			*) echo "其他" ;;
			esac

		}
		
		while循环{

			# while true  等同   while :
			# 读文件为整行读入
			num=1
			while [ $num -lt 10 ]
			do
			echo $num
			((num=$num+2))
			done
			###########################
			grep a  a.txt | while read a
			do
				echo $a
			done
			###########################
			while read a
			do
				echo $a
			done < a.txt 

		}
		
		for循环{

			# 读文件已空格分隔
			w=`awk -F ":" '{print $1}' c`
			for d in $w
			do
				$d
			done
			###########################
			for ((i=0;i<${#o[*]};i++))
			do
			echo ${o[$i]}
			done

		}
		
		until循环{

			#  当command不为0时循环
			until command	
			do
				body
			done

		}
		
		流程控制{

			break N     #  跳出几层循环
			continue N  #  跳出几层循环，循环次数不变
			continue    #  重新循环次数不变

		}
	
	}

	变量{
		
		A="a b c def"           # 将字符串复制给变量
		A=`cmd`                 # 将命令结果赋给变量
		A=$(cmd)                # 将命令结果赋给变量
		eval a=\$$a             # 间接调用
		i=2&&echo $((i+3))      # 计算后打印新变量结果
		i=2&&echo $[i+3]        # 计算后打印新变量结果
		a=$((2>6?5:8))          # 判断两个值满足条件的赋值给变量
		A=(a b c def)           # 将变量定义为組数
		$1  $2  $*              # 位置参数 *代表所有
		env                     # 查看环境变量
		env | grep "name"       # 查看定义的环境变量
		set                     # 查看环境变量和本地变量
		read name               # 输入变量
		readonly name           # 把name这个变量设置为只读变量,不允许再次设置
		readonly                # 查看系统存在的只读文件
		export name             # 变量name由本地升为环境
		export name="RedHat"    # 直接定义name为环境变量
		export Stat$nu=2222     # 变量引用变量赋值
		unset name              # 变量清除
		export -n name          # 去掉只读变量
		shift                   # 用于移动位置变量,调整位置变量,使$3的值赋给$2.$2的值赋予$1
		name + 0                # 将字符串转换为数字
		number " "              # 将数字转换成字符串
		
		定义变量类型{

			declare 或 typeset
			-r 只读(readonly一样)
			-i 整形
			-a 数组
			-f 函数
			-x export
			declare -i n=0

		}

		系统变量{

			$0   #  脚本启动名(包括路径)
			$n   #  第n个参数,n=1,2,…9
			$*   #  所有参数列表(不包括脚本本身)
			$@   #  所有参数列表(独立字符串)
			$#   #  参数个数(不包括脚本本身)
			$$   #  当前程式的PID
			$!   #  执行上一个指令的PID
			$?   #  执行上一个指令的返回值

		}

		变量引用技巧{

			${name:+value}        # 如果设置了name,就把value显示,未设置则为空
			${name:-value}        # 如果设置了name,就显示它,未设置就显示value
			${name:?value}        # 未设置提示用户错误信息value 
			${name:=value}        # 如未设置就把value设置并显示<写入本地中>
			${#A}                 # 可得到变量中字节
			${#A[*]}              # 数组个数
			${A[*]}               # 数组所有元素
			${A[@]}               # 数组所有元素(标准)
			${A[2]}               # 脚本的一个参数或数组第三位
			${A:4:9}              # 取变量中第4位到后面9位
			${A/www/http}         # 取变量并且替换每行第一个关键字
			${A//www/http}        # 取变量并且全部替换每行关键字
				
			定义了一个变量： file=/dir1/dir2/dir3/my.file.txt
			${file#*/}     # 去掉第一条 / 及其左边的字串：dir1/dir2/dir3/my.file.txt
			${file##*/}    # 去掉最后一条 / 及其左边的字串：my.file.txt
			${file#*.}     # 去掉第一个 .  及其左边的字串：file.txt
			${file##*.}    # 去掉最后一个 .  及其左边的字串：txt
			${file%/*}     # 去掉最后条 / 及其右边的字串：/dir1/dir2/dir3
			${file%%/*}    # 去掉第一条 / 及其右边的字串：(空值)
			${file%.*}     # 去掉最后一个 .  及其右边的字串：/dir1/dir2/dir3/my.file
			${file%%.*}    # 去掉第一个 .  及其右边的字串：/dir1/dir2/dir3/my
			#   # 是去掉左边(在键盘上 # 在 $ 之左边)
			#   % 是去掉右边(在键盘上 % 在 $ 之右边)
			#   单一符号是最小匹配﹔两个符号是最大匹配

		}
			
	}
	
	test条件判断{

		# 符号 [ ] 等同  test命令

		expression为字符串操作{

			-n str   # 字符串str是否不为空
			-z str   # 字符串str是否为空

		}

		expression为文件操作{

			-a     # 并且，两条件为真
			-b     # 是否块文件     
			-p     # 文件是否为一个命名管道
			-c     # 是否字符文件   
			-r     # 文件是否可读
			-d     # 是否一个目录   
			-s     # 文件的长度是否不为零
			-e     # 文件是否存在   
			-S     # 是否为套接字文件
			-f     # 是否普通文件   
			-x     # 文件是否可执行，则为真
			-g     # 是否设置了文件的 SGID 位 
			-u     # 是否设置了文件的 SUID 位
			-G     # 文件是否存在且归该组所有 
			-w     # 文件是否可写，则为真
			-k     # 文件是否设置了的粘贴位  
			-t fd  # fd 是否是个和终端相连的打开的文件描述符（fd 默认为 1）
			-o     # 或，一个条件为真
			-O     # 文件是否存在且归该用户所有
			!      # 取反

		}

		expression为整数操作{

			expr1 -a expr2   # 如果 expr1 和 expr2 评估为真，则为真
			expr1 -o expr2   # 如果 expr1 或 expr2 评估为真，则为真

		}

		两值比较{

			整数	 字符串
			-lt      <         # 小于
			-gt      >         # 大于
			-le      <=        # 小于或等于
			-ge      >=        # 大于或等于
			-eq      ==        # 等于
			-ne      !=        # 不等于

		}

		test 10 -lt 5       # 判断大小
		echo $?             # 查看上句test命令返回状态  # 结果0为真,1为假
		test -n "hello"     # 判断字符串长度是否为0
		[ $? -eq 0 ] && echo "success" || exit　　　# 判断成功提示,失败则退出

	}
	
	重定向{
	
		#  标准输出 stdout 和 标准错误 stderr  标准输入stdin
		cmd 1> fiel              # 把 标准输出 重定向到 file 文件中
		cmd > file 2>&1          # 把 标准输出 和 标准错误 一起重定向到 file 文件中
		cmd 2> file              # 把 标准错误 重定向到 file 文件中
		cmd 2>> file             # 把 标准错误 重定向到 file 文件中(追加)
		cmd >> file 2>&1         # 把 标准输出 和 标准错误 一起重定向到 file 文件中(追加)
		cmd < file >file2        # cmd 命令以 file 文件作为 stdin(标准输入)，以 file2 文件作为 标准输出
		cat <>file               # 以读写的方式打开 file
		cmd < file cmd           # 命令以 file 文件作为 stdin
		cmd << delimiter
		cmd; #从 stdin 中读入，直至遇到 delimiter 分界符
delimiter

		>&n    # 使用系统调用 dup (2) 复制文件描述符 n 并把结果用作标准输出
		<&n    # 标准输入复制自文件描述符 n
		<&-    # 关闭标准输入（键盘）
		>&-    # 关闭标准输出
		n<&-   # 表示将 n 号输入关闭
		n>&-   # 表示将 n 号输出关闭

	}
	
	运算符{
	
		$[]等同于$(())  # $[]表示形式告诉shell求中括号中的表达式的值
		~var            # 按位取反运算符,把var中所有的二进制为1的变为0,为0的变为1
		var\<<str       # 左移运算符,把var中的二进制位向左移动str位,忽略最左端移出的各位,最右端的各位上补上0值,每做一次按位左移就有var乘2
		var>>str        # 右移运算符,把var中所有的二进制位向右移动str位,忽略最右移出的各位,最左的各位上补0,每次做一次右移就有实现var除以2
		var&str         # 与比较运算符,var和str对应位,对于每个二进制来说,如果二都为1,结果为1.否则为0
		var^str         # 异或运算符,比较var和str对应位,对于二进制来说如果二者互补,结果为1,否则为0
		var|str         # 或运算符,比较var和str的对应位,对于每个二进制来说,如二都该位有一个1或都是1,结果为1,否则为0

		运算符优先级{
			级别      运算符                                  说明
			1      =,+=,-=,/=,%=,*=,&=,^=,|=,<<=,>>==     # 赋值运算符
			2         ||                                  # 逻辑或 前面不成功执行
			3         &&                                  # 逻辑与 前面成功后执行
			4         |                                   # 按位或
			5         ^                                   # 按异位与
			6         &                                   # 按位与
			7         ==,!=                               # 等于/不等于
			8         <=,>=,<,>                           # 大于或等于/小于或等于/大于/小于 
			9        \<<,>>                               # 按位左移/按位右移 (无转意符号)
			10        +,-                                 # 加减
			11        *,/,%                               # 乘,除,取余
			12        ! ,~                                # 逻辑非,按位取反或补码
			13        -,+                                 # 正负
		}
		
	}

	数学运算{
	
		$(( ))        # 整数运算
		+ - * / **    # 分別为 "加、減、乘、除、密运算"
		& | ^ !       # 分別为 "AND、OR、XOR、NOT" 运算
		%             # 余数运算

		let{
		
			let # 运算  
			let x=16/4
			let x=5**5
			
		}

		expr{
		
			expr 14 % 9                    # 整数运算
			SUM=`expr 2 \* 3`              # 乘后结果赋值给变量
			LOOP=`expr $LOOP + 1`          # 增量计数(加循环即可) LOOP=0
			expr length "bkeep zbb"        # 计算字串长度
			expr substr "bkeep zbb" 4 9    # 抓取字串
			expr index "bkeep zbb" e       # 抓取第一个字符数字串出现的位置
			expr 30 / 3 / 2                # 运算符号有空格
			expr bkeep.doc : '.*'          # 模式匹配(可以使用expr通过指定冒号选项计算字符串中字符数)
			expr bkeep.doc : '\(.*\).doc'  # 在expr中可以使用字符串匹配操作，这里使用模式抽取.doc文件附属名

			数值测试{

				#如果试图计算非整数，则会返回错误
				rr=3.4
				expr $rr + 1
				expr: non-numeric argument
				rr=5
				expr $rr + 1
				6

			}
			
		}
		
		bc{

			echo "m^n"|bc            # 次方计算
			seq -s '+' 1000 |bc      # 从1加到1000
			seq 1 1000 |tr "\n" "+"|sed 's/+$/\n/'|bc   # 从1加到1000
		}
		
	}
	
	grep{

		-c    # 显示匹配到得行的数目，不显示内容
		-h    # 不显示文件名
		-i    # 忽略大小写
		-l    # 只列出匹配行所在文件的文件名
		-n    # 在每一行中加上相对行号
		-s    # 无声操作只显示报错，检查退出状态
		-v    # 反向查找
		-e    # 使用正则表达式
		-A3   # 打印匹配行和下三行
		-w    # 精确匹配
		-wc   # 精确匹配次数
		-o    # 查询所有匹配字段
		-P    # 使用perl正则表达式

		grep -v "a" txt                              # 过滤关键字符行
		grep -w 'a\>' txt                            # 精确匹配字符串
		grep -i "a" txt                              # 大小写敏感
		grep  "a[bB]" txt                            # 同时匹配大小写
		grep '[0-9]\{3\}' txt                        # 查找0-9重复三次的所在行
		grep -E "word1|word2|word3"   file           # 任意条件匹配
		grep word1 file | grep word2 |grep word3     # 同时匹配三个
		echo quan@163.com |grep -Po '(?<=@.).*(?=.$)'                           # 零宽断言截取字符串  #　63.co
		echo "I'm singing while you're dancing" |grep -Po '\b\w+(?=ing\b)'      # 零宽断言匹配		
		echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' |grep -Po '(?<=:).*?(?=d)'           # 取出d前面数字 # ?为最小匹配
		echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' | grep -Po '[-0-9.]+'                # 取出d前面数字 # ?为最小匹配
		echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '[^"]+(?=",false)'             # 取出false前面的字母
		echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '\w+",false'|grep -Po '^\w+'   # 取出false前面的字母
		
		grep用于if判断{

			if echo abc | grep "a"  > /dev/null 2>&1
			then
				echo "abc"
			else
				echo "null"
			fi

		}

	}
	
	tr{
	
		-c          # 用字符串1中字符集的补集替换此字符集，要求字符集为ASCII
		-d          # 删除字符串1中所有输入字符
		-s          # 删除所有重复出现字符序列，只保留第一个:即将重复出现字符串压缩为一个字符串
		[a-z]       # a-z内的字符组成的字符串
		[A-Z]       # A-Z内的字符组成的字符串
		[0-9]       # 数字串
		\octal      # 一个三位的八进制数，对应有效的ASCII字符
		[O*n]       # 表示字符O重复出现指定次数n。因此[O*2]匹配OO的字符串

		tr中特定控制字符表达方式{

			\a Ctrl-G    \007    # 铃声
			\b Ctrl-H    \010    # 退格符
			\f Ctrl-L    \014    # 走行换页
			\n Ctrl-J    \012    # 新行
			\r Ctrl-M    \015    # 回车
			\t Ctrl-I    \011    # tab键
			\v Ctrl-X    \030

		}

		tr A-Z a-z                             # 将所有大写转换成小写字母
		tr " " "\n"                            # 将空格替换为换行
		tr -s "[\012]" < plan.txt              # 删除空行
		tr -s ["\n"] < plan.txt                # 删除空行
		tr -s "[\015]" "[\n]" < file           # 删除文件中的^M，并代之以换行
		tr -s "[\r]" "[\n]" < file             # 删除文件中的^M，并代之以换行
		tr -s "[:]" "[\011]" < /etc/passwd     # 替换passwd文件中所有冒号，代之以tab键
		tr -s "[:]" "[\t]" < /etc/passwd       # 替换passwd文件中所有冒号，代之以tab键
		echo $PATH | tr ":" "\n"               # 增加显示路径可读性
		1,$!tr -d '\t'                         # tr在vi内使用，在tr前加处理行范围和感叹号('$'表示最后一行)
		tr "\r" "\n"<macfile > unixfile        # Mac -> UNIX
		tr "\n" "\r"<unixfile > macfile        # UNIX -> Mac
		tr -d "\r"<dosfile > unixfile          # DOS -> UNIX  Microsoft DOS/Windows 约定，文本的每行以回车字符(\r)并后跟换行符(\n)结束
		awk '{ print $0"\r" }'<unixfile > dosfile   # UNIX -> DOS：在这种情况下，需要用awk，因为tr不能插入两个字符来替换一个字符

	}
	
	seq{

		# 不指定起始数值，则默认为 1
		-s   # 选项主要改变输出的分格符, 预设是 \n
		-w   # 等位补全，就是宽度相等，不足的前面补 0
		-f   # 格式化输出，就是指定打印的格式

		seq 10 100               # 列出10-100
		seq 1 10 |tac            # 倒叙列出
		seq -s '+' 90 100 |bc    # 从90加到100
		seq -f 'dir%g' 1 10 | xargs mkdir     # 创建dir1-10
		seq -f 'dir%03g' 1 10 | xargs mkdir   # 创建dir001-010

	}

	trap{

		信号         说明
		HUP(1)     # 挂起，通常因终端掉线或用户退出而引发
		INT(2)     # 中断，通常因按下Ctrl+C组合键而引发
		QUIT(3)    # 退出，通常因按下Ctrl+\组合键而引发
		ABRT(6)    # 中止，通常因某些严重的执行错误而引发
		ALRM(14)   # 报警，通常用来处理超时
		TERM(15)   # 终止，通常在系统关机时发送
		
		trap捕捉到信号之后，可以有三种反应方式：
			1、执行一段程序来处理这一信号
			2、接受信号的默认操作
			3、忽视这一信号
		
		第一种形式的trap命令在shell接收到 signal list 清单中数值相同的信号时，将执行双引号中的命令串：
		trap 'commands' signal-list   # 单引号，要在shell探测到信号来的时候才执行命令和变量的替换，时间一直变
		trap "commands" signal-list   # 双引号，shell第一次设置信号的时候就执行命令和变量的替换，时间不变

	}

	awk{
	
		# 默认是执行打印全部 print $0
		# 1为真 打印$0
		# 0为假 不打印

		-F   # 改变FS值(分隔符)
		~    # 域匹配
		==   # 变量匹配
		!~   # 匹配不包含
		=    # 赋值
		!=   # 不等于
		+=   # 叠加
		
		\b   # 退格
		\f   # 换页
		\n   # 换行
		\r   # 回车
		\t   # 制表符Tab
		\c   # 代表任一其他字符
		
		-F"[ ]+|[%]+"  # 多个空格或多个%为分隔符
		[a-z]+         # 多个小写字母
		[a-Z]          # 代表所有大小写字母(aAbB...zZ)
		[a-z]          # 代表所有大小写字母(ab...z)
		[:alnum:]      # 字母数字字符
		[:alpha:]      # 字母字符
		[:cntrl:]      # 控制字符
		[:digit:]      # 数字字符
		[:graph:]      # 非空白字符(非空格、控制字符等)
		[:lower:]      # 小写字母
		[:print:]      # 与[:graph:]相似，但是包含空格字符
		[:punct:]      # 标点字符
		[:space:]      # 所有的空白字符(换行符、空格、制表符)
		[:upper:]      # 大写字母
		[:xdigit:]     # 十六进制的数字(0-9a-fA-F)
		[[:digit:][:lower:]]    # 数字和小写字母(占一个字符)


		内建变量{
			$n            # 当前记录的第 n 个字段，字段间由 FS 分隔
			$0            # 完整的输入记录
			ARGC          # 命令行参数的数目
			ARGIND        # 命令行中当前文件的位置 ( 从 0 开始算 ) 
			ARGV          # 包含命令行参数的数组
			CONVFMT       # 数字转换格式 ( 默认值为 %.6g)
			ENVIRON       # 环境变量关联数组
			ERRNO         # 最后一个系统错误的描述
			FIELDWIDTHS   # 字段宽度列表 ( 用空格键分隔 ) 
			FILENAME      # 当前文件名
			FNR           # 同 NR ，但相对于当前文件
			FS            # 字段分隔符 ( 默认是任何空格 ) 
			IGNORECASE    # 如果为真（即非 0 值），则进行忽略大小写的匹配
			NF            # 当前记录中的字段数(列)
			NR            # 当前行数
			OFMT          # 数字的输出格式 ( 默认值是 %.6g) 
			OFS           # 输出字段分隔符 ( 默认值是一个空格 ) 
			ORS           # 输出记录分隔符 ( 默认值是一个换行符 ) 
			RLENGTH       # 由 match 函数所匹配的字符串的长度
			RS            # 记录分隔符 ( 默认是一个换行符 ) 
			RSTART        # 由 match 函数所匹配的字符串的第一个位置
			SUBSEP        # 数组下标分隔符 ( 默认值是 /034) 
			BEGIN         # 先处理(可不加文件参数)
			END           # 结束时处理
		}

		内置函数{
			gsub(r,s)          # 在整个$0中用s替代r   相当于 sed 's///g'
			gsub(r,s,t)        # 在整个t中用s替代r 
			index(s,t)         # 返回s中字符串t的第一位置 
			length(s)          # 返回s长度 
			match(s,r)         # 测试s是否包含匹配r的字符串 
			split(s,a,fs)      # 在fs上将s分成序列a 
			sprint(fmt,exp)    # 返回经fmt格式化后的exp 
			sub(r,s)           # 用$0中最左边最长的子串代替s   相当于 sed 's///'
			substr(s,p)        # 返回字符串s中从p开始的后缀部分 
			substr(s,p,n)      # 返回字符串s中从p开始长度为n的后缀部分 
		}

		awk判断{
			awk '{print ($1>$2)?"第一排"$1:"第二排"$2}'      # 条件判断 括号代表if语句判断 "?"代表then ":"代表else
			awk '{max=($1>$2)? $1 : $2; print max}'          # 条件判断 如果$1大于$2,max值为为$1,否则为$2
			awk '{if ( $6 > 50) print $1 " Too high" ;\
			else print "Range is OK"}' file
			awk '{if ( $6 > 50) { count++;print $3 } \
			else { x+5; print $2 } }' file
		}

		awk循环{
			awk '{i = 1; while ( i <= NF ) { print NF, $i ; i++ } }' file
			awk '{ for ( i = 1; i <= NF; i++ ) print NF,$i }' file
		}
		
		awk '/Tom/' file               # 打印匹配到得行
		awk '/^Tom/{print $1}'         # 匹配Tom开头的行 打印第一个字段
		awk '$1 !~ /ly$/'              # 显示所有第一个字段不是以ly结尾的行
		awk '$3 <40'                   # 如果第三个字段值小于40才打印
		awk '$4==90{print $5}'         # 取出第四列等于90的第五列
		awk '/^(no|so)/' test          # 打印所有以模式no或so开头的行
		awk '$3 * $4 > 500'            # 算术运算(第三个字段和第四个字段乘积大于500则显示)
		awk '{print NR" "$0}'          # 加行号
		awk '/tom/,/suz/'              # 打印tom到suz之间的行
		awk '{a+=$1}END{print a}'      # 列求和
		awk 'sum+=$1{print sum}'       # 将$1的值叠加后赋给sum
		awk '{a+=$1}END{print a/NR}'   # 列求平均值
		awk -F'[ :\t]' '{print $1,$2}'           # 以空格、:、制表符Tab为分隔符
		awk '{print "'"$a"'","'"$b"'"}'          # 引用外部变量
		awk '{if(NR==52){print;exit}}'           # 显示第52行
		awk '/关键字/{a=NR+2}a==NR {print}'      # 取关键字下第几行
		awk 'gsub(/liu/,"aaaa",$1){print $0}'    # 只打印匹配替换后的行
		ll | awk -F'[ ]+|[ ][ ]+' '/^$/{print $8}'             # 提取时间,空格不固定
		awk '{$1="";$2="";$3="";print}'                        # 去掉前三列
		echo aada:aba|awk '/d/||/b/{print}'                    # 匹配两内容之一
		echo aada:abaa|awk -F: '$1~/d/||$2~/b/{print}'         # 关键列匹配两内容之一
		echo Ma asdas|awk '$1~/^[a-Z][a-Z]$/{print }'          # 第一个域匹配正则
		echo aada:aaba|awk '/d/&&/b/{print}'                   # 同时匹配两条件
		awk 'length($1)=="4"{print $1}'                        # 字符串位数
		awk '{if($2>3){system ("touch "$1)}}'                  # 执行系统命令
		awk '{sub(/Mac/,"Macintosh",$0);print}'                # 用Macintosh替换Mac
		awk '{gsub(/Mac/,"MacIntosh",$1); print}'              # 第一个域内用Macintosh替换Mac
		awk -F '' '{ for(i=1;i<NF+1;i++)a+=$i  ;print a}'      # 多位数算出其每位数的总和.比如 1234， 得到 10
		awk '{ i=$1%10;if ( i == 0 ) {print i}}'               # 判断$1是否整除(awk中定义变量引用时不能带 $ )
		awk 'BEGIN{a=0}{if ($1>a) a=$1 fi}END{print a}'        # 列求最大值  设定一个变量开始为0，遇到比该数大的值，就赋值给该变量，直到结束
		awk 'BEGIN{a=11111}{if ($1<a) a=$1 fi}END{print a}'    # 求最小值
		awk '{if(A)print;A=0}/regexp/{A=1}'                    # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
		awk '/regexp/{print A}{A=$0}'                          # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
		awk '{if(!/mysql/)gsub(/1/,"a");print $0}'             # 将1替换成a，并且只在行中未出现字串mysql的情况下替换
		awk 'BEGIN{srand();fr=int(100*rand());print fr;}'      # 获取随机数
		awk '{if(NR==3)F=1}{if(F){i++;if(i%7==1)print}}'       # 从第3行开始，每7行显示一次
		awk '{if(NF<1){print i;i=0} else {i++;print $0}}'      # 显示空行分割各段的行数
		echo +null:null  |awk -F: '$1!~"^+"&&$2!="null"{print $0}'       # 关键列同时匹配
		awk -v RS=@ 'NF{for(i=1;i<=NF;i++)if($i) printf $i;print ""}'    # 指定记录分隔符
		awk '{b[$1]=b[$1]$2}END{for(i in b){print i,b[i]}}'              # 列叠加
		awk '{ i=($1%100);if ( $i >= 0 ) {print $0,$i}}'                 # 求余数
		awk '{b=a;a=$1; if(NR>1){print a-b}}'                            # 当前行减上一行
		awk '{a[NR]=$1}END{for (i=1;i<=NR;i++){print a[i]-a[i-1]}}'      # 当前行减上一行
		awk -F: '{name[x++]=$1};END{for(i=0;i<NR;i++)print i,name[i]}'   # END只打印最后的结果,END块里面处理数组内容
		awk '{sum2+=$2;count=count+1}END{print sum2,sum2/count}'         # $2的总和  $2总和除个数(平均值)
		awk 'BEGIN{ "date" | getline d; split(d,mon) ; print mon[2]}' file        # 将date值赋给d，并将d设置为数组mon，打印mon数组中第2个元素
		awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'      # 截取字符串(substr使用)
		awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'      # 匹配字符串(index使用)
		awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'    # 正则表达式匹配查找(match使用)
		awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'    # 字符串分割(split使用)
		awk '{for(i=1;i<=4;i++)printf $i""FS; for(y=10;y<=13;y++)  printf $y""FS;print ""}'        # 打印前4列和后4列
		awk 'BEGIN{for(n=0;n++<9;){for(i=0;i++<n;)printf i"x"n"="i*n" ";print ""}}'                # 乘法口诀
		awk '{if (system ("grep "$2" tmp/* > /dev/null 2>&1") == 0 ) {print $1,"Y"} else {print $1,"N"} }' a            # 执行系统命令判断返回状态
		awk  '{for(i=1;i<=NF;i++) a[i,NR]=$i}END{for(i=1;i<=NF;i++) {for(j=1;j<=NR;j++) printf a[i,j] " ";print ""}}'   # 将多行转多列
		awk 'BEGIN{printf "what is your name?";getline name < "/dev/tty" } $1 ~name {print "FOUND" name " on line ", NR "."} END{print "see you," name "."}' file  # 两文件匹配
		cat 1.txt|awk -F" # " '{print "insert into user (user,password,email)values(""'\''"$1"'\'\,'""'\''"$2"'\'\,'""'\''"$3"'\'\)\;'"}' >>insert_1.txt     # 处理sql语句
		
		取本机IP{
		/sbin/ifconfig |awk -v RS="Bcast:" '{print $NF}'|awk -F: '/addr/{print $2}'
		/sbin/ifconfig |awk -v RS='inet addr:' '$1!="eth0"&&$1!="127.0.0.1"{print $1}'|awk '{printf"%s|",$0}'
		/sbin/ifconfig |awk  '{printf("line %d,%s\n",NR,$0)}'         # 指定类型(%d数字,%s字符)
		}

		查看磁盘空间{
			df -h|awk -F"[ ]+|%" '$5>14{print $5}'
			df -h|awk 'NR!=1{if ( NF == 6 ) {print $5} else if ( NF == 5) {print $4} }' 
			df -h|awk 'NR!=1 && /%/{sub(/%/,"");print $(NF-1)}'
			df -h|sed '1d;/ /!N;s/\n//;s/ \+/ /;'    #将磁盘分区整理成一行   可直接用 df -P
		}

		排列打印{
			awk 'END{printf "%-10s%-10s\n%-10s%-10s\n%-10s%-10s\n","server","name","123","12345","234","1234"}' txt
			awk 'BEGIN{printf "|%-10s|%-10s|\n|%-10s|%-10s|\n|%-10s|%-10s|\n","server","name","123","12345","234","1234"}'
			awk 'BEGIN{
			print "   *** 开 始 ***   ";
			print "+-----------------+";
			printf "|%-5s|%-5s|%-5s|\n","id","name","ip";
			}
			$1!=1 && NF==4{printf "|%-5s|%-5s|%-5s|\n",$1,$2,$3" "$11}
			END{
			print "+-----------------+";
			print "   *** 结 束 ***   "
			}' txt
		}

		老男孩awk经典题{
			分析图片服务日志，把日志（每个图片访问次数*图片大小的总和）排行，也就是计算每个url的总访问大小
			说明：本题生产环境应用：这个功能可以用于IDC网站流量带宽很高，然后通过分析服务器日志哪些元素占用流量过大，进而进行优化或裁剪该图片，压缩js等措施。
			本题需要输出三个指标： 【被访问次数】    【访问次数*单个被访问文件大小】   【文件名（带URL）】
			测试数据
			59.33.26.105 - - [08/Dec/2010:15:43:56 +0800] "GET /static/images/photos/2.jpg HTTP/1.1" 200 11299 

			awk '{array_num[$7]++;array_size[$7]+=$10}END{for(i in array_num) {print array_num[i]" "array_size[i]" "i}}'
		}

		awk练习题{

			wang     4
			cui      3
			zhao     4
			liu      3
			liu      3
			chang    5
			li       2

			1 通过第一个域找出字符长度为4的
			2 当第二列值大于3时，创建空白文件，文件名为当前行第一个域$1 (touch $1)
			3 将文档中 liu 字符串替换为 hong
			4 求第二列的和
			5 求第二列的平均值
			6 求第二列中的最大值
			7 将第一列过滤重复后，列出每一项，每一项的出现次数，每一项的大小总和

			1、字符串长度
				awk 'length($1)=="4"{print $1}'
			2、执行系统命令
				awk '{if($2>3){system ("touch "$1)}}'
			3、gsub(/r/,"s",域) 在指定域(默认$0)中用s替代r  (sed 's///g')
				awk '{gsub(/liu/,"hong",$1);print $0}' a.txt
			4、列求和
				awk '{a+=$2}END{print a}'
			5、列求平均值
				awk '{a+=$2}END{print a/NR}'
				awk '{a+=$2;b++}END{print a,a/b}' 
			6、列求最大值
				awk 'BEGIN{a=0}{if($2>a) a=$2 }END{print a}'
			7、将第一列过滤重复列出每一项，每一项的出现次数，每一项的大小总和
				awk '{a[$1]++;b[$1]+=$2}END{for(i in a){print i,a[i],b[i]}}'
		}

	}

	sed{
	
		# 先读取资料、存入模式空间、对其进行编辑、再输出、再用下一行替换模式空间内容
		# 调试工具sedsed (参数 -d)   http://aurelio.net/sedsed/sedsed-1.0
			
		-n 	 # 输出由编辑指令控制(取消默认的输出,必须与编辑指令一起配合)
		-i   # 直接对文件操作
		-e   # 多重编辑
		-r   # 正则可不转移特殊字符

		b    # 跳过匹配的行
		p    # 打印
		d    # 删除
		s    # 替换
		g    # 配合s全部替换
		i    # 行前插入
		a    # 行后插入
		r    # 读
		y    # 转换
		q    # 退出

		&    # 代表查找的串内容
		*    # 任意多个 前驱字符(前导符)
		?    # 0或1个 最小匹配 没加-r参数需转义 \?
		$    # 最后一行
		.*   # 匹配任意多个字符
		\(a\)   # 保存a作为标签1(\1)

		模式空间{

			# 模式空间(两行两行处理) 模式匹配的范围，一般而言，模式空间是输入文本中某一行，但是可以通过使用N函数把多于一行读入模式空间
			# 暂存空间里默认存储一个空行
			n   # 读入下一行(覆盖上一行)
			h   # 把模式空间里的行拷贝到暂存空间
			H   # 把模式空间里的行追加到暂存空间
			g   # 用暂存空间的内容替换模式空间的行
			G   # 把暂存空间的内容追加到模式空间的行后
			x   # 将暂存空间的内容于模式空间里的当前行互换
			！  # 对其前面的要匹配的范围取反
			D   # 删除当前模式空间中直到并包含第一个换行符的所有字符(/.*/匹配模式空间中所有内容，匹配到就执行D,没匹配到就结束D)
			N   # 追加下一个输入行到模式空间后面并在第二者间嵌入一个换行符，改变当前行号码,模式匹配可以延伸跨域这个内嵌换行
			p   # 打印模式空间中的直到并包含第一个换行的所有字符 

		}

		标签函数{

			: lable # 建立命令标记，配合b，t函数使用跳转
			b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
			t labe  # 判断分支，从最后一行开始，条件一旦满足或者T,t命令，将导致分支到带有标号的命令出，或者到脚本末尾。与b函数不同在于t在执行跳转前会先检查其前一个替换命令是否成功，如成功，则执行跳转。

			sed -e '{:p1;/A/s/A/AA/;/B/s/B/BB/;/[AB]\{10\}/b;b p1;}'     # 文件内容第一行A第二行B:建立标签p1;两个替换函数(A替换成AA,B替换成BB)当A或者B达到10个以后调用b,返回
			echo 'sd  f   f   [a    b      c    cddd    eee]' | sed ':n;s#\(\[[^ ]*\)  *#\1#;tn'  #标签函数t使用方法,替换[]里的空格

		}

		引用外部变量{

			sed -n ''$a',10p'
			sed -n ""$a",10p"

		}

		sed 10q                                       # 显示文件中的前10行 (模拟"head")
		sed -n '$='                                   # 计算行数(模拟 "wc -l")
		sed -n '5,/^no/p'                             # 打印从第5行到以no开头行之间的所有行
		sed -i "/^$f/d" a     　　                  　# 删除匹配行
		sed -i '/aaa/,$d'                             # 删除匹配行到末尾
		sed -i "s/=/:/" c                             # 直接对文本替换
		sed -i "/^pearls/s/$/j/"                      # 找到pearls开头在行尾加j
		sed '/1/,/3/p' file                           # 打印1和3之间的行
		sed -n '1p' 文件                              # 取出指定行
		sed '5i\aaa' file                             # 在第5行之前插入行
		sed '5a\aaa' file                             # 在第5行之后抽入行
		echo a|sed -e '/a/i\b'                        # 在匹配行前插入一行
		echo a|sed -e '/a/a\b'                        # 在匹配行后插入一行
		echo a|sed 's/a/&\nb/g'                       # 在匹配行后插入一行
		seq 10| sed -e{1,3}'s/./a/'                   # 匹配1和3行替换
		sed -n '/regexp/!p'                           # 只显示不匹配正则表达式的行
		sed '/regexp/d'                               # 只显示不匹配正则表达式的行
		sed '$!N;s/\n//'                              # 将每两行连接成一行
		sed '/baz/s/foo/bar/g'                        # 只在行中出现字串"baz"的情况下将"foo"替换成"bar" 
		sed '/baz/!s/foo/bar/g'                       # 将"foo"替换成"bar"，并且只在行中未出现字串"baz"的情况下替换
		echo a|sed -e 's/a/#&/g'                      # 在a前面加#号
		sed 's/foo/bar/4'                             # 只替换每一行中的第四个字串
		sed 's/\(.*\)foo/\1bar/'                      # 替换每行最后一个字符串
		sed 's/\(.*\)foo\(.*foo\)/\1bar\2/'           # 替换倒数第二个字符串
		sed 's/[0-9][0-9]$/&5'                        # 在以[0-9][0-9]结尾的行后加5
		sed -n ' /^eth\|em[01][^:]/{n;p;}'            # 匹配多个关键字
		sed -n -r ' /eth|em[01][^:]/{n;p;}'           # 匹配多个关键字
		echo -e "1\n2"|xargs -i -t sed 's/^/1/' {}    # 同时处理多个文件
		sed '/west/,/east/s/$/*VACA*/'                # 修改west和east之间的所有行，在结尾处加*VACA*
		sed  's/[^1-9]*\([0-9]\+\).*/\1/'             # 取出第一组数字，并且忽略掉开头的0
		sed -n '/regexp/{g;1!p;};h'                   # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
		sed -n ' /regexp/{n;p;}'                      # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
		sed -n 's/\(mar\)got/\1ianne/p'               # 保存\(mar\)作为标签1
		sed -n 's/\([0-9]\+\).*\(t\)/\2\1/p'          # 保存多个标签
		sed -i -e '1,3d' -e 's/1/2/'                  # 多重编辑(先删除1-3行，在将1替换成2)
		sed -e 's/@.*//g' -e '/^$/d'                  # 删除掉@后面所有字符，和空行
		sed -n -e "{s/文本(正则)/替换的内容/p}"       # 替换并打印出替换行
		sed -n -e "{s/^ *[0-9]*//p}"                  # 打印并删除正则表达式的那部分内容
		echo abcd|sed 'y/bd/BE/'                      # 匹配字符替换
		sed '/^#/b;y/y/P/' 2                          # 非#号开头的行替换字符
		sed '/suan/r 读入文件'                        # 找到含suan的行，在后面加上读入的文件内容
		sed -n '/no/w 写入文件'                       # 找到含no的行，写入到指定文件中
		sed '/regex/G'                                # 在匹配式样行之后插入一空行
		sed '/regex/{x;p;x;G;}'                       # 在匹配式样行之前和之后各插入一空行
		sed 'n;d'                                     # 删除所有偶数行
		sed 'G;G'                                     # 在每一行后面增加两空行
		sed '/^$/d;G'                                 # 在输出的文本中每一行后面将有且只有一空行
		sed 'n;n;n;n;G;'                              # 在每5行后增加一空白行
		sed -n '5~5p'                                 # 只打印行号为5的倍数
		seq 1 30|sed  '5~5s/.*/a/'                    # 倍数行执行替换
		sed -n '3,${p;n;n;n;n;n;n;}'                  # 从第3行开始，每7行显示一次
		sed -n 'h;n;G;p'                              # 奇偶调换
		seq 1 10|sed '1!G;h;$!d'                      # 倒叙排列
		ls -l|sed -n '/^.rwx.*/p'                     # 查找属主权限为7的文件
		sed = filename | sed 'N;s/\n/\t/'             # 为文件中的每一行进行编号(简单的左对齐方式)
		sed 's/^[ \t]*//'                             # 将每一行前导的"空白字符"(空格，制表符)删除,使之左对齐 
		sed 's/^[ \t]*//;s/[ \t]*$//'                 # 将每一行中的前导和拖尾的空白字符删除
		echo abcd\\nabcde |sed 's/\\n/@/g' |tr '@' '\n'        # 将换行符转换为换行
		cat tmp|awk '{print $1}'|sort -n|sed -n '$p'           # 取一列最大值
		sed -n '{s/^[^\/]*//;s/\:.*//;p}' /etc/passwd          # 取用户家目录(匹配不为/的字符和匹配:到结尾的字符全部删除)
		sed = filename | sed 'N;s/^/      /; s/ *\(.\{6,\}\)\n/\1   /'   # 对文件中的所有行编号(行号在左，文字右端对齐)
		/sbin/ifconfig |sed 's/.*inet addr:\(.*\) Bca.*/\1/g' |sed -n '/eth/{n;p}'   # 取所有IP

		修改keepalive配置剔除后端服务器{

			sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^/#/' keepalived.conf
			sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^#//' keepalived.conf

		}
		
		模仿rev功能{

			echo 123 |sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//;'
			/\n/!G;         　　　　　　# 没有\n换行符，要执行G,因为保留空间中为空，所以在模式空间追加一空行
			s/\(.\)\(.*\n\)/&\2\1/;     # 标签替换 &\n23\n1$ (关键在于& ,可以让后面//匹配到空行)
			//D;            　　　　　　# D 命令会引起循环删除模式空间中的第一部分，如果删除后，模式空间中还有剩余行，则返回 D 之前的命令，重新执行，如果 D 后，模式空间中没有任何内容，则将退出。  //D 匹配空行执行D,如果上句s没有匹配到,//也无法匹配到空行, "//D;"命令结束
			s/.//;          　　　　　　# D结束后,删除开头的 \n

		}

	}

	dialog菜单{
	
		# 默认将所有输出用 stderr 输出，不显示到屏幕   使用参数  --stdout 可将选择赋给变量
		# 退出状态  0正确  1错误

		窗体类型{
			--calendar          # 日历
			--checklist         # 允许你显示一个选项列表，每个选项都可以被单独的选择 (复选框)
			--form              # 表单,允许您建立一个带标签的文本字段，并要求填写
			--fselect           # 提供一个路径，让你选择浏览的文件
			--gauge             # 显示一个表，呈现出完成的百分比，就是显示出进度条。
			--infobox           # 显示消息后，（没有等待响应）对话框立刻返回，但不清除屏幕(信息框)
			--inputbox          # 让用户输入文本(输入框)
			--inputmenu         # 提供一个可供用户编辑的菜单（可编辑的菜单框）
			--menu              # 显示一个列表供用户选择(菜单框)
			--msgbox(message)   # 显示一条消息,并要求用户选择一个确定按钮(消息框)
			--password          # 密码框，显示一个输入框，它隐藏文本
			--pause             # 显示一个表格用来显示一个指定的暂停期的状态
			--radiolist         # 提供一个菜单项目组，但是只有一个项目，可以选择(单选框)
			--tailbox           # 在一个滚动窗口文件中使用tail命令来显示文本
			--tailboxbg         # 跟tailbox类似，但是在background模式下操作
			--textbox           # 在带有滚动条的文本框中显示文件的内容  (文本框)
			--timebox           # 提供一个窗口，选择小时，分钟，秒
			--yesno(yes/no)     # 提供一个带有yes和no按钮的简单信息框
		}

		窗体参数{
			--separate-output          # 对于chicklist组件,输出结果一次输出一行,得到结果不加引号 
			--ok-label "提交"          # 确定按钮名称
			--cancel-label "取消"      # 取消按钮名称
			--title "标题"             # 标题名称
			--stdout                   # 将所有输出用 stdout 输出
			--backtitle "上标"         # 窗体上标
			--no-shadow                # 去掉窗体阴影
			--menu "菜单名" 20 60 14   # 菜单及窗口大小
			--clear                    # 完成后清屏操作
			--no-cancel                # 不显示取消项
			--insecure                 # 使用星号来代表每个字符
			--begin <y> <x>            # 指定对话框左上角在屏幕的上的做坐标
			--timeout <秒>             # 超时,返回的错误代码255,如果用户在指定的时间内没有给出相应动作,就按超时处理
			--defaultno                # 使选择默认为no
			--default-item <str>       # 设置在一份清单，表格或菜单中的默认项目。通常在框中的第一项是默认
			--sleep 5                  # 在处理完一个对话框后静止(延迟)的时间(秒)
			--max-input size           # 限制输入的字符串在给定的大小之内。如果没有指定，默认是2048
			--keep-window              # 退出时不清屏和重绘窗口。当几个组件在同一个程序中运行时，对于保留窗口内容很有用的
		}

		dialog --title "Check me" --checklist "Pick Numbers" 15 25 3 1 "one" "off" 2 "two" "on"         # 多选界面[方括号]
		dialog --title "title" --radiolist "checklist" 20 60 14 tag1 "item1" on tag2 "item2" off        # 多选界面(圆括号)
		dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"                         # 单选界面
		dialog --title "Installation" --backtitle "Star Linux" --gauge "Linux Kernel"  10 60 50         # 进度条
		dialog --title "标题" --backtitle "Dialog" --yesno "说明" 20 60                                 # 选择yes/no		
		dialog --title "公告标题" --backtitle "Dialog" --msgbox "内容" 20 60                            # 公告
		dialog --title "hey" --backtitle "Dialog" --infobox "Is everything okay?" 10 60                 # 显示讯息后立即离开
		dialog --title "hey" --backtitle "Dialog" --inputbox "Is okay?" 10 60 "yes"                     # 输入对话框
		dialog --title "Array 30" --backtitle "All " --textbox /root/txt 20 75                          # 显示文档内容
		dialog --title "Add" --form "input" 12 40 4 "user" 1 1 "" 1 15 15 0 "name" 2 1 "" 2 15 15 0     # 多条输入对话框
		dialog --title  "Password"  --insecure  --passwordbox  "请输入密码"  10  35                     # 星号显示输入--insecure
		dialog --stdout --title "日历"  --calendar "请选择" 0 0 9 1 2010                                # 选择日期
		dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2" 2>tmp                   # 取到结果放到文件中(以标准错误输出结果)
		a=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"`           # 选择操作赋给变量(使用标准输出)
		
		dialog菜单实例{
			while :
			do
			clear
			menu=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 1 system 2 custom`
			[ $? -eq 0 ] && echo "$menu" || exit         # 判断dialog执行,取消退出
				while :
				do
					case $menu in
					1)
						list="1a "item1" 2a "item2""     # 定义菜单列表变量
					;;
					2)
						list="1b "item3" 2b "item4""
					;;
					esac
					result=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 $list` 
					[ $? -eq 0 ] && echo "$result" || break    # 判断dialog执行,取消返回菜单,注意:配合上层菜单循环
					read
				done
			done
		}
		
	}

	select菜单{

		# 输入项不在菜单自动会提示重新输入
		select menuitem in pick1 pick2 pick3 退出
		do
			echo $menuitem
			case $menuitem in
			退出)
				exit
			;;
			*)
				select area in area1 area2 area3 返回
				do
					echo $area
					case area in
					返回)
						break
					;;
					*)
						echo "对$area操作"
					;;
					esac
				done
			;;
			esac
		done

	}

	shift{

		./cs.sh 1 2 3
		#!/bin/sh
		until [ $# -eq 0 ]
		do
			echo "第一个参数为: $1 参数个数为: $#"
			#shift 命令执行前变量 $1 的值在shift命令执行后不可用
			shift
		done

	}
		
	getopts给脚本加参数{

		#!/bin/sh
		while getopts :ab: name
		do
			case $name in
			a)  
				aflag=1
			;;
			b)  
				bflag=1
				bval=$OPTARG
			;;
			\?) 
				echo "USAGE:`basename $0` [-a] [-b value]"
				exit  1
			;;
			esac
		done
		if [ ! -z $aflag ] ; then
			echo "option -a specified"
			echo "$aflag"
			echo "$OPTIND"
		fi
		if [ ! -z $bflag ] ; then
			echo  "option -b specified"
			echo  "$bflag"
			echo  "$bval"
			echo  "$OPTIND"
		fi
		echo "here  $OPTIND"
		shift $(($OPTIND -1))
		echo "$OPTIND"
		echo " `shift $(($OPTIND -1))`  "

	}

	tclsh{

		set foo "a bc"                   # 定义变量
		set b {$a};                      # 转义  b的值为" $a " ,而不是变量结果
		set a 3; incr a 3;               # 数字的自增.  将a加3,如果要减3,则为 incr a –3;
		set c [expr 20/5];               # 计算  c的值为4
		puts $foo;                       # 打印变量
		set qian(123) f;                 # 定义数组
		set qian(1,1,1) fs;              # 多维数组
		parray qian;                     # 打印数组的所有信息
		string length $qian;             # 将返回变量qian的长度
		string option string1 string2;   # 字符相关串操作
		# option 的操作选项:
		# compare           按照字典的排序方式进行比较。根据string1 <,=,>string2分别返回-1,0,1
		# first             返回string2中第一次出现string1的位置，如果没有出现string1则返回-1
		# last              和first相反
		# trim              从string1中删除开头和结尾的出现在string2中的字符
		# tolower           返回string1中的所有字符被转换为小写字符后的新字符串
		# toupper           返回string1中的所有字符串转换为大写后的字符串
		# length            返回string1的长度
		set a 1;while {$a < 3} { set a [incr a 1;]; };puts $a    # 判断变量a小于3既循环
		for {initialization} {condition} {increment} {body}      # 初始化变量,条件,增量,具体操作
		for {set i 0} {$i < 10} {incr i} {puts $i;}              # 将打印出0到9
		if { 表达式 } {
			 #运算;
		} else {
			 #其他运算;
		}
		switch $x {
			字符串1 { 操作1 ;}
			字符串2 { 操作2 ;}
		}
		foreach element {0 m n b v} {    
		# 将在一组变元中进行循环，并且每次都将执行他的循环体
			   switch $element {
					 # 判断element的值
			 }
		}
		expect交互{

			exp_continue         # 多个spawn命令时并行
			interact             # 执行完成后保持交互状态，把控制权交给控制台
			expect "password:"   # 判断关键字符
			send "passwd\r"      # 执行交互动作，与手工输入密码的动作等效。字符串结尾加"\r"

			ssh后sudo{

				#!/bin/bash
				#sudo注释下行允许后台运行
				#Defaults requiretty
				#sudo去掉!允许远程
				#Defaults !visiblepw

				/usr/bin/expect -c '
				set timeout 5
				spawn ssh -o StrictHostKeyChecking=no xuesong1@192.168.42.128 "sudo grep xuesong1 /etc/passwd"
				expect {
					"passphrase" {
						send_user "sshkey\n"
						send "xuesong\r";
						expect {
							"sudo" {
							send_user "sudo\n"
							send "xuesong\r"
							interact
							}
							eof {
							send_user "sudo eof\n"
							}
						}
					}
					"password:" {
						send_user "ssh\n"
						send "xuesong\r";
						expect {
							"sudo" {
							send_user "sudo\n"
							send "xuesong\r"
							interact
							}
							eof {
							send_user "sudo eof\n"
							}
						}
					}
					"sudo" {
							send_user "sudo\n"
							send "xuesong\r"
							interact
							}
					eof {
						send_user "ssh eof\n"
					}
				}
				'

			}

			ssh执行命令操作{
			
				/usr/bin/expect -c "
				proc jiaohu {} {
					send_user expect_start
					expect {
						password {
							send ${RemotePasswd}\r;
							send_user expect_eof
							expect {
								\"does not exist\" {
									send_user expect_failure
									exit 10
								}
								password {
									send_user expect_failure
									exit 5
								}
								Password {
									send ${RemoteRootPasswd}\r;
									send_user expect_eof
									expect {
										incorrect {
											send_user expect_failure
											exit 6
										}
										eof 
									}
								}
								eof
							}
						}
						passphrase {
							send ${KeyPasswd}\r;
							send_user expect_eof
							expect {
								\"does not exist\" {
									send_user expect_failure
									exit 10
								}
								passphrase{
									send_user expect_failure
									exit 7
								}
								Password {
									send ${RemoteRootPasswd}\r;
									send_user expect_eof
									expect {
										incorrect {
											send_user expect_failure
											exit 6
										}
										eof
									}
								}
								eof
							}
						}
						Password {
							send ${RemoteRootPasswd}\r;
							send_user expect_eof
							expect {
								incorrect {
									send_user expect_failure
									exit 6
								}
								eof
							}
						}
						\"No route to host\" {
							send_user expect_failure
							exit 4
						}
						\"Invalid argument\" {
							send_user expect_failure
							exit 8
						}
						\"Connection refused\" {
							send_user expect_failure
							exit 9
						}
						\"does not exist\" {
							send_user expect_failure
							exit 10
						}
						
						\"Connection timed out\" {
							send_user expect_failure
							exit 11
						}
						timeout {
							send_user expect_failure
							exit 3
						}
						eof
					}
				}
				set timeout $TimeOut
				switch $1 {
					Ssh_Cmd {
						spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c \\\"$Cmd\\\"
						jiaohu
					}
					Ssh_Script {
						spawn scp -P $Port -o StrictHostKeyChecking=no $ScriptPath $RemoteUser@$Ip:/tmp/${ScriptPath##*/};
						jiaohu
						spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c  \\\"/bin/sh /tmp/${ScriptPath##*/}\\\" ;
						jiaohu
					}
					Scp_File {
						spawn scp -P $Port -o StrictHostKeyChecking=no -r $ScpPath $RemoteUser@$Ip:${ScpRemotePath};
						jiaohu
					}
				}
				"

			}

			交互双引号引用较长变量{
			
				#!/bin/bash
				RemoteUser=xuesong12
				Ip=192.168.1.2
				RemotePasswd=xuesong
				Cmd="/bin/echo "$PubKey" > "$RemoteKey"/authorized_keys"

				/usr/bin/expect -c "
				set timeout 10
				spawn ssh -o StrictHostKeyChecking=no $RemoteUser@$Ip {$Cmd};
				expect {
					password: {
						send_user RemotePasswd\n
						send ${RemotePasswd}\r;
						interact;
					}
					eof {
						send_user eof\n
					}
				}
				"

			}

			telnet{
			
				#!/bin/bash
				Ip="10.0.1.53"
				a="\{\'method\'\:\'doLogin\'\,\'params\'\:\{\'uName\'\:\'bobbietest\'\}"
				/usr/bin/expect -c"
						set timeout 15
						spawn telnet ${Ip} 8000
						expect "Escape"
						send "${a}\\r"
						expect {
								-re "\"err.*none\"" {
										exit 0
								}
								timeout {                       
										exit 1
								}
								eof {
										exit 2
								}
						}
				"
				echo $?

			}

		}


	}

}

9实例{

	从1叠加到100{

		echo $[$(echo +{1..100})]
		echo $[(100+1)*(100/2)]
		seq -s '+' 100 |bc

	}

	判断参数是否为空-空退出并打印null{

		#!/bin/sh
		echo $1
		name=${1:?"null"}
		echo $name

	}

	循环数组{

		for ((i=0;i<${#o[*]};i++))
		do
			echo ${o[$i]}
		done

	}

	判断路径{

		if [ -d /root/Desktop/text/123 ];then 
			echo "找到了123"
			if [ -d /root/Desktop/text ]
			then echo "找到了text"
			else echo "没找到text"
			fi
		else echo "没找到123文件夹"
		fi

	}

	找出出现次数最多{

		awk '{print $1}' file|sort |uniq -c|sort -k1r

	}
	
	判断脚本参数是否正确{

		./test.sh  -p 123 -P 3306 -h 127.0.0.1 -u root
		#!/bin/sh
		if [ $# -ne 8 ];then
			echo "USAGE: $0 -u user -p passwd -P port -h host"
			exit 1
		fi

		while getopts :u:p:P:h: name
		do
			case $name in
			u)
				mysql_user=$OPTARG
			;;
			p)
				mysql_passwd=$OPTARG
			;;
			P)
				mysql_port=$OPTARG
			;;
			h)
				mysql_host=$OPTARG
			;;
			*)
				echo "USAGE: $0 -u user -p passwd -P port -h host"
				exit 1
			;;
			esac
		done

		if [ -z $mysql_user ] || [ -z $mysql_passwd ] || [ -z $mysql_port ] || [ -z $mysql_host ]
		then
			echo "USAGE: $0 -u user -p passwd -P port -h host"
			exit 1
		fi

		echo $mysql_user $mysql_passwd $mysql_port  $mysql_host
		#结果 root 123 3306 127.0.0.1
	
	}

	打印表格{

		#!/bin/sh
		clear
		awk 'BEGIN{
		print "+--------------------+--------------------+";
		printf "|%-20s|%-20s|\n","Name","Number";
		print "+--------------------+--------------------+";
		}'
		a=`grep "^[A-Z]" a.txt |sort +1 -n |awk '{print $1":"$2}'`
		#cat a.txt |sort +1 -n |while read list
		for list in $a
		do
			name=`echo $list |awk -F: '{print $1}'`
			number=`echo $list |awk -F: '{print $2}'`
			awk 'BEGIN{printf "|%-20s|%-20s|\n","'"$name"'","'"$number"'";
			print "+--------------------+--------------------+";
			}'
		done
		awk 'BEGIN{
		print "              *** The End ***              "
		print "                                           "
		}'

	}
		
	判断日期是否合法{

		#!/bin/sh
		while read a
		do
		  if echo $a | grep -q "-" && date -d $a +%Y%m%d > /dev/null 2>&1
		  then
			if echo $a | grep -e '^[0-9]\{4\}-[01][0-9]-[0-3][0-9]$'
			then 
				break
			else
				echo "您输入的日期不合法，请从新输入！"
			fi
		  else
			echo "您输入的日期不合法，请从新输入！"
		  fi
		done
		echo "日期为$a"

	}
		
	打印日期段所有日期{

		#!/bin/bash
		qsrq=20010101
		jsrq=20010227
		n=0
		>tmp
		while :;do
		current=$(date +%Y%m%d -d"$n day $qsrq")
		if [[ $current == $jsrq ]];then
			echo $current >>tmp;break
		else
			echo $current >>tmp
			((n++))
		fi
		done
		rq=`awk 'NR==1{print}' tmp`

	}
		
	打印提示{

		cat <<EOF
		#内容
EOF

		}

	登陆远程执行命令{

		# 特殊符号需要 \ 转义
		ssh root@ip << EOF
		#执行命令
EOF

		}

	数学计算的小算法{

		#!/bin/sh
		A=1
		B=1
		while [ $A -le 10 ]
		do
			SUM=`expr $A \* $B`
			echo "$SUM"
			if [ $A = 10 ]
			then
				B=`expr $B + 1`
				A=1
			fi
			A=`expr $A + 1`
		done

	}

	横竖转换{

		cat a.txt | xargs           # 列转行
		cat a.txt | xargs -n1       # 行转列
		
		sed '{N;s/\n//}' file                   # 将两行合并一行(去掉换行符)
		awk '{printf(NR%2!=0)?$0" ":$0" \n"}'   # 将两行合并一行
		awk '{printf"%s ",$0}'                  # 将所有行合并
		awk '{if (NR%4==0){print $0} else {printf"%s ",$0}}' file    # 将4行合并为一行(可扩展)
		
		竖行转横行{

			cat file|tr '\n' ' '
			echo $(cat file)
			
			#!/bin/sh
			for i in `cat file`
			do
				  a=${a}" "${i}
			done
			echo $a

		}

	}

	取用户的根目录{

		#! /bin/bash 
		while read name pass uid gid gecos home shell 
		do 
			echo $home 
		done < /etc/passwd
	
	}

	把汉字转成encode格式{

		echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n"
		%c2%db%cc%b3
		echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n" | tr "[a-f]" "[A-F]"  # 大写的
		%C2%DB%CC%B3

	}

	把目录带有大写字母的文件名改为全部小写{

		#!/bin/bash
		for f in *;do
			mv $f `echo $f |tr "[A-Z]" "[a-z]"`
		done

	}

	查找连续多行，在不连续的行前插入{

		#/bin/bash
		lastrow=null
		i=0
		cat incl|while read line
		do
		i=`expr $i + 1`
		if echo "$lastrow" | grep "#include <[A-Z].h>"  
		then
			if echo "$line" | grep -v  "#include <[A-Z].h>" 
			then
				sed -i ''$i'i\\/\/All header files are include' incl
				i=`expr $i + 1`
			fi
		fi
		lastrow="$line"
		done

	}

	查询数据库其它引擎{

		#/bin/bash
		path1=/data/mysql/data/
		dbpasswd=db123
		#MyISAM或InnoDB
		engine=InnoDB

		if [ -d $path1 ];then

		dir=`ls -p $path1 |awk '/\/$/'|awk -F'/' '{print $1}'`
			for db in $dir
			do
			number=`mysql -uroot -p$dbpasswd -A -S "$path1"mysql.sock -e "use ${db};show table status;" |grep -c $engine`
				if [ $number -ne 0 ];then
				echo "${db}"
				fi
			done
		fi

	}

	批量修改数据库引擎{
	
		#/bin/bash
		for db in test test1 test3
		do
			tables=`mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;show tables;" |awk 'NR != 1{print}'`

			for table in $tables
			do
				mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;alter table $table engine=MyISAM;"
			done
		done
		
	}

	将shell取到的数据插入mysql数据库{
	
		mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
		use $dbname;
		insert into data values ('','$ip','$date','$time','$data')
		"

	}

	两日期间隔天数{
	
		D1=`date -d '20070409' +"%s"`
		D2=`date -d '20070304 ' +"%s"`
		D3=$(($D1 - $D2))
		echo $(($D3/60/60/24)) 
		
	}

	while执行ssh只循环一次{
		
		cat -    # 让cat读连接文件stdin的信息
		seq 10 | while read line; do ssh localhost "cat -"; done        # 显示的9次是被ssh吃掉的
		seq 10 | while read line; do ssh -n localhost "cat -"; done     # ssh加上-n参数可避免只循环一次
		
	}

	ssh批量执行命令{

		#版本1
		#!/bin/bash
		while read line
		do 
		Ip=`echo $line|awk '{print $1}'`
		Passwd=`echo $line|awk '{print $2}'`
		ssh -n localhost "cat -"
		sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"  
		done<iplist.txt

		#版本2
		#!/bin/bash
		Iplist=`awk '{print $1}' iplist.txt`
		for Ip in $Iplist
		do
		Passwd=`awk '/'$Ip'/{print $2}' iplist.txt`
		sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id" 
		done

	}

	在同一位置打印字符{

		#!/bin/bash
		echo -ne "\t"
		for i in `seq -w 100 -1 1`
		do
			echo -ne "$i\b\b\b";      # 关键\b退格
			sleep 1;
		done

	}

	多进程后台并发控制{

		#!/bin/bash
		test () {
			echo $a
			sleep 5
		}
		for a in `seq 1 30`
		do
			test &
			echo $!
			((num++))
			if [ $num -eq 6 ];then
			echo "wait..."
			wait
			num=0
			fi
		done
		wait

	}

	shell并发{

		#!/bin/bash
		tmpfile=$$.fifo   # 创建管道名称
		mkfifo $tmpfile   # 创建管道
		exec 4<>$tmpfile  # 创建文件标示4，以读写方式操作管道$tmpfile
		rm $tmpfile       # 将创建的管道文件清除
		thred=4           # 指定并发个数
		seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35) # 创建任务列表

		# 为并发线程创建相应个数的占位
		{
		for (( i = 1;i<=${thred};i++ ))
		do
			echo;  # 因为read命令一次读取一行，一个echo默认输出一个换行符，所以为每个线程输出一个占位换行
		done
		} >&4      # 将占位信息写入管道

		for id in ${seq}  # 从任务列表 seq 中按次序获取每一个任务
		do
		  read  # 读取一行，即fd4中的一个占位符
		  (./ur_command ${id};echo >&4 ) &   # 在后台执行任务ur_command 并将任务 ${id} 赋给当前任务；任务执行完后在fd4种写入一个占位符
		done <&4    # 指定fd4为整个for的标准输入
		wait        # 等待所有在此shell脚本中启动的后台任务完成
		exec 4>&-   # 关闭管道

	}

	shell并发函数{
		function ConCurrentCmd()
		{
			#进程数
			Thread=30

			#列表文件
			CurFileName=iplist.txt

			#定义fifo文件
			FifoFile="$$.fifo"

			#新建一个fifo类型的文件
			mkfifo $FifoFile

			#将fd6与此fifo类型文件以读写的方式连接起来
			exec 6<>$FifoFile      
			rm $FifoFile

			#事实上就是在文件描述符6中放置了$Thread个回车符
			for ((i=0;i<=$Thread;i++));do echo;done >&6

			#此后标准输入将来自fd5
			exec 5<$CurFileName

			#开始循环读取文件列表中的行
			Count=0
			while read -u5 line
			do
				read -u6
				let Count+=1
				# 此处定义一个子进程放到后台执行
				# 一个read -u6命令执行一次,就从fd6中减去一个回车符，然后向下执行
				# fd6中没有回车符的时候,就停在这了,从而实现了进程数量控制
				{		
					echo $Count
					
					#这段代码框就是执行具体的操作了
					function

					echo >&6 
					#当进程结束以后,再向fd6中追加一个回车符,即补上了read -u6减去的那个
				} &
			done

			#等待所有后台子进程结束
			wait  

			#关闭df6
			exec 6>&-

			#关闭df5
			exec 5>&-
		}
	}

	函数{

		ip(){
			echo "a 1"|awk '$1=="'"$1"'"{print $2}'
		}
		web=a
		ip $web

	}

	检测软件包是否存在{

		rpm -q dialog >/dev/null
		if [ "$?" -ge 1 ];then
			echo "install dialog,Please wait..."
			yum -y install dialog
			rpm -q dialog >/dev/null
			[ $? -ge 1 ] && echo "dialog installation failure,exit" && exit
			echo "dialog done"
			read
		fi

	}

	游戏维护菜单-修改配置文件{
	
		#!/bin/bash

		conf=serverlist.xml
		AreaList=`awk -F '"' '/<s/{print $2}' $conf`

		select area in $AreaList 全部 退出
		do
			echo ""
			echo $area
			case $area in
			退出)
				exit
			;;
			*)
				select operate in "修改版本号" "添加维护中" "删除维护中" "返回菜单"
				do
					echo ""
					echo $operate
					case $operate in
					修改版本号)
						echo 请输入版本号
						while read version
						do
							if echo $version | grep -w 10[12][0-9][0-9][0-9][0-9][0-9][0-9] 
							then
								break
							fi
							echo 请从新输入正确的版本号
						done
						case $area in
						全部)
							case $version in
							101*)
								echo "请确认操作对 $area 体验区 $operate"
								read
								sed -i 's/101[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf 
							;;
							102*)
								echo "请确认操作对 $area 正式区 $operate"
								read
								sed -i 's/102[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf 
							;;
							esac
						;;
						*)
							type=`awk -F '"' '/'$area'/{print $14}' $conf |cut -c1-3`
							readtype=`echo $version |cut -c1-3`
							if [ $type != $readtype ]
							then
								echo "版本号不对应，请从新操作"
								continue
							fi
						
							echo "请确认操作对 $area 区 $operate"
							read

							awk -F '"' '/'$area'/{print $12}' $conf |xargs -i sed -i '/'{}'/s/10[12][0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
						;;
						esac
					;;
					添加维护中)
						case $area in
						全部)
							echo "请确认操作对 $area 区 $operate"
							read
							awk -F '"' '/<s/{print $2}' $conf |xargs -i sed -i 's/'{}'/&维护中/' $conf
						;;
						*)
							echo "请确认操作对 $area 区 $operate"
							read
							sed -i 's/'$area'/&维护中/' $conf
						;;
						esac
					;;
					删除维护中)
						case $area in
						全部)
							echo "请确认操作对 $area 区 $operate"
							read
							sed -i 's/维护中//' $conf
						;;
						*)
							echo "请确认操作对 $area 区 $operate"
							read
							sed -i '/'$area'/s/维护中//' $conf
						;;
						esac
					;;
					返回菜单)
						break
					;;
					esac
				done
			;;
			esac
			echo "回车重新选择区"
		done

	}

	keepalive剔除后端服务{

		#!/bin/bash
		#行数请自定义,默认8行
		if [ X$2 == X ];then
			echo "error: IP null"
			read
			exit
		fi
		case $1 in
		del)
			sed -i '/real_server.*'$2'.*8888/,+8 s/^/#/' /etc/keepalived/keepalived.conf
			/etc/init.d/keepalived reload
		;;
		add)
			sed -i '/real_server.*'$2'.*8888/,+8 s/^#//' /etc/keepalived/keepalived.conf
			/etc/init.d/keepalived reload
		;;
		*)
			echo "Parameter error"
		;;
		esac
		
	}

	申诉中国反垃圾邮件联盟黑名单{

		#!/bin/bash

		IpList=`awk '$1!~"^#"&&$1!=""{print $1}' host.list`

		QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
		ComplaintAdd='http://www.anti-spam.org.cn/Rbl/Getout/Submit'

		CONTENT='我们是一家正规的XXX。xxxxxxx。恳请将我们的发送服务器IP移出黑名单。谢谢！
		处理措施：
		1.XXXX。
		2.XXXX。'
		CORP='abc.com'
		WWW='www.abc.cm'
		NAME='def'
		MAIL='def@163.com.cn'
		TEL='010-50000000'
		LEVEL='0'

		for Ip in $IpList
		do
			Status=`curl -d "IP=$Ip" $QueryAdd |grep 'Getout/ShowForm?IP=' |grep -wc '申诉脱离'`
			if [ $Status -ge 1 ];then
				IpStatus="黑名单中"
				results=`curl -d "IP=${Ip}&CONTENT=${CONTENT}&CORP=${CORP}&WWW=${WWW}&NAME=${NAME}&MAIL=${MAIL}&TEL=${TEL}&LEVEL=${LEVEL}" $ComplaintAdd |grep -E '您的黑名单脱离申请已提交|该IP的脱离申请已被他人提交|申请由于近期内有被拒绝的记录'`
				echo $results
				if echo $results | grep '您的黑名单脱离申请已提交'  > /dev/null 2>&1
				then
					complaint='申诉成功'
				elif echo $results | grep '该IP的脱离申请已被他人提交'  > /dev/null 2>&1
				then
					complaint='申诉重复'
				elif echo $results | grep '申请由于近期内有被拒绝的记录'  > /dev/null 2>&1
				then
					complaint='申诉拒绝'
				else
					complaint='异常'
				fi
			else
				IpStatus='正常'
				complaint='无需申诉'
			fi
			echo "$Ip    $IpStatus    $complaint" >> $(date +%Y%m%d_%H%M%S).log
		done

}

	Web Server in Awk{
	
		#gawk -f file
		BEGIN { 
		  x        = 1                         # script exits if x < 1 
		  port     = 8080                      # port number 
		  host     = "/inet/tcp/" port "/0/0"  # host string 
		  url      = "http://localhost:" port  # server url 
		  status   = 200                       # 200 == OK 
		  reason   = "OK"                      # server response 
		  RS = ORS = "\r\n"                    # header line terminators 
		  doc      = Setup()                   # html document 
		  len      = length(doc) + length(ORS) # length of document 
		  while (x) { 
			 if ($1 == "GET") RunApp(substr($2, 2)) 
			 if (! x) break   
			 print "HTTP/1.0", status, reason |& host 
			 print "Connection: Close"        |& host 
			 print "Pragma: no-cache"         |& host 
			 print "Content-length:", len     |& host 
			 print ORS doc                    |& host 
			 close(host)     # close client connection 
			 host |& getline # wait for new client request 
		  } 
		  # server terminated... 
		  doc = Bye() 
		  len = length(doc) + length(ORS) 
		  print "HTTP/1.0", status, reason |& host 
		  print "Connection: Close"        |& host 
		  print "Pragma: no-cache"         |& host 
		  print "Content-length:", len     |& host 
		  print ORS doc                    |& host 
		  close(host) 
		} 

		function Setup() { 
		  tmp = "<html>\
		  <head><title>Simple gawk server</title></head>\
		  <body>\
		  <p><a href=" url "/xterm>xterm</a>\
		  <p><a href=" url "/xcalc>xcalc</a>\
		  <p><a href=" url "/xload>xload</a>\
		  <p><a href=" url "/exit>terminate script</a>\
		  </body>\
		  </html>" 
		  return tmp 
		} 

		function Bye() { 
		  tmp = "<html>\
		  <head><title>Simple gawk server</title></head>\
		  <body><p>Script Terminated...</body>\
		  </html>" 
		  return tmp 
		} 

		function RunApp(app) { 
		  if (app == "xterm")  {system("xterm&"); return} 
		  if (app == "xcalc" ) {system("xcalc&"); return} 
		  if (app == "xload" ) {system("xload&"); return} 
		  if (app == "exit")   {x = 0} 
		}

	}

}



不定期更新，更新下载地址：
http://hi.baidu.com/quanzhou722/item/f4a4f3c9eb37f02d46d5c0d9

请勿删除信息，植入广告，抵制不道德行为。




