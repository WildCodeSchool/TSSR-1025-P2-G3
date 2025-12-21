
# Script Gestion Ordinateur Windows
# Auteur : Safi


# Sommaire :
# 01 - Menu Gestion Répertoire
# 02 - Création de répertoire
# 03 - Création de répertoire Linux (SUDO)
# 04 - Suppression de répertoire
# 05 - Redémmarage
# 06 - Prise en main à distance (CLI)
# 07 - Activation du pare-feu
# 08 - Exécution de scripts sur une machine distante


#==============================================================
#region 01 - MENU GESTION REPERTOIRE
#==============================================================
function gestion_repertoire_menu_windows {

    logEvent "MENU_GESTION_RÉPERTOIRE"
    
    while ($true) {
        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮" 
        Write-Host "│               GESTION REPERTOIRES                │"
        Write-Host "├──────────────────────────────────────────────────┤" 
        Write-Host $script:menuMachineLine
        Write-Host "├──────────────────────────────────────────────────┤"
        Write-Host "│                                                  │"
        Write-Host "│  1. Créer un répertoire                          │" 
        Write-Host "│  2. Créer un répertoire (ADMIN)                  │" 
        Write-Host "│  3. Supprimer un répertoire                      │" 
        Write-Host "│  4. Retour au menu précédent                     │" 
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $repertoireMainMenu = Read-Host "► Choisissez une option "

        switch ($repertoireMainMenu) {
            '1' {
                #fonction création de dossier
                logEvent "SÉLECTION_CRÉATION_DE_DOSSIER"
                creer_dossier_windows
            }
            '2' {
                #fonction création de dossier admin
                logEvent "SÉLECTION_CRÉATION_DE_DOSSIER_ADMIN"
                creer_dossier_admin_windows
            }
            '3' {
                #fonction suppression de dossier
                logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
                supprimer_dossier_windows
            }    
            '4' {
                # Retour au menu précédent
                logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
                Write-Host "► Retour au menu précédent"
                computerMainMenu
            }    
            default {
                # Option invalide
                logEvent "OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"
            }
        }
    }
}
#endregion


#==============================================================
#region 02 - CREATION DE REPERTOIRE
#==============================================================
function creer_dossier_windows {

    logEvent "CRÉATION_DE_DOSSIER"
    Write-Host "► Entrez le chemin du dossier :"
    $chemin = Read-Host "►"

    # Condition Vérification existence du dossier
    if ((command_ssh "Test-Path '$chemin'") -eq "True") {
        logEvent "LE_DOSSIER_EXISTE_DÉJÀ:$chemin"
        Write-Host "► Le dossier existe déjà"
    }
    else {
        # Création du dossier
        command_ssh "New-Item -Path '$chemin' -ItemType Directory -Force"
        
        if ($LASTEXITCODE -eq 0) {
            logEvent "DOSSIER_CRÉÉ:$chemin"
            Write-Host "► Le dossier a été créé : $chemin"
        }
        else {
            logEvent "ERREUR_DOSSIER_NON_CRÉÉ:$chemin"
            Write-Host "► Erreur : dossier non créé"
        }
    }

    Write-Host ""
    gestion_repertoire_menu_windows
}
#endregion


#==============================================================
#region 03 - CREATION DE REPERTOIRE AVEC PRIVILEGES ADMIN
#==============================================================
function creer_dossier_admin_windows {

    logEvent "CRÉATION_DE_DOSSIER_ADMIN"

    Write-Host "► Entrez le chemin du dossier:"
    $chemin = Read-Host "►"

    # Condition Vérification existence du dossier
    if ((command_ssh "Test-Path '$chemin'") -eq "True") {
        logEvent "LE_DOSSIER_EXISTE_DÉJÀ:$chemin"
        Write-Host "► Le dossier existe déjà"
    }
    else {
        # Création du dossier avec permissions admin
        command_ssh "New-Item -Path '$chemin' -ItemType Directory -Force; icacls '$chemin' /inheritance:r /grant Administrateurs:F SYSTEM:F"
        # Vérification de la création
        if ($LASTEXITCODE -eq 0) {
            logEvent "DOSSIER_ADMIN_CRÉÉ:$chemin"
            Write-Host "► Le dossier admin a été créé : $chemin"
            Write-Host "► Permissions : Administrateurs et SYSTEM uniquement"
        }
        else {
            logEvent "ERREUR_DOSSIER_ADMIN_NON_CRÉÉ:$chemin"
            Write-Host "► Erreur : dossier admin non créé"
        }
    }

    Write-Host ""
    gestion_repertoire_menu_windows
}
#endregion


