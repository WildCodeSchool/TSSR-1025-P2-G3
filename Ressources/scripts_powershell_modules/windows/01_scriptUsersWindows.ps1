# Script de recherche dans le fichier de journalisation


# Liste des fonctions :
# 1. Recherche utilisateurs
# 2. Recherche utilisateurs SSH
# 3. Recherche Ordinateur Local
# 4. Recherche Ordinateur SSH
# 5. Menu Filtrage Recherche


#==============================================================
#region 1 - RECHERCHE UTILISATEURS
#==============================================================
function searchUser {

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT"

    $userScriptSearch = Read-Host "► Entrez un nom d'utilisateur à rechercher "

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT:$userScriptSearch"

    $resultats = Get-Content $LogFile | Where-Object {
        $parts = $_ -split "_" 
        $parts.Count -ge 3 -and $parts[2] -match $userScriptSearch
    }

    if ($resultats) {

        menuSearchlog
        Write-Host ""
        Read-Host "► Appuyez sur une touche pour continuer..."
    } else {
        logEvent "UTILISATEUR_INEXISTANT:$userScriptSearch"
        Write-Host "► L'utilisateur $userScriptSearch n'existe pas dans la journalisation"

    }

    logsMainMenu
}
#endregion


#==============================================================
#region 2 - RECHERCHE UTILISATEURS SSH
#==============================================================
function searchUserSsh {
    
    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH"
    
    $userScriptSearchSSH = Read-Host "► Entrez un nom d'utilisateur distant à rechercher"
    
    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH:$userScriptSearchSSH"
    
    $resultats = Get-Content $LogFile | Where-Object {
        $fields = $_ -split '_'
        $fields.Count -ge 4 -and $fields[3] -match $userScriptSearchSSH
    }
    
    if ($resultats) {
        
        menuSearchlog
        Write-Host ""
        Read-Host "► Appuyez sur ENTRÉE pour continuer..."
        
    } else {
        logEvent "UTILISATEUR_SSH_INEXISTANT:$userScriptSearchSSH"
        Write-Host ""
        Write-Host "► L'utilisateur $userScriptSearchSSH n'existe pas dans la journalisation"
        
    }
    
    logsMainMenu
    
}
#endregion


#==============================================================
#region 3 - RECHERCHE ORDINATEURS LOCAL
#==============================================================
function searchComputerLocal {
    
    logEvent "RECHERCHE_LOGS_ORDINATEUR_LOCAL"
    
    $resultats = Get-Content $LogFile | Where-Object {
        $fields = $_ -split '_'
        $fields.Count -ge 4 -and $fields[3] -match "local"
    }
    
    
    if ($resultats) {
        
        menuSearchlog
        Write-Host ""
        Read-Host "► Appuyez sur ENTRÉE pour continuer..."
        
    }
    
    logsMainMenu
    
}
#endregion


#==============================================================
#region 4 - RECHERCHE ORDINATEURS SSH
#==============================================================
function searchComputerSsh {
    
    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH"
    
    $computerScriptSearchSSH = Read-Host "► Entrez un nom d'ordinateur distant à rechercher"
    
    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH:$computerScriptSearchSSH"
    
    $resultats = Get-Content $LogFile | Where-Object {
        $fields = $_ -split '_'
        $fields.Count -ge 4 -and $fields[3] -match $computerScriptSearchSSH
    }
    
    if ($resultats) {
        
        menuSearchlog
        Write-Host ""
        Read-Host "► Appuyez sur ENTRÉE pour continuer..."
        
    } else {
        
        logEvent "ORDINATEUR_INEXISTANT:$userScriptSearch"
        Write-Host "► L'ordinateur $computerScriptSearchSSH n'existe pas dans la journalisation"
        
    }
    
    logsMainMenu
    
}
#endregion


#==============================================================
#region 5 - FONCTION FILTRAGE DE RECHERCHE
#==============================================================
function menuSearchlog {
    
    logEvent "MENU_FILTRAGE_RECHERCHE"
    
    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│             MENU FILTRAGE RECHERCHE              │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Afficher les 20 derniers logs                │"
    Write-Host "│  2. Afficher page par page                       │"
    Write-Host "│  3. Afficher tous les résultats                  │"
    Write-Host "│  4. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""
    
    $menuSearch = Read-Host "► Choisissez une option"
    
    switch ($menuSearch) {
        
        1 {

            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_20_DERNIERS_RESULTATS"
            $resultats | Select-Object -Last 20

        }
        
        2 {

            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_PAGE_PAR_PAGE"
            $resultats | Out-Host -Paging

        }
        
        3 {

            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_TOUS_LES_RESULTATS"
            $resultats

        }
        
        4 {

            logEvent "MENU_FILTRAGE_RECHERCHE:MENU_PRECEDENT"
            logsMainMenu

        }

        default {
            logEvent "MENU_FILTRAGE_RECHERCHE:ENTREE_INVALIDE"
            Write-Host "► Option invalide."
            menuSearchlog
        }
    }
}
#endregion
