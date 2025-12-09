#!/bin/bash

# Script pour récupérer des informations sur un utilisateur
# Auteur : Pierre-Jean

fonc_date_lastconnection_windows() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          DATE DE DERNIÈRE CONNEXION              │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
    read -p "► Choisissez une option : " choix

    case $choix in

    1)
        echo ""
        echo "► Voici la liste des utilisateurs : "
        powershell_command "Get-LocalUser | Select-Object Name"

        read -p "► Quel utilisateur choisissez-vous ? : " userlastconnect
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastconnect"

        # vérification de l'existence utilisateur
        if powershell_command "Get-LocalUser -Name '$userlastconnect' -ErrorAction SilentlyContinue" >/dev/null; then
            echo ""
            echo "► L'utilisateur $userlastconnect s'est connecté pour la dernière fois : "
            lastconnection=$(powershell_command "Get-LocalUser -Name '$userlastconnect' | Select-Object Name, LastLogon" | tee /dev/tty)

            infoFile "$userlastconnect" "Dernière connexion" "$lastconnection"
            logEvent "AFFICHAGE_DE_LA_DERNIÈRE_CONNECTION_DE_L'UTILISATEUR"

            read -p "► Souhaitez-vous choisir un autre utilisateur ? (o/n) " conf

            if [ "$conf" = "o" ]; then
                fonc_date_lastconnection_windows
            else
                informationUserMainMenu
            fi

        else
            echo "► Erreur : cet utilisateur n'existe pas."
            logEvent "ERREUR_UTILISATEUR_INEXISTANT"
            fonc_date_lastconnection_windows
        fi
        ;;

    2)
        informationUserMainMenu
        ;;

    *)
        echo "Erreur de saisie"
        ;;
    esac
}

########################################################################################

fonc_date_lastpassmodif_windows() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│  DATE DE DERNIÈRE MODIFICATION DE MOT DE PASSE   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
    read -p "► Choisissez une option : " choix

    case $choix in

    1)
        echo ""
        echo "► Voici la liste des utilisateurs : "
        powershell_command "Get-LocalUser | Select-Object Name"

        read -p "► Quel utilisateur choisissez-vous ? : " userlastpass
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastpass"

        if powershell_command "Get-LocalUser -Name '$userlastpass' -ErrorAction SilentlyContinue" >/dev/null; then
            echo ""
            echo "► L'utilisateur $userlastpass a changé son mot de passe la dernière fois : "
            lastpasschange=$(powershell_command "Get-LocalUser -Name '$userlastpass' | Select-Object Name, PasswordLastSet" | tee /dev/tty)

            infoFile "$userlastpass" "Dernier changement de mot de passe" "$lastpasschange"
            logEvent "AFFICHAGE_DERNIER_CHANGEMENT_MDP"

            read -p "► Souhaitez-vous choisir un autre utilisateur ? (o/n) : " conf
            if [ "$conf" = "o" ]; then
                fonc_date_lastpassmodif_windows
            else
                informationUserMainMenu
            fi

        else
            echo "► Erreur : cet utilisateur n'existe pas."
            logEvent "ERREUR_UTILISATEUR_INEXISTANT"
            fonc_date_lastpassmodif_windows
        fi
        ;;

    2)
        informationUserMainMenu
        ;;

    *)
        echo "erreur de saisie"
        ;;
    esac
}

########################################################################################

fonc_opensessions_windows() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│  LISTE DES SESSIONS OUVERTES PAR L'UTILISATEUR   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " choix

    case $choix in

    1)
        echo "► Voici la liste des utilisateurs : "
        powershell_command "Get-LocalUser | Select-Object Name"

        read -p "► Quel utilisateur choisissez-vous ? : " userlastsession
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastsession"

        if powershell_command "Get-LocalUser -Name '$userlastsession' -ErrorAction SilentlyContinue" >/dev/null; then
            echo ""
            echo "► Voici les sessions ouvertes pour $userlastsession : "

            lastsession=$(powershell_command "quser | Select-String '$userlastsession'" | tee /dev/tty)
            infoFile "$userlastsession" "Sessions ouvertes" "$lastsession"
            logEvent "AFFICHAGE_SESSIONS_OUVERTES"

            read -p "► Souhaitez-vous choisir un autre utilisateur ? (o/n) ? : " conf

            if [ "$conf" = "o" ]; then
                fonc_opensessions_windows
            else
                informationUserMainMenu
            fi

        else
            echo "► Erreur : utilisateur introuvable."
            logEvent "ERREUR_UTILISATEUR_INEXISTANT"
            fonc_opensessions_windows
        fi
        ;;

    2)
        informationUserMainMenu
        ;;

    *)
        echo "erreur de saisie"
        ;;
    esac
}
