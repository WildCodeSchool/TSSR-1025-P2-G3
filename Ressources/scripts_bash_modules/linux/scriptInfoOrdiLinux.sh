#!/bin/bash


##################################### Menu Gestion Disques ####################################

# Menu principal de gestion des disques
gestion_disques_menu() {

logEvent "MENU_GESTION_DISQUES"

        while true; do

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

    read -p "# Choisissez une option : " choix

    logEvent  " Choisie ${choix^^} "


    case "$choix" in

        1)
            # Appel de la fonction pour compter les disques
            logEvent "SELECTION_NOMBRE_DISQUES"
            fonction_nombre_disques
        ;;

        2)
            # Appel de la fonction pour lister les partitions
            logEvent "SELECTION_PARTITIONS"
            fonction_partitions
        ;;

        3)
            # Appel de la fonction pour afficher les lecteurs montés
            logEvent "SELECTION_LECTEURS_MONTES"
            fonction_lecteurs_montes
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
fonction_nombre_disques() {

    logEvent "DEMANDE_NOMBRE_DISQUES"
    echo " ► Nombre de disques : "

    # Liste les disques et compte leur nombre
    lsblk | grep "disk" | wc -l

}

#################################### Fonction Partitions ###################################################

# Affiche les partitions avec leurs détails et leur nombre total
fonction_partitions() {

    logEvent "DEMANDE_LISTE_PARTITIONS"
    echo " ► Partitions Nom, FS, Taille : "

    # Affiche les partitions avec nom, type de système de fichiers et taille
    lsblk -o NAME,FSTYPE,SIZE,TYPE | grep "part"

    echo " ► Nombre de partitions : "
    # Compte le nombre total de partitions
    lsblk -o NAME,TYPE | grep "part" | wc -l

}

#################################### Fonction Lecteurs montés ############################################

# Affiche tous les lecteurs physiques actuellement montés
fonction_lecteurs_montes() {

    logEvent "DEMANDE_LECTEURS_MONTES"
    echo " ► Lecteurs montés disque, USB, CD, etc.: "

    # Affiche les lecteurs montés avec leur espace disque
    df -h | grep "^/dev/"

}


#################################### Fonction liste utilisateurs locaux #################################

# Liste les utilisateurs locaux (non système)
fonction_liste_utilisateurs() {

    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    echo " ► Liste des utilisateurs locaux "

    # Affiche les utilisateurs avec UID >= 1000
    awk -F':' '$3>=1000 { print $1 }' /etc/passwd
}


#################################### Fonction 5 derniers logins #######################################

# Affiche les 5 dernières connexions utilisateurs
fonction_5_derniers_logins() {

    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    echo " ► Les 5 derniers logins :"

    # Affiche l'historique des 5 dernières connexions
    last -n 5
}


#################################### Fonction IP, masque, passerelle ####################################

# Affiche les informations réseau (IP, masque et passerelle)
fonction_infos_reseau() {

    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    echo  " ► Adresse IP et masque "

    # Affiche l'adresse IP et le masque hors loopback
    ip -4 -o addr show | awk '$2 != "lo" {print "→ " $4}'

    echo " ► Passerelle par défaut "

    # Affiche la passerelle par défaut
    ip route | awk '/default/ {print "→ " $3}'
}

#################################### Fonction : Version OS ####################################

# Affiche la version du système d'exploitation
fonction_version_os() {

    logEvent "DEMANDE_VERSION_OS"
    echo " ► Version de l'OS : "

    # Affiche les informations de version (distribution, release, codename)
    lsb_release -a

}

#################################### Fonction : Mises à jour critiques ####################################

# Liste les mises à jour disponibles
fonction_mises_a_jour() {

    logEvent "DEMANDE_MISES_A_JOUR"
    echo " ► Mises à jour critiques manquantes: "

    # Affiche les paquets qui ont des mises à jour à faire
    apt list --upgradable 2>/dev/null


}

#################################### Fonction : Marque / Modèle ####################################

# Affiche les informations matérielles marque et modèle
fonction_marque_modele() {

    logEvent "DEMANDE_MARQUE_MODELE"
    echo "► Marque / Modèle de l'ordinateur :"

    # Extrait et affiche le fabricant du système
    sudo_command dmidecode -t system | grep "Manufacturer" | cut -d ':' -f2
    # Extrait et affice le nom du modèle
    sudo_command dmidecode -t system | grep "Product Name" | cut -d ':' -f2
    # Extrait et affiche la version du modèle
    sudo_command dmidecode -t system | grep "Version" | cut -d ':' -f2

}
