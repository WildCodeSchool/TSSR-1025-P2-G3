#!/bin/bash

#Date de dernière connexion d’un utilisateur


fonc_menu_group()
    {
    echo "###############################################"
    echo "#       MENU INFORMATIONS UTILISATEURS        #"
    echo "###############################################"
    echo "#                                             #"
    echo "# Choisissez l'information pour un utilisateur#"
    echo "# 1. Date de dernière connexion               #"
    echo "# 2. Date de dernière modification du mdp     #"
    echo "# 3. Liste des sessions ouvertes              #"
    echo "# 4. Retour au menu précédent                 #"
    echo "###############################################"                 
    echo ""
    echo -n "Votre choix (1-4): "
    }

    fonc_date_lastconnection()
    {
true
    }

    fonc_date_lastpassmodif()
    {
true
    }

    fonc_opensessions()
    {
true
    }