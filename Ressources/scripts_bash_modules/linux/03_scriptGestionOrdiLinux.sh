#!/bin/bash

# Script Gestion Ordinateur Linux
# Auteur : Safi


﻿# Sommaire :
# 01 - Menu Gestion Répertoire
# 02 - Création de répertoire
# 03 - Création de répertoire Linux (SUDO)
# 04 - Suppression de répertoire
# 05 - Redémmarage
# 06 - Prise en main à distance (CLI)
# 07 - Activation du pare-feu
# 08 - Exécution de scripts sur une machine distante



#==============================================================
# 01 - MENU GESTION REPERTOIRE
#==============================================================
gestion_repertoire_menu_linux() {

    logEvent "MENU_GESTION_RÉPERTOIRE"

    # boucle menue gestion de répertoires
    while true; do

        echo ""
        echo "╭──────────────────────────────────────────────────╮"
        echo "│               Gestion Répertoires                │"
        echo "├──────────────────────────────────────────────────┤"
        echo "│                                                  │"
        echo "│  1. Créer un répertoire                          │"
        echo "│  2. Créer une répertoire (SUDO)                  │"
        echo "│  3. Supprimer un répertoire                      │"
        echo "│  4. Retour au menu précédent                     │"
        echo "│                                                  │"
        echo "╰──────────────────────────────────────────────────╯"
        echo ""

        # Demande de faire un choix
        read -p "► Choisissez une option : " choix
        logEvent "${choix^^}"

        # structure case prend la valeur $choix cherche et excécute
        case "$choix" in

        1)
            # fonction de creation de dossier
            logEvent "SÉLECTION_CRÉATION_DE_DOSSIER"
            fonction_creer_dossier_linux
            ;;

        2)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_creer_dossier_sudo_linux
            ;;

        3)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_supprimer_dossier_linux
            ;;

        4)
            # fonction gestion ordinateur menue précédent
            logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
            echo "Retour au menu précédent"
            computerMainMenu
            ;;

        *)
            # si autre chosse c'est un valide
            logEvent "OPTION_INVALIDE"
            echo " Option invalide."
            ;;

        esac

    done
}


#==============================================================
# 02 - CREATION DE REPERTOIRE
#==============================================================
fonction_creer_dossier_linux() {

    logEvent "CRÉATION_DE_DOSSIER"

    read -rp "►" creation_dossier

    # fonction_demander_chemin_linux || return

    # vérifier si le dossier existe
    if [ -d "$creation_dossier" ]; then

        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        command "mkdir '$creation_dossier' 2>/dev/null"

        # vérifier si le dossier a bien été créé
        if [ $? -eq 0 ]; then

            logEvent "DOSSIER_CRÉÉ:$creation_dossier"
            echo ""
            echo "► Le dossier a été créé $creation_dossier "

        else

            logEvent "ERREUR_DOSSIER_NON_CRÉÉ"
            echo ""
            echo "► Erreur : dossier non créé"

        fi
    fi
}


#==============================================================
# 03 - CREATION DE REPERTOIRE AVEC PRIVILEGES ADMIN
#==============================================================
fonction_creer_dossier_sudo_linux() {

    logEvent "CRÉATION_DE_DOSSIER"

    read -p "► Entrez le chemin du dossier : " creation_dossier_sudo

    # vérifier si le dossier existe
    if [ -d "$creation_dossier_sudo" ]; then

        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        sudo_command "mkdir '$creation_dossier_sudo' 2>/dev/null"

        # vérifier si le dossier a bien été créé
        if [ $? -eq 0 ]; then

            logEvent "DOSSIER_CRÉÉ:$creation_dossier_sudo"
            echo ""
            echo "► Le dossier a été créé $creation_dossier_sudo "

        else

            logEvent "ERREUR_DOSSIER_NON_CRÉÉ"
            echo ""
            echo "► Erreur : dossier non créé"

        fi
    fi
}


