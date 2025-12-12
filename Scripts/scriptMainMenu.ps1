# Script PowerShell principal du Projet 2

# Liste des fonctions :
# 1. 
# 2. 
# 3. 
# 4. 



#=====================================================
# CHARGEMENT DES MODULES
#=====================================================
# GENERAL
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\00_scriptSearchLog.ps1" -Force

# WINDOWS
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\windows\01_scriptUsersWindows.ps1" -Force
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\windows\02_scriptGroupsWindows.ps1" -Force
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\windows\03_scriptGestionOrdiWindows.ps1" -Force
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\windows\04_scriptInfoOrdiWindows.ps1" -Force
Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\windows\05_scriptUsersInfosWindows.ps1" -Force

# LINUX


#=====================================================
# VARIABLES DES COULEURS
#=====================================================




#=====================================================
# JOURNALISATION
#=====================================================




#=====================================================
# MENU EXECUTION LOCAL OU SSH
#=====================================================




#=====================================================
# DETECTION DU SYSTEME D'EXPLOITATION
#=====================================================





#=====================================================
# FONCTIONS DES COMMANDES
#=====================================================




#=====================================================
# FICHIERS STOCKAGE INFORMATIONS
#=====================================================




#=====================================================
# MENU PRINCIPAL
#=====================================================
function mainMenu {
        
    logEvent "MENU_PRINCIPAL"
        
    while ($true) {

        Write-Host "╭──────────────────────────────────────────────────╮" 
        Write-Host "│                  MENU PRINCIPAL                  │" 
        Write-Host "├──────────────────────────────────────────────────┤" 
        Write-Host "│                                                  │"
        Write-Host "│  1. Gestion des Utilisateurs                     │" 
        Write-Host "│  2. Gestion des Ordinateurs                      │" 
        Write-Host "│  3. Informations Système                         │" 
        Write-Host "│  4. Informations Utilisateur                     │" 
        Write-Host "│  5. Journalisation                               │" 
        Write-Host "│  6. Changer mode exécution                       │" 
        Write-Host "│  7. Quitter                                      │" 
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯" 

        $userChoiceMainMenu = Read-Host "► Choisissez une option " 

        switch ($userChoiceMainMenu) {
            1 {
                userMainMenu
            }

            2 {
                computerMainMenu
            }

            3 {
                informationMainMenu
            }   

            4 {
                informationUserMainMenu
            }  

            5 {
                logsMainMenu
            }   

            6 {
                chooseExecutionMode
            }   

            7 {
                ##########################  FONCTION A FAIRE ICI ##########################
                Write-Host "TEMPORAIRE :Fermeture du script"
            }  
            
            default {
                logEvent "MENU_PRINCIPAL:ENTREE_INVALIDE"
                Write-Host "► Entrée invalide !"
            }
        }
    }
}



#=====================================================
# MENU GESTION UTILISATEUR
#=====================================================
function userMainMenu {

    logEvent "MENU_GESTION_UTILISATEUR"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│             MENU GESTION UTILISATEUR             │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Utilisateurs                                 │"
    Write-Host "│  2. Groupes                                      │"
    Write-Host "│  3. Menu Principal                               │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $userMainMenu = Read-Host "► Choisissez une option " 

    switch ($userMainMenu) {
        1 {
            logEvent "MENU_GESTION_UTILISATEUR:UTILISATEURS"
            userMenu_windows
        }

        2 {
            logEvent "MENU_GESTION_UTILISATEUR:GROUPES"
            gestion_menu_group_windows
        }

        3 {
            logEvent "MENU_GESTION_UTILISATEUR:MENU_PRINCIPAL"
            mainMenu
        } 

        default {
            logEvent "MENU_GESTION_UTILISATEUR:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"

        }
    }
}



