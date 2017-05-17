目的：查看一个文件夹中有多少个文件
====================================================
read -p "请输入要查询的文件夹的绝对路径: " pa
cd ${pa}
number=`ls | wc -l`        
echo "这个文件夹里有 $number 个文件"
====================================================


目的：批量创建用户
====================================================
read -p "请输入需要创建的用户个数： " n
for i in `seq 1 $n`
do
	useradd user$i
echo "123456$i"|passwd --stdin user$i
done
===================================================


目的：查看系统中有多少个普通用户
tips：c6 普通用户uid从500开始，c7从1000开始
====================================================
cp /etc/passwd /tmp/
touch /tmp/uin.txt
cat /etc/passwd | awk -F: '$3>=1000'| cut -f 1 -d : > /tmp/uin.txt
m=`awk 'END{ print NR   }' uin.txt`
echo "这个系统中有$m 个普通用户"
echo "普通用户的用户名已输出到/tmp/uin.txt"
==================================================

目的：vmware克隆虚拟机时存在缺陷导致网卡起不来，这个脚本就是用来
起克隆机的网卡
================================================================
#!/bin/bash
#this is B network script
cd /etc/udev/rules.d/
sed -i '8d' 70-persistent-net.rules
sed -i 's/eth1/eth0/' 70-persistent-net.rules
cat 70-persistent-net.rules | grep address | awk -F, '{print $4}' | awk -F\" '{print $2}' > /tmp/xx
cat /tmp/xx | tr 'a-z' 'A-Z' > /tmp/qq
md=$(cat /tmp/qq)
cd /etc/sysconfig/network-scripts/
sed -i '4d' ifcfg-eth0
sed -i '/HWADDR/c\HWADDR='"$md"'' ifcfg-eth0    /其中变量要使用'"(变量)"'才能有效
sed -i '/ONBOOT/c\ONBOOT=yes' ifcfg-eth0
sed -i '/NM_CONTROLLED/c\NM_CONTROLLED=no' ifcfg-eth0
sed -i '/BOOTPROTO/c\BOOTPROTO=static' ifcfg-eth0
read -p "please input ipaddr : " ipa
echo "ipaddr is : $ipa"
read -p "please input netmask : " net
echo "netmask is : $net"
read -p "please input gateway : " gat
echo "gateway is : $gat"
sed -i '/BOOTPROTO/a\IPADDR\='"$ipa"'' ifcfg-eth0
sed -i '/IPADDR/a\NETMASK\='"$net"'' ifcfg-eth0
sed -i '/NETMASK/a\GATEWAY\='"$gat"'' ifcfg-eth0
service network restart
=============================================================================================
