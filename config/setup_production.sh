#!/usr/bin/env bash

# 换成 root 用户运行
sudo su
# 装依赖
apt-get update
apt-get install -y supervisor git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
apt-get install -y python3-pip nginx mongodb ufw redis-server
pip3 install -U pip setuptools wheel
pip3 install flask pymongo gunicorn redis

# ufw
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8388     # shadowsocks
ufw default deny incoming
ufw default allow outgoing
ufw status verbose
ufw enable

# 删掉 nginx default 设置
rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/*

# 建立软连接，supervisor 配置文件
ln -s -f /root/Forum/config/forum.conf /etc/supervisor/conf.d/forum.conf
# nginx 配置文件, 不在 sites-available 里面放任何东西
ln -s -f /root/Forum/config/forum.nginx /etc/nginx/sites-enabled/forum

# nginx 对静态文件权限
chmod o+rx /root
chmod -R o+rx /root/Forum

# 重启服务器
service supervisor restart
service nginx restart

echo 'setup_production success'
