
#!/bin/bash




##################################### Menu Gestion Ordinateurs ####################################

#fonction de Gestion ordinateurs
gestion_ordinateurs_menu() {

logEvent " Menu Gestion ordinateur "
#boucle menu gestion ordinateurs
while true; do

echo "╭──────────────────────────────────────────────────╮"
echo "│               Gestion Ordinateurs                │"
echo "├──────────────────────────────────────────────────┤"
echo "│                                                  │"
echo "│  1. Gestion Repertoire                           │"
echo "│  2. Redémarrage                                  │"
echo "│  3. Prise de main à distance (CLI)               │"
echo "│  4. Activation du pare-feu                       │"
echo "│  5. Exécution de script sur machine distante     │"
echo "│  6. Retour au menu principal                     │"
echo "│                                                  │"
echo "╰──────────────────────────────────────────────────╯"

# Demande de faire un choix 
    read -p "# Choisissez une option : " choix

    # structure case prend la valeur $choix de cherche et excécute 
    case "$choix" in
        #appel au script de gestion de repertoire
        logEvent "Sélection menu gestion repertoire"
        1) gestion_repertoire_menu
        ;; 

        # appel la fonction de redemarrage
        logEvent "Sélection Redemarrage"
        2) fonction_redemarrage
        ;;
        
        # appel la fonction de prise à main distance
        logEvent "Sélection Prise à main distance"
        3) fonction_prise_main
        ;;

        # appel la fonction de activer le parefeu
        logEvent "Sélection Activer le parefeu"
        4) fonction_activer_parefeu 
        ;;
        
        # appel la fonction de excution de script locale
        logEvent "Sélection excution de script locale"
        5) fonction_exec_script 
        ;;

        # retour au menu principal
        logEvent "Sélectionretour au menu principal"
        6) return 
        ;;

        # si autre chosse c'est un valide
        logEvent "Sélection Option invalide"
        *) echo "► Option invalide" 
        ;;
    esac

done

}


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
    read -p "# Choisissez une option : " choix
    logEvent "$choix"

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
    logEvent " demande chemin Création de dossier " 
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

    logEvent " demande chemin Suppression de dossier "
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
    logEvent " demande info connexion en ssh "
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

################################### Fonction prise de main (CLI) ###################################
fonction_prise_main() {
    # Connexion SSH à la machine distante
    logEvent " demande info connexion en ssh "
	sudo ssh -p "$portSSH" "$remoteUser@$remoteComputer"

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
    # activation de pare-feu
    sudo ufw enable

    # vérifier si le activation à bien été effectué
    if [ $? -eq 0 ]; then
        logEvent " activation de par-feu avec succès "
        echo "► Pare-feu activé avec succès."
    else
        logEvent " Erreur : impossible d'activer le pare-feu "
        echo "► Erreur : impossible d'activer le pare-feu."
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
    bash "$scriptlocal"
}

gestion_ordinateurs_menu 