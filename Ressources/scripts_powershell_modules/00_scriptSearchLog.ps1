# Script de recherche dans le fichier de journalisation


# Liste des fonctions :
# 1. Recherche utilisateurs
# 2. Recherche utilisateurs SSH
# 3. Recherche Ordinateur Local
# 4. Recherche Ordinateur SSH
# 5. Menu Filtrage Recherche


#==============================================================
# 1 - RECHERCHE UTILISATEURS
#==============================================================
function searchUser {

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT"

    $userScriptSearch = Read-Host "► Entrez un nom d'utilisateur à rechercher "

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SCRIPT:$userScriptSearch"

    ##########################  FONCTION A FAIRE ICI ##########################

    logsMainMenu
}



#==============================================================
# 2 - RECHERCHE UTILISATEURS SSH
#==============================================================
function searchUserSsh {

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH"

    $userScriptSearchSSH = Read-Host "► Entrez un nom d'utilisateur à rechercher "

    logEvent "RECHERCHE_LOGS_UTILISATEUR_SSH:$userScriptSearchSSH"

    logsMainMenu
}



#==============================================================
# 3 - RECHERCHE ORDINATEURS LOCAL
#==============================================================
function searchComputerLocal {

    logEvent "RECHERCHE_LOGS_ORDINATEUR_LOCAL"

    ##########################  FONCTION A FAIRE ICI ##########################


    logsMainMenu
}



#==============================================================
# 4 - RECHERCHE ORDINATEURS SSH
#==============================================================
function searchComputerSsh {

    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH"

    $computerScriptSearchSSH = Read-Host "► Entrez un nom d'ordinateur distant à rechercher "

    logEvent "RECHERCHE_LOGS_ORDINATEUR_SSH:$computerScriptSearchSSH"
    ##########################  FONCTION A FAIRE ICI ##########################


    logsMainMenu
}

#==============================================================
# 5 - FONCTION FILTRAGE DE RECHERCHE
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

    $menuSearchLogs = Read-Host "► Choisissez une option "

    switch ($menuSearchLogs) {

        1 {
            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_20_DERNIERS_RESULTATS"
            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_PAGE_PAR_PAGE"
            ##########################  FONCTION A FAIRE ICI ##########################
        }

        3 {
            logEvent "MENU_FILTRAGE_RECHERCHE:AFFICHAGE_TOUS_LES_RESULTATS"
            ##########################  FONCTION A FAIRE ICI ##########################
        }    

        4 {
            logEvent "MENU_FILTRAGE_RECHERCHE:MENU_PRECEDENT"    
            Write-Host "Retour au menu précédent"
            logsMainMenu
        }  

        default {
            logEvent "OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"

        }
    }
}