# Script Gestion de groupes Windows en Powershell


# Liste des fonctions :
# 1. Menu Groupe
# 2. Ajouter un utilisateur au groupe Admin
# 3. Ajouter un utilisateur à un groupe
# 4. Supprimer un utilisateur d'un groupe


#==============================================================
# 1 - MENU GROUPE
#==============================================================
function gestion_menu_group_windows {

    logEvent "MENU_GROUPE"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮"
        Write-Host "│                   MENU GROUPE                    │"
        Write-Host "├──────────────────────────────────────────────────┤"
        Write-Host "│                                                  │"
        Write-Host "│  1. Ajouter un utilisateur au groupe Admin       │"
        Write-Host "│  2. Ajouter un utilisateur à un groupe           │"
        Write-Host "│  3. Retirer un utilisateur d'un groupe           │"
        Write-Host "│  4. Retour au menu précédent                     │"
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $groupMainMenu = Read-Host "► Choisissez une option"

        switch ($groupMainMenu) {

            1 {
                logEvent "MENU_GROUPES:AJOUT_D'_UTILISATEUR_AU_GROUPE_ADMIN"
                add_user_admin_group_windows
            }

            2 {
                logEvent "MENU_GROUPES:AJOUT_D'UN_UTILISATEUR_À_UN_GROUPE"
                add_user_group_windows
            }

            3 {
                logEvent "MENU_GROUPES:SORTIE_D'UN_UTILISATEUR_D'UN_GROUPE"
                del_user_group_windows
            }    

            4 {
                logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
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
# 2 - FONCTION AJOUTER UN UTILISATEUR AU GROUPE ADMIN
#==============================================================
function add_user_admin_group_windows {

    logEvent "MENU_AJOUT_GROUPE_ADMIN"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│      AJOUTER UTILISATEUR AU GROUPE ADMIN         │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir le nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""
    
    $addGroupAdmin = Read-Host "► Choisissez une option"

    switch ($addGroupAdmin) {
        1 {
            logEvent "MENU_AJOUT_GROUPE_ADMIN:SAISIE_UTILISATEUR:"
            
            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_AJOUT_GROUPE_ADMIN:RETOUR_MENU_PRECEDENT"
            gestion_menu_group_windows
        }

        default {
            logEvent "MENU_AJOUT_GROUPE_ADMIN:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }


}



#==============================================================
# 3 - FONCTION AJOUTER UN UTILISATEUR A UN GROUPE
#==============================================================

function add_user_group_windows {

    logEvent "MENU_AJOUT_GROUPE"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│          AJOUTER UTILISATEUR A UN GROUPE         │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir le nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $addGroup = Read-Host "► Choisissez une option"

    switch ($addGroup) {
        1 {
            logEvent "MENU_AJOUT_GROUPE:SAISIE_UTILISATEUR:"
            
            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_AJOUT_GROUPE:RETOUR_MENU_PRECEDENT"
            gestion_menu_group_windows
        }

        default {
            logEvent "MENU_AJOUT_GROUPE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }

}




#==============================================================
# 4 - FONCTION RETIRER UN UTILISATEUR D'UN GROUPE
#==============================================================

function del_user_group_windows {

    logEvent "MENU_SUPPRESSION_GROUPE"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│      SUPPRIMER UN UTILISATEUR D'UN GROUPE        │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir le nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $delGroup = Read-Host "► Choisissez une option"

    switch ($delGroup) {
        1 {
            logEvent "MENU_SUPPRESSION_GROUPE:SAISIE_UTILISATEUR:"
            
            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_SUPPRESSION_GROUPE:RETOUR_MENU_PRECEDENT"
            gestion_menu_group_windows
        }

        default {
            logEvent "MENU_SUPPRESSION_GROUPE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }

}
