[[ -f /usr/bin/git ]] || { echo 'install git';yum install -y git &>/dev/null; }
git clone https://github.com/anbai-inc/Kibana_Hanization.git
cd Kibana_Hanization
python main.py /usr/share/kibana

#重启kibana
systemctl restart kibana
