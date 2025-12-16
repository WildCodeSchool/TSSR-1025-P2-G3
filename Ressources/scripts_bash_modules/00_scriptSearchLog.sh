#!/usr/bin/env bash

# Script de recherche dans le fichier de journalisation
# Auteur : Christian


# Sommaire :
# 01 - Recherche utilisateurs
# 02 - Recherche utilisateurs SSH
# 03 - Recherche Ordinateur Local
# 04 - Recherche Ordinateur SSH
# 05 - Menu Filtrage Recherche



#==============================================================
#region 01 - RECHERCHE UTILISATEURS
#==============================================================
function searchUser() {

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT"

    read -p "► Entrez un nom d'utilisateur à rechercher : " userScriptSearch

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT:$userScriptSearch"

    resultats=$(awk -F'_' -v user="$userScriptSearch" '$3 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        echo ""
        read -p "Appuyez sur ENTRÉE pour continuer..."

    else

        logEvent "UTILISATEUR_INEXISTANT:$userScriptSearch"
        echo ""
        echo "► L'utilisateur $userScriptSearch n'existe pas dans la journalisation"

    fi

    logsMainMenu

}
#endregion


#==============================================================
#region 02 - RECHERCHE UTILISATEURS SSH
#==============================================================
function searchUserSsh() {

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH"

    read -p "► Entrez un nom d'utilisateur distant à rechercher : " userScriptSearchSSH

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH:$userScriptSearchSSH"

    resultats=$(awk -F'_' -v user="$userScriptSearchSSH" '$4 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        echo ""
        read -p "► Appuyez sur ENTRÉE pour continuer..."

    else
        logEvent "UTILISATEUR_SSH_INEXISTANT:$userScriptSearchSSH"
        echo ""
        echo "► L'utilisateur $userScriptSearchSSH n'existe pas dans la journalisation"

    fi

    logsMainMenu

}
#endregion


#==============================================================
#region 03 - RECHERCHE ORDINATEURS LOCAL
#==============================================================
function searchComputerLocal() {

    logEvent "RECHERCHE_LOGS_ORDINATEUR_LOCAL"

    resultats=$(awk -F'_' -v user="local" '$4 ~ user' /var/log/log_evt.log)


    if [ -n "$resultats" ]; then

        menuSearchlog
        echo ""
        read -p "► Appuyez sur ENTRÉE pour continuer..."

    fi

    logsMainMenu

}
#endregion


#==============================================================
#region 04 - RECHERCHE ORDINATEURS SSH
#==============================================================
function searchComputerSsh() {

    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH"

    read -p "► Entrez un nom d'ordinateur distant à rechercher : " computerScriptSearchSSH

    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH:$computerScriptSearchSSH"

    resultats=$(awk -F'_' -v user="$computerScriptSearchSSH" '$4 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        echo ""
        read -p "► Appuyez sur ENTRÉE pour continuer..."

    else

        logEvent "ORDINATEUR_INEXISTANT:$userScriptSearch"
        echo "► L'ordinateur $computerScriptSearchSSH n'existe pas dans la journalisation"

    fi

    logsMainMenu

}
#endregion


#==============================================================
#region 05 - FONCTION FILTRAGE DE RECHERCHE
#==============================================================
function menuSearchlog() {

    logEvent "MENU_FILTRAGE_RECHERCHE"

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│             MENU FILTRAGE RECHERCHE              │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Afficher les 20 derniers logs                │"
    echo "│  2. Afficher page par page                       │"
    echo "│  3. Afficher tous les résultats                  │"
    echo "│  4. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " menuSearch

    case $menuSearch in

    1)
        logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_20_DERNIERS_RESULTATS"
        echo "$resultats" | tail -n 20
        ;;

    2)
        logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_PAGE_PAR_PAGE"
        echo "$resultats" | less +G
        ;;

    3)
        logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_TOUS_LES_RESULTATS"
        echo "$resultats"
        ;;
    4)
        logEvent "MENU_FILTRAGE_RECHERCHE:MENU_PRECEDENT"
        logsMainMenu
        ;;
    esac
}
#endregion
