#!/bin/bash

# Script Bash principal du Projet 2

#=====================================================
# CHARGEMENT DES MODULES
#=====================================================

# LINUX
source ../Ressources/scripts_bash_modules/linux/scriptUsersLinux.sh
source ../Ressources/scripts_bash_modules/linux/scriptGroupsLinux.sh
source ../Ressources/scripts_bash_modules/linux/scriptGestionOrdiLinux.sh
source ../Ressources/scripts_bash_modules/scriptInfosUsersLinux.sh
source ../Ressources/scripts_bash_modules/scriptInfoOrdiLinux.sh
source ../Ressources/scripts_bash_modules/scriptSearchLog.sh

# WINDOWS
source ../Ressources/scripts_module/windows/scriptUsersWindows.sh
source ../Ressources/scripts_module/windows/scriptGroupsWindows.sh
source ../Ressources/scripts_module/windows/scriptGestionOrdiWindows.sh
source ../Ressources/scripts_module/windows/scriptSearchLogWindows.sh
source ../Ressources/scripts_module/windows/scriptInfosUsersWindows.sh

#=====================================================
# VARIABLES DES COULEURS
#=====================================================

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

#=====================================================
# JOURNALISATION
#=====================================================

#### TEMPORAIRE ####

# Chemin du fichier log
log_file="/var/log/log_evt.log"

# Vérification si le fichier existe, sinon création.
function logInit() {

    if [ ! -f "$log_file" ]; then

        sudo touch "$log_file"
        sudo chmod 777 "$log_file"

    fi
}

# Fonction enregistrement des évènements
function logEvent() {

    event="$1"
    date=$(date +%Y-%m-%d)
    heure=$(date +%H:%M:%S)
    utilisateur=$(whoami)

    context="local"
    if [ "$connexionMode" = "ssh" ]; then
        context="ssh:${remoteUser}@${remoteComputer}"
    fi

    entry="${date}_${heure}_${utilisateur}_${context}_${event}"

    echo "$entry" >>"$log_file"

}

# Fonction ajout aux logs du lancement du script
function startScript() {

    logEvent "START_SCRIPT"

}

# Fonction arrêt script avec ajout log
function stopScript() {

    logEvent "STOP_SCRIPT"
    echo ""
    echo -e "${YELLOW}► Fermeture du script${NC}"
    exit 0

}

#=====================================================
# VARIABLES DE CONNEXION
#=====================================================

export connexionMode=""
export remoteUser=""
export remoteComputer=""
export portSSH=""
export remoteOS=""

#=====================================================
# MENU EXECUTION LOCAL OU SSH
#=====================================================

function chooseExecutionMode() {

    logEvent "MENU_EXECUTION"

    echo ""
    echo "╭────────────────────────────────────────────────╮"
    echo "│           MENU EXECUTION LOCAL OU SSH          │"
    echo "├────────────────────────────────────────────────┤"
    echo "│                                                │"
    echo "│  1. Exécution locale                           │"
    echo "│  2. Exécution distante (SSH)                   │"
    echo "│  3. Quitter                                    │"
    echo "│                                                │"
    echo "╰────────────────────────────────────────────────╯"
    echo ""

    read -p "► Voulez-vous exécuter le script en Local ou à distance ? " executionMode

    case $executionMode in

    1)
        logEvent "EXECUTION_LOCAL"
        connexionMode="local"
        export connexionMode
        echo "► Exécution du script sur la machine hôte"
        echo ""
        ;;

    2)
        logEvent "EXECUTION_DISTANTE_SSH"
        connexionMode="ssh"
        export connexionMode

        echo ""
        read -p "► Entrez une Adresse IP ou Hostname : " remoteComputer
        logEvent "ADRESSE_IP_OU_HOSTNAME:$remoteComputer"

        read -p "► Entrez un Nom d'utilisateur : " remoteUser
        logEvent "NOM_UTILISATEUR:$remoteUser"

        read -p "► Entrez un Port : " portSSH
        logEvent "PORT:$portSSH"
        echo ""

        export remoteComputer
        export remoteUser
        export portSSH

        echo "► Connexion en cours : $remoteUser@$remoteComputer"
        echo ""

        logEvent "SSH_CONNEXION:$remoteUser@$remoteComputer:$portSSH"

        if ssh -o BatchMode=yes -o ConnectTimeout=5 -p"$portSSH" "$remoteUser@$remoteComputer" "echo 'Test connexion OK'" >/dev/null 2>&1; then

            echo -e "► ${GREEN}Connexion SSH réussie à $remoteUser@$remoteComputer:$portSSH. ${NC}"
            echo ""
            logEvent "SSH_CONNEXION_REUSSIE:$remoteUser@$remoteComputer:$portSSH"

        else

            echo -e "► ${RED}Impossible de se connecter à $remoteUser@$remoteComputer:$portSSH. ${NC}"
            echo ""
            logEvent "SSH_CONNEXION_ECHEC:$remoteUser@$remoteComputer:$portSSH"

            chooseExecutionMode
        fi
        ;;

    3)

        stopScript
        ;;

    *)

        logEvent "MENU_EXECUTION:ENTREE_INVALIDE"
        echo "► Entrée Invalide !\n Retour au menu"
        echo ""
        chooseExecutionMode
        ;;

    esac

    detectionRemoteOS
}

