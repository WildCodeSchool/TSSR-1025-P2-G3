# Script Gestion Utilisateurs Windows en Powershell


# Liste des fonctions :
# 1. Menu Utilisateurs
# 2. Ajouter utilisateur
# 3. Supprimer utilisateur
# 4. Changer mot de passe utilisateur


#==============================================================
# 1 - MENU UTILISATEURS
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
                ##########################  FONCTION A FAIRE ICI ##########################

                logEvent "MENU_UTILISATEUR:AFFICHAGE_LISTE_UTILISATEUR"
            }  

            5 {
                logEvent "MENU_UTILISATEUR:RETOUR_MENU_PRECEDENT"
                Write-Host "Retour au menu précédent"
                userMainMenu
            }    

            default {
                logEvent "OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"

            }
        }
    }
}



#==============================================================
# 2 - AJOUTER UTILISATEURS
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

    switch ($addUserMenu) {
        
        1 {
            logEvent "MENU_AJOUT_UTILISATEUR:SAISIR_NOM_UTILISATEUR"

            ##########################  FONCTION A FAIRE ICI ##########################
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



#==============================================================
# 3 - SUPPRIMER UTILISATEURS
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

    switch ($delUserMenu) {
        
        1 {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:SAISIR_NOM_UTILISATEUR"

            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_SUPPRIMER_UTILISATEUR:AFFICHER_LISTE_UTILISATEURS"

            Write-Host "► Liste des utilisateurs : "
            ##########################  FONCTION A FAIRE ICI ##########################

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
        }
    }
}



#==============================================================
# 4 - SUPPRIMER UTILISATEURS
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

    switch ($changePasswordMenu) {
        
        1 {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:SAISIR_NOM_UTILISATEUR"

            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_CHANGER_MOT_DE_PASSE:AFFICHER_LISTE_UTILISATEURS"

            Write-Host "► Liste des utilisateurs : "
            ##########################  FONCTION A FAIRE ICI ##########################

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
        }
    }
}