
yum install -y  gcc zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

yum install -y  libffi-devel

cd /opt/
##wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
tar -xvJf  Python-3.7.0.tar.xz

mkdir -p /usr/local/python3
cd Python-3.7.4
./configure --prefix=/usr/local/python3
make && make install

ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3

python3 -V
pip3 -V
