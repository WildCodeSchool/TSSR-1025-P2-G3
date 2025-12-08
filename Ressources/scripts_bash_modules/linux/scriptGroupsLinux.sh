#!/bin/bash

# Script de gestion groupes et utilisateurs
# Auteur : Pierre-Jan
#---------------------------------Fonctions-------------------------------------------

fonc_add_user_admin_linux() {

    echo "╭──────────────────────────────────────────────────╮"
    echo "│      AJOUTER UTILISATEUR AU GROUPE SUDO          │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur à ajouter        │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix
    case $choix in

    1)
        # choix de l'utilisateur:
        echo "Voici la liste des utilisateurs : "
        command "awk -F':' '\$3>=1000 { print \$1 }' /etc/passwd"
        read -p "Quel utilisateur souhaitez vous ajouter en admin ? : " useraddadmin
        logEvent "ENTRÉE_D'UTILISATEUR:$useraddadmin"

        # l'utilisateur existe ?
        if
            logEvent "_COMMANDE_DE_VÉRIFICATION_EXISTENCE_UTILISATEUR"
            command "cat /etc/passwd | grep -w $useraddadmin >/dev/null"

        # si il existe on ajoute au groupe sudo
        then
            logEvent "AJOUT_DE_L'UTILSATEUR:$useraddadmin"
            admin=$(sudo_command "usermod -aG sudo $useraddadmin" | tee /dev/tty)
            infoFile "$useraddadmin" "Ajout de l'utilisateur au groupe" "sudo"
            # On verfie si l'utilisateur a bien été ajouté

            if
                command "cat /etc/group | grep sudo | grep $useraddadmin" >/dev/null
            then
                echo "l'utilisateur $useraddadmin a bien été ajouté au groupe sudo"
                echo " souhaitez-vous ajouter un autre utilisateur au groupe sudo (o/n) ? "
                read -p "tapez o pour oui ou autre chose pour non " conf
                logEvent "AJOUT_DE_L'UTILISATEUR_SUDO:$useraddadmin"

                if [ $conf = "o" ]; then # si oui on relance la fonction
                    fonc_add_user_admin
                else
                    # retour au menu
                    fonc_menu_group
                fi

            else
                echo "erreur"
                logEvent "ERREUR_DU_SCRIPT_DANS_AJOUT_UTILISATEUR_GROUPE_SUDO"
                exit 130

            fi
        # si il n'existe pas
        else
            echo " l'utilisateur demandé n'existe pas, souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non : " conf
            if [ $conf = "o" ]; then # si oui on relance la fonction
                logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                fonc_add_user_admin
            else
                fonc_menu_group
            fi

        fi
        ;;
    2)
        fonc_menu_group
        ;;
    *)
        echo "Erreur de saisie"
        ;;
    esac
}

fonc_add_user_group_linux() {

    echo "╭──────────────────────────────────────────────────╮"
    echo "│                   MENU GROUPES                   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Ajouter un utilisateur à un groupe           │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix

    case $choix in
    1)
        # choix de l'ulisateur:
        read -p "Quel utilisateur souhaitez vous ajouter au groupe ? : " useraddgroup
        logEvent "ENTRÉE_D'UTILISATEUR:$useraddgroup"
        # l'utilisateur existe ?
        if
            command "cat /etc/passwd | grep -w $useraddgroup >/dev/null"
        # si il existe on demande le groupe auquel ajouter l'utilisateur
        then
            echo "Ok pour cet utilisateur, a quel groupe souhaitez vous l'ajouter ?"
            read namegroup
            #si le groupe existe
            if command "cat /etc/group | grep -w $namegroup >/dev/null"; then
                add=$(sudo_command "usermod -aG $namegroup $useraddgroup" | tee /dev/tty)
                infoFile "$useraddgroup" "Ajouté au groupe" "$namegroup"
                # on confirme l'ajout de l'utilisateur au groupe.
                if cat /etc/group | grep $namegroup | grep $useraddgroup >/dev/null; then
                    echo " l'utilisateur a bien été ajouté au groupe "
                    logEvent "UTILISATEUR:$namegroup À_ÉTÉ_AJOUTÉ_AU_GROUPE:$useraddgroup"
                    echo ""
                    echo " souhaitez-vous ajouter un autre utilisateur ?"
                    read -p "tape o pour oui ou autre chose pour non " conf

                    if [ $conf = "o" ]; then # si oui on relance la fonction
                        fonc_add_user_admin_linux
                    else
                        # retour au menu
                        fonc_menu_group_linux
                    fi

                else
                    echo "erreur su script"
                    logEvent "ERREUR_DANS_LE_SCRIPT_À_L'AJOUT_D'UN_UTILISATEUR_À_UN_GROUPE"
                    exit 130
                fi
            #si le groupe n'existe pas
            else
                echo "le groupe n'existe pas, souhaitez vous le créer et y ajouter l'utilisateur ? "
                read -p "tape o pour oui ou autre chose non" conf

                if [ $conf = "o" ]; then # si oui on crée le groupe et on ajoute l'utilisateur
                    userplusadd=$(sudo_command "groupadd $namegroup && usermod -aG $namegroup $useraddgroup" | tee /dev/tty)
                    infoFile "$useraddgroup" "A été ajouté au groupe" "$userplusadd"
                    logEvent "AJOUT_DE_DE_L'UTILISATEUR:$useraddgroup AU_GROUPE:$namegroup"
                else
                    fonc_menu_group_linux
                fi
            fi

        else
            echo "Cet utilisateur n'existe pas, souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non" conf

            if [ $conf = "o" ]; then # si oui on relance la fonction
                logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                fonc_add_user_group_linux
            else
                fonc_menu_group_linux

            fi
        fi
        ;;

    2)
        fonc_menu_group_linux
        ;;
    *)
        echo "Erreur de saisie"
        ;;
    esac
}

