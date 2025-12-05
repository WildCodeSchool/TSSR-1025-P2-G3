#!/bin/bash

# Script de création, suppression d'utilisateur et modification de mot de passe utilisateurs.
# Auteur : Christian

#=====================================================
# FONCTIONS
#=====================================================

# Sous menu "Utilisateurs"
function userMenu() {
    logEvent "MENU_UTILISATEUR"

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

            logEvent "MENU_UTILISATEUR:AJOUTER_UN_UTILISATEUR"
            addUserMenu
            ;;

        2)
            logEvent "MENU_UTILISATEUR:SUPPRIMER_UN_UTILISATEUR"
            deleteUserMenu
            ;;

        3)
            logEvent "MENU_UTILISATEUR:CHANGER_MOT_DE_PASSE_UTILISATEUR"
            changePasswordUserMenu
            ;;

        4)

            logEvent "MENU_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"
            echo ""
            echo "► Liste des utilisateurs : "
            command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort -k 2"
            logEvent "MENU_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"
            ;;

        5)

            logEvent "MENU_UTILISATEUR:RETOUR_MENU_PRECEDENT"
            return
            ;;

        *)
            logEvent "MENU_UTILISATEUR:ENTREE_INVALIDE"
            echo
            echo -e "► ${RED}Entrée invalide! ${NC}"
            userMenu
            ;;

        esac

    done
}

# Ajouter un utilisateur
function addUserMenu() {

    logEvent "MENU_AJOUT_UTILISATEUR"

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

        logEvent "MENU_AJOUT_UTILISATEUR:SAISIR_NOM_UTILISATEUR"
        userCreationChoice="o"

        while [ "$userCreationChoice" = "o" ]; do

            read -p "► Entrez un nom d'utilisateur : " addUserCommand
            logEvent "AJOUT_UTILISATEUR:ENTREE_UTILISATEUR:$addUserCommand"

            logEvent "AJOUT_UTILISATEUR:VERIFICATION_UTILISATEUR_EXISTE:$addUserCommand"
            command "grep '^$addUserCommand:' /etc/passwd >/dev/null"

            if [ $? = 1 ]; then

                read -p "► Voulez-vous créer l'utilisateur $addUserCommand ? (o/n) : " confirmUser
                logEvent "AJOUT_UTILISATEUR:CONFIRMATION:$confirmUser:$addUserCommand"

                if [ "$confirmUser" = "o" ]; then

                    logEvent "AJOUT_UTILISATEUR:CREATION:$addUserCommand"
                    sudo_command "useradd ${addUserCommand}"

                    logEvent "AJOUT_UTILISATEUR:VERIFICATION_CREATION:$addUserCommand"
                    command "grep '^$addUserCommand:' /etc/passwd >/dev/null"

                    if [ $? = 0 ]; then
                        echo ""
                        echo -e "► ${GREEN} L'utilisateur $addUserCommand a été créé. ${NC}"
                        echo ""
                        logEvent "AJOUT_UTILISATEUR:CREATION_REUSSIE:$addUserCommand"

                        read -p "► Voulez-vous créer un autre utilisateur ? (o/n) : " userCreationChoice
                        echo ""
                        logEvent "AJOUT_UTILISATEUR:CONTINUER_AJOUT_UTILISATEUR:$userCreationChoice"

                    else

                        echo ""
                        echo -e "► ${RED}L'utilisateur $addUserCommand n'a pas été créé. ${NC}"
                        logEvent "AJOUT_UTILISATEUR:CREATION_ECHOUEE:$addUserCommand"
                    fi

                else
                    echo ""
                    echo "► Retour au menu précédent"
                    echo ""
                    logEvent "AJOUT_UTILISATEUR:ANNULATION:$addUserCommand"
                    userCreationChoice="n"
                fi

            else
                echo ""
                echo -e "► ${RED}L'utilisateur $addUserCommand existe déjà.${NC}"
                echo "Retour au menu précédent"
                echo ""
                logEvent "AJOUT_UTILISATEUR:UTILISATEUR_EXISTE_DEJA:$addUserCommand"
                userCreationChoice="n"
            fi
        done
        ;;

    2)

        logEvent "MENU_AJOUT_UTILISATEUR:RETOUR_AU_MENU_PRECEDENT"
        return
        ;;

    *)

        logEvent "MENU_AJOUT_UTILISATEUR:ENTREE_INVALIDE"
        echo "► Entrée Invalide!!!"
        echo "► Retour au menu précédent."
        echo ""
        ;;

    esac

}

