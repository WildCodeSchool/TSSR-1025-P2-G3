# Script PowerShell principal du Projet 2


#=====================================================
# CHARGEMENT DES MODULES
#=====================================================




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
                Write-Host "test"
            }    
            default {
                Write-Host "► Entrée invalide !"
            }
        }
    }
}



#=====================================================
# MENU GESTION UTILISATEUR
#=====================================================

function userMainMenu {



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
            Write-Host "test"
        }
        2 {
            Write-Host "test"
        }
        3 {
            Write-Host "test"
        }    
        default {
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
            Write-Host "test"
        }
        2 {
            Write-Host "test"
        }
        3 {
            Write-Host "test"
        }    
        4 {
            Write-Host "test"
        }    
        5 {
            Write-Host "test"
        }    
        6 {
            Write-Host "test"
        }    
        default {
            Write-Host "► Entrée invalide !"
        }
    }
}



#=====================================================
# MENU INFORMATIONS SYSTEME
#=====================================================

function computerMainMenu {

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

    $computerMainMenu = Read-Host "► Choisissez une option " 

    switch ($computerMainMenu) {
        1 {
            Write-Host "test"
        }
        2 {
            Write-Host "test"
        }
        3 {
            Write-Host "test"
        }    
        4 {
            Write-Host "test"
        }    
        5 {
            Write-Host "test"
        }    
        6 {
            Write-Host "test"
        }    
        default {
            Write-Host "► Entrée invalide !"
        }
    }
}




#=====================================================
# MENU INFORMATIONS UTILISATEUR
#=====================================================

function informationUserMainMenu {


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
            Write-Host "test"
        }
        2 {
            Write-Host "test"
        }
        3 {
            Write-Host "test"
        }    
        4 {
            Write-Host "test"
        }  
        default {
            Write-Host "► Entrée invalide !"
        }
    }
}


#=====================================================
# MENU JOURNALISATION
#=====================================================

function logsMainMenu {


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
            Write-Host "test"
        }
        2 {
            Write-Host "test"
        }
        3 {
            Write-Host "test"
        }    
        4 {
            Write-Host "test"
        }  
        5 {
            Write-Host "test"
        }    
        6 {
            Write-Host "test"
        }  
        default {
            Write-Host "► Entrée invalide !"
        }
    }
}


#=====================================================
# EXECUTION DU SCRIPT
#=====================================================
mainMenu
