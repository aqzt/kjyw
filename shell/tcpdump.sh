


tcpdump -i em2  port 19000
tcpdump -i eth0 -nn port 21

tcpdump -vv -nn -i em2  tcp  port 19000 and host 192.168.1.131

 tcpdump -vv -nn -i em2  tcp port 19000

tcpdump -vv -nn -i em2  tcp  port 19000 -p

tcpdump -i em2 -s 0 -c 100000 -w 0809.cap

tcpdump -i em2 -s 0 -c 10000 -w 1.cap
tcpdump -i em2 -s 0 -c 10000 -w 0808.cap

ss -an | grep 19000|grep -i es | awk '{ print $6 }' | awk -F: '{ print $1}' | sort | uniq -c | sort -nr | head -n 30

echo ok
