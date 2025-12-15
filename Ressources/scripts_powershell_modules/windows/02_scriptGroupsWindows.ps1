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
            
            Write-Host ""
            Write-Host "► Voici la liste des utilisateurs : "
            $users = command_ssh "Get-LocalUser | Where-Object { $_.Enabled -eq $true }"
            $users.Name
            Write-Host ""

            $useraddadmin = Read-Host "► Quel utilisateur souhaitez vous ajouter en admin ? "
            logEvent "ENTRÉE_D'UTILISATEUR:$useraddadmin"

            if ($users.Name -contains $useraddadmin) {
                Write-Host ""
                logEvent "AJOUT_DE_L'UTILSATEUR:$useraddadmin"
                
                try {
                    command_ssh "Add-LocalGroupMember -Group "Administrateurs" -Member $useraddadmin -ErrorAction Stop"
                    
                    if (command_ssh "Get-LocalGroupMember -Group "Administrateurs" | Where-Object { $_.Name -like "*\$useraddadmin" }") {
                        Write-Host "L'utilisateur $useraddadmin a bien été ajouté au groupe Administrateurs"
                        logEvent "AJOUT_DE_L'UTILISATEUR_SUDO:$useraddadmin"
                        
                        $conf = Read-Host "► Souhaitez-vous ajouter un autre utilisateur au groupe Admin (o/n) ? "
                        if ($conf -eq "o") {
                            add_user_admin_group_windows
                        }
                        else {
                            gestion_menu_group_windows
                        }
                    }
                    else {
                        throw "Verification failed"
                    }
                }
                catch {
                    Write-Host "erreur (Assurez-vous que le groupe 'Administrateurs' existe ou essayez 'Administrators')"
                    logEvent "ERREUR_DU_SCRIPT_DANS_AJOUT_UTILISATEUR_GROUPE_ADMIN"
                    add_user_admin_group_windows
                }
            }
            else {
                Write-Host ""
                $conf = Read-Host "► l'utilisateur demandé n'existe pas, souhaitez vous choisir un autre utilisateur ? (o/n) : "
                if ($conf -eq "o") {
                    logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                    add_user_admin_group_windows
                }
                else {
                    gestion_menu_group_windows
                }
            }
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
            
            $useraddgroup = Read-Host "► Quel utilisateur souhaitez vous ajouter au groupe ? "
            logEvent "ENTRÉE_D'UTILISATEUR:$useraddgroup"

            $u = command_ssh "Get-LocalUser -Name $useraddgroup -ErrorAction SilentlyContinue"

            if ($u) {
                Write-Host "► Ok pour cet utilisateur, a quel groupe souhaitez vous l'ajouter ?"
                $namegroup = Read-Host

                $g = command_ssh "Get-LocalGroup -Name $namegroup -ErrorAction SilentlyContinue"

                if ($g) {
                    command_ssh "Add-LocalGroupMember -Group $namegroup -Member $useraddgroup"
                    if (command_ssh "Get-LocalGroupMember -Group $namegroup | Where-Object { $_.Name -like "*\$useraddgroup" }") {
                        Write-Host "► L'utilisateur a bien été ajouté au groupe $namegroup "
                        logEvent "UTILISATEUR:$namegroup À_ÉTÉ_AJOUTÉ_AU_GROUPE:$useraddgroup"

                        Write-Host ""
                        $conf = Read-Host "souhaitez-vous ajouter un autre utilisateur ? (o/n) : "
                        if ($conf -eq "o") {
                            add_user_group_windows
                        }
                        else {
                            gestion_menu_group_windows
                        }
                    }
                }
                else {
                    Write-Host ""
                    $conf = Read-Host "► Le groupe n'existe pas, souhaitez vous le créer et y ajouter l'utilisateur ? (o/n) : "
                    if ($conf -eq "o") {
                        command_ssh "New-LocalGroup -Name $namegroup"
                        command_ssh "Add-LocalGroupMember -Group $namegroup -Member $useraddgroup"
                        Write-Host "► Le groupe $namegroup a été créé en y ajoutant l'utilisateur $useraddgroup"
                        logEvent "AJOUT_DE_DE_L'UTILISATEUR:$useraddgroup AU_GROUPE:$namegroup"
                    }
                    else {
                        gestion_menu_group_windows
                    }
                }
            }
            else {
                Write-Host ""
                $conf = Read-Host "► Cet utilisateur n'existe pas, souhaitez vous choisir un autre utilisateur ? (o/n) : "
                if ($conf -eq "o") {
                    logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                    add_user_group_windows
                }
                else {
                    gestion_menu_group_windows
                }
            }
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
            
            $userexitgroup = Read-Host "► Quel utilisateur souhaitez-vous sortir du groupe ? "
            $u = command_ssh "Get-LocalUser -Name $userexitgroup -ErrorAction SilentlyContinue"
            
            if ($u) {
                logEvent "ENTRÉE_D'UTILISATEUR:$userexitgroup"
                Write-Host ""
                Write-Host "► C'est d'accord pour cet utilisateur "
                Write-Host "► Voici le ou les groupes dans lequel $userexitgroup est présent "
                Write-Host ""

                $memberships = command_ssh "Get-LocalUser -Name $userexitgroup | Get-LocalGroupMembership"
                $cleanNames = $memberships | ForEach-Object { $_.Name.Split('\')[-1] }
                $cleanNames

                Write-Host ""
                $exitgroup = Read-Host "► Quel groupe choisissez vous pour la sortie de $userexitgroup ? "

                if ($cleanNames -contains $exitgroup) {
                    try {
                        command_ssh "Remove-LocalGroupMember -Group $exitgroup -Member $userexitgroup -ErrorAction Stop"
                        Write-Host ""
                        Write-Host "► L'utilisateur $userexitgroup a bien été retiré du groupe $exitgroup "
                        logEvent "UTILISATEUR_'$userexitgroup'_A_ÉTÉ_RETIRÉ_DU_GROUPE_$exitgroup"

                        Write-Host ""
                        $choix = Read-Host "► Souhaitez vous choisir un autre utilisateur ? (o/n) : "
                        if ($choix -eq "o") {
                            del_user_group_windows
                        }
                        else {
                            gestion_menu_group_windows
                        }
                    }
                    catch {
                        Write-Host "Il y a eu une erreur pour la sortie du groupe..retour au menu.."
                        logEvent "ERREUR_DANS_LE_SCRIPT_POUR_LA_SORTIE_D'UN_UTILISATEUR_D'UN_GROUPE"
                        gestion_menu_group_windows
                    }
                }
                else {
                    Write-Host "Groupe invalide ou utilisateur non membre."
                    logEvent "ERREUR_DANS_LE_SCRIPT_POUR_LA_SORTIE_D'UN_UTILISATEUR_D'UN_GROUPE"
                    gestion_menu_group_windows
                }
            }
            else {
                Write-Host ""
                $conf = Read-Host "► L'utilisateur demandé n'existe pas, souhaitez vous choisir un autre utilisateur ? (o/n) : "
                if ($conf -eq "o") {
                    logEvent "UTILISATEUR_NON_EXISTENT_CHOIX_D'UN_AUTRE_UTILISATEUR"
                    del_user_group_windows
                }
                else {
                    gestion_menu_group_windows
                }
            }
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
