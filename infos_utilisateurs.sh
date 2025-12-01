#!/bin/bash

#Date de dernière connexion d’un utilisateur

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
        fonc_date_lastconnection
        ;;
    2)
        fonc_date_lastpassmodif
        ;;
    3)
        fonc_opensessions
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac
}

fonc_date_lastconnection() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date de dernière connexion                   │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        echo "infos"
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
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date de dernière modification du mot de passe│"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        echo "infos"
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
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Liste des sessions ouvertes                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        echo "infos"
        ;;
    2)
        fonc_menu_infosutilisateurs
        ;;
    *)
        echo "erreur de saisie"
        ;;
    esac

}

fonc_menu_infosutilisateurs