# Supprimer un utilisateur
function deleteUserMenu() {

    logEvent "MENU_SUPPRIMER_UTILISATEUR"

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

        logEvent "MENU_SUPPRIMER_UTILISATEUR:SAISIR_NOM_UTILISATEUR"
        delAnotherUser="o"

        while [ "$delAnotherUser" = "o" ]; do

            read -p "► Entrez un nom d'utilisateur : " delUserCommand
            logEvent "SUPPRIMER_UTILISATEUR:ENTREE_UTILISATEUR:$delUserCommand"

            logEvent "SUPPRIMER_UTILISATEUR:VERIFICATION_UTILISATEUR_EXISTE:$delUserCommand"
            command "grep '^$delUserCommand:' /etc/passwd >/dev/null"

            if [ $? = 1 ]; then

                echo ""
                echo "► L'utilisateur n'existe pas."
                echo ""
                logEvent "SUPPRIMER_UTILISATEUR:UTILISATEUR_INEXISTANT:$delUserCommand"

            else

                read -p "# Souhaitez-vous supprimer l'utilisateur $delUserCommand ? (o/n) " delUserChoice
                logEvent "SUPPRIMER_UTILISATEUR:CONFIRMATION:$delUserChoice:$delUserCommand"

                if [ "$delUserChoice" = "o" ]; then

                    logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_UTILISATEUR:$delUserCommand"
                    sudo_command "userdel ${delUserCommand}"

                    logEvent "SUPPRIMER_UTILISATEUR:VERIFICATION_UTILISATEUR_SUPPRESSION:$delUserCommand"
                    command "grep '^$delUserCommand:' /etc/passwd >/dev/null"

                    if [ $? = 1 ]; then

                        echo "► L'utilisateur $delUserCommand a été supprimé."
                        logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_REUSSIE:$delUserCommand"

                        read -p "Voulez-vous supprimer un autre utilisateur ? (o/n) " delAnotherUser
                        echo ""
                        logEvent "SUPPRIMER_UTILISATEUR:CONTINUER?:$delAnotherUser"

                    else

                        echo ""
                        echo "► L'utilisateur $delUserCommand n'a pas été supprimé."
                        echo ""
                        logEvent "SUPPRIMER_UTILISATEUR:ECHEC_SUPPRESSION:$delUserCommand"

                    fi

                else

                    echo "Retour au menu."

                fi
            fi
        done
        ;;

    2)

        logEvent "MENU_SUPPRIMER_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"
        echo ""
        echo "► Liste des utilisateurs : "
        command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort"
        echo ""
        logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"

        deleteUserMenu
        ;;

    3)

        logEvent "MENU_SUPPRIMER_UTILISATEUR:RETOUR_MENU_PRECEDENT"
        return
        ;;

    *)

        logEvent "MENU_SUPPRIMER_UTILISATEUR:ENTREE_INVALIDE"
        echo "► Entrée invalide !"
        ;;

    esac
}

# Changer mot de passe utilisateur
function changePasswordUserMenu() {

    logEvent "MENU_CHANGER_MOT_DE_PASSE"

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
        logEvent "CHANGEMENT_MOT_DE_PASSE:SAISIE_NOM:$changePasswordUser"

        logEvent "CHANGEMENT_MOT_DE_PASSE:VERIFICATION_EXISTENCE:$changePasswordUser"
        command "grep '^$changePasswordUser:' /etc/passwd >/dev/null"

        if [ $? = 1 ]; then

            echo "► Cet utilisateur n'existe pas"
            logEvent "CHANGEMENT_MOT_DE_PASSE:UTILISATEUR_INEXISTANT:$changePasswordUser"

        else
            logEvent "CHANGEMENT_MOT_DE_PASSE:UTILISATEUR_EXISTE:$changePasswordUser"

            read -p "► Souhaitez-vous changer le mot de passe de l'utilisateur $changePasswordUser ? (o/n) " changepasswordUserChoice
            logEvent "CHANGEMENT_MOT_DE_PASSE:CONFIRMATION:$changepasswordUserChoice:$changePasswordUser"

            if [ "$changepasswordUserChoice" = "o" ]; then

                logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_DEBUT:$changePasswordUser"
                sudo_command "passwd $changePasswordUser"

                if [ $? = 0 ]; then

                    echo "► Le mot de passe de l'utilisateur $changePasswordUser a été modifié."
                    logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_REUSSIE:$changePasswordUser"

                else

                    echo "► Erreur lors de la modification du mot de passe de l'utilisateur $changePasswordUser."
                    echo ""
                    logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_ECHOUEE:$changePasswordUser"

                fi

            else

                echo "► Retour au menu."
                logEvent "CHANGEMENT_MOT_DE_PASSE:ANNULATION:$changePasswordUser"

            fi
        fi
        ;;

    2)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:AFFICHER_LISTE_UTILISATEURS"
        echo ""
        echo "► Liste des utilisateurs : "
        command "awk -F':' '\$3 >= 1000 {print \$1, \$3}' /etc/passwd | sort"
        logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"
        changePasswordUserMenu
        ;;

    3)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:RETOUR_MENU_PRECEDENT"
        return
        ;;

    *)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:ENTREE_INVALIDE"
        echo "► Entrée invalide !"
        ;;

    esac

}