#=====================================================
# DETECTION DU SYSTEME D'EXPLOITATION
#=====================================================

function detectionRemoteOS() {

    if [ "$connexionMode" = "local" ]; then
        remoteOS="Linux"
    fi

    if ssh -p "$portSSH" "$remoteUser@$remoteComputer" "uname" 2>/dev/null | grep -q 'Linux'; then
        remoteOS="Linux"
        export remoteOS
        echo "► Système d'exploitation détecté : ${GREEN}Linux${NC}"
        logEvent "DETECTION_OS:Linux"
    fi

    if ssh -p "$portSSH" "$remoteUser@$remoteComputer" 'echo %OS%' 2>/dev/null | grep -q 'Windows'; then
        remoteOS="Windows"
        export remoteOS
        echo "► Système d'exploitation détecté : ${GREEN}Windows${NC}"
        logEvent "DETECTION_OS:Windows"
    fi
}

#=====================================================
# FONCTION DES COMMANDES
#=====================================================

# Fonction pour les commandes sans SUDO
function command() {

    local cmd="$1"

    if [ "$connexionMode" = "local" ]; then
        bash -c "$cmd"
    else
        ssh -p "$portSSH" "$remoteUser@$remoteComputer" "$cmd"
    fi

}

# Fonction pour les commandes exigeant SUDO
function sudo_command() {

    local cmd="$1"

    if [ "$connexionMode" = "local" ]; then
        bash -c "sudo $cmd"
    else
        ssh -t -o logLevel=ERROR -p "$portSSH" "$remoteUser@$remoteComputer" "sudo $cmd"
    fi

}

# Fonction pour les commandes PowerShell
function powershell_command() {

    local cmd="$1"

    ssh -p "$portSSH" "$remoteUser@$remoteComputer" "powershell.exe -Command \"$cmd\""

}

#=====================================================
# FICHIERS STOCKAGE INFORMATIONS
#=====================================================

function infoFile() {
    local cible="$1"
    local description="$2"
    local informations="$3"

    local date=$(date +%Y%m%d)
    local dossierInfo="info"
    local fichierInfo="${dossierInfo}/info_${cible}_${date}.txt"

    if [ ! -d "$dossierInfo" ]; then
        mkdir -p "$dossierInfo"
    fi

    if [ ! -f "$fichierInfo" ]; then
        touch "$fichierInfo"
    fi

    local time=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$time] $description : $informations" >>"$fichierInfo"
}

#=====================================================
# MENU PRINCPAL
#=====================================================

function mainMenu() {

    logEvent "MENU_PRINCIPAL"

    while true; do
        echo ""
        echo "╭──────────────────────────────────────────────────╮"
        echo "│                  MENU PRINCIPAL                  │"
        echo "├──────────────────────────────────────────────────┤"
        echo "│                                                  │"
        echo "│  1. Gestion des Utilisateurs                     │"
        echo "│  2. Gestions des Ordinateurs                     │"
        echo "│  3. Informations Système                         │"
        echo "│  4. Informations Utilisateur                     │"
        echo "│  5. Journalisation                               │"
        echo "│  6. Changer mode exécution                       │"
        echo "│  7. Quitter                                      │"
        echo "│                                                  │"
        echo "╰──────────────────────────────────────────────────╯"
        echo ""

        read -p "► Choisissez une option : " userChoiceMainMenu

        case $userChoiceMainMenu in

        1)
            logEvent "MENU_PRINCIPAL:GESTION_UTILISATEURS"
            userMainMenu
            ;;

        2)
            logEvent "MENU_PRINCIPAL:GESTION_ORDINATEURS"
            computerMainMenu
            ;;

        3)
            logEvent "MENU_PRINCIPAL:INFORMATIONS_SYSTEME"
            informationMainMenu
            ;;

        4)
            logEvent "MENU_PRINCIPAL:INFORMATIONS_UTILISATEURS"
            informationUserMainMenu
            ;;

        5)
            logEvent "MENU_PRINCIPAL:JOURNALISATION"
            logsMainMenu
            ;;

        6)
            logEvent "MENU_PRINCIPAL:CHANGER_MODE_EXECUTION"
            chooseExecutionMode
            ;;

        7)
            read -p "► Voulez-vous fermer le script ? (o/n) " fermetureScript
            if [ "$fermetureScript" = "o" ]; then
                stopScript
            fi
            ;;

        *)
            logEvent "MENU_PRINCIPAL:ENTREE_INVALIDE"
            echo -e "► ${RED}Entrée invalide !${NC}"
            userMainMenu
            ;;

        esac
    done

}

