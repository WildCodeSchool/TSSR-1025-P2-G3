#!/usr/bin/env bash

# Script de recherche dans le fichier de journalisation
# Auteur : Christian

#=====================================================
# FONCTION RECHERCHE UTILISATEURS
#=====================================================


function searchUser() {

    read -p "Entrez un nom d'utilisateur à rechercher : " userScriptSearch

    resultats=$(awk -F'_' -v user="$userScriptSearch" '$3 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        read -p "Appuyez sur ENTRÉE pour continuer..."

    else

        echo "Cet utilisateur n'existe pas dans la journalisation"

    fi

    logsMainMenu

}

function searchUserSsh() {

    read -p "Entrez un nom d'utilisateur distant à rechercher : " userScriptSearchSSH

    resultats=$(awk -F'_' -v user="$userScriptSearchSSH" '$4 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        read -p "Appuyez sur ENTRÉE pour continuer..."

    else

        echo "Cet utilisateur n'existe pas dans la journalisation"

    fi

    logsMainMenu

}

function searchComputerLocal() {

    resultats=$(awk -F'_' -v user="local" '$4 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        read -p "Appuyez sur ENTRÉE pour continuer..."

    fi

    logsMainMenu

}

function searchComputerSsh() {

    read -p "Entrez un nom d'ordinateur distant à rechercher : " computerScriptSearchSSH

    resultats=$(awk -F'_' -v user="$computerScriptSearchSSH" '$4 ~ user' /var/log/log_evt.log)

    if [ -n "$resultats" ]; then

        menuSearchlog
        read -p "Appuyez sur ENTRÉE pour continuer..."

    else

        echo "Cet ordinateur n'existe pas dans la journalisation"

    fi

    logsMainMenu

}

#=====================================================
# FONCTION FILTRAGE RECHERCHE
#=====================================================

function menuSearchlog() {

    echo ""
    echo "╭────────────────────────────────────────────────╮"
    echo "│           MENU EXECUTION LOCAL OU SSH          │"
    echo "├────────────────────────────────────────────────┤"
    echo "│                                                │"
    echo "│  1. Afficher les 20 derniers logs              │"
    echo "│  2. Afficher Page par Page                     │"
    echo "│  3. Afficher tous les résultats                │"
    echo "│  3. Quitter                                    │"
    echo "│                                                │"
    echo "╰────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " menuSearch

    case $menuSearch in

    1)

        echo "$resultats" | tail -n 20
        ;;

    2)

        echo "$resultats" | less
        ;;

    3)
        echo "$resultats"
        ;;

    esac
}
