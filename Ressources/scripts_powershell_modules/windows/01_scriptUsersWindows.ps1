# Script Gestion Utilisateurs Windows en Powershell
# Auteur : Christian



# Sommaire :
# 01 - Menu Utilisateurs
# 02 - Ajouter utilisateur
# 03 - Supprimer utilisateur
# 04 - Changer mot de passe utilisateur



#==============================================================
#region 01 - MENU UTILISATEURS
#==============================================================
function userMenu_windows {

    logEvent "MENU_UTILISATEUR"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭────────────────────────────────────────────────╮"
        Write-Host "│                MENU UTILISATEUR                │"
        Write-Host "├────────────────────────────────────────────────┤"
        Write-Host "│                                                │"
        Write-Host "│  1. Ajouter un utilisateur                     │"
        Write-Host "│  2. Supprimer un utilisateur                   │"
        Write-Host "│  3. Changer le mot de passe d'un Utilisateur   │"
        Write-Host "│  4. Afficher les Utilisateurs                  │"
        Write-Host "│  5. Retour au menu précédent                   │"
        Write-Host "│                                                │"
        Write-Host "╰────────────────────────────────────────────────╯"
        Write-Host ""
        
        $menuUser = Read-Host "► Choisissez une option "
        Write-Host ""

        switch ($menuUser) {

            1 {
                logEvent "MENU_UTILISATEUR:AJOUTER_UN_UTILISATEUR"
                addUserMenu_Windows
            }

            2 {
                logEvent "MENU_UTILISATEUR:SUPPRIMER_UN_UTILISATEUR"
                deleteUserMenu_windows
            }

            3 {
                logEvent "MENU_UTILISATEUR:CHANGER_MOT_DE_PASSE_UTILISATEUR"
                changePasswordUserMenu_windows
            }    

            4 {
                logEvent "MENU_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"
    
                Write-Host "► Liste des utilisateurs : "
                command_ssh "Get-LocalUser | Select-Object -ExpandProperty Name"

                Write-Host ""

                logEvent "MENU_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"
            }  

            5 {
                logEvent "MENU_UTILISATEUR:RETOUR_MENU_PRECEDENT"
                Write-Host "► Retour au menu précédent"
                userMainMenu
            }    

            default {
                logEvent "MENU_UTILISATEUR:OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"

            }
        }
    }
}
#endregion


