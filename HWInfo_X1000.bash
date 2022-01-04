#!/bin/sh 
if [[ $(clary-locate -n $1) =~ "NSR423e4i" ]] 
#router 
then 
	#Init variables environnement 
	EQUIP=$(clary-locate -n $1 1 cut -d " " -f 1 ); 
	nodeset=; 
	router=$EQUIP; 
	ISLET=$(nodeset -l $1 1 grep router- 1 cut -d'-' -f2 1 nodeset -f); 
	#Affichage 
	echo "----------";date; 
	echo "LOGBOOK: $(clary-logbook -n $1 -b 10)";echo "**********"; 
	echo -e "EQUIP=$EQUIP\nrouter=$router\nISLET=$ISLET\nLOCATE: $(clary-locate -n $1)"; 
	echo "----------";clary-overview -n $router;echo "----------"; 
	echo "*****TOPOLOGIE*****" ;grep $1 /etc/topo.bxi; 
	#Preparation intervention 
	read -p "Voulez-vous être assigné pour cette intervention (y/n) ? " response; 
	if [ "$response" = "y" ] 
	then 
		clary-state -n $EQUIP -c "En cours de traitement"; 
		echo "*****Vous traiterez cette intervention*****"; 
		read -p "Souhaitez-vous voir etat demons (y/n) ? " demons; 
		if [ "$demons" = "y" ] 
		then 
			date ; milkeheek etat_demons -n $router 
		else
			echo "Commande pour arret_demons : ";echo "# milkcheck arret demons -n $router" ;clary-overview -n $router; 
		fi
	else
		echo "*****Vous ne serez pas assigné pour cette intervention*****"; 
	fi 
elif [[ $(clary-locate -n $1) =~ "X1210" ]] 11 [[ $(clary-locate -n $1) =~ "X1120" ]] 11 [[ $(clary-locate -n $1) =~ "X1310" ]] 
# Noeud 
then 
	#Init variables environnement 
	EQUIP=$(clary-locate -n $1 1 cut -d " " -f 1 ); 
	nodeset=$(clary-locate -n $1 1 cut -d "(" -f 2 1 cut -d ")" -f 1); 
	ISLET=$(nodeset -l $1 1 grep "compute-" 1 cut -d "-" -f 2 ); 
	#Affichage 
	echo "----------";date; 
	echo "LOGBOOK: $(clary-logbook -n $1 -b 10)";echo "**********"; 
	echo -e "EQUIP=$EQUIP\nnodeset=$nodeset\nISLET=$ISLET\nLOCATE: $(clary-locate -n $1)"; 
	echo "----------";clary-overview -n $nodeset;echo "----------"; 
	#Preparation intervention 
	read -p "Voulez-vous etre assigne pour cette intervention (y/n) ? " response; 
	if [ "$response" = "y" ] 
	then 
		clary-state -n $EQUIP -c "En cours de traitement"; 
		echo "*****Vous traiterez cette intervention*****"; 
		read -p "Souhaitez-vous drainer le nodeset (y/n) ? " draining; 
			if [ "$draining" = "y" ] 
			then 
				drain2hard -D $nodeset; 
			else
				echo "*****Verifier la disponibilité des noeuds si besoin*****"; 
				echo "# drain2hard -D $nodeset"; 
				clary-overview -n $nodeset; 
			fi
	else
		echo "*****Vous ne serez pas assigné pour cette intervention*****";
		echo "*****Verifier la disponibilité des noeuds si besoin*****"; 
		echo "# drain2hard -D $nodeset"; 
	fi 
elif [[ $(clary-locate -n $2) =- "WMC" ]] 
# Switch 
then 
	#Init variables environnement 
	EQUIP=$(clary-locate -n $1 1 cut -d " " -f 1 ) ; 
	nodeset=$(clary-locate -n $1 1 cut -d " " -f 1 );
	ISLET=$(nodeset -l $1 1 grep "@mgroup-" 1 cut -d "-" -f 2 ); SWITCH1=$(clary-locate -n $1 1 cut -d " " -f 1 ) ; 
	#Affichage 
	echo "----------";date; 
	echo "LOGBOOK: $(clary-logbook -n $1 -b 10)";echo "**********"; 
	echo -e "LOCATE: $(clary-locate -n $1)\nEQUIP=$EQUIP\nnodeset=$nodeset\nSWITCH1=$SWITCHl\nISLET=$ISLET" 
	echo "----------";clary-overview -n $nodeset;
	echo "----------"; echo "*****TOPOLOGIE*****";grep $1 /etc/topo.bxi; 
	#Preparation intervention 
	read -p "Voulez-vous etre assigne pour cette intervention (y/n) ?" response;
	if [ "$response" = "y" ] 
	then 
		clary-state -n $EQUIP -c "En cours de traitement"; 
		echo "*****Vous traiterez cette intervention*****"; 
	else
		echo "*****Vous ne serez pas assigné pour cette intervention*****"; 
	fi 
else
	EQUIP=$(clary-locate -n $1 1 cut -d " " -f 1 ); 
	nodeset=$EQUIP; 
	ISLET=; 
	#Affichage 
	echo "----------";date; 
	echo "LOGBOOK: $(clary-logbook -n $1 -b 10)";echo "**********"; 
	echo -e "EQUIP=$EQUIP\nnodeset=$nodeset\nISLET=$ISLET\nLOCATE: $(clary-locate -n $1)"; 
	echo "----------";clary-overview -n $EQUIP;echo "----------"; 
fi 

# HWinfo nodel000 
#---------
#DATE
#LOGBOOK: @@@@@@@@@@@@@ nodel000 @@@@@@@@@@@@@ 
# *LOGBOOK 10 LIGNE - Historique du node* 
#********** 
#EQUIP=nodel000 
#nodeset=node[l000-1002] 
#ISLET=20 
#LOCATE: node1000 (node[l000-1002]):POSITION slot Left face Front node Bull None Xl210
#- - - - - - - - - -
#Overview of 2021-05-21 16:50:21.957483 
#Total number of equipments: 3 
# Prod (3): node[1000-1002] 
#- - - - - - - - - -
#Voulez-vous être assigné pour cette intervention (y/n) ? n 
#*****Vous ne serez pas assigné pour cette intervention***** 
#*****Verifier la disponibilité des noeuds si besoin***** 
# drain2hard -D node[1000-1002] 
# ISLET=20 nodeset=node[1000-1002] 