#=====================================================
# MENU GESTION UTILISATEUR
#=====================================================

function userMainMenu() {

    logEvent "MENU_GESTION_UTILISATEUR"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│             MENU GESTION UTILISATEUR             │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Utilisateurs                                 │"
    echo "│  2. Groupes                                      │"
    echo "│  3. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " userMainMenu

    case $userMainMenu in

    1)

        logEvent "MENU_GESTION_UTILISATEUR:UTILISATEURS"

        if [ "$remoteOS" = "Linux" ]; then

            userMenuLinux

        else

            userMenuWindows

        fi
        ;;

    2)

        logEvent "MENU_GESTION_UTILISATEUR:GROUPES"
        logEvent "MENU_GESTION_UTILISATEUR:UTILISATEURS"

        if [ "$remoteOS" = "Linux" ]; then

            fonc_menu_group_linux

        else

            fonc_menu_group_windows

        fi
        ;;

    3)

        logEvent "MENU_GESTION_UTILISATEUR:MENU_PRINCIPAL"
        mainMenu
        ;;

    *)
        logEvent "MENU_GESTION_UTILISATEUR:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        userMainMenu
        ;;

    esac

}

#=====================================================
# MENU GESTION ORDINATEURS
#=====================================================

function computerMainMenu() {

    logEvent "MENU_GESTION_ORDINATEUR"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│               Gestion Ordinateurs                │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Gestion Répertoire                           │"
    echo "│  2. Redémarrage                                  │"
    echo "│  3. Prise de main à distance (CLI)               │"
    echo "│  4. Activation du pare-feu                       │"
    echo "│  5. Exécution de script sur machine distante     │"
    echo "│  6. Retour au menu principal                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    # Demande de faire un choix
    read -p "► Choisissez une option : " choix
    echo ""

    # structure case prend la valeur $choix de cherche et excécute
    case "$choix" in

    1)
        #appel au script de gestion de repertoire
        logEvent "MENU_GESTION_ORDINATEURS:GESTION_REPERTOIRE"

        if [ "$remoteOS" = "Linux" ]; then

            gestion_repertoire_menu_linux

        else

            gestion_repertoire_menu_windows

        fi
        ;;

    2)
        # appel la fonction de redemarrage
        logEvent "MENU_GESTION_ORDINATEURS:REDEMARRAGE"
        if [ "$remoteOS" = "Linux" ]; then

            fonction_redemarrage_linux

        else

            fonction_redemarrage_windows

        fi
        ;;

    3)

        # appel la fonction de prise à main distance
        logEvent "MENU_GESTION_ORDINATEURS:PRISE_EN_MAIN_A_DISTANCE"
        if [ "$remoteOS" = "Linux" ]; then

            fonction_prise_main_linux

        else

            fonction_prise_main_windows

        fi
        ;;

    4)
        # appel la fonction de activer le parefeu
        logEvent "MENU_GESTION_ORDINATEURS:ACTIVATION_PAREFEU"
        if [ "$remoteOS" = "Linux" ]; then

            fonction_activer_parefeu_linux

        else

            fonction_activer_parefeu_windows

        fi
        ;;

    5)
        # appel la fonction de excution de script locale
        logEvent "MENU_GESTION_ORDINATEURS:EXECUTION_SCRIPT"
        if [ "$remoteOS" = "Linux" ]; then

            fonction_exec_script_linux

        else

            fonction_exec_script_windows

        fi
        ;;

    6)
        # retour au menu principal
        logEvent "MENU_GESTION_ORDINATEURS:MENU_PRINCIPAL"
        mainMenu
        ;;

    *)
        # si autre chosse c'est un valide
        logEvent "MENU_GESTION_UTILISATEUR:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        ;;

    esac
}

#=====================================================
# MENU INFORMATIONS SYSTEME
#=====================================================

