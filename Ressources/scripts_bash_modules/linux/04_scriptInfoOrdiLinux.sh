#!/bin/bash

##################################### Menu Gestion Disques ####################################

# Menu principal de gestion des disques
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

#################################### Fonction Nombre de disques ##########################################

# Compte et affiche le nombre de disques physiques
fonction_nombre_disques_linux() {

    logEvent "DEMANDE_NOMBRE_DISQUES"
    echo " ► Nombre de disques : "

    # Liste les disques et compte leur nombre
    nombreDisques=$(command "lsblk | grep 'disk' | wc -l" | tee /dev/tty)
    infoFile "$HOSTNAME" "Nombre de disques:" "$nombreDisques"

}

#################################### Fonction Partitions ###################################################

# Affiche les partitions avec leurs détails et leur nombre total
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

#################################### Fonction Lecteurs montés ############################################

# Affiche tous les lecteurs physiques actuellement montés
fonction_lecteurs_montes_linux() {

    logEvent "DEMANDE_LECTEURS_MONTES"
    echo " ► Lecteurs montés disque, USB, CD, etc.: "

    # Affiche les lecteurs montés avec leur espace disque
    lecteursList=$(command " df -h | grep '^/dev/' " | tee /dev/tty)
    infoFile "$HOSTNAME" "Lecteurs montés:" "$lecteursList"

}

#################################### Fonction liste utilisateurs locaux #################################

# Liste les utilisateurs locaux (non système)
fonction_liste_utilisateurs_linux() {

    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    echo "► Liste des utilisateurs locaux :"

    # Affiche les utilisateurs avec UID >= 1000
    userList=$(command "awk -F':' '\$3>=1000 && \$3<60000 { print \$1 }' /etc/passwd" | tee /dev/tty)
    infoFile "$HOSTNAME" "Liste d'utilisateurs:" "$userList"
}

#################################### Fonction 5 derniers logins #######################################

# Affiche les 5 dernières connexions utilisateurs
fonction_5_derniers_logins_linux() {

    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    echo "► Les 5 derniers logins :"

    # Affiche l'historique des 5 dernières connexions
    loginsList=$(command "last -n 5" | tee /dev/tty)
    infoFile "$HOSTNAME" "5 derniers logins:" "$loginsList"

}

#################################### Fonction IP, masque, passerelle ####################################

# Affiche les informations réseau (IP, masque et passerelle)
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

#################################### Fonction : Version OS ####################################

# Affiche la version du système d'exploitation
fonction_version_os_linux() {

    logEvent "DEMANDE_VERSION_OS"
    echo "► Version de l'OS :"

    # Affiche les informations de version (distribution, release, codename)
    versionOS=$(command " lsb_release -a " | tee /dev/tty)
    infoFile "$HOSTNAME" "Version OS:" "$versionOS"

}

#################################### Fonction : Mises à jour critiques ####################################

# Liste les mises à jour disponibles
fonction_mises_a_jour_linux() {

    logEvent "DEMANDE_MISES_A_JOUR"
    echo "► Mises à jour critiques manquantes: "

    # Affiche les paquets qui ont des mises à jour à faire
    majList=$(command "apt list --upgradable 2>/dev/null" | tee /dev/tty)
    infoFile "$HOSTNAME" "Mises à jour disponibles:" "$majList"
    # sudo_command "unattended-upgrade --dry-run -d"
    echo ""

}

#################################### Fonction : Marque / Modèle ####################################

# Affiche les informations matérielles marque et modèle
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
