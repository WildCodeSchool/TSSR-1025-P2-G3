#!/bin/bash

#Date de dernière connexion d’un utilisateur

fonc_menu_group() {
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
}

fonc_date_lastconnection() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Date de dernière connexion                   │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"

}

fonc_date_lastpassmodif() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  2. Date de dernière modification du mot de passe│"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
}

fonc_opensessions() {
    echo "╭──────────────────────────────────────────────────╮"
    echo "│          MENU INFORMATIONS UTILISATEURS          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  3. Liste des sessions ouvertes                  │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
}

fonc_menu_group