function informationMainMenu() {

    logEvent "MENU_INFOMATIONS_SYSTEME"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│            MENU INFORMATIONS SYSTEME             │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Liste des utilisateurs                       │"
    echo "│  2. Afficher les 5 derniers logins               │"
    echo "│  3. Afficher adresse IP, masque, passerelle      │"
    echo "│  4. Informations disque dur                      │"
    echo "│  5. Version de l'OS                              │"
    echo "│  6. Mises à jour critiques manquantes            │"
    echo "│  7. Afficher marque/modèle de l'ordinateur       │"
    echo "│  8. Statut UAC                                   │"
    echo "│  9. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " informationMainMenu

    case $informationMainMenu in

    1)

        logEvent "MENU_INFORMATIONS_SYSTEME:LISTE_UTILISATEURS"
        fonction_liste_utilisateurs_linux
        ;;

    2)

        logEvent "MENU_INFORMATIONS_SYSTEME:5_DERNIERS_LOGINS"
        fonction_5_derniers_logins_linux
        ;;
    3)

        logEvent "MENU_INFORMATIONS_SYSTEME:AFFICHE_IP_MASQUE_PASSERELLE"
        fonction_infos_reseau_linux
        ;;
    4)

        logEvent "MENU_INFORMATIONS_SYSTEME:INFORMATIONS_DISQUES_DUR"
        gestion_disques_menu_linux
        ;;

    5)

        logEvent "MENU_INFORMATIONS_SYSTEME:VERSION_OS"
        fonction_version_os_linux
        ;;

    6)

        logEvent "MENU_INFORMATIONS_SYSTEME:MISES_A_JOUR_MANQUANTES"
        fonction_mises_a_jour_linux
        ;;

    7)

        logEvent "MENU_INFORMATIONS_SYSTEME:MARQUE_MODELE_ORDINATEUR"
        fonction_marque_modele_linux
        ;;

    8)

        logEvent "MENU_INFORMATIONS_SYSTEME:STATUS_UAC"
        echo "Statut UAC"
        ;;

    9)

        logEvent "MENU_INFORMATIONS_SYSTEME:MENU_PRINCIPAL"
        mainMenu
        ;;

    *)

        logEvent "MENU_INFORMATIONS_SYSTEME:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        informationMainMenu
        ;;

    esac
}

#=====================================================
# MENU INFORMATIONS UTILISATEUR
#=====================================================

function informationUserMainMenu() {

    logEvent "MENU_INFORMATIONS_UTILISATEUR"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEUR           │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date dernière connexion                      │"
    echo "│  2. Date dernière modification de mot de passe   │"
    echo "│  3. Liste des sessions ouvertes                  │"
    echo "│  4. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " informationUserMenu

    case $informationUserMenu in

    1)

        logEvent "MENU_INFORMATIONS_UTILISATEUR:DATE_DERNIERE_CONNEXION"
        if [ "$remoteOS" = "Linux" ]; then

            fonc_date_lastconnection_linux

        else

            fonc_date_lastconnection_windows

        fi
        ;;
    2)

        logEvent "MENU_INFORMATIONS_UTILISATEUR:DATE_DERNIERE_MODIFICATION_MOT_DE_PASSE"
        if [ "$remoteOS" = "Linux" ]; then

            fonc_date_lastpassmodif_linux

        else

            fonc_date_lastpassmodif_windows

        fi
        ;;

    3)

        logEvent "MENU_INFORMATIONS_UTILISATEUR:LISTE_SESSIONS_OUVERTES"

        if [ "$remoteOS" = "Linux" ]; then

            fonc_opensessions_linux

        else

            fonc_opensessions_windows

        fi
        ;;

    4)

        logEvent "MENU_INFORMATIONS_UTILISATEUR:MENU_PRINCIPAL"
        mainMenu
        ;;

    *)

        logEvent "MENU_INFORMATIONS_UTILISATEUR:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        informationUserMainMenu
        ;;

    esac
}

#=====================================================
# MENU JOURNALISATION
#=====================================================

function logsMainMenu() {

    logEvent "MENU_JOURNALISATION"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│               MENU JOURNALISATION                │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Recherche log Utilisateur                    │"
    echo "│  2. Recherche log utilisateur distant (SSH)      │"
    echo "│  3. Recherche log Ordinateur local               │"
    echo "│  4. Recherche log Ordinateur distant (SSH)       │"
    echo "│  5. Afficher le fichier de journalisation        │"
    echo "│  6. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " logsMenu

    case $logsMenu in

    1)

        logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_UTILISATEUR"
        searchUser
        ;;

    2)

        logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_UTILISATEUR_SSH"
        searchUserSsh
        ;;

    3)
        logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_ORDINATEURS_LOCAL"
        searchComputerLocal
        ;;

    4)

        logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_ORDINATEURS_DISTANT_SSH"
        searchComputerSsh
        ;;

    5)

        logEvent "MENU_JOURNALISATION:AFFICHAGE_FICHIER_JOURNALISATION"
        less +G /var/log/log_evt.log
        ;;

    6)

        logEvent "MENU_JOURNALISATION:RETOUR_MENU_PRINCIPAL"
        mainMenu
        ;;

    *)

        logEvent "MENU_JOURNALISATION:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        logsMainMenu
        ;;

    esac

}

#=====================================================
# EXECUTION DU SCRIPT
#=====================================================

logInit
startScript
chooseExecutionMode
mainMenu
