#!/bin/bash

# Script de gestion groupes et utilisateurs
# Auteur : Pierre-Jean

# Sommaire :
# 01 - Menu Groupe
# 02 - Ajouter un utilisateur au groupe Admin
# 03 - Ajouter un utilisateur à un groupe
# 04 - Supprimer un utilisateur d'un groupe


#==============================================================
#region 01 - MENU GROUPE
#==============================================================
fonc_menu_group_windows() {
    logEvent "MENU_GROUPES"
    while true; do
        echo ""
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
        echo ""
        echo -n "► Votre choix (1-4): "
        echo ""
        read selection

        case $selection in

        1)
            logEvent "MENU_GROUPES:AJOUT_D'_UTILISATEUR_AU_GROUPE_ADMIN"
            fonc_add_user_admin_windows
            ;;
        2)
            logEvent "MENU_GROUPES:AJOUT_D'UN_UTILISATEUR_À_UN_GROUPE"
            fonc_add_user_group_windows
            ;;
        3)
            logEvent "MENU_GROUPES:SORTIE_D'UN_UTLISATEUR_D'UN_GROUPE"
            fonc_exit_group_windows
            ;;
        4)

            userMainMenu
            ;;
        *)
            echo "Erreur de saisie"
            fonc_menu_group_windows
            ;;

        esac
    done

}
#endregion


#==============================================================
#region 02 - FONCTION AJOUTER UN UTILISATEUR AU GROUPE ADMIN
#==============================================================
fonc_add_user_admin_windows() {
    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│      AJOUTER UTILISATEUR AU GROUPE ADMIN         │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur à ajouter        │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""

    read -p "► Choisissez une option : " choix
    case $choix in

    1)
        echo ""
        echo "► Voici la liste des utilisateurs Windows :"
        powershell_command "Get-LocalUser | Select-Object Name"
        echo ""

        read -p "► Quel utilisateur souhaitez-vous ajouter en administrateur ? : " useraddadmin
        logEvent "ENTRÉE_D'UTILISATEUR:$useraddadmin"

        # Vérification existence utilisateur
        if powershell_command "Get-LocalUser -Name '$useraddadmin' -ErrorAction SilentlyContinue" >/dev/null; then
            echo ""
            echo "► Ajout de l'utilisateur au groupe Administrateurs..."
            logEvent "DÉBUT_AJOUT_UTILISATEUR_ADMIN:$useraddadmin"

            # Ajout au groupe Administrateurs (nom système : Administrators)
            powershell_command "Add-LocalGroupMember -Group 'Administrateurs' -Member '$useraddadmin'"

            # Vérification que l'utilisateur est bien dans le groupe Administrateurs
            if powershell_command "Get-LocalGroupMember -Group 'Administrateurs' -Member '$useraddadmin' -ErrorAction SilentlyContinue" >/dev/null; then
                echo "► L'utilisateur '$useraddadmin' a bien été ajouté au groupe Administrateurs."
                logEvent "UTILISATEUR:$useraddadmin AJOUTÉ_AU_GROUPE:Administrators"

                echo ""
                read -p "► Souhaitez-vous ajouter un autre administrateur ? (o/n) : " conf

                if [ "$conf" = "o" ]; then
                    fonc_add_user_admin_windows
                else
                    fonc_menu_group_windows
                fi
            else
                echo "ERREUR : l'utilisateur n'a pas été ajouté au groupe Administrateurs."
                logEvent "ERREUR_AJOUT_ADMIN_UTILISATEUR:$useraddadmin"
                exit 130
            fi

        else
            echo ""
            read -p "► Cet utilisateur n'existe pas. Voulez-vous en choisir un autre ? (o/n) : " conf
            if [ "$conf" = "o" ]; then
                logEvent "UTILISATEUR_INEXISTANT_NOUVELLE_SAISIE"
                fonc_add_user_admin_windows
            else
                fonc_menu_group_windows
            fi
        fi
        ;;

    2)
        fonc_menu_group_windows
        ;;

    *)
        echo "Erreur de saisie"
        ;;
    esac
}
#endregion


