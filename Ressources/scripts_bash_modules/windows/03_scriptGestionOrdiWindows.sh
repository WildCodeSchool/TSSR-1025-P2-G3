#!/bin/bash

# Script Gestion Ordinateur Windows
# Auteur : Safi


# Sommaire :
# 01 - Menu Gestion Répertoire
# 02 - Création de répertoire
# 03 - Suppression de répertoire
# 04 - Redémmarage
# 05 - Prise en main à distance (CLI)
# 06 - Activation du pare-feu
# 07 - Exécution de scripts sur une machine distante



#==============================================================
# 01 - MENU GESTION REPERTOIRE
#==============================================================
gestion_repertoire_menu_windows() {

    logEvent "MENU_GESTION_RÉPERTOIRE"

    # boucle menue gestion de répertoires
    while true; do

        echo ""
        echo "╭──────────────────────────────────────────────────╮"
        echo "│               Gestion Répertoires                │"
        echo "├──────────────────────────────────────────────────┤"
        echo "$menuMachineLine"
        echo "├──────────────────────────────────────────────────┤"
        echo "│                                                  │"
        echo "│  1. Créer un répertoire                          │"
        echo "│  2. Supprimer un répertoire                      │"
        echo "│  3. Retour au menu précédent                     │"
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
            fonction_creer_dossier_windows
            ;;


        2)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_supprimer_dossier_windows
            ;;

        3)
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
fonction_creer_dossier_windows() {
    logEvent "CRÉATION_DE_DOSSIER"
    read -p "►" creation_dossier
    # vérifier si le dossier existe
    if powershell_command "Test-Path -Path \"$creation_dossier\" | Out-Null"; then

        powershell_command "New-Item -Path \"$creation_dossier\" -ItemType Directory | Out-Null"
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

    # si le dossier existe pas créé le dossier
    else
        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"
    fi
}


#==============================================================
# 03 - SUPPRESSION DE REPERTOIRE
#==============================================================
fonction_supprimer_dossier_windows() {

    logEvent "SUPPRESSION_DE_DOSSIER"
    echo "► Suppression de dossier"

    read -rp "► " delfolder

    # vérifier si le dossier existe pas si existe supprime
    if powershell_command "Test-Path -Path \"$delfolder\" | Out-Null"; then

        powershell_command "Remove-Item -path '$delfolder' -Recurse -Force | Out-Null" 

        if [ $? -eq 0 ]; then

            logEvent "SUPPRESSION_EFFECTUE"
            echo " "
            echo "► Suppression de dossier effectue "
        fi
    else
        logEvent "DOSSIER_INEXISTANT:$delfolder"
        echo "► Le dossier $delfolder n'existe pas"

    fi
}


#==============================================================
# 04 - REDEMARRAGE
#==============================================================
fonction_redemarrage_windows() {

    # Demande si Voulez-vous redémarrer l'ordinateur distant
    logEvent "DEMANDE_VOULEZ_VOUS_REDEMARRER_L'ORDINATEUR"
    read -p "► Voulez-vous redémarrer l'ordinateur distant ? (o/n) " restartComputer

    # Si la reponse est (o) alors redémarre l'ordinateur distante sinon erreur.
    if [ "$restartComputer" = "o" ]; then
        logEvent "REBOOT_ORDINATEUR"
        echo "► l'ordinateur va redémarrer "

        powershell_command "Restart-Computer -Force"
        computerMainMenu

    else
        logEvent "ERREUR_REDEMARRAGE"
        echo "► Erreur : commande n'est pas fonctionné "
        computerMainMenu
    fi

}


#==============================================================
# 05 - PRISE EN MAIN A DISTANCE
#==============================================================
fonction_prise_main_windows() {

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
# 06 - ACTIVATION PARE-FEU
#==============================================================
fonction_activer_parefeu_windows() {
    logEvent "DEMANDE_ACTIVATION_PAREFEU"
    echo "► Activation du pare-feu Windows"
    
    # Afficher statut actuel
    echo "► Statut actuel :"
    powershell_command "netsh advfirewall show allprofiles state"
    
    echo ""
    read -p "► Voulez-vous activer le pare-feu Windows ? (o/n) " activateFirewall
    
    if [ "$activateFirewall" = "o" ]; then
        echo "► Activation en cours..."
        
        powershell_command "netsh advfirewall set allprofiles state on"
        
        if [ $? -eq 0 ]; then
            logEvent "PAREFEU_ACTIVE"
            echo "► ✓ Pare-feu activé avec succès."
            
            echo "► Nouveau statut :"
            powershell_command "netsh advfirewall show allprofiles state"
        else
            logEvent "ERREUR_ACTIVATION"
            echo "► ✗ Erreur : impossible d'activer le pare-feu."
        fi
    else
        echo "► Activation annulée."
    fi
    
    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu..."
    computerMainMenu
}


#==============================================================
# 07 - EXECUTION DE SCRIPT LOCAL
#==============================================================
fonction_exec_script_windows() {

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
    powershell_command "& $scriptlocal"

}

