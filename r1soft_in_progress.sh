if [ -f /etc/yum.repos.d/r1soft.repo ]
then
echo -e "\e[94mRepo file already available\e[92m\n"
else
echo -e "\e[94mCreating R1soft Repo\e[92m\n"
echo -e "[r1soft]\nname=R1Soft Repository Server\nbaseurl=http://repo.r1soft.com/yum/stable/\$basearch/\nenabled=1\ngpgcheck=0" >>/etc/yum.repos.d/r1soft.repo
fi
####Installing cdp agent####
if [ $(rpm -qa | grep serverbackup | wc -l) -gt 0 ]
then
	echo "Some r1soft packages are already installed"
	read -p "Please confirm to remove already installed packages of r1soft.  Y/N:" c
	if [ "$c" == "Y" ] || [ $c == "y" ]
	then
		echo -e "\e[92mUninstalling old r1soft packages..\e[m\n"
		rpm -e $(rpm -qa | grep serverbackup)
		echo -e "\e[92mInstalling CDP-agent_ _\e[m\n"
		yum -y install r1soft-cdp-enterprise-agent > log 2>err
	fi
else
echo -e "\e[92mInstalling CDP-agent_ _\e[m\n"
yum -y install r1soft-cdp-enterprise-agent > log 2>err
fi
if [ $(rpm -qa | grep Kernel-devel-$(uname -r) | wc -l) -gt 0 ]
then
	echo "Kernel-devel-$(uname -r)  found already installed on server."
else
	echo -e "\e[92mTrying to installing Kernel devel_ _\e[m\n"
	yum -y install kernel-devel-$(uname -r) > log 2>err
	if [ $(rpm -qa | grep Kernel-devel-$(uname -r) | wc -l) -gt 0 ]
	then
		echo "Kernel-devel-$(uname -r)  found installed successfully."
	else
		echo -e "Error while installing Kernel-devel-$(uname -r) \nplease install kernel devel manually ."
	fi
fi
