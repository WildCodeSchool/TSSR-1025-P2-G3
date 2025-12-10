#!/bin/bash

##################################### Menu Gestion Répertoire ####################################

# fonction de gestion de répertoires
gestion_repertoire_menu_windows() {

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
            fonction_creer_dossier_windows
            ;;

        2)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_creer_dossier_sudo_windows
            ;;

        3)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_supprimer_dossier_windows
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

################################## Fonction création répertoire #####################################

fonction_creer_dossier_windows() {

    logEvent "CRÉATION_DE_DOSSIER"

    read -rp "►" creation_dossier

    # vérifier si le dossier existe
    if [ -d "$creation_dossier" ]; then

        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        powershell_command "New-Item -Path "$creation_dossier" -ItemType Directory"

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

################################## Fonction création répertoire SUDO #####################################

fonction_creer_dossier_sudo_windows() {

    logEvent "CRÉATION_DE_DOSSIER"

    read -p "► Entrez le chemin du dossier : " creation_dossier_sudo

    # vérifier si le dossier existe
    if [ -d "$creation_dossier_sudo" ]; then

        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        powershell_command "New-Item -Path "$creation_dossier_sudo" -ItemType Directory"

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

#################################### Fonction supprimer dossier #####################################

fonction_supprimer_dossier_windows() {

    logEvent "SUPPRESSION_DE_DOSSIER"
    echo "► Suppression de dossier"

    read -rp "► Entrez un chemin: " delfolder

    # vérifier si le dossier existe pas si existe supprime
    if [ -d "$delfolder" ]; then

        powershell_command "Remove-Item -path '$delfolder' -Recurse -Force"

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

###################################### Fonction redémarrage #######################################

#fonction de redemarage poste distante
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

################################### Fonction prise de main (CLI) ###################################
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

################################### Fonction activation pare-feu ####################################
fonction_activer_parefeu_windows() {

    logEvent "DEMANDE_ACTIVATION_UFW"
    echo "► Activation du pare-feu UFW "

    # Demmande si l'utilisateur veut activer le pare-feu UFW
    read -p "► Voulez-vous activer le pare-feu UFW ? (o/n) " activateFirewall

    # Si la reponse est (o) alors active le pare-feu UFW sinon retourne au menu principal.
    if [ "$activateFirewall" = "o" ]; then

        powershell_command "Set-NetfirewallProfile -Enabled True"

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

################################# Fonction exécution script local ###################################
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
