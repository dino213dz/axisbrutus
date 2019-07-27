# AXIS BRUTUS 

# A propos:
 - Auteur: CHORFA Alla-eddine
 - Crée le: 25.07.2019
 - Edité le: 27.07.2019
 - Version: 0.9
 - Contact: h4ckr213dz@gmail.com
 - Web: http://dino213dz.free.fr

# Description:
 - Brute force les interfaces web des cameras IP AXIS
 - Necessite un fichier mdp et un fichier usernames :
	1- ./wordlists/axis_mdp_light.txt
	2- ./wordlists/axis_mdp_light.txt

# Syntaxe:
 - $> ./axisBrutus.sh [OPTIONS] --cible|-c IP|IP:PORT

# Parametres obligatoires:
 - --cible, -c : IP, IP:PORT, URL

# Parametres optionnels:
 - --skip, -s : N'effectue pas la detection du modele. L'url cible sera "/operator/basic.shtml". L'argument --url peut etre utilisé pour changer l'url cible.
 - --list, -l : liste les modeles de camera compatibles
 - --help, -h : affiche l'aide
 - --passwords, -p : fichier wordlist contenant la liste des mots-de-passe
 - --usernames, -u: fichier wordlist contenant la liste des noms d'utilisateurs
 - --export, --output, -o : fichier dans lequel le mot-de-passe sera enregistré s'il est trouvé
 - --url : L'url dépend du modele. Vous povez le modifier si vous souhaitez tester une page web précise avec un modele inconnu par exemple

# Exemples:
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 
  - $> ./axisBrutus.sh --cible http://192.23.36.254:83
  - $> ./axisBrutus.sh --cible https://maCameraIp213dz.axis.com/
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 --help
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 --list
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 --passwords ./axis_pass.txt --usernames ./axis_usernames.txt 
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 --export mdp_axis_test.txt]
  - $> ./axisBrutus.sh --cible 192.23.36.254:83 --export mdp_axis_test.txt] --url /index2.shtml

