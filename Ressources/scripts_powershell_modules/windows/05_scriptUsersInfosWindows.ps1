# Script Information Utilisateurs Windows en Powershell


# Liste des fonctions :
# 1. Date dernière connexion
# 2. Date dernière modification mot de passe
# 3. Liste des sessions ouvertes


#==============================================================
# 1 - DATE DERNIER CONNEXION
#==============================================================
function date_lastconnection_windows {

    logEvent "MENU_DERNIERE_CONNEXION"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮"
        Write-Host "│             DATE DERNIERE CONNEXION              │"
        Write-Host "├──────────────────────────────────────────────────┤"
        Write-Host "│                                                  │"
        Write-Host "│  1. Saisir un nom d'utilisateur                  │"
        Write-Host "│  2. Retour au menu précédent                     │"
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $dateLastConnection = Read-Host "► Choisissez une option "

        switch ($dateLastConnection) {

            1 {
                logEvent "MENU_DERNIERE_CONNEXION:SAISIE_NOM_UTILISATEUR:"

                ##########################  FONCTION A FAIRE ICI ##########################
            }

            2 {
                logEvent "MENU_DERNIERE_CONNEXION:RETOUR_MENU_PRECEDENT"
                informationUserMainMenu
            }

            default {
                logEvent "MENU_DERNIERE_CONNEXION:OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"
            }
        }
    }
}




#==============================================================
# 2 - DATE DERNIERE MODIFICATION MOT DE PASSE
#==============================================================
function date_lastpassmodif_windows {

    logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│  DATE DE DERNIÈRE MODIFICATION DE MOT DE PASSE   │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $dateLastPassModif = Read-Host "► Choisissez une option "

    switch ($dateLastPassModif) {

        1 {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:SAISIE_NOM_UTILISATEUR:"

            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }
}



#==============================================================
# 3 - LISTE DES SESSIONS OUVERTES
#==============================================================
function opensessions_windows {

    logEvent "MENU_SESSION_OUVERTE"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│  LISTE DES SESSIONS OUVERTES PAR L'UTILISATEUR   │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $openSession = Read-Host "► Choisissez une option "

    switch ($openSession) {

        1 {
            logEvent "MENU_SESSION_OUVERTE:SAISIE_NOM_UTILISATEUR:"

            ##########################  FONCTION A FAIRE ICI ##########################
        }

        2 {
            logEvent "MENU_SESSION_OUVERTE:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_SESSION_OUVERTE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }
}



