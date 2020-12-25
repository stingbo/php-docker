#!/bin/bash
#coding=utf-8
#作用: 本脚本旨在在容器启动后把配置文件和需要启动程序进行配置和创建

#create path for log
mkdir -p /var/log/project
chmod -R 777 /var/log/project

#开启cron日志
sh /root/rsyslog.sh
#设置具体的定时任务
sh /root/crontab.sh start
#重启rsyslog
service rsyslog restart >/dev/null 2>&1
#重启cron
service cron restart >/dev/null 2>&1

#start php-fpm
/usr/bin/supervisord
