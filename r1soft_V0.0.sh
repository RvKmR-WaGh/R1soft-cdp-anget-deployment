#!/bin/bash
#######################################
#Author:  Ravikuamr Wagh
#######################################
url="null"
pro="http://"
port="1167"
find_distro()
{
if [ -f /etc/redhat-release ]; then
	optsys=$(cat /etc/redhat-release)
	if [ `cat /etc/redhat-release |grep -i 'Fedora' |wc -l` -gt 0 ] ;then
		OS='Centos';
	elif [ `cat /etc/redhat-release |grep -Ei 'Centos' |wc -l` -gt 0 ] ;then
		OS='Centos';
	elif [ `cat /etc/redhat-release |grep -Ei 'CloudLinux' |wc -l` -gt 0 ] ;then
		OS='Centos';
	else
		OS="None"
	fi
elif [ -f '/etc/issue' ]; then
	if [ `cat /etc/issue |grep -i 'Ubuntu' |wc -l` -gt 0 ] ;then
		OS='Ubuntu';
		optsys=$(cat /etc/issue | awk '{print $1,$2}')
	elif [ `cat /etc/issue |grep -i 'Linux Mint' |wc -l` -gt 0 ] ;then
		OS='Ubuntu';
		optsys=$(cat /etc/issue | awk '{print $1,$2,$3}')
	elif [ `cat /etc/issue |grep -i 'Debian' |wc -l` -gt 0 ] ;then
		optsys=$(cat /etc/issue | awk '{print $1,$2}')
	elif [ `cat /etc/issue |grep -Ei 'Centos' |wc -l` -gt 0 ] ;then
		OS='Centos';
		optsys=$(cat /etc/redhat-release)
	else 
		OS="None"
	fi
elif [ -f '/etc/debian_version' ]; then
	if [ `cat /etc/debian_version |grep -i 'Ubuntu' |wc -l` -gt 0 ] ;then
		OS='Ubuntu';
		optsys=$(cat /etc/debian_version)
	elif [ `cat /etc/debian_version |grep -i 'Debian' |wc -l` -gt 0 ] ;then
		OS='Debian';
		optsys=$(cat /etc/issue)
	else
		OS="None"
	fi
else
os="none"
fi

echo -e "\n..........................................."
echo -e "\n..........................................." > log 2>err
echo -e "\e[94m\nOperating system found : \e[m$optsys" 
echo -e "\e[94m\nOperating system found : \e[m$optsys" > log 2>err 
echo -e "\e[94mKernel release : \e[m$(uname -r)"
echo -e "\e[94mKernel release : \e[m$(uname -r)" > log 2>err
}

rpm_based(){
echo -e "\e[94mCreating R1soft Repo\e[92m\n"
echo -e "[r1soft]\nname=R1Soft Repository Server\nbaseurl=http://repo.r1soft.com/yum/stable/\$basearch/\nenabled=1\ngpgcheck=0" >>/etc/yum.repos.d/r1soft.repo
echo -e "\e[92mInstalling CDP-agent_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling CDP-agent_ _\e[m\n"
yum -y install r1soft-cdp-enterprise-agent > log 2>err
echo -e "\e[92mInstalling Kernel devel_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling Kernel devel_ _\e[m\n"
yum -y install kernel-devel-$(uname -r) > log 2>err
echo -e "\e[92mInstalling HCP drivers_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling HCP drivers_ _\e[m\n"
r1soft-setup --get-module > log 2>err
echo -e "\e[92mRestarting cdp-agent_ _\e[m\n" > log 2>err
echo -e "\e[92mRestarting cdp-agent_ _\e[m\n"
/etc/init.d/cdp-agent restart > log 2>err
if [ -f /usr/sbin/csf  ] ;then
echo -e "\e[92mcsf firewall found\e[m\n" > log 2>err
echo -e "\e[92mcsf firewall found\e[m\n"
echo "tcp/udp|in/out|d=$port|s=$url" >> /etc/csf/csf.allow
echo -e "\e[92mFirewall rules added_ _\e[m\n" > log 2>err
echo -e "\e[92mFirewall rules added_ _\e[m\n"
echo -e "\e[92mRestarting CSF_ _\e[m\n" > log 2>err
echo -e "\e[92mRestarting CSF_ _\e[m\n"
csf -r > log 2>err
fi
}
debian_based(){
echo -e "\e[94mAdding R1soft repo to sources list\e[92m\n" > log 2>err
echo -e "\e[94mAdding R1soft repo to sources list\e[92m\n" 
echo  "deb http://repo.r1soft.com/apt stable main" >>/etc/apt/sources.list
wget http://repo.r1soft.com/r1soft.asc > log 2>err
apt-key add r1soft.asc > log 2>err
echo -e "\e[92mUpdating system_ _\e[m\n" > log 2>err
echo -e "\e[92mUpdating system_ _\e[m\n"
apt-get -y update > log 2>err
echo -e "\e[92mInstalling CDP-agent_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling CDP-agent_ _\e[m\n"
apt-get -y install r1soft-cdp-enterprise-agent > log 2>err
echo -e "\e[92mInstalling Kernel devel_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling Kernel devel_ _\e[m\n"
apt-get -y install kernel-devel > log 2>err
echo -e "\e[92mInstalling HCP drivers_ _\e[m\n" > log 2>err
echo -e "\e[92mInstalling HCP drivers_ _\e[m\n"
r1soft-setup --get-module > log 2>err
echo -e "\e[92mRestarting cdp-agent_ _\e[m\n" > log 2>err
echo -e "\e[92mRestarting cdp-agent_ _\e[m\n"
/etc/init.d/cdp-agent restart > log 2>err
}
######MAIN FUNCTION#########

echo -e "\n\e[100mWelcome to r1soft cdp-agent deployment script\e[m"
read -p "Enter backup server IP or host name :" url
key=$pro$url
find_distro
fs=$(fsck -N /dev/sda | awk FNR==2{'print $5'}) #DO NOT EDIT THIS, MAY CAUSE ISSUE WITh YOUR SERVER FILESYTESM.
echo -e "\e[94mFile system found : \e[m$fs" > log 2>err 
echo -e "\e[94mFile system found : \e[m$fs"
echo -e "...........................................\n"
echo -e "...........................................\n" > log 2>err
echo -n -e "Do you wish to continue with this file system: \e[100m(y/n)\e[m:"
read c
echo $OS
cent='Centos'
deb='Ubuntu'
if [ $c == "y" ];
then
	if [ "$OS" = "$deb" ]
                then
               debian_based
         #       echo "Comming soon"
		r1soft-setup --get-key $key
	elif [ "$OS" = "$cent" ]
	        then
	#        echo "calling rpm based"
		rpm_based
		r1soft-setup --get-key $key
	else
	        echo "Unknown os please try manual installation"
	fi
echo -e "\n\e[100mThanks for using r1soft cdp-agent deployment script\e[m"
elif [ $c == "n" ];
	then
        echo -e "\n\e[100mThanks for using r1soft cdp-agent deployment script\e[m"
fi
