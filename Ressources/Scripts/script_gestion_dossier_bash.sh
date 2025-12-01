#!/bin/bash

##################################### Menu Gestion Répertoire Ubuntu ####################################
repertoireMenu() {
while true; do

echo "╭──────────────────────────────────────────────────╮"
echo "│               Gestion Répertoires                │"
echo "├──────────────────────────────────────────────────┤"
echo "│                                                  │"
echo "│  1. Créer un répertoire                          │"
echo "│  2. Supprimer un répertoire                      │"
echo "│  3. Retour au menu précédent                     │"
echo "│                                                  │"
echo "╰──────────────────────────────────────────────────╯"

    read -p "# Choisissez une option : " choix

    case "$choix" in
        1)
            fonction_creer_dossier
            ;;
        2)
            fonction_supprimer_dossier
            ;;
        3)
            echo "Retour au menu principal..."
            exit 0
            ;;
        *)
            echo " Option invalide."
            ;;

    esac
    
    done
}

################################## Fonction demander chemin #######################################

fonction_demander_chemin() {
    echo "► Entrez le chemin du dossier :"
    read -r chemindossier

    if [ -z "$chemindossier" ]; then
        echo "► Aucun chemin saisi"
        return 1
    fi
    return 0
}

################################## Fonction création répertoire #####################################

fonction_creer_dossier() {
    echo "► Création de dossier"
    fonction_demander_chemin || return

    if [ -d "$chemindossier" ]; then
        echo "► Le dossier existe déjà"
    else
        mkdir "$chemindossier" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "► Le dossier a été créé"
        else
            echo "► Erreur : dossier non créé"
        fi
    fi
}

#################################### Fonction supprimer dossier #####################################

fonction_supprimer_dossier() {
    echo "► Suppression de dossier"
    fonction_demander_chemin || return

    if [ ! -d "$chemindossier" ]; then
        echo "► Le dossier n'existe pas"
    else
        rm -r "$chemindossier" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "► Dossier supprimé"
        else
            echo "► Erreur : dossier non supprimé"
        fi
    fi
}

#################################### Boucle principale ##############################################

    repertoireMenu
