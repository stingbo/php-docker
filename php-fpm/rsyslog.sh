#!/usr/bin/env bash

#Open file: /etc/apt/sources.list.d/adiscon-ubuntu-v8-devel-xenial.list
#Edit first line to: deb http://ppa.launchpad.net/adiscon/v8-devel/ubuntu xenial main/debug
#sudo apt-get update
#sudo apt-get install rsyslog
# crontab 需要配置rsyslog使用

# 开启服务
sed -i "s/#cron/cron/g" /etc/rsyslog.conf