#==============================================================
# 04 - SUPPRESSION DE REPERTOIRE
#==============================================================
fonction_supprimer_dossier_linux() {

    logEvent "SUPPRESSION_DE_DOSSIER"
    echo "► Suppression de dossier"

    # fonction_demander_chemin_linux || return
    read -rp "► Entrez un chemin: " delfolder

    # vérifier si le dossier existe pas si existe supprime
    if [ -d "$delfolder" ]; then

        sudo_command "rm -rf -- \"$delfolder\""

        if [ $? -eq 0 ]; then

            logEvent "SUPPRESSION_EFFECTUE"
            echo " "
            echo "► Suppression de dossier effectue "
        else
            logEvent "DOSSIER_INEXISTANT:$delfolder"
            echo "► Le dossier $delfolder n'existe pas"
        fi
    fi
}


#==============================================================
# 05 - REDEMARRAGE
#==============================================================
#fonction de redemarage poste distante
fonction_redemarrage_linux() {
    # Demande si Voulez-vous redémarrer l'ordinateur distant
    logEvent "DEMANDE_VOULEZ_VOUS_REDEMARRER_L'ORDINATEUR"
    read -p "► Voulez-vous redémarrer l'ordinateur distant ? (o/n) " restartComputer

    # Si la reponse est (o) alors redémarre l'ordinateur distante sinon erreur.
    if [ "$restartComputer" = "o" ]; then
        logEvent "REBOOT_ORDINATEUR"
        echo "► l'ordinateur va redémarrer "
        sudo_command "reboot"
        computerMainMenu

    else
        logEvent "ERREUR_REDEMARRAGE"
        echo "► Erreur : commande n'est pas fonctionné "
        computerMainMenu
    fi

}


#==============================================================
# 06 - PRISE EN MAIN A DISTANCE (CLI)
#==============================================================
fonction_prise_main_linux() {

    # apple au variables mainScript.sh (variables de connexion SSH)
    logEvent "DEMANDE_PRISE_DE_MAIN_DISTANTE_SSH"
    ssh -p "$portSSH" "$remoteUser@$remoteComputer"

    # Condition si le dernier commande c'est bien exécutée
    if [ $? -eq 0 ]; then

        logEvent "CONNEXION_SUCCESS"
        echo "► Vous êtes prise de main distante en (SSH)."
        computerMainMenu
    else

        logEvent "ERREUR_SSH"
        echo "► Erreur : Vous êtes pas prise de main à distante en (SSH)."
        computerMainMenu

    fi
}


#==============================================================
# 07 - ACTIVATION PARE-FEU
#==============================================================
fonction_activer_parefeu_linux() {

    logEvent "DEMANDE_ACTIVATION_UFW"
    echo "► Activation du pare-feu UFW "

    # Demmande si l'utilisateur veut activer le pare-feu UFW
    read -p "► Voulez-vous activer le pare-feu UFW ? (o/n) " activateFirewall

    # Si la reponse est (o) alors active le pare-feu UFW sinon retourne au menu principal.
    if [ "$activateFirewall" = "o" ]; then

        sudo_command "ufw enable"

        # vérifier si le pare-feu a bien été activé
        if [ $? -eq 0 ]; then

            logEvent "PAREFEU_ACTIVÉ"
            echo "► Pare-feu activé avec succès."
            computerMainMenu
        else

            logEvent "ERREUR_ACTIVATION_UFW"
            echo "► Erreur : impossible d'activer le pare-feu."
            computerMainMenu
        fi
    # si la reponse est (n) retourne au menu Gestion Ordinateur
    else
        computerMainMenu
    fi
}


#==============================================================
# 08 - EXECUTION DE SCRIPT LOCAL
#==============================================================
fonction_exec_script_linux() {

    logEvent "DEMANDE_CHEMIN_SCRIPT"
    echo "► Entrez le chemin du script local à exécuter :"

    # Demande donner un chemin de script local
    read -r scriptlocal
    logEvent "SCRIPT_SÉLECTIONNÉ:$scriptlocal"

    # vérifier si le fichier script existe

    if [ ! -f "$scriptlocal" ]; then
        logEvent "SCRIPT_INTROUVABLE:$scriptlocal"
        echo "► Erreur : fichier introuvable."
        return
    fi

    logEvent "EXÉCUTION_SCRIPT:$scriptlocal"
    echo "► Exécution du script : $scriptlocal"
    # exécute le script local sur l'ordinateur distant
    sudo_command "bash $scriptlocal"

}
