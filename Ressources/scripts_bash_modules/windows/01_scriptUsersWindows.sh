#!/bin/bash

# Script de création, suppression d'utilisateur et modification de mot de passe utilisateurs.
# Auteur : Christian


# Sommaire :
# 01 - Menu Utilisateurs
# 02 - Ajouter utilisateur
# 03 - Supprimer utilisateur
# 04 - Changer mot de passe utilisateur


#==============================================================
# 01 - MENU UTILISATEURS
#==============================================================
function userMenuWindows() {
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
            addUserMenuWindows
            ;;

        2)
            logEvent "MENU_UTILISATEUR:SUPPRIMER_UN_UTILISATEUR"
            deleteUserMenuWindows
            ;;

        3)
            logEvent "MENU_UTILISATEUR:CHANGER_MOT_DE_PASSE_UTILISATEUR"
            changePasswordUserMenuWindows
            ;;

        4)

            logEvent "MENU_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"
            echo ""
            echo "► Liste des utilisateurs : "
            powershell_command "Get-LocalUser | Select-Object Name"
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
            userMenuWindows
            ;;

        esac

    done
}


#==============================================================
# 02 - AJOUTER UTILISATEURS
#==============================================================
function addUserMenuWindows() {

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

            # Vérification si l'utilisateur existe déjà.
            powershell_command "Get-LocalUser -Name '$addUserCommand' -ErrorAction SilentlyContinue" >/dev/null

            if [ $? = 1 ]; then

                read -p "► Voulez-vous créer l'utilisateur $addUserCommand ? (o/n) : " confirmUser
                logEvent "AJOUT_UTILISATEUR:CONFIRMATION:$confirmUser:$addUserCommand"

                if [ "$confirmUser" = "o" ]; then

                    logEvent "AJOUT_UTILISATEUR:CREATION:$addUserCommand"

                    # Commande création de l'utilisateur.
                    powershell_command "New-LocalUser -Name '$addUserCommand' -NoPassword | Out-Null"

                    logEvent "AJOUT_UTILISATEUR:VERIFICATION_CREATION:$addUserCommand"

                    # Vérification si l'utilisateur a bien été créé.
                    powershell_command "Get-LocalUser -Name '$addUserCommand'" >/dev/null

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
        echo -e "► ${RED}Entrée Invalide!!!{NC}"
        echo "► Retour au menu précédent."
        echo ""
        ;;

    esac

}


#==============================================================
# 03 - SUPPRIMER UTILISATEURS
#==============================================================
function deleteUserMenuWindows() {

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

            # Vérification si l'utilisateur existe.
            powershell_command "Get-LocalUser -Name '$delUserCommand' -ErrorAction SilentlyContinue" >/dev/null

            if [ $? = 1 ]; then

                echo ""
                echo -e "► ${RED}L'utilisateur n'existe pas.${NC}"
                echo ""
                logEvent "SUPPRIMER_UTILISATEUR:UTILISATEUR_INEXISTANT:$delUserCommand"

            else

                read -p "► Souhaitez-vous supprimer l'utilisateur $delUserCommand ? (o/n) " delUserChoice
                logEvent "SUPPRIMER_UTILISATEUR:CONFIRMATION:$delUserChoice:$delUserCommand"

                if [ "$delUserChoice" = "o" ]; then

                    logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_UTILISATEUR:$delUserCommand"

                    # Commande pour supprimer l'utilisateur entrée.
                    powershell_command "Remove-LocalUser -Name '$delUserCommand' | Out-Null"

                    logEvent "SUPPRIMER_UTILISATEUR:VERIFICATION_UTILISATEUR_SUPPRESSION:$delUserCommand"

                    # Vérification si l'utilisateur est toujours présent dans le système.
                    powershell_command "Get-LocalUser -Name '$delUserCommand' -ErrorAction SilentlyContinue" >/dev/null

                    if [ $? = 1 ]; then

                        echo -e "► ${GREEN}L'utilisateur $delUserCommand a été supprimé.${NC}"
                        logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_REUSSIE:$delUserCommand"

                        read -p "► Voulez-vous supprimer un autre utilisateur ? (o/n) " delAnotherUser
                        echo ""
                        logEvent "SUPPRIMER_UTILISATEUR:CONTINUER?:$delAnotherUser"

                    else

                        echo ""
                        echo -e "► ${RED}L'utilisateur $delUserCommand n'a pas été supprimé.${NC}"
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
        powershell_command "Get-LocalUser | Select-Object Name"
        echo ""

        logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"

        deleteUserMenuWindows
        ;;

    3)

        logEvent "MENU_SUPPRIMER_UTILISATEUR:RETOUR_MENU_PRECEDENT"
        return
        ;;

    *)

        logEvent "MENU_SUPPRIMER_UTILISATEUR:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        ;;

    esac
}