#=====================================================
# MENU GESTION ORDINATEURS
#=====================================================
function computerMainMenu {

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮" 
    Write-Host "│               GESTION ORDINATEURS                │"
    Write-Host "├──────────────────────────────────────────────────┤" 
    Write-Host "│                                                  │"
    Write-Host "│  1. Gestion Répertoire                           │" 
    Write-Host "│  2. Redémarrage                                  │" 
    Write-Host "│  3. Prise de main à distance (CLI)               │" 
    Write-Host "│  4. Activation du pare-feu                       │" 
    Write-Host "│  5. Exécution de script sur machine distante     │" 
    Write-Host "│  6. Retour au menu principal                     │" 
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯" 
    Write-Host ""

    $computerMainMenu = Read-Host "► Choisissez une option " 

    switch ($computerMainMenu) {
        1 {
            logEvent "MENU_GESTION_ORDINATEURS:GESTION_REPERTOIRE"
            gestion_repertoire_menu_windows
        }

        2 {
            logEvent "MENU_GESTION_ORDINATEURS:REDEMARRAGE"
            redemarrage_windows
        }

        3 {
            logEvent "MENU_GESTION_ORDINATEURS:PRISE_EN_MAIN_A_DISTANCE"
            prise_main_windows
        } 

        4 {
            logEvent "MENU_GESTION_ORDINATEURS:ACTIVATION_PAREFEU"
            activer_parefeu_windows
        } 

        5 {
            logEvent "MENU_GESTION_ORDINATEURS:EXECUTION_SCRIPT"
            exec_script_windows
        } 

        6 {
            logEvent "MENU_GESTION_ORDINATEURS:MENU_PRINCIPAL"
            mainMenu
        }  

        default {
            logEvent "MENU_GESTION_ORDINATEURS:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }
}



#=====================================================
# MENU INFORMATIONS SYSTEME
#=====================================================
function informationMainMenu {

    logEvent "MENU_INFOMATIONS_SYSTEME"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮" 
    Write-Host "│            MENU INFORMATIONS SYSTEME             │" 
    Write-Host "├──────────────────────────────────────────────────┤" 
    Write-Host "│                                                  │"
    Write-Host "│  1. Liste des utilisateurs                       │" 
    Write-Host "│  2. Afficher les 5 derniers logins               │" 
    Write-Host "│  3. Afficher adresse IP, masque, passerelle      │" 
    Write-Host "│  4. Informations disque dur                      │" 
    Write-Host "│  5. Version de l'OS                              │" 
    Write-Host "│  6. Mises à jour critiques manquantes            │" 
    Write-Host "│  7. Afficher marque/modèle de l'ordinateur       │" 
    Write-Host "│  8. Statut UAC                                   │" 
    Write-Host "│  9. Menu Principal                               │" 
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯" 
    Write-Host ""

    $informationMainMenu = Read-Host "► Choisissez une option " 

    switch ($informationMainMenu) {

        1 {
            logEvent "MENU_INFORMATIONS_SYSTEME:LISTE_UTILISATEURS"
            liste_utilisateurs_windows
        }

        2 {
            logEvent "MENU_INFORMATIONS_SYSTEME:5_DERNIERS_LOGINS"
            5_derniers_logins_windows
        }

        3 {
            logEvent "MENU_INFORMATIONS_SYSTEME:AFFICHE_IP_MASQUE_PASSERELLE"
            infos_reseau_windows
        } 

        4 {
            logEvent "MENU_INFORMATIONS_SYSTEME:INFORMATIONS_DISQUES_DUR"
            gestion_disques_menu_windows
        } 

        5 {
            logEvent "MENU_INFORMATIONS_SYSTEME:VERSION_OS"
            version_os_windows
        } 

        6 {
            logEvent "MENU_INFORMATIONS_SYSTEME:MISES_A_JOUR_MANQUANTES"
            mises_a_jour_windows
        }  

        7 {
            logEvent "MENU_INFORMATIONS_SYSTEME:MARQUE_MODELE_ORDINATEUR"
            marque_modele_windows
        }  

        8 {
            logEvent "MENU_INFORMATIONS_SYSTEME:STATUS_UAC"
            status_uac_windows
        }  

        9 {
            logEvent "MENU_INFORMATIONS_SYSTEME:MENU_PRINCIPAL"
            mainMenu
        }  

        default {
            logEvent "MENU_INFORMATIONS_SYSTEME:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
            informationMainMenu
        }
    }
}



#=====================================================
# MENU INFORMATIONS UTILISATEUR
#=====================================================
function informationUserMainMenu {

    logEvent "MENU_INFORMATIONS_UTILISATEUR"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│          MENU INFORMATIONS UTILISATEUR           │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Date dernière connexion                      │"
    Write-Host "│  2. Date dernière modification de mot de passe   │"
    Write-Host "│  3. Liste des sessions ouvertes                  │"
    Write-Host "│  4. Menu Principal                               │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $informationUserMenu = Read-Host "► Choisissez une option " 

    switch ($informationUserMenu) {
        1 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:DATE_DERNIERE_CONNEXION"
            date_lastconnection_windows
        }
        2 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:DATE_DERNIERE_MODIFICATION_MOT_DE_PASSE"
            date_lastpassmodif_windows
        }
        3 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:LISTE_SESSIONS_OUVERTES"
            opensessions_windows
        }    
        4 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:MENU_PRINCIPAL"
            mainMenu
        }  
        default {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
        }
    }
}



#=====================================================
# MENU JOURNALISATION
#=====================================================
function logsMainMenu {

    logEvent "MENU_JOURNALISATION"
    
    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│             MENU JOURNALISATION                  │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Recherche log Utilisateur                    │"
    Write-Host "│  2. Recherche log utilisateur distant (SSH)      │"
    Write-Host "│  3. Recherche log Ordinateur local               │"
    Write-Host "│  4. Recherche log Ordinateur distant (SSH)       │"
    Write-Host "│  5. Afficher le fichier de journalisation        │"
    Write-Host "│  6. Menu Principal                               │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $informationUserMenu = Read-Host "► Choisissez une option " 

    switch ($informationUserMenu) {
        1 {
            logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_UTILISATEUR"
            searchUser
        }

        2 {
            logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_UTILISATEUR_SSH"
            searchUserSsh
        }

        3 {
            logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_ORDINATEURS_LOCAL"
            searchComputerLocal
        }  

        4 {
            logEvent "MENU_JOURNALISATION:RECHERCHE_LOGS_ORDINATEURS_DISTANT_SSH"
            searchComputerSsh
        }  

        5 {
            logEvent "MENU_JOURNALISATION:AFFICHAGE_FICHIER_JOURNALISATION"
            ##########################  FONCTION A FAIRE ICI ##########################
        }   

        6 {
            logEvent "MENU_JOURNALISATION:RETOUR_MENU_PRINCIPAL"
            mainMenu
        }  

        default {
            logEvent "MENU_JOURNALISATION:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"
            logsMainMenu
        }
    }
}



#=====================================================
# EXECUTION DU SCRIPT
#=====================================================
mainMenu