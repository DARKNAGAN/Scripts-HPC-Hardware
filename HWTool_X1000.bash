#!/bin/sh 
echo $2; 
case $1 in 
# DEVELOPE par CB 
	info)
		if [[ $(clary-locate -n $2) =- "X1310" ]] 
		# ARM 
		then 
			echo "Compute systems informations"; 
			echo "*****Information Motherboard*****";
			clush --worker=exec -­remote=no -w $2-ipmi pmsmMC.py display -f -n %h; 
			echo "*****Information Processor*****";
			clush -bw $2 dmidecode -t processor | grep -E 'node|---------------|Socket|Version|Cache|Core|Speed'; 
			echo "*****Information PCI CZI IB ARM*****";
			clush -bw $2 lspci -vv -s 09:00 | grep -E 'node|---------------|Mellanox|Bull|number|Engineering|lnk'; 
			echo "*****Information Memory*****";
			clush -bw $2 dmidecode -t memory | grep -E 'node|---------------|Memory Device|Size|Form Factor|locator Type|Speed|Number|Manuf'; 
		elif [[ $(clary-locate -n $2) =- "X1210" ]] || [[ $(clary-locate -n $2) =­"X1120" ]] 
		# KNL CKL 
		then 
			echo "Compute systems informations"; 
			echo "*****Information Motherboard*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py display -f -n %h; 
			echo "*****Information Processor*****";
			clush -bw $2 dmidecode -t processor | grep -E 'node|---------------|Socket|Version|Cache|Core|Speed'; 
			echo "*****Information PCI CZB BXI*****";
			clush -bw $2 lspci -vv -s 01:00 | grep -E 'node|---------------|BXI|number|Engineering|Vendor| Lnk'; 
			echo "*****Information Memory*****";
			clush -bw $2 dmidecode -t memory | grep -E 'node|---------------|Memory Device|Size|Form Factor|locator Type!Speed!Number!Manuf'; 
			echo "**********"; 
			echo "RAMA analyse $2"; 
			echo "*****LOCALISATION*****";clary-locate -n $2; 
			echo "*****Etat Memory*****";clush -bw $2 free; 
			echo "#### RAMA Normal Mem: 65751648 ####"; 
			echo "#### Router Normal Mem: 131743204 ####"; 
			clush -bw $2 dmidecode -t memory | grep -E 'node|---------------|Locator' ; 
			conman.sh $2; 
		elif [[ $(clary-locate -n $2) =~ "NSR423e4i" ]] || [[ $(clary-locate -n $2) =~ "NSR423e4m" ]] 
		# Router RAMA|ISMA 
		then 
			echo "*****Localisation*****";clary-locate -n $2; 
			echo "*****Status equipement*****";clmctrl status $2; 
			echo "*****Information Motherboard*****";clush -bw $2 dmidecode -t base board; 
			echo "*****Information Sensors*****";clush -bw $2 ipmitool sensor; 
			echo "*****Information Processor*****";clush -bw $2 dmidecode -t processor | grep -E 'node|---------------|Socket|Version|Cache|Core|Speed'; 
			echo "*****Information Memory*****";clush -bw $2 dmidecode -t memory | grep -E 'node|---------------|Memory Device|Size|Form Factor|locator|Type|Speed|Number|Manuf'; 
			if [[ $(clary-locate -n $2) =~ "NSR423e4i" ]] 
			then	
				echo "*****Information PCI PBNI ROUTER*****";clush -bw $2 lspci -vv -s 02:00 | grep -E 'node|---------------|BXI|number|Engineering|Vendor|lnk';
			fi
		else
			echo "Verifier vos parametres"; 
		fi 
	;;
	status)
		if [[ $(clary-locate -n $2) =~ "X1210" ]] || [[ $(clary-locate -n $2) =~ "X1120" ]] || [[ $(clary-locate -n $2) =~ "Xl310" ]] 
		# KNL CKL ARM 
		then 
				echo "*****Status Electrique compute*****"; clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repair -P status -n %h; 
				echo "*****Status Soft compute*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h; 
		else				
			echo "Verifier vos parametres"; 
		fi 
	;;
	analyse)
		if [[ $(clary-locate -n $2) =~ "X1310" ]] 
		# ARM 
		then 
			echo "Compute analyse $2"; 
			echo "*****LOCALISATION*****";clary-locate -n $2; 
			echo "*****SENSOR*****" ;clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py monitor -S -n %h; 
			echo "*****SEL*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py monitor -l 10 -n %h; 
			echo "*****Etat Memory*****";clush -bw $2 free;
			echo "#### ARM Normal Mem:267438464 ####";
			clush -bw $2 dmidecode -t memory | grep -E 'node|---------------|Locator'; 
			echo "*****Carte IB ARM*****" ;clush -bw $2 ibstatus; 
			clush -bw $2 lspci -vv -s 09:00 | grep -E 'node|---------------|Mellanox|Bull|LnkSta'; 
			echo "#### SPEED NORMAL LnkSta: Speed 8GT/s, Width x16 ####"; conman.sh $2; 
			firefox -P $USERLOGIN https://$2$3/ & bg; 
		elif [[ $(clary-locate -n $2) =~ "X1210" ]] || [[ $(clary-locate -n $2) =~ "X1120" ]] 
		# KNL CKL 
		then
			echo "Compute analyse $2"; 
			echo "*****LOCALISATION*****";clary-locate -n $2; 
			echo "*****SENSOR*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py monitor -5 -n %h; 
			echo "*****MESSAGES*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py monitor -m 20 -n %h; 
			echo "*****SEL*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py monitor -l 10 -n %h; 
			echo "*****CONSOLELOG*****";clush --worker=exec --remote=no -w $2-ipmi cat /var/log/sysloghosts/mce_log/$2/mcelog.log | tail -n 15; 
			echo "*****Etat Memory*****";clush -bw $2 free;
			echo "#### KNL Normal Mem:197495272 ####";echo "#### SKL Normal Mem:196276312 ####";
			clush -bw $2 dmidecode -t memory | grep -E 'node|---------------1 Locator'; 
			echo "*****Carte BXI*****";clush -bw $2 bxinic; 
			conman.sh $2; 
			firefox -P $USERLOGIN https://$2$3/ & bg; 
		elif [[ $(clary-locate -n $2) =~ "NSR423e4i" ]] 
		# Router 
		then 	
			echo "Router analyse $2"; 
			echo "*****LOCALISATION*****";clary-locate -n $2; 
			echo "*****SUIVI LOGS SWITCH*****";nodelog -t w -q -v cat $2; 
			echo "*****BXINIC ROUTER CPLD=2.3 OK*****";clush -bw $2 bxinic info;echo "*****BXINIC ROUTER CPLD<>2.3 NOTOK -> UPDATE PBNI & QSFP MELLANOX*****"; 
			echo "SWITCH1=; PORT1=; "; 
		elif [[ $(clary-locate -n $2) =~ "HMC" ]] 
		# HYC 
		then 
			echo "HYC analyse $2"; 
			echo "*****LOCALISATION*****";clary-locate -n $2;
			echo "*****HardPOWER*****";clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P status -n %h; 
			echo "*****SoftPOWER*****";clush --worker=exec --remote=no -w $2 pmsmMC.py control -p status -n %h; 
			echo "*****ETAT*****";clush --worker=exec --remote=no -w $2 /bin/hyc_state.sh;
			echo "*****SENSOR*****";clush --worker=exec --remote=no -w $2 pmsmMC.p monitor -5 -n %h;
			echo "*****SEL*****" ;clush --worker=exec --remote=no -w $2 pmsmMC.py monitor -l -n %h;
			echo "*****MESSAGES*****";clush --worker=exec --remote=no -w $2 pmsmMC.py monitor -m -n %h;
			firefox -P $USERLOGIN https://$2/ & bg;		

		elif [[ $(clary-locate -n $2) =~ "WMC" ]] 
		# Switch 
		then
			echo "Switch analyse $2 portstep $3"; 
			echo "*****LOCALISATION*****";clary-locate -n $2; 
			echo "*****TEMPERATURE*****";clush -bw $2 boardtemp -d; 
			echo "***** ETAT DES PORTS SWITCH "$2":"$3" *****"; 
			clush -bw $2 portstep -p $3; 
			clush -bw $2 cat /var/log/snmpd.log | tail -n 15; 
			echo "*****";/root/cavin/pod_status -s $2":"$3; 
		else
			echo "Verifier vos parametres"; 
			echo "Pour test de switch indiquer deux variable analyse SWITCH1 PORT1";
		fi
	;;
	test)
		echo "Check HardwareSys & Status"; 
		date; milkcheck --report=full -c /milkcheck/ HardwareSys -n $2; 
		date; milkcheck --report=full -c /milkcheck/ status -n $2; 
	;;
	testU)
		echo "TestU ~25minute"; 
		read -p "Combien de testU voulez-vous faire? " nbre; 
		date; milkcheck minimum -c /milkcheck/conf/diskless/ -n $2\!@compute­recette ; 
		date; milkcheck config -c /milkcheck/conf/diskless/ -n $2\!@compute­recette; 
		date; milkcheck --report=full -c /milkcheck/ statpost -n $2 ;
		date ;i=$nbre; while [ $i -gt 0 ]; 
		do milkcheck --report=full -c /milkcheck/ Unitaire -n $2; i=$(($i - 1)); done; 
	;;
	testUScore)
		echo "TestU Seo re ( POUR 1 NOEUD)"; 
		echo "SCORE HPL (DIMM Performance)"; 
		clush --worker=exec --remote=no -w $2-ipmi tail -10 /var/log/sysloghosts/testU/$2/hpl.log ;
		echo "SCORE STREAM (Bande Passante DIMM)"; 
		clush --worker=exec --remote=no -w $2-ipmi tail -10 /var/log/sysloghosts/testU/$2/stream.log ;
		echo "SCORE DGEMM ( CPU Memo rySocket Performance)" ;
		clush --worker=exec --remote=no -w $2-ipmi tail -10 /var/log/sysloghosts/testU/$2/dgemm.log;
	;;
	version)
		if [[ $(clary-locate -n $2) =~ "X1210" ]] || [[ $(clary-locate -n $2) =~ "X1120" ]] || [[ $(clary-locate -n $2) =~ "Xl310" ]]
		# KNL CKL ARM 
		then 
			echo "Version des composants";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py display -v -n %h; 
			TS=$(nodeset -s TS -l $2 | cut -d ":" -f 2);echo $TS; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py upgrade -a diff -­ts /bull/sequana/${TS} -n %h; 
			echo "Pour mettre a jour commande ci-dessous"; 
			echo "clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py upgrade -a upg --ts /bull/sequana/${TS} -n %h"; 
		else
			echo "Verifier vos parametres"; 
			fi 
	;;
	cycle)
			echo "***--Compute Power Cycle--***"; 
			echo "*****Extinction*****"; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h;sleep 3; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p off -n %h;sleep 3; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P off -n %h;sleep 3; 
			echo "*****Demarrage*****"; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P on -n %h;sleep 60; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P status -n %h;
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p on -n %h;
			conman.sh $2; sleep 205;
			if [[ $(clary-locate -n $2) =~ "Xl310"])
			then sleep 150; 
			fi 
			echo "*****Reboot Cycle OK*****"; 
	;;
	on)
			if [[ $(clary-locate -n $2) =~ "Xl210" ]] || [[ $(clary-locate -n $2) =~ "Xl120" ]] || [[ $(clary-locate -n $2) =~ "Xl310" ]] 
			# KNL CKL ARM 
			then 
				echo "*****Boot Compute*****"; 
				clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repair -P on -n %h;sleep 60; 
				clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repair -P status -n %h; 
				clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h;
				clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p on -n %h; 
				conman.sh $2; sleep 205; 
				if [[ $(clary-locate -n $2) =~ "X1310"]] 
					then sleep 150; 
				fi 
				echo "*****Boot Compute OK*****"; 
			elif [[ $(clary-locate -n $2) =~ "NSR423e4i" ]] # Router 
			then 
				echo "*****Boot Router*****"; 
				clmctrl poweron $2;sleep 60; 
				clmctrl status $2; 
				echo "*****Boot Router OK*****"; 
			elif [[ $(clary-locate -n $2) =~ "HMC" ]] 
			# HYC 
			then 
				echo "*****Boot HMC*****"; 
				clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P on -n %h;sleep 90; 
				clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P status -n %h; 
				clush --worker=exec --remote=no -w $2 pmsmMC.py control -p status -n %h; 
				echo "*****ETAT*****";clush --worker=exec --remote=no -w $2;
				/bin/hyc_state.sh; 
				echo "*****Boot HMC OK*****";
			elif [[ $(clary-locate -n $2) =~ "WMC" ]] 
			# Switch 
			then 
				echo "*****Boot Switch L1|L2*****"; 
				clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P on -n %h;sleep 60; 
				clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P status -n %1 
				clush --worker=exec --remote=no -w $2 pmsmMC.py control -p status -n %h; 
				echo "*****Boot Switch OK*****"; 
			else
				echo "Verifier vos parametres"; 
			fi
	;;
	off)
		if [[ $(clary-locate -n $2) =~ "HMC" ]] || [[ $(clary-locate -n $2) =c--"WMC" ]) 
		# Switch HYC 
		then 
			echo "*****Extinction HMCISWITCH-L1|L2*****"; 
			clush --worker=exec --remote=no -w $2 pmsmMC.py control -p status -n %h;sleep 3; 
			clush --worker=exec --remote=no -w $2 pmsmMC.py control -p off -n %h;sleep 3; 
			clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P off -n %h;sleep 3; 
			clush --worker=exec --remote=no -w $2 pmsmMC.py repair -P status -n %h; 
			echo "*****Extinction HMCISWITCH-L1|L2 OK*****"; 
		elif [[ $(clary-locate -n $2) =~ "X1210" ]] || [[ $(clary-locate -n $2) =~ "X1120" ]] || [ [ $(clary-locate -n $2) =~ "Xl310" ]] 
		# KNL CKL ARM 
		then 
			echo "*****Extinction Compute*****"; 
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h;sleep 3;
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p off -n %h;sleep 3;
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repair -P off -n %h;sleep 3;
			clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repair -P status -n %h;
			echo "*****Extinction Compute OK*****"; 
		elif [[ $(clary-locate -n $2) =~ "NSR423e4i" ]] 
		# Router 
		then 
			echo "*****Extinction Router*****"; 
			clmctrl poweroff $2;sleep 3; 
			clmctrl status $2; 
			echo "*****Extinction Router OK*****";
		else 
			echo "Verifier vos parametres"; 
		fi
	;;
	update)
		echo "*****Mise en etat de MAJ compute*****"; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h;sleep 3; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p off -n %h;sleep	3; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P off -n %h;sleep 3; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P status -n %h; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py repai r -P on -n %h;sleep 60; 
		clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -p status -n %h; echo "******Etat repairON pour MAJ*****"; 
	;;
	trace)
		echo "*****Enable Trace*****";clush --worker=exec --remote=no -bw $2-ipmi /opt/BSMHW_NG/sbin/ipmi-oem -h %h Bull setcfg bmc.bios.enable traces yes; 
	;;
	led)
		echo "*****ID Led ON*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -ion -n %h; 
	;;
	clear)
		read -p "Choix de l'option de nettoyage (LOGIIBITRACEILED)? " clean; 
		case $clean in 
			IB)echo "*****ib_error_counter_clear*****";ib_node_error_reset $2;; LOG)echo "*****SELLOG_Purge*****";manage_sel.sh -w $2 -p;; 
			LED)echo "*****ID Led OFF*****";clush --worker=exec --remote=no -w $2-ipmi pmsmMC.py control -i off -n %h;; 
			TRACE)echo "*****No_Trace*****";clush --worker=exec --remote=no -bw $2-ipmi /opt/BSMHW_NG/sbin/ipmi-oem -h %h Bull setcfg 
			bmc.bios.enable_traces no;; 
			*)echo "*****Valeur non valide Attention au MAJUSCULE*****";; 
		esac 
	;;
	*)
		echo "!--Commande INFORMATION [l[status,info,version] 2[nodeset]]--!"; 
		echo "!--Commande ACTION 
		[l[test,testU,testUSocket,on,off,cycle,update,trace,led,clear] 2[nodeset]]--!"; 
		echo "!--Commande ANALYSE [l[analyse] 2[nodeset]]--!"; 
esac