#==============================================================
# 04 - CHANGER MOT DE PASSE UTILISATEUR
#==============================================================
function changePasswordUserMenuWindows() {

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

        logEvent "MENU_CHANGER_MOT_DE_PASSE:SAISIR_NOM_UTILISATEUR"
        changeAnotherPassword="o"

        while [ "$changeAnotherPassword" = "o" ]; do

            read -p "► Entrer un nom d'utilisateur : " changePasswordUser
            logEvent "CHANGEMENT_MOT_DE_PASSE:SAISIE_NOM:$changePasswordUser"

            logEvent "CHANGEMENT_MOT_DE_PASSE:VERIFICATION_EXISTENCE:$changePasswordUser"

            # Vérification si l'utilisateur existe.
            powershell_command "Get-LocalUser -Name '$changePasswordUser' -ErrorAction SilentlyContinue" >/dev/null

            if [ $? = 1 ]; then

                echo -e "► ${RED}Cet utilisateur n'existe pas ${NC}"
                logEvent "CHANGEMENT_MOT_DE_PASSE:UTILISATEUR_INEXISTANT:$changePasswordUser"

            else

                logEvent "CHANGEMENT_MOT_DE_PASSE:UTILISATEUR_EXISTE:$changePasswordUser"

                read -p "► Souhaitez-vous changer le mot de passe de l'utilisateur $changePasswordUser ? (o/n) " changepasswordUserChoice
                logEvent "CHANGEMENT_MOT_DE_PASSE:CONFIRMATION:$changepasswordUserChoice:$changePasswordUser"

                if [ "$changepasswordUserChoice" = "o" ]; then

                    logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_DEBUT:$changePasswordUser"
                    read -s -p "► Entrez le nouveau mot de passe pour $changePasswordUser : " newPassword
                    echo ""

                    # Commande pour changer le mot de passe de l'utilisateur entrée.
                    powershell_command "\$securePassword = ConvertTo-SecureString '$newPassword' -AsPlainText -Force; Set-LocalUser -Name '$changePasswordUser' -Password \$securePassword | Out-Null"

                    if [ $? = 0 ]; then

                        echo "► Le mot de passe de l'utilisateur $changePasswordUser a été modifié."
                        logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_REUSSIE:$changePasswordUser"
                        read -p "► Voulez-vous changer le mot de passe d'un autre utilisateur ? (o/n) " changeAnotherPassword
                        echo ""

                    else

                        echo "► Erreur lors de la modification du mot de passe de l'utilisateur $changePasswordUser."
                        echo ""
                        logEvent "CHANGEMENT_MOT_DE_PASSE:MODIFICATION_ECHOUEE:$changePasswordUser"

                    fi

                else

                    echo "► Retour au menu."
                    logEvent "CHANGEMENT_MOT_DE_PASSE:ANNULATION:$changePasswordUser"
                    changeAnotherPassword="n"

                fi
            fi
        done
        ;;

    2)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:AFFICHER_LISTE_UTILISATEURS"
        echo ""
        echo "► Liste des utilisateurs : "
        powershell_command "Get-LocalUser | Select-Object Name"
        logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"
        changePasswordUserMenuWindows
        ;;

    3)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:RETOUR_MENU_PRECEDENT"
        return
        ;;

    *)

        logEvent "MENU_CHANGER_MOT_DE_PASSE:ENTREE_INVALIDE"
        echo -e "► ${RED}Entrée invalide !${NC}"
        ;;

    esac

}

