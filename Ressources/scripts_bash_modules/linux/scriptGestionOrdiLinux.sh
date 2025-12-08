#!/bin/bash

##################################### Menu Gestion Répertoire ####################################

# fonction de gestion de répertoires
gestion_repertoire_menu() {
    logEvent "MENU_GESTION_RÉPERTOIRE"

    # boucle menue gestion de répertoires
    while true; do

        echo "╭──────────────────────────────────────────────────╮"
        echo "│               Gestion Répertoires                │"
        echo "├──────────────────────────────────────────────────┤"
        echo "│                                                  │"
        echo "│  1. Créer un répertoire                          │"
        echo "│  2. Supprimer un répertotour                     │"
        echo "│  3. Retour au menu précédent                     │"
        echo "│                                                  │"
        echo "╰──────────────────────────────────────────────────╯"

        # Demande de faire un choix
        read -p "► Choisissez une option : " choix
        logEvent "${choix^^}"

        # structure case prend la valeur $choix cherche et excécute
        case "$choix" in

        1)
            # fonction de creation de dossier
            logEvent "SÉLECTION_CRÉATION_DE_DOSSIER"
            fonction_creer_dossier
            ;;

        2)
            # fonction de supprition de dossier
            logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
            fonction_supprimer_dossier
            ;;

        3)
            # fonction gestion ordinateur menue précédent
            logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
            echo "Retour au menu précédent"
            return
            ;;

        *)
            # si autre chosse c'est un valide
            logEvent "OPTION_INVALIDE"
            echo " Option invalide."
            ;;

        esac

    done
}

################################## Fonction demander chemin #######################################
fonction_demander_chemin() {

    logEvent "ENTREZ_LE_CHEMIN_DU_DOSSIER"
    echo "► Entrez le chemin du dossier :"

    # Demande donner un chemin dossier
    read -r chemindossier
    logEvent "ENTRÉE_UTILISATEUR:$chemindossier"

    # vérifier si au moin un chemin a ete saisie
    if [ -z "$chemindossier" ]; then
        logEvent "AUCUN_CHEMIN_SAISI"
        echo "► Aucun chemin saisi"

        return 1
    fi
    return 0
}

################################## Fonction création répertoire #####################################

fonction_creer_dossier() {
    logEvent "CRÉATION_DE_DOSSIER"
    echo "► Création de dossier"

    fonction_demander_chemin || return

    # vérifier si le dossier existe
    if [ -d "$chemindossier" ]; then

        logEvent "LE_DOSSIER_EXISTE_DÉJÀ"
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        sudo_command mkdir "$chemindossier" 2>/dev/null
        powershell_command mkdir "$chemindossier"

        # vérifier si le dossier a bien été créé
        if [ $? -eq 0 ]; then

            logEvent "DOSSIER_CRÉÉ:$chemindossier"
            echo "► Le dossier a été créé $chemindossier "

        else

            logEvent "ERREUR_DOSSIER_NON_CRÉÉ"
            echo "► Erreur : dossier non créé"

        fi
    fi
}

#################################### Fonction supprimer dossier #####################################

fonction_supprimer_dossier() {

    logEvent "SUPPRESSION_DE_DOSSIER"
    echo "► Suppression de dossier"
    fonction_demander_chemin || return

    # vérifier si le dossier existe pas si existe supprime
    if [ ! -d "$chemindossier" ]; then
        logEvent "DOSSIER_INEXISTANT:$chemindossier"
        echo "► Le dossier $chemindossier n'existe pas"
    else
        sudo_command rm -r "$chemindossier" 2>/dev/null
        powershell_command rmdir "$chemindossier" -Recurse -Force
        
        #vérifier si le dossier à bien été supprimé
        if [ $? -eq 0 ]; then
            logEvent "DOSSIER_SUPPRIMÉ:$chemindossier"
            echo "► Dossier supprimé : $chemindossier"
        else
            logEvent "ERREUR_SUPPRESSION:$chemindossier"
            echo "► Erreur : dossier $chemindossier non supprimé"
        fi
    fi
}

###################################### Fonction redémarrage #######################################

#fonction de redemarage poste distante
fonction_redemarrage() {
    # Demande si Voulez-vous redémarrer l'ordinateur distant 
    logEvent "DEMANDE_VOULEZ_VOUS_REDEMARRER_L'ORDINATEUR"
    read -p "► Voulez-vous redémarrer l'ordinateur distant ? (o/n) " restartComputer

    # Si la reponse est (o) alors redémarre l'ordinateur distante sinon erreur.
    if [ "$restartComputer" = "o" ]; then
        logEvent "REBOOT_ORDINATEUR"
        echo "► l'ordinateur va redémarrer "
        sudo_command "reboot"
        powershell_command "Restart-Computer"

    else
        logEvent "ERREUR_REDEMARRAGE"
        echo "► Erreur : commande n'est pas fonctionné "
    fi

}

################################### Fonction prise de main (CLI) ###################################
fonction_prise_main() {

    # apple au variables mainScript.sh (variables de connexion SSH)
    logEvent "DEMANDE_PRISE_DE_MAIN_DISTANTE_SSH"
    ssh -p "$portSSH" "$remoteUser@$remoteComputer"
    powershell_command Enter-PSSession -ComputerName "$remoteComputer" -Credential "$remoteUser"

    # Condition si le dernier commande c'est bien exécutée  
    if [ $? -eq 0 ]; then

        logEvent "CONNEXION_SUCCESS"
        echo "► Vous êtes prise de main distante en (SSH)."

    else

        logEvent "ERREUR_SSH"
        echo "► Erreur : Vous êtes pas prise de main à distante en (SSH)."

    fi
}

################################### Fonction activation pare-feu ####################################
fonction_activer_parefeu() {

    logEvent "DEMANDE_ACTIVATION_UFW"
    echo "► Activation du pare-feu UFW "

    # Demmande si l'utilisateur veut activer le pare-feu UFW
    read -p "► Voulez-vous activer le pare-feu UFW ? (o/n) " activateFirewall

    # Si la reponse est (o) alors active le pare-feu UFW sinon retourne au menu principal.
    if [ "$activateFirewall" = "o" ]; then

        sudo_command "ufw enable"
        powershell_command "netsh advfirewall set allprofiles state on"

        # vérifier si le pare-feu a bien été activé
        if [ $? -eq 0 ]; then

            logEvent "PAREFEU_ACTIVÉ"
            echo "► Pare-feu activé avec succès."

        else

            logEvent "ERREUR_ACTIVATION_UFW"
            echo "► Erreur : impossible d'activer le pare-feu."
        fi
    # si la reponse est (n) retourne au menu Gestion Ordinateur
    else
        computerMainMenu
    fi
}

################################# Fonction exécution script local ###################################
fonction_exec_script() {

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
    powershell_command "$scriptlocal"