#==============================================================
#region 02 - AJOUTER UTILISATEURS
#==============================================================
function addUserMenu_Windows {

    logEvent "MENU_AJOUT_UTILISATEUR"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│               AJOUTER UTILISATEUR                │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $addUserMenu = Read-Host "► Choisissez une option "
    Write-Host ""


    switch ($addUserMenu) {

        1 {
            logEvent "MENU_AJOUT_UTILISATEUR:SAISIR_NOM_UTILISATEUR"
            $UserCreationChoice = "o"

            while ($UserCreationChoice -eq "o") {

                $addUserCommand = Read-Host "► Entrez un nom d'utilisateur"
                Write-Host ""

                logEvent "AJOUT_UTILISATEUR:ENTREE_UTILISATEUR:$addUserCommand"

                logEvent "AJOUT_UTILISATEUR:VERIFICATION_UTILISATEUR_EXISTE:$addUserCommand"

                # Vérification si l'utilisateur existe déjà
                $userExists = command_ssh "Get-LocalUser -Name $addUserCommand -ErrorAction SilentlyContinue"

                if (-not $userExists) {

                    $ConfirmUser = Read-Host "► Voulez-vous créer l'utilisateur '$addUserCommand' ? (o/n)"
                    Write-Host ""

                    logEvent "AJOUT_UTILISATEUR:CONFIRMATION:$ConfirmUser : $addUserCommand"

                    if ($ConfirmUser -eq "o") {

                        logEvent "AJOUT_UTILISATEUR:CREATION:$addUserCommand"
                        command_ssh "New-LocalUser -Name $addUserCommand -NoPassword"

                        logEvent "AJOUT_UTILISATEUR:VERIFICATION_CREATION:$addUserCommand"

                        # Vérification si l'utilisateur a été créé
                        $userExists = command_ssh "Get-LocalUser -Name $addUserCommand -ErrorAction SilentlyContinue"

                        if ($userExists) {

                            Write-Host "► L'utilisateur $addUserCommand a été créé."
                            Write-Host ""
                            logEvent "AJOUT_UTILISATEUR:CREATION_REUSSIE:$addUserCommand"

                            $UserCreationChoice = Read-Host "► Voulez-vous créer un autre utilisateur ? (o/n) "
                            Write-Host ""
                            logEvent "AJOUT_UTILISATEUR:CONTINUER_AJOUT_UTILISATEUR:$userCreationChoice"

                        } else {

                            Write-Host "► L'utilisateur $addUserCommand n'a pas été créé. "
                            logEvent "AJOUT_UTILISATEUR:CREATION_ECHOUEE:$addUserCommand"
                            addUserMenu_Windows
                        }
                    } else {

                        Write-Host "► Retour au menu précédent."
                        logEvent "AJOUT_UTILISATEUR:ANNULATION:$addUserCommand"
                    }

                } else {

                    Write-Host "► L'utilisateur $addUserCommand existe déjà."
                    Write-Host ""
                    logEvent "AJOUT_UTILISATEUR:UTILISATEUR_EXISTE_DEJA:$addUserCommand"

                    $UserCreationChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    Write-Host ""
                    logEvent "AJOUT_UTILISATEUR:REESSAYER_AJOUT_UTILISATEUR:$UserCreationChoice"    

                }
            }
        }

        2 {

            logEvent "MENU_AJOUT_UTILISATEUR:RETOUR_AU_MENU_PRECEDENT"
            userMenu_windows
        }

        default {

            logEvent "MENU_AJOUT_UTILISATEUR:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }
}
#endregion


#==============================================================
#region 03 - SUPPRIMER UTILISATEURS
#==============================================================
function deleteUserMenu_windows {

    logEvent "MENU_SUPPRIMER_UTILISATEUR"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│              SUPPRIMER UTILISATEUR               │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Afficher la liste des utilisateurs           │"
    Write-Host "│  3. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $delUserMenu = Read-Host "► Choisissez une option "
    Write-Host ""

    switch ($delUserMenu) {

        1 {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:SAISIR_NOM_UTILISATEUR"

            $delAnotherUser = "o" 

            while ($delAnotherUser -eq "o") {   

                $delUserCommand = Read-Host "► Entrez un nom d'utilisateur à supprimer"
                Write-Host ""
                logEvent "SUPPRIMER_UTILISATEUR:ENTREE_UTILISATEUR:$delUserCommand"

                logEvent "SUPPRIMER_UTILISATEUR:VERIFICATION_UTILISATEUR_EXISTE:$delUserCommand"

                # Vérification si l'utilisateur existe
                $userExists = command_ssh "Get-LocalUser -Name $delUserCommand -ErrorAction SilentlyContinue"

                if ($userExists) {

                    $confirmDelUser = Read-Host "► Voulez-vous supprimer l'utilisateur '$delUserCommand' ? (o/n)"
                    Write-Host ""
                    logEvent "SUPPRIMER_UTILISATEUR:CONFIRMATION:$confirmDelUser : $delUserCommand"

                    if ($confirmDelUser -eq "o") {

                        logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION:$delUserCommand"
                        command_ssh "Remove-LocalUser -Name $delUserCommand"

                        logEvent "SUPPRIMER_UTILISATEUR:VERIFICATION_SUPPRESSION:$delUserCommand"

                        # Vérification si l'utilisateur a été supprimé
                        $userDeleted = command_ssh "Get-LocalUser -Name $delUserCommand -ErrorAction SilentlyContinue"

                        if (-not $userDeleted) {

                            Write-Host "► L'utilisateur $delUserCommand a été supprimé."
                            Write-Host ""
                            logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_REUSSIE:$delUserCommand"

                        } else {

                            Write-Host "► L'utilisateur $delUserCommand n'a pas été supprimé."
                            logEvent "SUPPRIMER_UTILISATEUR:SUPPRESSION_ECHOUEE:$delUserCommand"
                        }

                    } else {

                        Write-Host "► Retour au menu précédent."
                        logEvent "SUPPRIMER_UTILISATEUR:ANNULATION:$delUserCommand"
                    }

                } else {

                    Write-Host "► L'utilisateur $delUserCommand n'existe pas."
                    Write-Host ""
                    logEvent "SUPPRIMER_UTILISATEUR:UTILISATEUR_INEXISTANT:$delUserCommand"
                }
                $delAnotherUser = Read-Host "► Voulez-vous supprimer un autre utilisateur ? (o/n)"
                Write-Host ""
            }
        }

        2 {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"

            Write-Host "► Liste des utilisateurs : "
            command_ssh "Get-LocalUser | Select-Object -ExpandProperty Name"
            Write-Host ""

            logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"

            deleteUserMenu_windows
        }

        3 {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:RETOUR_MENU_PRECEDENT"
            userMenu_windows
        }

        default {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
            Write-Host ""
        }
    }

}
#endregion


#==============================================================
#region 04 - CHANGER MOT DE PASSE UTILISATEUR
#==============================================================
function changePasswordUserMenu_windows {

    logEvent "MENU_CHANGER_MOT_DE_PASSE"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│         CHANGER MOT DE PASSE UTILISATEUR         │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Afficher la liste des utilisateurs           │"
    Write-Host "│  3. Retour au menu précédent                     │"

    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $changePasswordMenu = Read-Host "► Choisissez une option "
    Write-Host ""

    switch ($changePasswordMenu) {

        1 {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:SAISIR_NOM_UTILISATEUR"

            $changeAnotherPassword = "o"


            while ($changeAnotherPassword -eq "o") {

                $changePasswordUserCommand = Read-Host "► Entrez un nom d'utilisateur pour changer le mot de passe"
                Write-Host ""
                logEvent "CHANGER_MOT_DE_PASSE:ENTREE_UTILISATEUR:$changePasswordUserCommand"

                logEvent "CHANGER_MOT_DE_PASSE:VERIFICATION_UTILISATEUR_EXISTE:$changePasswordUserCommand"

                # Vérification si l'utilisateur existe
                $userExists = command_ssh "Get-LocalUser -Name $changePasswordUserCommand -ErrorAction SilentlyContinue"

                if ($userExists) {

                    $newPassword = Read-Host "► Entrez le nouveau mot de passe"
                    Write-Host ""
                    logEvent "CHANGER_MOT_DE_PASSE:NOUVEAU_MOT_DE_PASSE_ENTRE:$changePasswordUserCommand"

                    command_ssh "Set-LocalUser -Name $changePasswordUserCommand -Password $newPassword"
                    logEvent "CHANGER_MOT_DE_PASSE:CHANGEMENT_EFFECTUE:$changePasswordUserCommand"

                    Write-Host "► Le mot de passe de l'utilisateur $changePasswordUserCommand a été changé."
                    Write-Host ""
                    logEvent "CHANGER_MOT_DE_PASSE:CHANGEMENT_REUSSI:$changePasswordUserCommand"

                    $changeAnotherPassword = Read-Host "► Voulez-vous changer le mot de passe d'un autre utilisateur ? (o/n) "
                    Write-Host ""
                    logEvent "CHANGER_MOT_DE_PASSE:CONTINUER_CHANGEMENT_MOT_DE_PASSE:$changeAnotherPassword"

                } else {

                    Write-Host "► L'utilisateur $changePasswordUserCommand n'existe pas."
                    logEvent "CHANGER_MOT_DE_PASSE:UTILISATEUR_INEXISTANT:$changePasswordUserCommand"

                    # Demander si l'utilisateur veut réessayer
                    $changeAnotherPassword = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    Write-Host ""
                    logEvent "CHANGER_MOT_DE_PASSE:REESSAYER_CHANGEMENT_MOT_DE_PASSE:$changeAnotherPassword"  
                }
            }
        }

        2 {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:AFFICHER_LISTE_UTILISATEURS"

            Write-Host "► Liste des utilisateurs : "
            command_ssh "Get-LocalUser | Select-Object -ExpandProperty Name"
            Write-Host ""

            logEvent "SUPPRIMER_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"

            changePasswordUserMenu_windows
        }
        3 {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:RETOUR_MENU_PRECEDENT"
            userMenu_windows
        }

        default {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
            Write-Host ""
        }
    }
}
#endregion





