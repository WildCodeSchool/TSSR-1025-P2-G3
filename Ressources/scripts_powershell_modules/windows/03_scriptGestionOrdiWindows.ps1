# Script Gestion ordinateur Windows en Powershell


# Liste des fonctions :
# 1. Menu Gestion Répertoire
# 2. Création de répertoire
# 3. Création de répertoire Linux (SUDO)
# 4. Suppression de répertoire
# 5. Redémmarage
# 6. Prise en main à distance (CLI)
# 7. Activation du pare-feu
# 8. Exécution de scripts sur une machine distante


#==============================================================
# 1 - MENU GESTION REPERTOIRE
#==============================================================
function gestion_repertoire_menu_windows {

    logEvent "MENU_GESTION_RÉPERTOIRE"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮" 
        Write-Host "│               GESTION REPERTOIRES                │"
        Write-Host "├──────────────────────────────────────────────────┤" 
        Write-Host "│                                                  │"
        Write-Host "│  1. Créer un répertoire                          │" 
        Write-Host "│  2. Créer une répertoire (SUDO LINUX)            │" 
        Write-Host "│  3. Supprimer un répertoire                      │" 
        Write-Host "│  4. Retour au menu précédent                     │" 
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $repertoireMainMenu = Read-Host "► Choisissez une option "

        switch ($repertoireMainMenu) {

            1 {
                logEvent "SÉLECTION_CRÉATION_DE_DOSSIER"
                # A CHANGER
                creer_dossier_windows
            }

            2 {
                logEvent "SÉLECTION_CRÉATION_DE_DOSSIER_SUDO"
                # A CHANGER
                creer_dossier_admin_windows
            }

            3 {
                logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
                # A CHANGER
                supprimer_dossier_windows
            }    

            4 {
                logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
                # A CHANGER
                Write-Host "Retour au menu précédent"
                computerMainMenu
            }    

            default {
                logEvent "OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"

            }
        }
    }
}




#==============================================================
# 2 - FONCTION CREATION DE REPERTOIRE
#==============================================================
function creer_dossier_windows {

    logEvent "CRÉATION_DE_DOSSIER"

    Write-Host "Entrez le chemin du dossier "
    $creation_dossier = Read-Host "►"

    ##########################  FONCTION A FAIRE ICI ##########################

}



#==============================================================
# 3 - FONCTION CREATION DE REPERTOIRE SUDO LINUX
#==============================================================

function creer_dossier_admin_windows {

    logEvent "CRÉATION_DE_DOSSIER"

    Write-Host "Entrez le chemin du dossier "
    $creation_dossier_sudo = Read-Host "►"

    ##########################  FONCTION A FAIRE ICI ##########################

}



#==============================================================
# 4 - FONCTION SUPPRESSION DE REPERTOIRE
#==============================================================

function supprimer_dossier_windows {

    logEvent "CRÉATION_DE_DOSSIER"
    Write-Host "Entrez le chemin du dossier "

    $suppression_dossier = Read-Host "►"

    ##########################  FONCTION A FAIRE ICI ##########################

}



#==============================================================
# 5 - FONCTION REDEMARRAGE
#==============================================================
function redemarrage_windows {

    logEvent "DEMANDE_VOULEZ_VOUS_REDEMARRER_L'ORDINATEUR"
    $restartComputer = Read-Host "► Voulez-vous redémarrer l'ordinateur distant ? (o/n) "

    ##########################  FONCTION A FAIRE ICI ##########################

}



#==============================================================
# 6 - FONCTION PRISE EN MAIN A DISTANCE (CLI)
#==============================================================
function prise_main_windows {

    logEvent "DEMANDE_PRISE_DE_MAIN_DISTANTE_SSH"
    # FONCTION SSH A AJOUTER

}



#==============================================================
# 7 - FONCTION ACTIVATION PARE-FEU
#==============================================================
function activer_parefeu_windows {

    logEvent "DEMANDE_ACTIVATION_UFW"
    Write-Host "► Activation du pare-feu"

    $activationParefeu = Read-Host "► Voulez-vous activer le pare-feu UFW ? (o/n) "

    ##########################  FONCTION A FAIRE ICI ##########################

}



#==============================================================
# 8 - FONCTION EXECUTION DE SCRIPT LOCAL
#==============================================================
function exec_script_windows {

    logEvent "DEMANDE_CHEMIN_SCRIPT"
    Write-Host "► Entrez le chemin du script local à exécuter "

    $scriptLocal = Read-Host "► "

    ##########################  FONCTION A FAIRE ICI ##########################

}