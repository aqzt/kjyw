yum install epel-release -y
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum install python36  python36u-pip  -y
python3.6  -m  pip install --upgrade pip

mkdir -p  /root/.pip/

cat >  /root/.pip/pip.conf   <<EOF
[global]
trusted-host=mirrors.aliyun.com
index-url=http://mirrors.aliyun.com/pypi/simple/
EOF

python -V
