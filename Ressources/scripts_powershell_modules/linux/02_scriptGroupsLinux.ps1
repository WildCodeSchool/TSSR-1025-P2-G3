# Script Gestion de groupes Linux en Powershell
# Auteur : Pierre-Jean

# Sommaire :
# 01. Menu Groupe
# 02. Ajouter un utilisateur au groupe sudo
# 03. Ajouter un utilisateur à un groupe
# 04. Supprimer un utilisateur d'un groupe


#==============================================================
#region 01 - MENU GROUPE
#==============================================================
function gestion_menu_group_linux {

    logEvent "MENU_GROUPE"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮"
        Write-Host "│                   MENU GROUPE                    │"
        Write-Host "├──────────────────────────────────────────────────┤"
        Write-Host "│                                                  │"
        Write-Host "│  1. Ajouter un utilisateur au groupe sudo        │"
        Write-Host "│  2. Ajouter un utilisateur à un groupe           │"
        Write-Host "│  3. Retirer un utilisateur d'un groupe           │"
        Write-Host "│  4. Retour au menu précédent                     │"
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $groupMainMenu = Read-Host "► Choisissez une option"

        switch ($groupMainMenu) {

            1 {
                logEvent "MENU_GROUPES:AJOUT_UTILISATEUR_AU_GROUPE_SUDO"
                add_user_sudo_group_linux
            }

            2 {
                logEvent "MENU_GROUPES:AJOUT_UTILISATEUR_A_UN_GROUPE"
                add_user_group_linux
            }

            3 {
                logEvent "MENU_GROUPES:SORTIE_UTILISATEUR_D_UN_GROUPE"
                del_user_group_linux
            }    

            4 {
                logEvent "SELECTION_RETOUR_AU_MENU_PRECEDENT"
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
#endregion


#==============================================================
#region 02 - FONCTION AJOUTER UN UTILISATEUR AU GROUPE ADMIN
#==============================================================
function add_user_sudo_group_linux {

    logEvent "MENU_AJOUT_GROUPE_SUDO"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│       AJOUTER UTILISATEUR AU GROUPE SUDO         │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir le nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""
    
    $addGroupSudo = Read-Host "► Choisissez une option"

    switch ($addGroupSudo) {
        1 {
            logEvent "MENU_AJOUT_GROUPE_SUDO:SAISIE_UTILISATEUR"
            
            Write-Host ""
            Write-Host "► Voici la liste des utilisateurs : "
            bash_command 'awk -F'':'' ''$3 >= 1000 && $3 < 60000 {print $1, $3}'' /etc/passwd'
            Write-Host ""

            $useraddadmin = Read-Host "► Quel utilisateur souhaitez-vous ajouter au groupe sudo ? "
            logEvent "ENTREE_UTILISATEUR:${useraddadmin}"

            # Vérification si l'utilisateur existe
            $userExists = bash_command "id '$useraddadmin' > /dev/null 2>&1 && echo 'true' || echo 'erreur'"

            if ($userExists.Trim() -eq "true") {
                Write-Host ""
                logEvent "AJOUT_UTILISATEUR_SUDO:${useraddadmin}"
                
                # Ajout au groupe sudo
                $result = bash_sudo_command "usermod -aG sudo '$useraddadmin'"
                
                # Vérification
                $inSudo = bash_command "groups '$useraddadmin' | grep -q sudo && echo 'true' || echo 'false'"
                
                if ($inSudo.Trim() -eq "true") {
                    Write-Host "► L'utilisateur ${useraddadmin} a bien été ajouté au groupe sudo"
                    logEvent "AJOUT_UTILISATEUR_SUDO_REUSSI:${useraddadmin}"
                    
                    $conf = Read-Host "► Souhaitez-vous ajouter un autre utilisateur au groupe sudo (o/n) ? "
                    if ($conf -eq "o") {
                        add_user_sudo_group_linux
                    }
                    else {
                        gestion_menu_group_linux
                    }
                }
                else {
                    Write-Host "► Erreur lors de l'ajout au groupe sudo"
                    logEvent "ERREUR_AJOUT_UTILISATEUR_SUDO:${useraddadmin}"
                    add_user_sudo_group_linux
                }
            }
            else {
                Write-Host ""
                $conf = Read-Host "► L'utilisateur demandé n'existe pas, souhaitez-vous choisir un autre utilisateur ? (o/n) : "
                if ($conf -eq "o") {
                    logEvent "UTILISATEUR_INEXISTANT_AUTRE_CHOIX"
                    add_user_sudo_group_linux
                }
                else {
                    gestion_menu_group_linux
                }
            }
        }

        2 {
            logEvent "MENU_AJOUT_GROUPE_SUDO:RETOUR_MENU_PRECEDENT"
            gestion_menu_group_linux
        }

        default {
            logEvent "MENU_AJOUT_GROUPE_SUDO:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            add_user_sudo_group_linux
        }
    }
}
#endregion


#==============================================================
#region 03 - FONCTION AJOUTER UN UTILISATEUR A UN GROUPE
#==============================================================
function add_user_group_linux {

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
            logEvent "MENU_AJOUT_GROUPE:SAISIE_UTILISATEUR"
            
            $useraddgroup = Read-Host "► Quel utilisateur souhaitez-vous ajouter au groupe ? "
            logEvent "ENTREE_UTILISATEUR:${useraddgroup}"

            # Vérification si l'utilisateur existe
            $userExists = bash_command "id '$useraddgroup' > /dev/null 2>&1 && echo 'true' || echo 'false'"

            if ($userExists.Trim() -eq "true") {
                Write-Host ""
                    
                $namegroup = Read-Host "► À quel groupe souhaitez-vous l'ajouter ? "

                # Vérification si le groupe existe
                $groupExists = bash_command "getent group '$namegroup' > /dev/null 2>&1 && echo 'true' || echo 'false'"

                if ($groupExists.Trim() -eq "true") {
                    # Ajout au groupe
                    bash_sudo_command "usermod -aG '$namegroup' '$useraddgroup'"
                    
                    # Vérification
                    $inGroup = bash_command "groups '$useraddgroup' | grep -q '$namegroup' && echo 'true' || echo 'false'"
                    
                    if ($inGroup.Trim() -eq "true") {
                        Write-Host "► L'utilisateur ${useraddgroup} a bien été ajouté au groupe ${namegroup}"
                        logEvent "UTILISATEUR_AJOUTE_AU_GROUPE:${useraddgroup}:${namegroup}"

                        Write-Host ""
                        $conf = Read-Host "► Souhaitez-vous ajouter un autre utilisateur ? (o/n) : "
                        if ($conf -eq "o") {
                            add_user_group_linux
                        }
                        else {
                            gestion_menu_group_linux
                        }
                    }
                    else {
                        Write-Host "► Erreur lors de l'ajout au groupe"
                        logEvent "ERREUR_AJOUT_GROUPE:${useraddgroup}:${namegroup}"
                    }
                }
                else {
                    Write-Host ""
                    $conf = Read-Host "► Le groupe n'existe pas, souhaitez-vous le créer et y ajouter l'utilisateur ? (o/n) : "
                    if ($conf -eq "o") {
                        bash_sudo_command "groupadd '$namegroup'"
                        bash_sudo_command "usermod -aG '$namegroup' '$useraddgroup'"
                        Write-Host "► Le groupe ${namegroup} a été créé et l'utilisateur ${useraddgroup} y a été ajouté"
                        logEvent "CREATION_GROUPE_ET_AJOUT_UTILISATEUR:${namegroup}:${useraddgroup}"
                    }
                    else {
                        gestion_menu_group_linux
                    }
                }
            }
            else {
                Write-Host ""
                $conf = Read-Host "► Cet utilisateur n'existe pas, souhaitez-vous choisir un autre utilisateur ? (o/n) : "
                if ($conf -eq "o") {
                    logEvent "UTILISATEUR_INEXISTANT_AUTRE_CHOIX"
                    add_user_group_linux
                }
                else {
                    gestion_menu_group_linux
                }
            }
        }

        2 {
            logEvent "MENU_AJOUT_GROUPE:RETOUR_MENU_PRECEDENT"
            gestion_menu_group_linux
        }

        default {
            logEvent "MENU_AJOUT_GROUPE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            add_user_group_linux
        }
    }
}
#endregion


#==============================================================
#region 04 - FONCTION RETIRER UN UTILISATEUR D'UN GROUPE
#==============================================================
function del_user_group_linux {

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
            logEvent "MENU_SUPPRESSION_GROUPE:SAISIE_UTILISATEUR"
            
            $userexitgroup = Read-Host "► Quel utilisateur souhaitez-vous sortir du groupe ? "
            
            # Vérification de l'utilisateur
            $userExists = bash_command "id '$userexitgroup' > /dev/null 2>&1 && echo 'true' || echo 'false'"
            
            if ($userExists.Trim() -eq "true") {
                logEvent "UTILISATEUR_TROUVE:${userexitgroup}"
                Write-Host ""
                Write-Host "► Groupes de l'utilisateur ${userexitgroup} :"
                
                # Récupération des groupes de l'utilisateur
                $userGroups = bash_command "groups '$userexitgroup' | cut -d: -f2"
                Write-Host $userGroups
                Write-Host ""
                
                $exitgroup = Read-Host "► De quel groupe retirer ${userexitgroup} ? "
                
                # Vérification que l'utilisateur est bien dans ce groupe
                $inGroup = bash_command "groups '$userexitgroup' | grep -q '$exitgroup' && echo 'true' || echo 'false'"
                
                if ($inGroup.Trim() -eq "true") {
                    # Retrait du groupe avec gpasswd
                    bash_sudo_command "gpasswd -d '$userexitgroup' '$exitgroup'"
                    
                    # Vérification
                    $stillInGroup = bash_command "groups '$userexitgroup' | grep -q '$exitgroup' && echo 'true' || echo 'false'"
                    
                    if ($stillInGroup.Trim() -eq "false") {
                        Write-Host "► ${userexitgroup} a été retiré du groupe ${exitgroup}"
                        logEvent "RETRAIT_REUSSI:${userexitgroup}:${exitgroup}"
                    }
                    else {
                        Write-Host "► Échec du retrait du groupe"
                        logEvent "RETRAIT_ECHOUE:${userexitgroup}:${exitgroup}"
                    }
                }
                else {
                    Write-Host "► L'utilisateur n'appartient pas à ce groupe"
                    logEvent "UTILISATEUR_PAS_DANS_GROUPE:${userexitgroup}:${exitgroup}"
                }
                
                # Question de continuation
                Write-Host ""
                $retry = Read-Host "► Autre opération ? (o/n)"
                if ($retry -eq "o") { 
                    del_user_group_linux 
                }
                else { 
                    gestion_menu_group_linux 
                }
            }
            else {
                Write-Host "► Utilisateur introuvable."
                logEvent "UTILISATEUR_INTROUVABLE:${userexitgroup}"
                
                $retry = Read-Host "► Réessayer ? (o/n)"
                if ($retry -eq "o") { 
                    del_user_group_linux 
                }
                else { 
                    gestion_menu_group_linux 
                }
            }
        }

        2 {
            logEvent "RETOUR_MENU_GROUPE"
            gestion_menu_group_linux
        }

        default {
            Write-Host "► Option invalide !"
            del_user_group_linux
        }
    }
}
#endregion


