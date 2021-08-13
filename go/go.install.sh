cd /opt/
##wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
##wget  https://dl.google.com/go/go1.12.12.linux-amd64.tar.gz
##
##wget https://studygolang.com/dl/golang/go1.13.3.linux-amd64.tar.gz
wget https://studygolang.com/dl/golang/go1.12.12.linux-amd64.tar.gz
tar zxvf go1.12.12.linux-amd64.tar.gz
mkdir -p /opt/gopath/bin
mkdir -p /opt/gopath/src
cat >>/etc/profile<<EOF
export GOROOT=/opt/go
export GOPATH=/opt/gopath
export PATH=\$PATH:/opt/gopath/bin:/opt/go/bin
EOF
source  /etc/profile
go version

