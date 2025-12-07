#!/bin/bash

# Script pour récupérer des informations sur un utilisateur
# Auteur : Pierre-Jean

fonc_menu_infosutilisateurs() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date de dernière connexion                   │"
    echo "│  2. Date de dernière modification du mot de passe│"
    echo "│  3. Liste des sessions ouvertes                  │"
    echo "│  4. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
    echo -n "Votre choix (1-4): "
    read selection

    case $selection in
    1)
        logEvent "MENU_GROUPES:RECHERCHE_DERNIÈRE_CONNECTION_UTILISATEUR"
        fonc_date_lastconnection
        ;;
    2)
        logEvent "MENU_GROUPES:RECHERCHE_DERNIÈRE_MODIFICATION_DE_MOT_DE_PASSE"
        fonc_date_lastpassmodif
        ;;
    3)
        logEvent "MENU_GROUPES:RECHERCHE_DERNIÈRES_SESSIONS_OUVERTES"
        fonc_opensessions
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac
}

fonc_date_lastconnection() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          DATE DE DERNIÈRE CONNEXION              |"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        echo "Voici la liste des utilisateurs : "
        command "awk -F':' '\$3>=1000 { print \$1 }' /etc/passwd"
        read -p "Quel utilisateur choisissez-vous  ? : " userlastconnect

        # l'utilisateur existe ?
        if
            command "cat /etc/passwd | grep -w $userlastconnect >/dev/null"
            logEvent "ENTRÉE_D'UTILISATEUR:$userlastconnect"
        # si il existe on affiche l'info
        then
            echo "L'utilisateur $userlastconnect s'est connecté pour la dernière fois : "
            command "last -1 \$userlastconnect | head -1 | awk '{print \$4, \$5, \$6, \$7}'"
            logEvent "AFFICHAGE_DE_LA_DERNIÈRE_CONNECTION_DE_L'UTILISATEUR"
            echo "Souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non" conf

            if [ $conf = "o" ]; then # si oui on relance la fonction
                fonc_date_lastconnection
            else
                fonc_menu_infosutilisateurs
            fi
        # sinon on retoure au menu précédent
        else
            echo "Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE,_RETOUR_AU_MENU_PRÉCÉDENT"
            fonc_date_lastconnection
        fi
        ;;
    2)
        fonc_menu_infosutilisateurs
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac
}

fonc_date_lastpassmodif() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│  DATE DE DERNIÈRE MODIFICATION DE MOT DE PASSE   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)

        echo "Voici la liste des utilisateurs : "
        command "awk -F':' '\$3>=1000 { print \$1 }' /etc/passwd"
        read -p "Quel utilisateur choisissez-vous  ? : " userlastpass
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastpass"

        # l'utilisateur existe ?
        if
            command "cat /etc/passwd | grep -w $userlastpass >/dev/null"

        # si il existe on affiche l'info
        then
            echo "L'utilisateur $userlastpass à changé son mot de passe la dernière fois : "
            command "chage -l $userlastpass | head -1 | awk '{print \$8, \$9, \$10}'"
            logEvent "AFFICHAGE_DE_LA_DATE_DU_DERNIER_CHANGEMENT_DE_MDP_DE_L'UTILISATEUR"
            echo "Souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non" conf

            if [ $conf = "o" ]; then # si oui on relance la fonction
                fonc_date_lastpassmodif
            else
                fonc_menu_infosutilisateurs
            fi
        # sinon on retoure au menu précédent
        else
            echo "Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE"
            fonc_date_lastconnection
        fi
        ;;

    2)
        fonc_menu_infosutilisateurs
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac

}

fonc_opensessions() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│  LISTE DES SESSIONS OUVERTES PAR L'UTILISATEUR   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        echo "Voici la liste des utilisateurs : "
        command "awk -F':' '\$3>=1000 { print \$1 }' /etc/passwd"
        read -p "Quel utilisateur choisissez-vous  ? : " userlastsession
        logEvent "ENTRÉE_D'UTILISATEUR:$userlastsession"

        # l'utilisateur existe ?
        if
            command "cat /etc/passwd | grep -w $userlastsession" >/dev/null

        # si il existe on affiche l'info
        then
            echo "voici la liste des sessions ouvertes par $userlastsession : "
            command "who | grep $userlastsession"
            logEvent "AFFICHAGE_DE_LA_LISTE_DES_SESSIONS_OUVERTES_PAR_L'UTILISATEUR"
            echo "Souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non" conf

            if [ $conf = "o" ]; then # si oui on relance la fonction
                fonc_opensessions
            else
                fonc_menu_infosutilisateurs
            fi
        else
            echo "Erreur de saisie, retour au menu précédent"
            logEvent "ERREUR_DE_SAISIE"
            fonc_date_lastconnection
        fi
        ;;
    2)
        fonc_menu_infosutilisateurs
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac

}
