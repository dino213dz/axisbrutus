# AXIS BRUTUS

# Change logs:
- Version 2.6 :
	- Améliorations:
		- Erreur "test_unauthorized" : commande grep remplacée par egrep
		- Erreur "ligne_complete" : grep starts with * corrigée (grep "\*")
- Version 2.5 :
	- Améliorations:
		- Sauvegarder la liste des ip deja scannées avec la date de l'attaque. 
		- Possibilité de sauter les cible présentes dans le l'historique graceau parametre --hist-break
		- Ajout d'un fichier de configuration et de personnalisation
		- Ajout d'un fichier de traductions des messages
		- Agencements et ajout d'informations lors de l'attaque
		- Ajout de smiley
		- Fichier temporaire horodaté pour eviter les conflit en cas de multi-process
	- Ajout de modèles vérifiés:
		- AXIS 210A Network Camera
		- AXIS 2401 Network Camera
- Version 2.4 :
	- Améliorations:
		- Vérification des dépendances:
			- curl
			- ping.
		- Tests de connectivité:
			- --ignore, -i : Igorer le test de connectivité (attaquer dans tous les cas).
		- Amélioration des messages de logs
		- Style barre de progression améliorée
	- Correction de bugs :
		- Correction du mode check: opérations inutiles supprimées
		- Correction d'orthographe
- Version 2.3 :
	- Améliorations:
		- Graphiques: Ajout de barres de progressions.
		- Tests de connectivité: Vérifie la disponibilité de la cible avant d'attaquer
			- --ping-timeout : Délai des pings. à 10 par défaut (min. 3)
		- Ajout paramétrage Curl:
			- --maxtime : Délai maximum de chaque requêtes (min. 3)
			- --timeout : Délai en cas d'absence de réponse (min. 3)
- Version 2.2 :
	- Améliorations:
		- Mode verbeux (--verbose, --v) : Possibilité d'afficher plus ou moins d'infos à l'écran
	- Correction de bugs :
		- calcul de durée plus précis
		- Suppresson des fichiers temporaires locaux
- Version 2.1 :
	- Améliorations:
		- Logging attaques : Un fichier logs est créé afin de logger les actions. Pratique lorsqu'on envoie une grande liste d'adresses ip en paramètre.
		- Afficher l'IP Cible à chaque combinaison: permet de savoir quelle ip est ciblée sans devoir remonter tout en haut de l'écran.
	- Nouveautés
		- Ajout du paramètre permettant de définir un fichier log pour les attaques : --log, --logs, -l
		- Ajout d'un paramètre qui vérifie la version de la caméra mais sans attaque : --check, -k
	- Correction de bugs :
		- Prise en compte du décalage d'heure d'été dans les calculs des durées

- Version 2.0 :
	- Améliorations:
		- Amélioration de la recherche de pages protégées
		- Corrections de bugs
	- Nouveautés
		- Geolocalisation de l'IP
		- Telechargement de fichiers
		- Effacement de traces

# Améliorations à venir:
- --cortex-mode: Utiliser le social Engeneering en plus. utiliser le nom de la ville ou le departement comme mot-de-passe ainsi que les logins 
- Fichier de configuration séparé du code
- Verification des ip déjà craquées
- Parametrage du user-agent
- Verification de la disponibilité de l'IP avant d'opérer
- Barre de progression
- Estimation du temps restant d'après le nombre de combinaisons restantes et la durée des précedentes
- Forcer l'utilisation d'un username en particulier, d'un mot-de-passe ou les deux
- Creation d'accès permanent caché (root-kit) : --root-kit
- activation de l'accès ftp --ftp-on port
- Activation d'un reverse shell si possible (dépend de la version) --reverse-shell

