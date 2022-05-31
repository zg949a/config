#!/bin/bash
#AUTHOR GuoZhong-Zhang  github: zg949a

#sudo apt-get install git

touch sources.list

echo "deb http://mirrors.163.com/debian sid main contrib non-free
deb http://ftp2.cn.debian.org/debian sid main contrib non-free
deb http://mirrors.ustc.edu.cn/debian sid main contrib non-free" >> sources.list

sudo mv sources.list /etc/apt/
cd 
sudo apt update
sudo apt upgrade
#sudo apt install sudo
sudo apt install firmware-iwlwifi
sudo apt install network-manager
#sudo apt install git



#sudo apt install python3-pip
#cd
#mkdir Install
#cd Install/
#sudo python3 -m pip install --upgarde pip
#sudo pip3 install requests
#sudo pip3 install bypy
#bypy info
#sync netdisk
#bypy download