#==============================================================
#region 04 - SUPPRESSION DE REPERTOIRE
#==============================================================
function supprimer_dossier_windows {

    logEvent "SUPPRESSION_DE_DOSSIER"
    
    Write-Host "► Entrez le chemin du dossier à supprimer :"
    $chemin = Read-Host "►"

    # Vérification existence du dossier
    if ((command_ssh "Test-Path '$chemin'") -ne "True") {
        logEvent "DOSSIER_INEXISTANT:$chemin"
        Write-Host "► Le dossier n'existe pas"
    }
    else {
        Write-Host ""
        Write-Host "► ATTENTION : Cette action est irréversible !" -ForegroundColor Yellow
        # Confirmation de la suppression
        if ((Read-Host "► Confirmer la suppression de '$chemin' ? (o/n)") -eq "o") {
            # Suppression du dossier
            command_ssh "Remove-Item -Path '$chemin' -Recurse -Force"
            
            if ($LASTEXITCODE -eq 0) {
                logEvent "SUPPRESSION_EFFECTUÉE:$chemin"
                Write-Host "► Suppression effectuée"
            }
            else {
                logEvent "ERREUR_SUPPRESSION:$chemin"
                Write-Host "► Erreur lors de la suppression"
            }
        }
        else {
            logEvent "SUPPRESSION_ANNULÉE"
            Write-Host "► Suppression annulée"
        }
    }

    Write-Host ""
    gestion_repertoire_menu_windows
}
#endregion


#==============================================================
#region 05 - REDEMARRAGE
#==============================================================
function redemarrage_windows {

    logEvent "DEMANDE_REDEMARRAGE"
    # Affichage message de confirmation
    if ((Read-Host "► Voulez-vous redémarrer l'ordinateur distant ? (o/n)") -eq "o") {
        logEvent "REBOOT_ORDINATEUR"
        
        Write-Host "► L'ordinateur va redémarrer dans 10 secondes..."
        Start-Sleep -Seconds 3
        
        # Redémarrage de la machine distante
        command_ssh "shutdown /r /t 10"
        
        if ($LASTEXITCODE -eq 0) {
            logEvent "REDEMARRAGE_SUCCESS"
            Write-Host "► Commande de redémarrage envoyée"
        }
        else {
            logEvent "ERREUR_REDEMARRAGE"
            Write-Host "► Erreur : la commande a échoué"
        }
    }
    else {
        logEvent "REDEMARRAGE_ANNULE"
        Write-Host "► Redémarrage annulé"
    }

    Write-Host ""
    computerMainMenu
}
#endregion


#==============================================================
#region 06 - PRISE EN MAIN A DISTANCE
#==============================================================
function prise_main_distance_windows {

    logEvent "DEMANDE_PRISE_DE_MAIN_SSH"
    
    Write-Host "► Établissement de la connexion SSH interactive..."
    Write-Host "► Tapez 'exit' pour quitter la session"
    Write-Host ""

    # Session SSH interactive
    logEvent "DEMANDE_PRISE_DE_MAIN_DISTANTE_SSH"
    ssh -p "$portSSH" "$remoteUser@$remoteComputer" 
    

    if ($LASTEXITCODE -eq 0) {
        logEvent "CONNEXION_SUCCESS"
        Write-Host "► Vous êtes prise de main distante en (SSH)." -ForegroundColor Green
    }
    else {
        logEvent "ERREUR_SSH"
        write-Host "► Erreur : Vous êtes pas prise de main à distante en (SSH)." -ForegroundColor Red
        
    }
    Write-Host ""  
    computerMainMenu
}
#endregion


