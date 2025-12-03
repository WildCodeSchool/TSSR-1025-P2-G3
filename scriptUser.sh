#!/bin/bash

# Script de création, suppression d'utilisateur et modification de mot de passe utilisateurs.
# Auteur : Christian

#=====================================================
# FONCTIONS
#=====================================================

# Sous menu "Utilisateurs"
function userMenu() {
    logEvent "Menu Utilisateur"

    while true; do

        echo ""
        echo "╭────────────────────────────────────────────────╮"
        echo "│                MENU UTILISATEUR                │"
        echo "├────────────────────────────────────────────────┤"
        echo "│                                                │"
        echo "│  1. Ajouter un utilisateur                     │"
        echo "│  2. Supprimer un utilisateur                   │"
        echo "│  3. Changer le mot de passe d'un Utilisateur   │"
        echo "│  4. Afficher les Utilisateurs                  │"
        echo "│  5. Retour au menu précédent                   │"
        echo "│                                                │"
        echo "╰────────────────────────────────────────────────╯"
        echo ""

        read -p "► Choisissez une option : " menuUser

        case $menuUser in

        1)
            logEvent "Sélection menu ajout utilisateur"
            addUserMenu
            ;;

        2)
            logEvent "Sélection menu suppression utilisateur"
            deleteUserMenu
            ;;

        3)  
            logEvent "Sélection menu suppression utilisateur"
            changePasswordUserMenu
            ;;

        4)

            echo ""
            echo "► Liste des utilisateurs : "
            command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort -k 2"
            logEventUser "Demande de la liste utilisateur"
            ;;

        5)
            return
            ;;

        *)
            echo
            echo -e "► ${RED}Entrée invalide! ${NC}"
            userMenu
            ;;

        esac

    done
}

# Ajouter un utilisateur
function addUserMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│               AJOUTER UTILISATEUR                │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " menuAddUser

    case $menuAddUser in

    1)
        userCreationChoice="o"

        while [ "$userCreationChoice" = "o" ]; do

            read -p "► Entrez un nom d'utilisateur : " addUserCommand
            logEventUser "Entrée utilisateur : $addUserCommand"
            logEventUser "Commande de vérification des utilisateurs"
            command "grep '^$addUserCommand:' /etc/passwd >/dev/null"

            if [ $? = 1 ]; then

                read -p "► Voulez-vous créer l'utilisateur $addUserCommand ? (o/n) : " confirmUser
                logEventUser "Entrée utilisateur : $addUserCommand"
                if [ "$confirmUser" = "o" ]; then
                    sudo_command "useradd ${addUserCommand}"

                    command "grep '^$addUserCommand:' /etc/passwd >/dev/null"
                    if [ $? = 0 ]; then
                        echo ""
                        echo -e "► ${GREEN} L'utilisateur $addUserCommand a été créé. ${NC}"
                        echo ""

                        read -p "► Voulez-vous créer un autre utilisateur ? (o/n) : " userCreationChoice
                        echo ""
                    else
                        echo ""
                        echo -e "► ${RED}L'utilisateur $addUserCommand n'a pas été créé. ${NC}"
                    fi

                else
                    echo ""
                    echo "► Retour au menu précédent"
                    echo ""
                    userCreationChoice="n"
                fi

            else
                echo ""
                echo -e "► ${RED}L'utilisateur $addUserCommand existe déjà.${NC}"
                echo "Retour au menu précédent"
                echo ""
                userCreationChoice="n"
            fi
        done
        ;;

    2)
        return
        ;;

    *)
        echo "► Entrée Invalide!!!"
        echo "► Retour au menu précédent."
        echo ""
        ;;
    esac

}

# Supprimer un utilisateur
function deleteUserMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│              SUPPRIMER UTILISATEUR               │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur à supprimer      │"
    echo "│  2. Afficher la liste des utilisateurs           │"
    echo "│  3. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " delUserMenu

    case $delUserMenu in

    1)
        delAnotherUser="o"

        while [ "$delAnotherUser" = "o" ]; do
            read -p "► Entrez un nom d'utilisateur : " delUserCommand
            command "grep '^$delUserCommand:' /etc/passwd >/dev/null"

            if [ $? = 1 ]; then
                echo ""
                echo "► L'utilisateur n'existe pas."
                echo ""
            else
                read -p "# Souhaitez-vous supprimer l'utilisateur $delUserCommand ? (o/n) " delUserChoice

                if [ "$delUserChoice" = "o" ]; then

                    sudo_command "userdel ${delUserCommand}"
                    command "grep '^$delUserCommand:' /etc/passwd >/dev/null"

                    if [ $? = 1 ]; then
                        echo "► L'utilisateur $delUserCommand a été supprimé."
                        read -p "Voulez-vous supprimer un autre utilisateur ? (o/n) " delAnotherUser
                        echo ""
                    else
                        echo ""
                        echo "► L'utilisateur $delUserCommand n'a pas été supprimé."
                        echo ""
                    fi

                else
                    echo "Retour au menu."
                fi
            fi
        done
        ;;

    2)
        echo ""
        echo "► Liste des utilisateurs : "
        command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort"
        echo ""
        deleteUserMenu
        ;;

    3)
        return
        ;;

    *)
        echo "► Entrée invalide !"
        ;;

    esac
}

# Changer mot de passe utilisateur
function changePasswordUserMenu() {

    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│         CHANGER MOT DE PASSE UTILISATEUR         │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Afficher la liste des utilisateurs           │"
    echo "│  3. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " changePasswordMenu

    case $changePasswordMenu in

    1)

        read -p "► Entrer un nom d'utilisateur : " changePasswordUser
        command "grep '^$changePasswordUser:' /etc/passwd >/dev/null"

        if [ $? = 1 ]; then
            echo "► Cet utilisateur n'existe pas"

        else

            read -p "► Souhaitez-vous changer le mot de passe de l'utilisateur $changePasswordUser ? (o/n) " changepasswordUserChoice

            if [ "$changepasswordUserChoice" = "o" ]; then

                sudo_command "passwd $changePasswordUser"
                echo "► Le mot de passe de l'utilisateur $changePasswordUser a été modifié."
                echo ""

            else

                echo "► Retour au menu."

            fi
        fi
        ;;

    2)
        echo ""
        echo "► Liste des utilisateurs : "
        command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort"
        changePasswordUserMenu
        ;;

    3)
        return
        ;;

    *)
        echo "► Entrée invalide !"
        ;;

    esac

}
