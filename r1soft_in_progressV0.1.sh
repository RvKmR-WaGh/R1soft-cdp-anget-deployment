rpm_based(){
####Creaing repo On RPM type servers####
if [ -f /etc/yum.repos.d/r1soft.repo ]
then
echo -e "\e[94mRepo file already available\e[92m\n"
else
echo -e "\e[94mCreating R1soft Repo\e[92m\n"
echo -e "[r1soft]\nname=R1Soft Repository Server\nbaseurl=http://repo.r1soft.com/yum/stable/\$basearch/\nenabled=1\ngpgcheck=0" >>/etc/yum.repos.d/r1soft.repo
fi
####Installing cdp agent On RPM type servers####
if [ $(rpm -qa | grep serverbackup | wc -l) -gt 0 ]
then
	echo -e "\e[92mSome r1soft packages are already installed\e[m"
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
	echo "\e[94mKernel-devel-$(uname -r)  found already installed on server.\e[m"
else
	echo -e "\e[92mTrying to installing Kernel devel_ _\e[m\n"
	yum -y install kernel-devel-$(uname -r) > log 2>err
	if [ $(rpm -qa | grep Kernel-devel-$(uname -r) | wc -l) -gt 0 ]
	then
		echo "\e[94mKernel-devel-$(uname -r)  found installed successfully.\e[m"
	else
		echo -e "\e[91mError while installing Kernel-devel-$(uname -r) \nplease install kernel devel manually .\e[m"
	fi
fi
}
####Creaing repo On DEB type servers####
debian_based(){
echo -e "\e[94mAdding R1soft repo to sources list\e[92m\n" 
if [ $(grep "repo.r1soft.com" /etc/apt/sources.list | wc -l) -eq 1 ]; 
then 
	echo -e "\e[94mRepo file already available\e[92m\n"
else 
	echo  "deb http://repo.r1soft.com/apt stable main" >>/etc/apt/sources.listfi
	wget http://repo.r1soft.com/r1soft.asc > log 2>err
	apt-key add r1soft.asc > log 2>err
fi
echo -e "\e[94mUpdating system_ _\e[m\n"
apt-get -y update > log 2>err

####Installing cdp agent On DEB type servers####
echo -e "\e[94mInstalling CDP-agent_ _\e[m\n"
if [ $(dpkg -l | grep serverbackup | wc -l) -gt 0 ]
then
	echo -e "\e[92mSome r1soft packages are already installed\e[m"
	read -p "Please confirm to remove already installed packages of r1soft and install new updates.  Y/N:" c
	if [ "$c" == "Y" ] || [ $c == "y" ]
	then
		echo -e "\e[92mUninstalling old r1soft packages..\e[m\n"
		apt-get -y remove serverbackup*
		echo -e "\e[92mInstalling r1soft packages..\e[m\n"
		#apt-get -y install r1soft-cdp-enterprise-agent > log 2>err
	else
		echo "installing cdp agetn"
		#apt-get -y install r1soft-cdp-enterprise-agent > log 2>err
	fi
else
	echo -e "\e[92mInstalling CDP-agent_ _\e[m\n"
	#apt-get -y install r1soft-cdp-enterprise-agent > log 2>err

if [ $(dpkg -l | grep serverbackup | wc -l) -gt 0 ]
then
	echo -e "\e[92mKernel devel found alrady installed_ _\e[m\n"
else
	echo -e "\e[92mInstalling Kernel devel_ _\e[m\n"
	apt-get -y install kernel-devel > log 2>err
echo -e "\e[92mInstalling HCP drivers_ _\e[m\n"
#r1soft-setup --get-module > log 2>err
echo -e "\e[92mRestarting cdp-agent_ _\e[m\n"
#/etc/init.d/cdp-agent restart > log 2>err
}
