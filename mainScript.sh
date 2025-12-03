#!/bin/bash

# Script Bash principal du Projet 2

#=====================================================
# CHARGEMENT DES MODULES
#=====================================================

source scriptUsers.sh
source scriptGroups.sh
source scriptFolder.sh

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
log_file="log_evt.log"

# Vérification si le fichier existe, sinon création.
function logInit() {

    if [ ! -f "$log_file" ]; then

        sudo touch "$log_file"
        sudo chmod 777 "$log_file"

    fi
}

# Enregistrement des évènements

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

function logEventUser() {

    event="$1"
    date=$(date +%Y-%m-%d)
    heure=$(date +%H:%M:%S)
    utilisateur=$(whoami)


    context="local"
    if [ "$connexionMode" = "ssh" ]; then
        context="ssh:${remoteUser}@${remoteComputer}"
    fi

    entry="${date}_${heure}_${utilisateur}_${context}_"USER"_${event}"

    echo "$entry" >>"$log_file"

}

function logEventComputer() {

    event="$1"
    date=$(date +%Y-%m-%d)
    heure=$(date +%H:%M:%S)
    utilisateur=$(whoami)

    context="local"
    if [ "$connexionMode" = "ssh" ]; then
        context="ssh:${remoteUser}@${remoteComputer}"
    fi

    entry="${date}_${heure}_${utilisateur}_${context}_"COMPUTER"_${event}"

    echo "$entry" >>"$log_file"

}

function startScript(){
    logEvent "Start script"
}


logInit
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
    logEvent "Menu Execution"
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
    logEvent "Entrée utilisateur $executionMode"

    case $executionMode in

    1)
        connexionMode="local"
        export connexionMode
        logEvent "Exécution du script sur la machine hôte"
        echo "► Exécution du script sur la machine hôte"
        echo ""
        ;;

    2)

        connexionMode="ssh"
        export connexionMode

        echo ""
        read -p "► Entrez une Adresse IP ou Hostname : " remoteComputer
        logEvent "Adresse IP ou Hostname : $remoteComputer"
        read -p "► Entrez un Nom d'utilisateur : " remoteUser
        logEvent "Nom d'utilisateur : $remoteUser"
        read -p "► Entrez un Port : " portSSH
        logEvent "Port : $portSSH"
        echo ""

        export remoteComputer
        export remoteUser
        export portSSH

        echo "► Connexion en cours : $remoteUser@$remoteComputer"
        echo ""

        if ssh -o BatchMode=yes -o ConnectTimeout=5 -p"$portSSH" "$remoteUser@$remoteComputer" "echo 'Test connexion OK'" >/dev/null 2>&1; then

            echo -e "► ${GREEN}Connexion SSH réussie à $remoteUser@$remoteComputer:$portSSH. ${NC}"
            echo ""
        else

            echo -e "► ${RED}Impossible de se connecter à $remoteUser@$remoteComputer:$portSSH. ${NC}"
            echo ""
            chooseExecutionMode
        fi
        ;;

    3)
        logEvent "Stop Script"
        echo "► Fermeture du script"
        exit 0
        ;;

    *)
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

    if ssh -p "$portSSH" "$remoteUser@$remoteComputer" "uname" 2>/dev/null | grep -q 'Linux'; then
        remoteOS="Linux"
        export remoteOS
        echo "► Système d'exploitation détecté : Linux"
    fi

    if ssh -p "$portSSH" "$remoteUser@$remoteComputer" 'echo %OS%' 2>/dev/null | grep -q 'Windows'; then
        remoteOS="Windows"
        export remoteOS
        echo "► Système d'exploitation détecté : Windows"
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

# Fonction pour les commandes Powershell
# function powershell_command(){

# }

#=====================================================
# MENU PRINCPAL
#=====================================================

function mainMenu() {

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
            userMainMenu
            ;;

        2)
            computerMainMenu
            ;;

        3)
            informationMainMenu
            ;;

        4)
            informationUserMainMenu
            ;;

        5)
            logsMainMenu
            ;;

        6)
            chooseExecutionMode
            ;;

        7)
            read -p "► Voulez-vous fermer le script ? (o/n) " fermetureScript
            if [ "$fermetureScript" = "o" ]; then
                logEvent "Stop Script"
                echo ""
                echo "► Fermeture du script."
                exit 0
            fi
            ;;
        esac
    done

}

function userMainMenu() {

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
        userMenu
        ;;

    2)
        fonc_menu_group
        ;;

    3)
        mainMenu
        ;;

    *)
        echo "► Entrée Invalide"
        userMainMenu
        ;;
    esac

}

function computerMainMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│             MENU GESTION ORDINATEUR              │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Répertoire                                   │"
    echo "│  2. Redémarrer                                   │"
    echo "│  3. Activer le Pare-Feu                          │"
    echo "│  4. Prise de main à distance (CLI)               │"
    echo "│  5. Exécuter un script                           │"
    echo "│  6. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " computerMainMenu

    case $computerMainMenu in

    1)
        repertoireMenu
        ;;

    6)
        mainMenu
        ;;

    *)
        echo "► Entrée Invalide"
        computerMainMenu
        ;;
    esac
}

function informationMainMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│            MENU INFORMATIONS SYSTEME             │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Liste des utilisateurs                       │"
    echo "│  2. Afficher adresse IP, masque, passerelle      │"
    echo "│  3. Informations disque dur                      │"
    echo "│  4. Version de l'OS                              │"
    echo "│  5. Mises à jour critiques manquantes            │"
    echo "│  6. Afficher marque/modèle de l'ordinateur       │"
    echo "│  7. Statut UAC                                   │"
    echo "│  8. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " informationMainMenu

    case $informationMainMenu in

    1)

        echo "blabla"
        ;;

    8)

        mainMenu
        ;;

    *)
        echo "► Entrée Invalide"
        informationMainMenu
        ;;

    esac
}

function informationUserMainMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date dernière connexion                      │"
    echo "│  2. Date dernière modification de mot de passe   │"
    echo "│  3. Liste des sessions ouvertes                  │"
    echo "│  4. Afficher les 5 derniers logins               │"
    echo "│  5. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " informationUserMenu

    case $informationUserMenu in

    1)

        echo "blabla"
        ;;
    2)

        echo "blabla"
        ;;

    5)
        mainMenu
        ;;

    *)
        echo "► Entrée Invalide"
        informationUserMainMenu
        ;;

    esac
}

function logsMainMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│               MENU JOURNALISATION                │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Recherche log Utilisateur                    │"
    echo "│  2. Recherche log Ordinateur                     │"
    echo "│  3. Menu Principal                               │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " logsMenu

    case $logsMenu in

    1)

        echo "blabla"
        ;;
    2)

        echo "blabla"
        ;;
    3)

        mainMenu
        ;;

    *)
        echo "► Entrée Invalide"
        logsMainMenu
        ;;

    esac

}

#=====================================================
# EXECUTION DU SCRIPT
#=====================================================

startScript
chooseExecutionMode
mainMenu
