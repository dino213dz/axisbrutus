[![License](https://img.shields.io/badge/license-GPLv2-green.svg)](https://github.com/dino213dz)
![logo](https://avatars2.githubusercontent.com/u/34544107 "axisBrutus Logo")

# AXIS BRUTUS

## A propos:
- Auteur: CHORFA Alla-eddine
- Crée le: 25.07.2019
- Edité le: 05.08.2019
- Version: 2.5
- Contact: h4ckr213dz@gmail.com
- Web: http://dino213dz.free.fr

## Description:
- La plus fine des brutes!
- Brute force les interfaces web des cameras IP AXIS
- Nécessite un fichier de mots-de-passe et un fichier usernames :
	1- ./wordlists/axis_users.txt
	2- ./wordlists/axis_mdp.txt
- Ces fichiers contiennent les logins et mot-de-passe par défaut des caméras Axis.

## Algorithme:
- Vérifier les dépendances
- Verifier les paramètres et les fichiers
- Verifier l'historique
- Verifier la connectivité de la cible
- Récuperer le modèle de la caméra
- Recuperer le firmware
- Recherche d'URL protégée par mot-de-passe
- Brute force
- Si mot de passe trouvé:
	- Télécharger les fichiers de configuration
	- Sauvegarde des données
	- Effacer les logs

## Syntaxe:
- $> ./axisBrutus.sh -c IP:PORT [OPTIONS]

## Options/Parametres:
### Paramètres obligatoires:
- --cible, -c : IP, IP:PORT, URL
### Parametres optionnels:
- --skip, -s : N'effectue pas la détection du modèle. L'url cible sera "/operator/basic.shtml" qui est la plus probable. L'argument --url peut être utilisé pour changer l'url cible.
- --list, -l : liste les modèles de caméra compatibles
- --help, -h : affiche l'aide
- --no-geo, --nogeo, -g : Désactive la géolocalisation de l'IP
- --check, --chk : Vérifie uniquement la compatibilité d'un modèle sans procéder à l'attaque
- --log, --logs : Définit l'emplacement du fichier logs des opérations d'attaque. La valeur par défaut est : ./axisBrutus.log
- --passwords, -p : fichier wordlist contenant la liste des mots-de-passe
- --usernames, -u: fichier wordlist contenant la liste des noms d'utilisateurs
- --export, --output, -o : fichier dans lequel le mot-de-passe sera enregistré s'il est trouvé. Aucun fichier créé si le mot-de-passe n'est pas trouvé
- --url, -r : L'url dépend du modèle. Vous pouvez le modifier si vous souhaitez tester une page web bien précise (cas d'un modèle inconnu par exemple)
- --verbose, -v : permet d'afficher plus ou moins d'infos à l'écran. Si verbeux alors : Garde à l'ecran les combinaisons testées & affiche le contenu des fichiers téléchargés
- --timeout, -t : définit le temps de réponse limite dans curl
- --maxtime, -m : définit le temps limite d'une requête curl
- --ping-timeout : définit le timeout du test de connectivité (ping)
- --ignore, -i : ignorer le résultat du test de connectivité (attaquer dans tous les cas)
- --hist-break, --history-break : Sauter les cibles présentes dans l'historique. L'historique est stocké dans le fichier "./axisBrutus.history".

## Exemples:
### Attaque standard par ip ou par url:
- Les wordlist utilisés ici sont ceux par défaut. (Voir "Description")
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83
	 - $> ./axisBrutus.sh --cible http://192.23.36.254:83
	 - $> ./axisBrutus.sh --cible https://maCameraIp213dz.axis.com/
### Afficher la liste des modèles compatibles:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --list
### Pas de géolocalisation
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --no-geo
### Pas de détection du modèle:
- On définit le TARGETURI manuellement. peut servir pour attaquer d'autres type de cameras. du moment qu'il s'agisse d'une page protegée par uen authentification http simple.
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --skip --url /admin/admin.shtml
### Definir une liste de login mot-de-passe:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --passwords ./axis_pass.txt --usernames ./axis_usernames.txt
### Définir le fichier de sauvegarde:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --export mdp_axis_test.txt --verbose
### Fichier logs d'attaque:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --log ./test.log
### Mode verbeux :
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --verbose
### Paramétrage curl:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --maxtime 10 --timeout 4
###- Paramétrage ping:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --ping-timeout 4
### Ne pas attaquer les IP présentes dans l'historique:
	 - $> ./axisBrutus.sh --cible 192.23.36.254:83 --hist-break


## Captures d'écran:
![logo](https://dino213dz.online.com/img/screenshot/axisbrutus_2.5_screenshot.jpg "axisBrutus.sh 2.5")