fonc_exit_group_linux() {

    echo "╭──────────────────────────────────────────────────╮"
    echo "│       RETIRER UN UTILISATEUR D'UN GROUPE         │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "╰──────────────────────────────────────────────────╯"
    read -p "Choisissez une option : " choix

    case $choix in

    1)
        echo " Quel utilisateur souhaitez-vous sortir du groupe ? : "
        read userexitgroup
        # on verifie si l'utilisateur existe
        if
            command "cat /etc/passwd | grep -w $userexitgroup"
            logEvent "ENTRÉE_D'UTILISATEUR:$userexitgroup"
        # si il existe on demande de quel groupe l'enlever
        then
            echo "C'est d'accord pour cet utilisateur "
            echo "Voici le ou les groupes dans lequel $userexitgroup est présent "
            command "cat /etc/group | grep "[:,]$userexitgroup""
            echo "Quel groupe choisissez vous pour la sortie de $userexitgroup ? "
            read exitgroup
            #si le groupe selectionné est valide on sort l'utilisateur
            if command "cat /etc/group | grep $exitgroup && cat /etc/group | grep $userexitgroup"; then

                exit=$(sudo_command "usermod -rG $exitgroup $userexitgroup" | tee /dev/tty)
                infoFile "$userexitgroup" "Sortie du groupe" "$exitgroup"
                echo " l'utilisateur $userexitgroup a bien été retiré du groupe $exitgroup "
                logEvent "UTILISATEUR_'$userexitgroup'_A_ÉTÉ_RETIRÉ_DU_GROUPE_$exitgroup"
                echo " souhaitez vous choisir un autre utilisateur ? "
                read -p "tape o pour oui ou autre chose non" choix

                if [ $choix = "o" ]; then # si oui on relance la fonction
                    fonc_exit_group_linux
                else
                    fonc_menu_group_linux
                fi
            else
                echo "il y a eu une erreur pour la sortie du groupe..retour au menu.."
                logEvent "ERREUR_DANS_LE_SCRIPT_POUR_LA_SORTIE_D'UN_UTILISATEUR_D'UN_GROUPE"
                fonc_menu_group_linux
            fi

        else
            #si il n'existe pas
            echo " l'utilisateur demandé n'existe pas, souhaitez vous choisir un autre utilisateur ?  "
            read -p "tape o pour oui ou autre chose non" conf

            if [ $conf = "o" ]; then # si oui on relance la fonction
                logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                fonc_exit_group_linux
            else
                fonc_menu_group_linux
            fi

        fi
        ;;
    2)
        fonc_menu_group_linux
        ;;

    *)
        echo "Erreur de saisie"
        ;;
    esac
}

fonc_exit_menu() {

    echo "retour au menu précédent"
    exit 0

}
#-------------------------------Menu--------------------------------

fonc_menu_group_linux() {
    logEvent "MENU_GROUPES"
    while true; do

        echo "╭──────────────────────────────────────────────────╮"
        echo "│                   MENU GROUPES                   │"
        echo "├──────────────────────────────────────────────────┤"
        echo "│                                                  │"
        echo "│  1. Ajouter un utilisateur au groupe sudo        │"
        echo "│  2. Ajouter un utilisateur à un groupe           │"
        echo "│  3. Retirer un utilisateur d'un groupe           │"
        echo "│  4. Retour au menu précédent                     │"
        echo "│                                                  │"
        echo "╰──────────────────────────────────────────────────╯"
        echo -n "Votre choix (1-4): "
        echo ""
        read selection

        case $selection in

        1)
            logEvent "MENU_GROUPES:AJOUT_D'_UTILISATEUR_AU_GROUPE_ADMIN"
            fonc_add_user_admin_linux
            ;;
        2)
            logEvent "MENU_GROUPES:AJOUT_D'UN_UTILISATEUR_À_UN_GROUPE"
            fonc_add_user_group_linux
            ;;
        3)
            logEvent "MENU_GROUPES:SORTIE_D'UN_UTLISATEUR_D'UN_GROUPE"
            fonc_exit_group_linux
            ;;
        4)

            userMainMenu
            ;;
        *)
            echo "Erreur de saisie"
            fonc_menu_group_linux
            ;;

        esac
    done

}
