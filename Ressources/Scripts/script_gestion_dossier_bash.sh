#!/bin/bash








################################## Fonction demander chemin #######################################

fonction_demander_chemin() {
        echo "##################################################"
        echo "#          Entre le chemin du dossier:           #"
        echo "##################################################"
        read chemindossier

# Vérifie si l'utilisateur a pas laissé vide

    if [ -z "$chemindossier" ]
        then 
            echo " ********* Aucun chemin saisi ************ "
            return 1
    fi
    return 0
}

################################## Fonction création répertoire #####################################

fonction_creer_dossier() {
clear
        echo "##################################################"
        echo "#              Création de dossier               #"
        echo "##################################################"
        fonction_demander_chemin
# Vérifie si l'utilisateur a pas laissé vide

# Vérificaton si le répertoire existe déja

    if [ -d "$chemindossier" ]
        then 
            echo " ******* Le Dossier existe déja pas de création ********* "
            
        else
            echo " Création do Dossier"
            mkdir "$chemindossier"

            # vrification que dossier à bien été créé
            if [ $? -eq 0 ]
                then echo " ******** Le dossier à bien été créé ********** "
                else echo " ******** Le dossier à été pas créé  ********** "
            fi
    fi
}

#################################### Fonction Supprimer un Dossier #####################################

fonction_supprimer_dossier() {
clear
        echo "##################################################"
        echo "#              Suppressin de dossier             #"
        echo "##################################################"

        fonction_demander_chemin

# Vérificaton si le dossier exist déja

    if [ ! -d "$chemindossier" ]
        then 
            echo " ****** Le Dossier n'existe, pas de Supprition ******* "
        else
            rm -r "$chemindossier" 2>/dev/null
            if [ $? -eq 0 ]
                then echo " ********* Le dossier à bien été Suprimé ********* "
                else echo " ********* Le dossier à été pas Suprimé ********** "
            fi
    fi

}

##################################### Menu Gestion Répertoire Ubuntu ####################################

while true;
    do
    
        echo "##################################################"
        echo "#              Gestion Répertoires Ubuntu        #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Crée répertoire                            #"
        echo "#  2. Supprimer répertoire                       #"
        echo "#  3. Retour Menu président (sortire)            #"
        echo "#                                                #"
        echo "##################################################"

        read choix

        case "$choix" in
        
            1) fonction_creer_dossier ;;
            2) fonction_supprimer_dossier ;;
            3) echo " Retour Menu président "; exit ;;
        esac
done 


