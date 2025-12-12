
# 📜 Projet 2 : The Scripting Project
![README IMAGE](Ressources/images/readme/readme_presentation_rounded.png)
## 📑 Sommaire 

- [🎯 Présentation du projet](#-présentation-du-projet)
- [👥 Membres du groupe](#-membres-du-groupe)
- [⚙️ Choix techniques](#️-choix-techniques)
  - [🖥️ Configuration des machines virtuelles](#️-configuration-des-machines-virtuelles)
  - [🌐 Configuration réseau](#-configuration-réseau)

---

## 🎯 Présentation du projet  

### Administration automatisée par scripts

Ce projet consiste à développer deux scripts d'administration système permettant la gestion à distance de machines clientes :

- **Script Bash** : déployé sur un serveur Debian pour administrer des clients linux et windows
- **Script PowerShell** : déployé sur un serveur Windows Server pour administrer des clients Windows et linux

**Objectifs** :
- Exécuter des actions à distance sur les machines clientes
- Documenter chaque fonctionnalité implémentée

---

## 👥 Membres du groupe

### Sprint 1

| Membre      | Rôle           | Missions principales |
|-------------|----------------|----------------------|
| Safi        | Technicien     | • Mise en place de la VM Windows Server 2022, **Script** : Création et suppression de répertoires |
| Christian   | Product Owner  | • Mise en place de la VM Debian Serveur, **Script** : Gestion des mots de passe utilisateur |
| Jérôme      | Scrum Master   | • Mise en place du client Windows 10, **Script** : Gestion des disques durs |
| Pierre Jean | Technicien     | • Mise en place du client Ubuntu, **Script** : Gestion des groupes |

### Sprint 2

| Membre      | Rôle           | Missions principales |
|-------------|----------------|----------------------|
| Safi        | Technicien     | • Script Bash Gestion Ordinateurs Script d'information Ordinateurs  |
| Christian   | Scrum Master   | • Script Bash Gestion des Menu et Journalisation et Script Principal |
| Pierre Jean | Technicien     | • Script Bash Information Utilisateur Mise en place du SSH avec authentification par clé sur Proxmo |


### Sprint 3

| Membre      | Rôle | Missions |
|-------------|------|----------|
| Safi        | Product Owner  | Adaptation des scripts Bash Gestion Ordinateurs Script d'information Ordinateurs à PowerShell Test des script  sur Proxmox |
| Christian   | Technicien  | Adaptation des scripts Bash Gestion des Menu et Journalisation et Script Principal à PowerShell Test des script  sur Proxmox |
| Pierre Jean | Scrum Master | Adaptation des scripts Bash Gestion des groupes et User info à PowerShell Test des script  sur Proxmox |

### Sprint 4

| Membre      | Rôle | Missions |
|-------------|------|----------|
| Safi        |  |  |
| Christian   |  |  |
| Pierre Jean |  |  |


---

## ⚙️ Choix techniques

### 🖥️ Configuration des machines virtuelles

#### Serveurs

| Élément | Serveur Debian (SRVLX01) | Serveur Windows (SRVWIN01) |
|---------|--------------------------|----------------------------|
| **Système d'exploitation** | Debian 12 CLI | Windows Server 2022 |
| **Comptes utilisateurs** |  **root** & **wilder** (groupe sudo) |  **Administrator** & **wilder** (groupe Admin) |
| **Mot de passe** | **Azerty1*** | **Azerty1*** |

#### Clients

| Élément | Client Ubuntu (CLILIN01) | Client Windows (CLIWIN01) |
|---------|--------------------------|---------------------------|
| **Système d'exploitation** | Ubuntu 24.04 LTS | Windows 11 Pro |
| **Compte utilisateur** | **wilder** | **wilder** |
| **Mot de passe** | **Azerty1*** | **Azerty1*** |

### 🌐 Configuration réseau

Toutes les machines sont configurées sur le réseau `172.16.30.0/24` :

| Machine  | Adresse IP      | Passerelle    | DNS     | Rôle |
|----------|-----------------|---------------|---------|------|
| SRVLX01  | 172.16.30.10/24 | 172.16.30.254 | 8.8.8.8 | Serveur Debian |
| SRVWIN01 | 172.16.30.5/24  | 172.16.30.254 | 8.8.8.8 | Serveur Windows |
| CLILIN01 | 172.16.30.30/24 | 172.16.30.254 | 8.8.8.8 | Client Ubuntu |
| CLIWIN01 | 172.16.30.20/24 | 172.16.30.254 | 8.8.8.8 | Client Windows |