#==============================================================
#region 03 - FONCTION AJOUTER UN UTILISATEUR A UN GROUPE
#==============================================================
fonc_add_user_group_windows() {
    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│                   MENU GROUPES                   │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Ajouter un utilisateur à un groupe           │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
    read -p "► Choisissez une option : " choix

    case $choix in

    1)
        # Saisie utilisateur
        read -p "► Quel utilisateur souhaitez-vous ajouter au groupe ? : " useraddgroup
        logEvent "ENTRÉE_D'UTILISATEUR:$useraddgroup"

        # Vérifier si l'utilisateur Windows existe
        if powershell_command "Get-LocalUser -Name '$useraddgroup' -ErrorAction SilentlyContinue" >/dev/null; then
            echo "► L'utilisateur existe."

            # Saisie groupe
            read -p "► À quel groupe souhaitez-vous l'ajouter ? : " namegroup

            # Vérifier si le groupe Windows existe
            if powershell_command "Get-LocalGroup -Name '$namegroup' -ErrorAction SilentlyContinue" >/dev/null; then
                echo "► Le groupe existe, ajout en cours..."

                # Ajout de l'utilisateur
                powershell_command "Add-LocalGroupMember -Group '$namegroup' -Member '$useraddgroup'"

                echo "► L'utilisateur '$useraddgroup' a été ajouté au groupe '$namegroup'."
                logEvent "UTILISATEUR:$useraddgroup AJOUTÉ_AU_GROUPE:$namegroup"

                echo ""
                read -p "► Souhaitez-vous ajouter un autre utilisateur ? (o/n) : " conf
                if [ "$conf" = "o" ]; then
                    fonc_add_user_group_windows
                else
                    fonc_menu_group_windows
                fi

            else
                # Le groupe n'existe pas
                echo ""
                read -p "► Le groupe n'existe pas. Voulez-vous le créer puis ajouter l'utilisateur ? (o/n) : " conf

                if [ "$conf" = "o" ]; then
                    powershell_command "New-LocalGroup -Name '$namegroup'"
                    powershell_command "Add-LocalGroupMember -Group '$namegroup' -Member '$useraddgroup'"

                    echo "► Groupe '$namegroup' créé et utilisateur ajouté."
                    logEvent "GROUPE:$namegroup CRÉÉ_UTILISATEUR_AJOUTÉ:$useraddgroup"

                    fonc_menu_group_windows
                else
                    fonc_menu_group_windows
                fi
            fi

        else
            # Utilisateur introuvable
            echo ""
            read -p "► Cet utilisateur n'existe pas. Voulez-vous en choisir un autre ? (o/n) : " conf

            if [ "$conf" = "o" ]; then
                logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                fonc_add_user_group_windows
            else
                fonc_menu_group_windows
            fi
        fi
        ;;

    2)
        fonc_menu_group_windows
        ;;

    *)
        echo "Erreur de saisie"
        ;;
    esac
}
#endregion


#==============================================================
#region 04 - FONCTION RETIRER UN UTILISATEUR D'UN GROUPE
#==============================================================
fonc_exit_group_windows() {
    echo ""
    echo "╭──────────────────────────────────────────────────╮"
    echo "│       RETIRER UN UTILISATEUR D'UN GROUPE         │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│                                                  │"
    echo "│  1. Saisir un nom d'utilisateur                  │"
    echo "│  2. Retour au menu précédent                     │"
    echo "│                                                  │"
    echo "╰──────────────────────────────────────────────────╯"
    echo ""
    read -p "► Choisissez une option : " choix

    case $choix in

    1)

        read -p "► Quel utilisateur souhaitez-vous sortir du groupe ? : " userexitgroup
        logEvent "ENTRÉE_D'UTILISATEUR:$userexitgroup"

        # Vérifier l'existence de l'utilisateur
        if powershell_command "Get-LocalUser -Name '$userexitgroup' -ErrorAction SilentlyContinue" >/dev/null; then

            echo ""
            echo "► L'utilisateur existe."
            echo "► Recherche des groupes auxquels il appartient :"
            echo ""

            # Récupérer les groupes Windows de l'utilisateur
            groups=$(powershell_command "Get-LocalGroup | ForEach-Object { if (Get-LocalGroupMember -Group \$_.Name -Member '$userexitgroup' -ErrorAction SilentlyContinue) { \$_.Name } }")

            if [ -z "$groups" ]; then
                echo "► Cet utilisateur n'appartient à aucun groupe."
                fonc_menu_group_windows
                return
            fi

            echo "$groups"
            echo ""
            read -p "► Choisissez le groupe duquel retirer l'utilisateur : " exitgroup

            # Vérifier que ce groupe existe et contient l’utilisateur
            if powershell_command "Get-LocalGroupMember -Group '$exitgroup' -Member '$userexitgroup' -ErrorAction SilentlyContinue" >/dev/null; then

                # Retrait du groupe
                powershell_command "Remove-LocalGroupMember -Group '$exitgroup' -Member '$userexitgroup'"

                echo ""
                echo "► L'utilisateur '$userexitgroup' a été retiré du groupe '$exitgroup'."
                logEvent "UTILISATEUR:$userexitgroup RETIRÉ_DU_GROUPE:$exitgroup"

                echo ""
                read -p "► Souhaitez-vous retirer un autre utilisateur ? (o/n) : " conf

                if [ "$conf" = "o" ]; then
                    fonc_exit_group_windows
                else
                    fonc_menu_group_windows
                fi

            else
                echo ""
                echo "► ERREUR : L'utilisateur n'est pas dans ce groupe ou le groupe n'existe pas."
                logEvent "ERREUR_SORTIE_GROUPE_UTILISATEUR:$userexitgroup GROUPE:$exitgroup"
                fonc_menu_group_windows
            fi

        else
            echo ""
            read -p "► Cet utilisateur n'existe pas. Voulez-vous en saisir un autre ? (o/n) : " conf

            if [ "$conf" = "o" ]; then
                fonc_exit_group_windows
            else
                fonc_menu_group_windows
            fi
        fi
        ;;

    2)
        fonc_menu_group_windows
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
#endregion
