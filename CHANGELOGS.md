# AXIS BRUTUS 

# Change logs:
 - Version 2.3 :
	- Ameliorations:
		- Graphiques: Ajout de barres de progressions.
		- Tests de connectivité: Vérifie la disponibilité de la cible avant d'attaquer 
			- --ping-timeout : Délai des ping. à 10 poar défaut (min. 3)
		- Ajout parametrage Curl:
			- --maxtime : Délai maximum de chaque requetes (min. 3)
			- --timeout : Délai en cas d'absence de réponse (min. 3)
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
 - Verification de la disponibilité de l'IP avant d'opererw
 - Barre de progression
 - Estimation du temps restants d'après le nombre de combinaisons restantes et la durée des précedentes 
 - Forcer l'utilisation d'un username en particulier, d'un mot-de-passe ou les deux
 - Creation d'accès permanant caché (root-kit) : --root-kit
 - activation de l'accès ftp --ftp-on port
 - Activation d'un reverseshell si possible (depend de la version) --reverse-shell


