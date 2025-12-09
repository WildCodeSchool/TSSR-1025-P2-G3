#!/bin/bash

# Script pour récupérer des informations sur un utilisateur
# Auteur : Pierre-Jean

fonc_date_lastconnection_windows() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          DATE DE DERNIÈRE CONNEXION              |"
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

        read -p "► Quel utilisateur choisissez-vous  ? : " userlastconnect

        # l'utilisateur existe ?
        if
            powershell_command "Get-LocalUser -Name '$userlastconnect' -ErrorAction SilentlyContinue" >/dev/null
            logEvent "ENTRÉE_D'UTILISATEUR:$userlastconnect"

        # si il existe on affiche l'info
        then
            echo ""
            echo "► L'utilisateur $userlastconnect s'est connecté pour la dernière fois : "

            lastconnection=$(powershell_command Get-ADUser -Identity "$userlastconnect" -Properties LastLogonDate | Select-Object Name, LastLogonDate | tee /dev/tty)
            infoFile "$userlastconnect" "Dernière connexion" "$lastconnection"
            logEvent "AFFICHAGE_DE_LA_DERNIÈRE_CONNECTION_DE_L'UTILISATEUR"

            read -p "► Souhaitez vous choisir un autre utilisateur ? (o/n) " conf

            if [ $conf = "o" ]; then # si oui on relance la fonction

                fonc_date_lastconnection_linux

            else

                informationUserMainMenu

            fi

        # sinon on retoure au menu précédent
        else

            echo "► Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE,_RETOUR_AU_MENU_PRÉCÉDENT"
            fonc_date_lastconnection_linux

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

        read -p "► Quel utilisateur choisissez-vous  ? : " userlastpass
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastpass"

        # l'utilisateur existe ?
        if

            powershell_command "Get-LocalUser -Name '$userlastpass' -ErrorAction SilentlyContinue" >/dev/null

        # si il existe on affiche l'info
        then

            echo ""
            echo "► L'utilisateur $userlastpass à changé son mot de passe la dernière fois : "
            lastpasschange=$(powershell_command Get-ADUser -Identity $userlastpass -Properties PasswordLastSet | Select-Object Name, PasswordLastSet | tee /dev/tty)
            infoFile "$userlastpass" "À changé son mot de passe pour la dernière fois" "$lastpasschange"
            logEvent "AFFICHAGE_DE_LA_DATE_DU_DERNIER_CHANGEMENT_DE_MDP_DE_L'UTILISATEUR"
            echo ""

            read -p "Souhaitez vous choisir un autre utilisateur (o/n) ? : " conf

            if [ $conf = "o" ]; then # si oui on relance la fonction

                fonc_date_lastpassmodif_windows

            else

                informationUserMainMenu

            fi

        # sinon on retoure au menu précédent
        else

            echo "► Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE"
            fonc_date_lastconnection_windows

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

fonc_opensessions_linux() {

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

        read -p "► Quel utilisateur choisissez-vous  ? : " userlastsession
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastsession"

        # l'utilisateur existe ?
        if

            powershell_command "Get-LocalUser -Name '$userlastconnect' -ErrorAction SilentlyContinue" >/dev/null

        # si il existe on affiche l'info
        then
            echo ""
            echo "► Voici la liste des sessions ouvertes par $userlastsession : "

            lastsession=$(powershell_command quser | Select-String "$userlastsession" | tee /dev/tty)
            infoFile "$userlastsession" "Sessions ouvertes" "$lastsession"
            logEvent "AFFICHAGE_DE_LA_LISTE_DES_SESSIONS_OUVERTES_PAR_L'UTILISATEUR"

            echo ""
            read -p "► Souhaitez vous choisir un autre utilisateur (o/n) ? : " conf

            if [ $conf = "o" ]; then # si oui on relance la fonction

                fonc_opensessions_linux

            else

                informationUserMainMenu

            fi

        else

            echo "► Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE"
            fonc_date_lastconnection_linux

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
