cd /opt/
##wget https://nodejs.org/dist/v16.18.0/node-v16.18.0-linux-x64.tar.gz
##wget  https://nodejs.org/dist/v16.18.0/node-v16.18.0-linux-x64.tar.xz

wget https://nodejs.org/dist/v16.18.0/node-v16.18.0-linux-x64.tar.gz
tar zxvf node-v16.18.0-linux-x64.tar.gz
mv node-v16.18.0-linux-x64  v16 
mkdir -p /opt/node/
mv v16 /opt/node/
cat >>/etc/profile<<EOF
export NODE_HOME=/opt/node/v16
export NODE_HOME1=/opt/node/v16/bin
export PATH=\$PATH:$NODE_HOME/bin:$NODE_HOME1
EOF
source  /etc/profile
node -v
