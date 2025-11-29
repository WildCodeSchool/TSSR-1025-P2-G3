 //  # Script de gestion des disques

Ce projet contient un script Bash permettant de faciliter **l’administration du stockage sous Linux** : disques, partitions, lecteurs montés et systèmes de fichiers.

>  Le script est prévu pour un système **Linux**.  
> Sous Windows, il peut être démontré via Git Bash, mais certaines commandes comme "lsblk" ne seront pas disponibles nativement.

---

## Objectifs du script

Le script a pour but de:

- Afficher le **nombre de disques physiques** détectés par le système  
- Lister les **partitions** (nom, système de fichiers, taille, type)  
- Afficher les **lecteurs montés** (point de montage, type, taille)  
- Afficher les **systèmes de fichiers montés** via `df -hT  

Le tout est centralisé dans un **menu interactif**.

---

## Fonctionnement général

Lors de l’exécution, le script affiche un menu :

text
     MENU GESTION DISQUES
===============================
1) Afficher le nombre de disques
2) Afficher les partitions
3) Afficher les lecteurs montés
4) Afficher les systèmes de fichiers montés
0) Quitter
-------------------------------
