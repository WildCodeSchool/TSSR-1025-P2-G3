#!/bin/bash

##################################### Menu Gestion Répertoire ####################################

# fonction de gestion de répertoires
gestion_repertoire_menu() {
    logEvent " menu gestion répertoire "

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
        logEvent "$choix"

        # structure case prend la valeur $choix de cherche et excécute
        case "$choix" in

        1)
            # fonction de creation de dossier
            logEvent "Sélection creation de dossier"
            fonction_creer_dossier
            ;;

        2)
            # fonction de supprition de dossier
            logEvent "Sélection supprition de dossier"
            fonction_supprimer_dossier
            ;;

        3)
            # fonction gestion ordinateur menue précédent
            logEvent "Sélection Retour au menu précédent"
            echo "Retour au menu précédent"
            return
            ;;

        *)
            # si autre chosse c'est un valide
            logEvent "Sélection Option invalide"
            echo " Option invalide."
            ;;

        esac

    done
}

################################## Fonction demander chemin #######################################
fonction_demander_chemin() {

    logEvent " Entrez le chemin du dossier "
    echo "► Entrez le chemin du dossier :"

    # Demande donner un chemin dossier
    read -r chemindossier
    logEvent "Entrée utilisateur : $chemindossier"

    # vérifier si au moin un chemin a ete saisie
    if [ -z "$chemindossier" ]; then
        logEvent " Aucun chemin saisi, retour "
        echo "► Aucun chemin saisi"

        return 1
    fi
    return 0
}

################################## Fonction création répertoire #####################################

fonction_creer_dossier() {
    logEvent " demande chemin Création de dossier "
    echo "► Création de dossier"

    fonction_demander_chemin || return

    # vérifier si le dossier existe
    if [ -d "$chemindossier" ]; then

        logEvent " Le dossier existe déjà "
        echo "► Le dossier existe déjà"

    # si le dossier existe pas créé le dossier
    else
        sudo_command mkdir "$chemindossier" 2>/dev/null

        # vérifier si le dossier a bien été créé
        if [ $? -eq 0 ]; then

            logEvent " Le dossier a été créé $chemindossier "
            echo "► Le dossier a été créé $chemindossier "

        else

            logEvent " Erreur : dossier non créé "
            echo "► Erreur : dossier non créé"

        fi
    fi
}

#################################### Fonction supprimer dossier #####################################

fonction_supprimer_dossier() {

    logEvent " demande chemin Suppression de dossier "
    echo "► Suppression de dossier"
    fonction_demander_chemin || return

    # vérifier si le dossier existe pas si existe supprime
    if [ ! -d "$chemindossier" ]; then
        logEvent " Le dossier $chemindossier n'existe pas "
        echo "► Le dossier $chemindossier n'existe pas"
    else
        sudo_command rm -r "$chemindossier" 2>/dev/null
        #vérifier si le dossier à bien été supprimé
        if [ $? -eq 0 ]; then
            logEvent " Dossier supprimé : $chemindossier"
            echo "► Dossier supprimé : $chemindossier"
        else
            logEvent " Dossier : $chemindossier non supprimé "
            echo "► Erreur : dossier $chemindossier non supprimé"
        fi
    fi
}

###################################### Fonction redémarrage #######################################

#fonction de redemarage poste distante
fonction_redemarrage() {

    read -p "► Voulez-vous redémarrer l'ordinateur distant ? (o/n) " restartComputer

    # vérifier si la commande avant (ssh) a bien été exécuté je fais redémarrer l'ordinateur, si non je donne la message erreur
    if [ "$restartComputer" = "o" ]; then
        logEvent "conextion fait avec succès l'ordinateur va redémarre"
        echo "► l'ordinateur va redémarrer "
        sudo_command "reboot"
    else
        logEvent " ► Erreur ssh ou la commande redémarrage n'est pas fonctionné "
        echo "► Erreur : commande n'est pas fonctionné "
    fi

}

################################### Fonction prise de main (CLI) ###################################
fonction_prise_main() {

    # local remoteComputer
    # local remoteUser
    # local portSSH

    # # Connexion SSH à la machine distante
    # logEvent " demande info connexion en ssh "
    # read -p "► Entrez une Adresse IP ou Hostname : " remoteComputer
    # logEvent "Adresse IP ou Hostname : $remoteComputer"
    # read -p "► Entrez un Nom d'utilisateur : " remoteUser
    # logEvent "Nom d'utilisateur : $remoteUser"
    # read -p "► Entrez un Port : " portSSH
    # logEvent "Port : $portSSH"

    ssh -p "$portSSH" "$remoteUser@$remoteComputer"

    # vérifier si la connexion ssh à bien été effectué
    if [ $? -eq 0 ]; then

        logEvent " conextion fait avec succès "
        echo "► Vous êtes prise de main distante en (SSH)."

    else

        logEvent " ► Erreur ssh à pas été connecté "
        echo "► Erreur : Vous êtes pas prise de main à distante en (SSH)."

    fi
}

################################### Fonction activation pare-feu ####################################
fonction_activer_parefeu() {
    logEvent " demande d'activation de pare-feu "
    echo "► Activation du pare-feu UFW "

    read -p "► Voulez-vous activer le pare-feu UFW ? (o/n) " activateFirewall
    # activation de pare-feu

    # vérifier si le activation à bien été effectué
    if [ "$activateFirewall" = "o" ]; then

        sudo_command "ufw enable"

        if [ $? -eq 0 ]; then

            logEvent " activation de par-feu avec succès "
            echo "► Pare-feu activé avec succès."

        else

            logEvent " Erreur : impossible d'activer le pare-feu "
            echo "► Erreur : impossible d'activer le pare-feu."
        fi
    else
        computerMainMenu
    fi
}

################################# Fonction exécution script local ###################################
fonction_exec_script() {

    logEvent " demande chemin du script "
    echo "► Entrez le chemin du script local à exécuter :"

    ## Demande donner le chemin de script
    read -r scriptlocal
    logEvent " $scriptlocal été choisi "

    # condition si le dossier existe pas retourne
    if [ ! -f "$scriptlocal" ]; then
        logEvent " $scriptlocal inrouvable "
        echo "► Erreur : fichier introuvable."
        return
    fi

    # exécution de script demandé
    logEvent " Exécution du script : $scriptlocal "
    echo "► Exécution du script : $scriptlocal"
    sudo_command "bash $scriptlocal"
}
