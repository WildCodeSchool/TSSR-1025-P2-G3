## Sommaire

1. [Prérequis technique](#1-prérequis-techniques)

2. [Configuration sur le serveur Debian ( Debian 12.9 )](#2-configuration-sur-le-serveur-debian--debian-129-)

3. [Configuration sur le serveur Windows ( Windows serveur 2022 )](#3-configuration-sur-le-serveur-windows--windows-serveur-2022-)

4. [Configuration sur le client Linux ( Ubuntu 24.04 LTS )](#4-configuration-sur-le-client-linux--ubuntu-2404-lts-)

5. [Configuration sur le client Windows ( Windows 10 )](#5-configuration-sur-le-client-windows--windows-10-)

6. [FAQ](#6-faq)

## 1. Prérequis techniques  

4 machines Virtuelle sous **PROXMOX** :
Groupe 3
**Réseau: 172.16.30.0/24**
**BROADCAST: 172.16.30.254**  
**DNS : 8.8.8.8**  

- **Serveur Debian** :
 Nom : **srvlx01**  
 IP : **172.16.30.10**  
 
- **Serveur Windows 2022** :  
 Nom : **srvwin01**  
 IP : **172.16.30.5**  

- **Client Windows 10**  :  
 Nom : **cliwin01**  
 IP : **172.16.30.20**  
  
- **Client Linux** :  
 Nom : **clilin01**  
 IP : **172.16.30.30/24**  

Il faut un compte **ROOT** et un compte **wilder** sur le  serveur **Debian**
Il faut un compte **Administrator** et un compte **wilder** sur le **Serveur Windows**  
Il faut un compte utilisateur **wilder** sur les 2 VM **Client Windows** et **Client Linux**  

## 2. Configuration sur le serveur Debian ( Debian 12.9 )

### Instalation de open-ssh

- Mettre à jour les paquets avec `sudo apt update`
- Installer open-ssh avec `sudo apt install openssh-server`
sudo nano /etc/ssh/sshd_config

### Configuration du fichier config (pour une connection rapide)  

Si il n'existe pas, créez le fichier config dans ~./ssh
`sudo mkdir -p ~./ssh/config`

Nous pouvons y renseigner les informations des machines cibles :

### Génération des clés RSA

En ligne de commande, pour générer une paire de clés RSA (4096 bits recommandé)  
`ssh-keygen -t rsa -b 4096`
  
  Il est alors de possible de choisir un nom de clé personnalisé ("projet2deb" et "winprojet2" dans notre cas) ou d'appuyer sur Entrée pour obtenir un nom de clé par défaut.

### Transfert des clés publiques sur les machines cibles (Ubuntu et Windows 10 dans notre cas)

* Vers Ubuntu :
 	- `ssh-copy-id -p 4444 -i ~/.ssh/projet2deb.pub wilder@172.16.30.30`
- Vers Windows 10 :
 	- `scp -P 4444 ~/.ssh/projet2deb.pub Wilder@172.16.30.20:C:\Users\Wilder`

Une fois la connection réussie en ssh vers les machines cible à l'aide des clés RSA il sera possible de désactiver l'authentification par mot de passe.

## 3. Configuration sur le serveur Windows ( Windows serveur 2022 )

### Instalation de open-ssh sur windows

## 4. Configuration sur le client Linux ( Ubuntu )

## 5. Configuration sur le client windows ( Windows 10 )

Ajoutez la fonctionnalité facultative "open-ssh server"

![]

## 6. FAQ
