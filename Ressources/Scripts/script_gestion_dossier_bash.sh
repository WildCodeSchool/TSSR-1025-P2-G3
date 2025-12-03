#################################### Menu Gestion Répertoire ####################################

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
echo "│  2. Supprimer un répertotour au menire           │"
echo "│  3. Retour au menu précédent                     │"
echo "│                                                  │"
echo "╰──────────────────────────────────────────────────╯"

    # Demande de faire un choix
    read -p "# Choisissez une option : " choix
    logEvent "$"

    # structure case prend la valeur $choix de cherche et excécute 
    case "$choix" in
    

        # fonction de creation de dossier
        logEvent "Sélection creation de dossier" 
        1) fonction_creer_dossier
        ;;

        # fonction de supprition de dossier
        logEvent "Sélection supprition de dossier"
        2) fonction_supprimer_dossier
        ;;

        # fonction gestion ordinateur menue précédent
        logEvent "Sélection Retour au menu précédent"
        3) echo "Retour au menu précédent"
        return
        ;;


        # si autre chosse c'est un valide
        logEvent "Sélection Option invalide"
        *) echo " Option invalide."
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
    logEvent "chemindossier"

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
    logEvent " Création de dossier " 
    echo "► Création de dossier"
    fonction_demander_chemin || return
    
    # vérifier si le dossier existe
    if [ -d "$chemindossier" ]; then
        logEvent " Le dossier existe déjà "
        echo "► Le dossier existe déjà"
    # si le dossier existe pas créé le dossier 
    else 
        mkdir "$chemindossier" 2>/dev/null
        # vérifier si le dossier a bien été créé 
        if [ $? -eq 0 ]; then
            logEvent " Le dossier a été créé"
            echo "► Le dossier a été créé"
        else
            logEvent " Erreur : dossier non créé "
            echo "► Erreur : dossier non créé"
        fi
    fi
}

#################################### Fonction supprimer dossier #####################################

fonction_supprimer_dossier() {

    logEvent " Suppression de dossier "
    echo "► Suppression de dossier"
    fonction_demander_chemin || return

    # vérifier si le dossier existe pas si existe supprime 
    if [ ! -d "$chemindossier" ]; then
        logEvent " Le dossier n'existe pas " 
        echo "► Le dossier n'existe pas"
    else
        rm -r "$chemindossier" 2>/dev/null
        #vérifier si le dossier à bien été supprimé
        if [ $? -eq 0 ]; then
            logEvent " Dossier supprimé "
            echo "► Dossier supprimé"
        else
            logEvent " dossier non supprimé "
            echo "► Erreur : dossier non supprimé"
        fi
    fi
}

###################################### Fonction redémarrage #######################################

#fonction de redemarage poste distante
fonction_redemarrage() {
    # demande redémarrer la machine en ssh
    logEvent " connexion en ssh "
    sudo ssh -p "$portSSH" "$remoteUser@$remoteComputer"
    
    # vérifier si la commande avant (ssh) a bien été exécuté je fais redémarrer l'ordinateur, si non je donne la message erreur
    if [ $? -eq 0 ]; then
    logEvent "conextion fait avec succès l'ordinateur va redémarre"
	echo "► l'ordinateur va redémarrer "
    sudo reboot
    else 
    logEvent " ► Erreur ssh ou la commande redémarrage n'est pas fonctionné "
	echo "► Erreur : commande n'est pas fonctionné "
	fi
    
}