#==============================================================
#region 07 - ACTIVATION PARE-FEU
#==============================================================
function activation_parefeu_windows {
    logEvent "DEMANDE_ACTIVATION_PAREFEU"
    
    Write-Host "► Statut actuel du pare-feu :"
    Write-Host ""
    
    # Appel direct sans &
    command_ssh "Get-NetFirewallProfile | Select-Object Name,Enabled"
    Write-Host ""
    # Demande confirmation activation
    if ((Read-Host "► Voulez-vous activer le pare-feu Windows ? (o/n)") -eq "o") {
        Write-Host "► Activation en cours..."
        # Activation du pare-feu
        command_ssh "Set-NetFirewallProfile -All -Enabled True"
        # Vérification de l'activation
        if ($LASTEXITCODE -eq 0) {
            logEvent "PAREFEU_ACTIVE"
            Write-Host "► Pare-feu activé avec succès"
            Write-Host ""
            Write-Host "► Nouveau statut :"
            command_ssh "Get-NetFirewallProfile | Select-Object Name,Enabled"
        }
        else {
            logEvent "ERREUR_ACTIVATION_PAREFEU"
            Write-Host "► Erreur : impossible d'activer le pare-feu"
        }
    }
    else {
        logEvent "ACTIVATION_PAREFEU_ANNULEE"
        Write-Host "► Activation annulée"
    }
    Write-Host ""
    computerMainMenu
}
#endregion


#==============================================================
#region 08 - EXECUTION DE SCRIPT A DISTANCE
#==============================================================
function exec_script_linux {
    logEvent "DEMANDE_CHEMIN_SCRIPT"
    
    Write-Host "► Entrez le chemin du script sur $global:remoteComputer (machine Ubuntu) :"
    $scriptRemote = (Read-Host "► ").Trim().Trim('"')
    
    logEvent "SCRIPT_SELECTIONNE:$scriptRemote"
    
    # Test d'existence avec commande Linux
    Write-Host "► Verification de l'existence du fichier..." -ForegroundColor Cyan
    
    $testResult = bash_command "test -f '$scriptRemote' && echo 'EXISTS' || echo 'NOT_FOUND'"
    
    if ($testResult -notmatch "EXISTS") {
        logEvent "SCRIPT_INTROUVABLE:$scriptRemote"
        Write-Host "► Erreur : fichier introuvable sur $global:remoteComputer" -ForegroundColor Red
        Write-Host "   Chemin recherche : $scriptRemote" -ForegroundColor Gray
        
        # Afficher les fichiers du répertoire pour aide
        $dossier = Split-Path $scriptRemote -Parent
        if ($dossier) {
            Write-Host "`n► Fichiers dans le repertoire :" -ForegroundColor Yellow
            bash_command "ls -la '$dossier' 2>/dev/null | head -10"
        }
        
        Read-Host "`n► ENTREE pour continuer"
        computerMainMenu
        return
    }
    
    Write-Host "► Fichier trouve !" -ForegroundColor Green
    
    # Déterminer le type de script et l'exécuter
    logEvent "EXECUTION_SCRIPT:$scriptRemote"
    Write-Host "► Execution sur $global:remoteComputer..." -ForegroundColor Cyan
    Write-Host ""
    
    # Exécution avec bash
    bash_command "bash '$scriptRemote'"
    
    if ($LASTEXITCODE -eq 0) {
        logEvent "SUCCES"
        Write-Host ""
        Write-Host "► Script execute avec succes" -ForegroundColor Green
    }
    else {
        logEvent "ERREUR:CODE_$LASTEXITCODE"
        Write-Host ""
        Write-Host "► Erreur d'execution (code: $LASTEXITCODE)" -ForegroundColor Red
    }
    
    Write-Host ""
    Read-Host "► ENTREE pour continuer"
    computerMainMenu
}

#endregion


















