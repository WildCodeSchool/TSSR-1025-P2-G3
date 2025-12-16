#!/bin/bash

# Script Informations Système Windows en Powershell
# Auteur : Safi

# Sommaire :
# 01 - MENU GESTION DISQUE
# 02 - NOMBRE DE DISQUES
# 03 - PARTITIONS
# 04 - LECTEURS MONTÉS
# 05 - LISTE UTILISATEURS LOCAUX
# 06 - 5 DERNIERS LOGINS
# 07 - INFORMATIONS RÉSEAU
# 08 - VERSION DU OS
# 09-  MISES À JOUR CRITIQUES
# 10 - MARQUE ET MODÈLE DE L'ORDINATEUR



#==============================================================
# 01 - MENU GESTION DISQUES
#==============================================================
gestion_disques_menu_linux() {

    logEvent "MENU_GESTION_DISQUES"

    while true; do

        echo ""
        echo "╭──────────────────────────────────────────╮"
        echo "|             Gestion Des Disques          │"
        echo "├──────────────────────────────────────────┤"
        echo "│                                          │"
        echo "│  1. Nombre de disques                    │"
        echo "│  2. Afficher les partitions              │"
        echo "│  3. Afficher les lecteurs montés         │"
        echo "│  4. Retour au menu précédent             │"
        echo "│                                          │"
        echo "╰──────────────────────────────────────────╯"
        echo ""

        read -p "# Choisissez une option : " choix

        logEvent " Choisie ${choix^^} "

        case "$choix" in

        1)
            # Appel de la fonction pour compter les disques
            logEvent "SELECTION_NOMBRE_DISQUES"
            fonction_nombre_disques_linux
            ;;

        2)
            # Appel de la fonction pour lister les partitions
            logEvent "SELECTION_PARTITIONS"
            fonction_partitions_linux
            ;;

        3)
            # Appel de la fonction pour afficher les lecteurs montés
            logEvent "SELECTION_LECTEURS_MONTES"
            fonction_lecteurs_montes_linux
            ;;

        4)
            # Retour au menu principal
            logEvent "RETOUR_MENU_PRECEDENT"
            echo "Retour au menu précédent"
            return
            ;;

        *)
            # Gestion des choix invalides
            logEvent "OPTION_INVALIDE_GESTION_DISQUES"
            echo " ► Option invalide. "
            ;;
        esac

    done
}


#==============================================================
# 02 - NOMBRE DE DISQUES
#==============================================================
fonction_nombre_disques_linux() {

    logEvent "DEMANDE_NOMBRE_DISQUES"
    echo " ► Nombre de disques : "

    # Liste les disques et compte leur nombre
    nombreDisques=$(command "lsblk | grep 'disk' | wc -l" | tee /dev/tty)
    infoFile "$HOSTNAME" "Nombre de disques:" "$nombreDisques"

}


#==============================================================
# 03 - PARTITIONS
#==============================================================
fonction_partitions_linux() {

    logEvent "DEMANDE_LISTE_PARTITIONS"
    echo " ► Partitions Nom, FS, Taille : "

    # Affiche les partitions avec nom, type de système de fichiers et taille
    partitionsList=$(command " lsblk -o NAME,FSTYPE,SIZE,TYPE | grep 'part' " | tee /dev/tty)

    echo " ► Nombre de partitions : "
    # Compte le nombre total de partitions
    nombrePartitions=$(command " lsblk -o NAME,TYPE | grep 'part' | wc -l " | tee /dev/tty)

    infoFile "$HOSTNAME" "Liste des partitions:" "$partitionsList"
    infoFile "$HOSTNAME" "Nombre de partitions:" "$nombrePartitions"

}


#==============================================================
# 04 - LECTEURS MONTÉS
#==============================================================
fonction_lecteurs_montes_linux() {

    logEvent "DEMANDE_LECTEURS_MONTES"
    echo " ► Lecteurs montés disque, USB, CD, etc.: "

    # Affiche les lecteurs montés avec leur espace disque
    lecteursList=$(command " df -h | grep '^/dev/' " | tee /dev/tty)
    infoFile "$HOSTNAME" "Lecteurs montés:" "$lecteursList"

}


#==============================================================
# 05 - LISTE UTILISATEURS LOCAUX
#==============================================================
fonction_liste_utilisateurs_linux() {

    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    echo "► Liste des utilisateurs locaux :"

    # Affiche les utilisateurs avec UID >= 1000
    userList=$(command "awk -F':' '\$3>=1000 && \$3<60000 { print \$1 }' /etc/passwd" | tee /dev/tty)
    infoFile "$HOSTNAME" "Liste d'utilisateurs:" "$userList"
}


#==============================================================
# 06 - 5 DERNIERS LOGINS
#==============================================================
fonction_5_derniers_logins_linux() {

    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    echo "► Les 5 derniers logins :"

    # Affiche l'historique des 5 dernières connexions
    loginsList=$(command "last -n 5" | tee /dev/tty)
    infoFile "$HOSTNAME" "5 derniers logins:" "$loginsList"

}


#==============================================================
# 07 - INFORMATIONS RÉSEAU
#==============================================================
fonction_infos_reseau_linux() {

    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    echo "► Adresse IP et masque "

    # Affiche l'adresse IP et le masque
    ipMasque=$(command "ip -4 -o addr show | awk '\$2 != \"lo\" {print \"→ \" \$4}'" | tee /dev/tty)

    echo "► Passerelle par défaut "

    # Affiche la passerelle par défaut
    passerelle=$(command "ip route | awk '/default/ {print \"→ \" \$3}'" | tee /dev/tty)

    infoFile "$HOSTNAME" "Adresse IP et masque:" "$ipMasque"
    infoFile "$HOSTNAME" "Passerelle par défaut:" "$passerelle"

}


#==============================================================
# 08 - VERSION DU SYSTÈME
#==============================================================
fonction_version_os_linux() {

    logEvent "DEMANDE_VERSION_OS"
    echo "► Version de l'OS :"

    # Affiche les informations de version (distribution, release, codename)
    versionOS=$(command " lsb_release -a " | tee /dev/tty)
    infoFile "$HOSTNAME" "Version OS:" "$versionOS"

}


#==============================================================
# 09 - MISES À JOUR CRITIQUES
#==============================================================
fonction_mises_a_jour_linux() {

    logEvent "DEMANDE_MISES_A_JOUR"
    echo "► Mises à jour critiques manquantes: "

    # Affiche les paquets qui ont des mises à jour à faire
    majList=$(command "apt list --upgradable 2>/dev/null" | tee /dev/tty)
    infoFile "$HOSTNAME" "Mises à jour disponibles:" "$majList"
    # sudo_command "unattended-upgrade --dry-run -d"
    echo ""

}


#==============================================================
# 10 - MARQUE ET MODÈLE
#==============================================================
fonction_marque_modele_linux() {

    logEvent "DEMANDE_MARQUE_MODELE"
    echo "► Marque / Modèle de l'ordinateur :"

    # Fabricant
    echo "► Fabricant:"
    fabricant=$(command "cat /sys/class/dmi/id/sys_vendor" | tee /dev/tty)

    # Nom du modèle
    echo "► Modèle:"
    modele=$(command "cat /sys/class/dmi/id/product_name" | tee /dev/tty)

    # Version
    echo "► Version:"
    version=$(command "cat /sys/class/dmi/id/product_version" | tee /dev/tty)

    infoFile "$HOSTNAME" "Fabricant:" "$fabricant"
    infoFile "$HOSTNAME" "Modèle:" "$modele"
    infoFile "$HOSTNAME" "Version:" "$version"

}
