#!/bin/bash
# 在centos7.4上部署pptp server
# jason
# 2018 11 29
# v1.0



# 安装配置pptp
if [ $# -eq 2 ];then
    # 添加epel源
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    
    # 安装pptpd
    yum -y install pptpd

    # 配置/etc/pptpd.conf
    echo -e "localip $1\nremoteip $2" >>/etc/pptpd.conf
    
    # 配置ip转发
    echo "net.ipv4.ip_forward=1" >>/etc/sysctl.conf
    sysctl -p

    # 配置日志信息
    sed -i '$iecho "$PEERNAME 分配ip: $6 登录ip: $6 登录时间: `date -d today +%F+%T`" >>/var/log/pptpd.log' /etc/ppp/ip-up
    sed -i '$iecho "$PEERNAME 下线ip: $6 下线时间: `date -d today +%F+%T`" >>/var/log/pptpd.log' /etc/ppp/ip-down

    # 启动pptp
    systemctl enable pptpd
    systemctl start pptpd
    
    # 提示pptp用户添加方法
    echo "pptp server已经部署成功，需编辑/etc/ppp/chap-secrets添加用户及密码"

else echo -e "脚本使用方法:\nsh auto_pptp_server.sh localip remoteip\n\nlocalip指pptp_server被拨入网卡的ip 写法:10.0.0.62\n\nremoteip指给pptp客户端分配的ip段 写法:172.16.1.100-110"
fi