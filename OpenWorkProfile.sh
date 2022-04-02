pkgs=("")
pkg_num=0
INIT_USER_SIZE=1024
pathdir="/data/adb/service.d"
autobootfile="$pathdir/owp_auto_boot.sh"
getPackage3(){
	getPackages=$(pm list packages -3|cut -d':' -f2)
	count=0
	nn=0
	for ppp in $getPackages
	do
		nn=$((count++))
		pkgs[$nn]=$ppp
		echo "$nn -- $ppp"
	done
}

initBaseSetting(){
	clear
	resetprop ro.debuggable 1
	setprop persist.sys.max_profiles "$INIT_USER_SIZE"
	setprop fw.max_users "$INIT_USER_SIZE"
}

fuckPkg(){
	pkgname=$1
	createUsers=$2
	for uu in ${createUsers[*]}
	do
		if [ "$uu" != "Users" ] && [ "$uu" != "0" ];then
			pm install --user "$uu" -r "$(pm path $pkgname |cut -d':' -f2)"
		fi
	done
	
}

fuckPkgByUsers(){
	pkgname=$1
	createUsers=$(pm list users |cut -d' ' -f1 |cut -d':' -f1|cut -d'{' -f2)
	fuckPkg "$pkgname" "${createUsers[*]}"
}

runTheWorkProfileUser(){
	uu=$1
	am start-user "$uu"
}

runTheWorkProfileUsers(){
	createUsers=$(pm list users |cut -d' ' -f1 |cut -d':' -f1|cut -d'{' -f2)
	for uu in ${createUsers[*]}
	do
		if [ "$uu" != "Users" ] && [ "$uu" != "0" ];then
			runTheWorkProfileUser "$uu"
		fi
	done
}

removeWorkProfileUser(){
	uu=$1
	am stop-user -f "$uu" 
	am stop-user "$uu" 
	pm remove-user "$uu" 
}

removeWorkProfileUsers(){
	createUsers=$(pm list users |cut -d' ' -f1 |cut -d':' -f1|cut -d'{' -f2)
	for uu in $createUsers
	do
		if [ "$uu" != "Users" ] && [ "$uu" != "0" ];then
			removeWorkProfileUser "$uu" 
		fi
	done
	removeautobootfile
}

createWorkProfileUser(){
	appnum=$1
	for i in $(seq $appnum)
	do
		pm create-user --profileOf 0 --managed owp
	done
}

createWorkProfile(){
	initBaseSetting
	pkgname=${pkgs[$pkg_num]}
	echo "pkgname : $pkgname"
	if [ "$pkgname" != "" ];then
		echo "input open application num : "
		read appnum
		if [ "$appnum" -gt 0 ];then
			createUserSize=$(pm list users |wc -l)
			if [ "$createUserSize"  != "2" ];then
				removeWorkProfileUsers
			fi
			createWorkProfileUser "$appnum"
			runTheWorkProfileUsers
			fuckPkgByUsers "$pkgname"
		else
			createWorkProfile
		fi
	else
		exit 1;
	fi
}

openWorkProfileMenu(){
	getPackage3
	echo "q -- quit"
	echo "please select package name : "
	read  pkg_num
	if [ "$pkg_num" == "q" ]
	then
		exit 0;
	else
		createWorkProfile 
	fi
}

reinstallByUser(){
	getPackage3
	echo "q -- quit"
	echo "please select package name : "
	read  pkg_num
	if [ "$pkg_num" == "q" ]
	then
		exit 0;
	else
		clear
		pkgname=${pkgs[$pkg_num]}
		echo "pkgname : $pkgname"
		if [ "$pkgname" != "" ];then
			fuckPkgByUsers "$pkgname"
		else
			exit 1;
		fi
	fi
}

autoboot(){
	echo "write auto boot file ...."
	if [ -d "$pathdir" ];then
		removeautobootfile
		createUsers=$(pm list users |cut -d' ' -f1 |cut -d':' -f1|cut -d'{' -f2)
		for uu in $createUsers
		do
			if [ "$uu" != "Users" ] && [ "$uu" != "0" ];then
				echo "am start-user $uu \n" >> $autobootfile
			fi
		done
		chmod 755 "$autobootfile"
	fi
	echo "write auto boot file ok."
}

removeautobootfile(){
	if [ -f "$autobootfile" ];then
		rm -rf $autobootfile
	fi
}

menu(){
	echo -ne "1.create work profile\n2.remove work profile\n3.reinstall by user\n4.I want auto boot the work profile\n5.remove auto boot file\nq.exit\ninput : "
	read sssf
	case $sssf in
	1)
	openWorkProfileMenu
	exit 0;;
	2)
	removeWorkProfileUsers 
	exit 0;;
	3)
	reinstallByUser
	exit 0;;
	4)
	autoboot
	exit 0;;
	5)
	removeautobootfile
	exit 0;;
	q)
	exit 0;;
	*)
	menu;;
	esac
}

main(){
	clear
	UUUUID=$(id -u)
	if [ "$UUUUID" == "0" ]
	then
		menu
	else
		echo "need root user run $0"
		exit 1;
	fi
}
main

