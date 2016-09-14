#!/bin/bash
#Author:wing
#
#
#服务器CentOS PPTP一键部署
#

#检查用户
if [ `id -u` -ne 0 ];then
	echo "对比起！您必须以root运行此脚本！"
	exit 2
fi

#检查是否安装PPTP
if [ -z `rpm -qa | grep pptpd` ];then
	echo "检测到系统未安装PPTP，正在安装中..."
	yum install pptpd ppp -y > /dev/null 2>&1
	echo "PPTP已安装成功，正在配置中"
else
	echo "检测到系统已安装PPTP，正在配置中..."
fi

#配置PPTP

#检查PPTP版本
pptpd_version=`pptpd -v | grep pptpd | awk -F 'v' '{print $2}'`
echo ${pptpd_version}

cat /usr/share/doc/pptpd-${pptpd_version}/samples/pptpd.conf > /etc/pptpd.conf
sed -i "\$alocalip 192.168.66.1" /etc/pptpd.conf
sed -i "\$aremoteip 192.168.66.2-100" /etc/pptpd.conf

cat /usr/share/doc/pptpd-${pptpd_version}/samples/options.pptpd > /etc/ppp/options.pptpd
sed -i "\$ams-dns 223.5.5.5" /etc/ppp/options.pptpd
sed -i "\$ams-dns 223.6.6.6" /etc/ppp/options.pptpd
sed -i "\$ams-wins 223.5.5.5" /etc/ppp/options.pptpd
sed -i "\$ams-wins 223.6.6.6" /etc/ppp/options.pptpd

read -p "请输入用户名：" username
read -p "请输入密码：" password

echo > /etc/ppp/chap-secrets
sed -i "\$a${username} pptpd ${password} *" /etc/ppp/chap-secrets
