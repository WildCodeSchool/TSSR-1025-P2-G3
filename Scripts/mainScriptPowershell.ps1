# Script PowerShell principal du Projet 2

# Liste des fonctions :
# 1. 
# 2. 
# 3. 
# 4. 



# Force le lancement en administrateur
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList "-File", $PSCommandPath `
        -Verb RunAs
    exit
}

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
# Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\Linux\01_scriptUsersLinux.ps1" -Force
# Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\Linux\02_scriptGroupsLinux.ps1" -Force
# Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\Linux\03_scriptGestionOrdiLinux.ps1" -Force
# Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\Linux\04_scriptInfoOrdiLinux.ps1" -Force
# Import-Module "$PSScriptRoot\..\Ressources\scripts_powershell_modules\Linux\05_scriptUsersInfosLinux.ps1" -Force

#=====================================================
# VARIABLES DES COULEURS
#=====================================================




#=====================================================
# JOURNALISATION
#=====================================================
$LogFile = "$env:USERPROFILE\Documents\log_event.log"

function logInit {
    param (
        [Parameter(Mandatory)]
        [string]$LogFile
    )

    if (-not (Test-Path -Path $LogFile)) {

        New-Item -Path $LogFile -ItemType File -Force | Out-Null

        $acl = Get-Acl -Path $LogFile
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Everyone", "FullControl", "Allow"
        )
        $acl.SetAccessRule($accessRule)
        Set-Acl -Path $LogFile -AclObject $acl
    }
}

function logEvent {
    param(
        [Parameter(Mandatory)]
        [string]$event
    )

    $date = Get-Date -Format "yyyy-MM-dd"
    $heure = Get-Date -Format "HH:mm:ss"
    $utilisateur = $($env:USERNAME)

    $context = if ($connexionMode -eq "ssh") {
        "ssh:$RemoteUser@$RemoteComputer" 
    } else {
        "local" 
    }

    $Entry = "${Date}_${Heure}_${Utilisateur}_${Context}_$event"

    Add-Content -Path $LogFile -Value $Entry
}

function startScript {
    logEvent "START_SCRIPT"
}

function stopScript {
    logEvent "STOP_SCRIPT"
    Write-Host "► Fermeture du script..."
    exit
}

$script:connexionMode = ""
$script:remoteUser = ""
$script:remoteComputer = ""
$script:portSSH = ""
$script:remoteOS = ""

#=====================================================
# MENU EXECUTION LOCAL OU SSH
#=====================================================
function executionMode {

    #=====================================================
    # VARIABLES DE CONNEXION
    #=====================================================
    $script:connexionMode = ""
    $script:remoteUser = ""
    $script:remoteComputer = ""
    $script:portSSH = ""
    $script:remoteOS = ""

    logEvent "MENU_EXECUTION"

    Write-Host ""
    Write-Host "╭────────────────────────────────────────────────╮"
    Write-Host "│           MENU EXECUTION LOCAL OU SSH          │"
    Write-Host "├────────────────────────────────────────────────┤"
    Write-Host "│                                                │"
    Write-Host "│  1. Exécution locale                           │"
    Write-Host "│  2. Exécution distante (SSH)                   │"
    Write-Host "│  3. Quitter                                    │"
    Write-Host "│                                                │"
    Write-Host "╰────────────────────────────────────────────────╯"
    Write-Host ""

    $executionmode = Read-Host "► Voulez-vous exécuter le script en Local ou à distance ? "

    switch ($executionmode) {

        1 {
            logEvent "EXECUTION_LOCAL"
            $connexionMode = "local"
            $script:connexionMode
            Write-Host "► Exécution du script sur la machine hôte."
            Write-Host
        }

        2 {
            logEvent "EXECUTION_DISTANTE_SSH"
            $script:connexionMode = "ssh"

            $script:remoteComputer = Read-Host "► Entrez une Adresse IP ou Hostname"
            logEvent "ADRESSE_IP_OU_HOSTNAME:$remoteComputer"

            $script:remoteUser = Read-Host "► Entrez un Nom d'utilisateur"
            logEvent "NOM_UTILISATEUR:$remoteUser"

            $script:portSSH = Read-Host "► Entrez un Port"
            logEvent "PORT:$portSSH"

            Write-Host " Connexion en cours à $remoteUser@$remoteComputer :$portSSH ..."
            Write-Host ""
            
            logEvent "SSH_CONNEXION:$remoteUser@$remoteComputer :$portSSH"
            
            ssh -p $portSSH "$remoteUser@$remoteComputer" "exit" 2>$null

            if ($LASTEXITCODE -eq 0) {
                Write-Host "► Connexion SSH réussie à $remoteUser@$remoteComputer :$portSSH."
                logEvent "SSH_CONNEXION_REUSSIE:$remoteUser@$remoteComputer :$portSSH"
            } else {
                Write-Host "► Impossible de se connecter à $remoteUser@$remoteComputer :$portSSH."
                logEvent "SSH_CONNEXION_ECHEC:$remoteUser@$remoteComputer :$portSSH"
                executionMode
            }

        }

        3 {
            stopScript
        }
        
        default {

            logEvent "MENU_EXECUTION:ENTREE_INVALIDE"
            Write-Host "► Entrée invalide !"

        }
    }

    detectionRemoteOS
}



#=====================================================
# DETECTION DU SYSTEME D'EXPLOITATION
#=====================================================
function detectionRemoteOS {

    if ($script:connexionMode -eq "ssh") {

        $osInfo = ssh -p $script:portSSH "$script:remoteUser@$script:remoteComputer" "uname -a" 2>$null
        
        if ($osInfo -match "Linux") {

            $script:remoteOS = "Linux"
            logEvent "DETECTION_OS:LINUX"

            Write-Host "► Système d'exploitation distant détecté : Linux"
        } else {

            $script:remoteOS = "Windows"
            logEvent "DETECTION_OS:WINDOWS"
            Write-Host "► Système d'exploitation distant détecté : Windows"

        }

        Write-Host ""
    } else {

        $script:remoteOS = "Windows"
        logEvent "DETECTION_OS:WINDOWS_LOCAL"
        Write-Host "► Système d'exploitation distant détecté : Windows"
        Write-Host ""

    }
}



#=====================================================
# FONCTIONS DES COMMANDES
#=====================================================
function command_ssh {
    param (
        [string]$cmd
    )


    if ($script:connexionMode -eq "local") {

        Invoke-Expression $cmd

    } elseif ($script:connexionMode -eq "ssh") {

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($cmd)
        $encodedCmd = [Convert]::ToBase64String($bytes)
        $remoteCmd = "powershell.exe -NoProfile -EncodedCommand $encodedCmd"


        ssh -p $script:portSSH "$script:remoteUser@$script:remoteComputer" $remoteCmd 2>&1

    } else {
        
        Write-Host "ERREUR : Mode de connexion inconnu ($script:connexionMode)" -ForegroundColor Red
        return
    }
}

function bash_command {
    param (
        [string]$cmd
    )

    if ($connexionMode -eq "local") {
        return Invoke-Expression $cmd
    } elseif ($connexionMode -eq "ssh") {
        return ssh -p $portSSH -o BatchMode=yes "$remoteUser@$remoteComputer" "bash -lc '$cmd'" 2>&1
    }
}

function bash_sudo_command {
    param (
        [string]$cmd
    )

    if ($connexionMode -eq "local") {
        return Invoke-Expression $cmd
    } elseif ($connexionMode -eq "ssh") {
        return ssh -t -p $portSSH "$remoteUser@$remoteComputer" "sudo bash -lc '$cmd'" 2>&1
    }
}

#=====================================================
# FICHIERS STOCKAGE INFORMATIONS
#=====================================================




#=====================================================
# MENU PRINCIPAL
#=====================================================
function mainMenu {
        
    logEvent "MENU_PRINCIPAL"
        
    while ($true) {

        Write-Host ""
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
        Write-Host ""

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
                executionMode
            }   

            7 {
                stopScript
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

            if ($remoteOS -eq "Windows") {
                userMenu_windows
            } else {
                userMenu_linux
            }
        }

        2 {
            logEvent "MENU_GESTION_UTILISATEUR:GROUPES"

            if ($remoteOS -eq "Windows") {
                gestion_menu_group_windows
            } else {
                gestion_menu_group_linux
            }          
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

            if ($remoteOS -eq "Windows") {
                gestion_repertoire_menu_windows
            } else {
                gestion_repertoire_menu_linux
            }
        }

        2 {
            logEvent "MENU_GESTION_ORDINATEURS:REDEMARRAGE"

            if ($remoteOS -eq "Windows") { 
                redemarrage_windows
            } else {
                redemarrage_linux
            }
        }

        3 {
            logEvent "MENU_GESTION_ORDINATEURS:PRISE_EN_MAIN_A_DISTANCE"
            if ($remoteOS -eq "Windows") { 
                prise_main_distance_windows
            } else {
                prise_main_distance_linux
            }
        } 

        4 {
            logEvent "MENU_GESTION_ORDINATEURS:ACTIVATION_PAREFEU"
            if ($remoteOS -eq "Windows") { 
                activation_parefeu_windows
            } else {
                activation_parefeu_linux
            }
        } 

        5 {
            logEvent "MENU_GESTION_ORDINATEURS:EXECUTION_SCRIPT"
            if ($remoteOS -eq "Windows") { 
                exec_script_windows
            } else {
                exec_script_linux
            }
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

            if ($remoteOS -eq "Windows") {
                liste_utilisateurs_windows
            } else {
                liste_utilisateurs_linux
            }
        }

        2 {
            logEvent "MENU_INFORMATIONS_SYSTEME:5_DERNIERS_LOGINS"

            if ($remoteOS -eq "Windows") {
                cinq_derniers_logins_windows
            } else {
                cinq_derniers_logins_linux
            }
        }

        3 {
            logEvent "MENU_INFORMATIONS_SYSTEME:AFFICHE_IP_MASQUE_PASSERELLE"

            if ($remoteOS -eq "Windows") {
                infos_reseau_windows
            } else {
                infos_reseau_linux
            }
        } 

        4 {
            logEvent "MENU_INFORMATIONS_SYSTEME:INFORMATIONS_DISQUES_DUR"

            if ($remoteOS -eq "Windows") {
                gestion_disques_menu_windows
            } else {
                gestion_disques_menu_linux
            }
        } 

        5 {
            logEvent "MENU_INFORMATIONS_SYSTEME:VERSION_OS"

            if ($remoteOS -eq "Windows") {
                version_os_windows
            } else {
                version_os_linux
            }
        } 

        6 {
            logEvent "MENU_INFORMATIONS_SYSTEME:MISES_A_JOUR_MANQUANTES"

            if ($remoteOS -eq "Windows") {
                mises_a_jour_windows
            } else {
                mises_a_jour_linux
            }
        }  

        7 {
            logEvent "MENU_INFORMATIONS_SYSTEME:MARQUE_MODELE_ORDINATEUR"

            if ($remoteOS -eq "Windows") {
                marque_modele_windows
            } else {
                marque_modele_linux
            }
        }  

        8 {
            logEvent "MENU_INFORMATIONS_SYSTEME:STATUS_UAC"

            if ($remoteOS -eq "Windows") {
                status_uac_windows
            } else {
                status_uac_linux
            }
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

            if ($remoteOS -eq "Windows") {
                date_lastconnection_windows
            } else {
                date_lastconnection_linux
            }
        }

        2 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:DATE_DERNIERE_MODIFICATION_MOT_DE_PASSE"

            if ($remoteOS -eq "Windows") {
                date_lastpassmodif_windows
            } else {
                date_lastpassmodif_linux
            }
        }

        3 {
            logEvent "MENU_INFORMATIONS_UTILISATEUR:LISTE_SESSIONS_OUVERTES"

            if ($remoteOS -eq "Windows") {
                list_opensessions_windows
            } else {
                list_opensessions_linux
            }
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
            Get-Content -Path $LogFile
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


executionMode
mainMenu


