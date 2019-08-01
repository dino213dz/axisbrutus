# AXIS BRUTUS 

# A propos:
 - Auteur: CHORFA Alla-eddine
 - Crée le: 25.07.2019
 - Edité le: 01.08.2019
 - Version: 2.2
 - Contact: h4ckr213dz@gmail.com
 - Web: http://dino213dz.free.fr

# Description:
 - La plus fine des brutes!
 - Brute force les interfaces web des cameras IP AXIS
 - Necessite un fichier mdp et un fichier usernames :
	1- ./wordlists/axis_mdp_light.txt
	2- ./wordlists/axis_mdp_light.txt
 - Ces fichiers contiennet les logins et mot-de-passe par defaut des cameras Axis.

# Syntaxe:
 - $> ./axisBrutus.sh [OPTIONS] --cible|-c IP|IP:PORT

# Parametres obligatoires:
 - --cible, -c : IP, IP:PORT, URL

# Parametres optionnels:
 - --skip, -s : N'effectue pas la detection du modele. L'url cible sera "/operator/basic.shtml" qui est la plus probable. L'argument --url peut etre utilisé pour changer l'url cible.
 - --list, -l : liste les modeles de camera compatibles
 - --help, -h : affiche l'aide
 - --no-geo, --nogeo, -g : Désactive la géolocalisation de l'IP
 - --check, --chk : Vérifie uniquement la compatibilité d'un modele sans procéder à l'attaque
 - --log, --logs : Définit l'emplacement du fichier logs des operations d'attaque. La valeur  par défaut est : ./axisBrutus.log
 - --passwords, -p : fichier wordlist contenant la liste des mots-de-passe
 - --usernames, -u: fichier wordlist contenant la liste des noms d'utilisateurs
 - --export, --output, -o : fichier dans lequel le mot-de-passe sera enregistré s'il est trouvé. Aucun fichier créé si le mot-de-passe n'est pas trouvé
 - --url, -r : L'url dépend du modele. Vous pouvez le modifier si vous souhaitez tester une page web bien précise (cas d'un modele inconnu par exemple)
 - --verbose, -v : permet d'afficher plus ou moins d'infos à l'écran

# Exemples:
 - Attaque standard par ip ou par url. les wordlist utilisés ici sont ceux par defaut. (Voir "Description")
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 
	 - $> ./axisBrutus.sh --cible http://192.23.36.254:83
	 - $> ./axisBrutus.sh --cible https://maCameraIp213dz.axis.com/

 - Afficher la liste des modèles compatibles
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --list

 - Pas de geolocalisation
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --no-geo

 - Pas de detection du modele. on définit le TARGETURI manuellement.
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --skip --url /admin/admin.shtml

 - Definir une liste de login mot-de-passe 
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --passwords ./axis_pass.txt --usernames ./axis_usernames.txt 

 - Definir le fichier de sauvegarde:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --export mdp_axis_test.txt --verbose 

 - Mode verbeux (Garde à l'ecran les combinaisons testées + affiche le contenu du fichers téléchargés:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --verbose 

# Algorithme:
 - Récuperer le modele de la camera
 - Recuperer le firmware 
 - Recherche d'URL protegée par mot-de-passe 
 - Bruteforce
 - Si mot de passe trouvé:
 - Telecharger les fichiers de configuration
 - Sauvegarde des données
 - Effacer les logs

# Change logs:
 - Version 2.2 :
	- Ameliorations:
		- Mode verbeux (--verbose, --v) : Possibilité d'affichier plus ou moins d'infos à l'écran 
	- Correction de bugs : 
		- calcul de durée plus précis
		- Suppresson des fichiers temporaires locaux
 - Version 2.1 :
	- Ameliorations:
		- Logging attaques : Un fichier logs est créé afin de logger les actions. Pratique lorsqu'on envoi une grande liste d'adresses ip en parametre.
		- Afficher l'IP Cible à chaque combinaison: permet de savoir quelle ip est ciblées sans devoir remonter tout en haut de l'écran.
	- Nouveautés
		- Ajout du parametre permettant de definir un fichier log pour les attaques : --check, -k
		- Ajout d'un parametre qui vérifie la compatibilité de la version de la camera mais sans attaque : --check, -k
	- Correction de bugs : 
		- Prise en compte du décalage d'heure d'été dans les calculs des durées

 - Version 2.0 :
	- Ameliorations:
		- Amelioration de la recherche de page protegées
		- Corrections de bugs
	- Nouveautés
		- Geolocalisation de l'IP
		- Telechargement de fichiers
		- Effacement de traces

# Améliorations à venir:
 - Estimation du temps restants d'après le nombre de combinaisons restantes et la durée des précedentes 
 - Forcer l'utilisation d'un username en particulier, d'un mot-de-passe ou les deux
 - Parametrage des timeout et maxtime des requetes curl	
 - Creation d'accès permanant caché (root-kit) : --root-kit
 - activation de l'accès ftp --ftp-on port
 - Activation d'un reverseshell si possible (depend de la version) --reverse-shell


