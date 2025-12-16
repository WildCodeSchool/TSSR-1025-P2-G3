# Script Gestion Ordinateur Linux
# Auteur : Safi
 
 # Sommaire :
# 01. Menu Gestion Répertoire
# 02. Création de répertoire
# 03. Création de répertoire Linux (SUDO)
# 04. Suppression de répertoire
# 05. Redémmarage
# 06. Prise en main à distance (CLI)
# 07. Activation du pare-feu
# 08. Exécution de scripts sur une machine distante


#==============================================================
#region 01 - MENU GESTION REPERTOIRE
#==============================================================
function gestion_repertoire_menu_linux {

    logEvent "MENU_GESTION_RÉPERTOIRE"
    
    while ($true) {
        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮" 
        Write-Host "│               GESTION REPERTOIRES                │"
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
                creer_dossier_linux
            }
            '2' {
                #fonction création de dossier admin
                logEvent "SÉLECTION_CRÉATION_DE_DOSSIER_ADMIN"
                creer_dossier_admin_linux
            }
            '3' {
                #fonction suppression de dossier
                logEvent "SÉLECTION_SUPPRESSION_DE_DOSSIER"
                supprimer_dossier_linux
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
function creer_dossier_linux {

    logEvent "CRÉATION_DE_DOSSIER"
    Write-Host "► Entrez le chemin du dossier :"
    $chemin = Read-Host "►"

    # Condition Vérification existence du dossier
    if ((bash_command "test -d '$chemin' && echo 'True' || echo 'False'") -eq "True") {
        logEvent "LE_DOSSIER_EXISTE_DÉJÀ:$chemin"
        Write-Host "► Le dossier existe déjà"
    }
    else {
        # Création du dossier
        bash_command "mkdir -p '$chemin'"
        
        if ($LASTEXITCODE -eq 0) {
            logEvent "DOSSIER_CRÉÉ:$chemin" 
            Write-Host "► Le dossier a été créé : $chemin" -ForegroundColor Green
        }
        else {
            logEvent "ERREUR_DOSSIER_NON_CRÉÉ:$chemin"
            Write-Host "► Erreur : dossier non créé" -ForegroundColor Red
        }
    }

    Write-Host ""
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
}
#endregion


#==============================================================
#region 03 - CREATION DE REPERTOIRE AVEC PRIVILEGES ADMIN
#==============================================================
function creer_dossier_admin_linux {

    logEvent "CRÉATION_DE_DOSSIER_ADMIN"

    Write-Host "► Entrez le chemin du dossier:"
    $chemin = Read-Host "►"

    # Condition Vérification existence du dossier
    if ((bash_command "test -d '$chemin' && echo 'True' || echo 'False'") -eq "True") {
        logEvent "LE_DOSSIER_EXISTE_DÉJÀ:$chemin"
        Write-Host "► Le dossier existe déjà"
    }
    else {
        # Création du dossier avec permissions admin
        bash_sudo_command "sudo mkdir -p '$chemin' && sudo chmod 700 '$chemin' && sudo chown root:root '$chemin'"
        # Vérification de la création
        if ($LASTEXITCODE -eq 0) {
            logEvent "DOSSIER_ADMIN_CRÉÉ:$chemin"
            Write-Host "► Le dossier a été créé : $chemin" -ForegroundColor Green
            Write-Host "► Permissions : root uniquement (700)"
        }
        else {
            logEvent "ERREUR_DOSSIER_ADMIN_NON_CRÉÉ:$chemin"
            Write-Host "► Erreur : dossier non créé" -ForegroundColor Red
        }
    }

    Write-Host ""
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
}
#endregion


#==============================================================
#region 04 - SUPPRESSION DE REPERTOIRE
#==============================================================
function supprimer_dossier_linux {

    logEvent "SUPPRESSION_DE_DOSSIER"
    
    Write-Host "► Entrez le chemin du dossier à supprimer :"
    $chemin = Read-Host "►"

    # Vérification existence du dossier
    if ((bash_command "test -d '$chemin' && echo 'True' || echo 'False'") -ne "True") {
        logEvent "DOSSIER_INEXISTANT:$chemin"
        Write-Host "► Le dossier n'existe pas"
    }
    else {
        Write-Host ""
        Write-Host "► ATTENTION : Cette action est irréversible !" -ForegroundColor Yellow
        # Confirmation de la suppression
        if ((Read-Host "► Confirmer la suppression de '$chemin' ? (o/n)") -eq "o") {
            # Suppression du dossier
            bash_command "rm -rf '$chemin'"
            
            if ($LASTEXITCODE -eq 0) {
                logEvent "SUPPRESSION_EFFECTUÉE:$chemin" 
                Write-Host "► Suppression effectuée" -ForegroundColor Yellow
            }
            else {
                logEvent "ERREUR_SUPPRESSION:$chemin"
                Write-Host "► Erreur lors de la suppression" -ForegroundColor Red
            }
        }
        else {
            logEvent "SUPPRESSION_ANNULÉE"
            Write-Host "► Suppression annulée"
        }
    }

    Write-Host ""
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
}
#endregion


#==============================================================
#region 05 - REDEMARRAGE
#==============================================================
function redemarrage_linux {

    logEvent "DEMANDE_REDEMARRAGE"
    # Affichage message de confirmation
    if ((Read-Host "► Voulez-vous redémarrer l'ordinateur distant ? (o/n)") -eq "o") {
        logEvent "REBOOT_ORDINATEUR"
        Write-Host "► L'ordinateur va redémarrer dans 10 secondes..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        
        # Redémarrage de la machine distante
        bash_command "sudo shutdown -r +0"
        
        if ($LASTEXITCODE -eq 0) {
            logEvent "REDEMARRAGE_SUCCESS"
            Write-Host "► Commande de redémarrage envoyée"
        }
        else {
            logEvent "ERREUR_REDEMARRAGE"
            Write-Host "► Erreur : la commande a échoué" -ForegroundColor Red
        }
    }
    else {
        logEvent "REDEMARRAGE_ANNULE"
        Write-Host "► Redémarrage annulé"
    }

    Write-Host ""
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
}
#endregion


#==============================================================
#region 06 - PRISE EN MAIN A DISTANCE
#==============================================================
function prise_main_distance_linux {

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
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
    computerMainMenu
    
}
#endregion


#==============================================================
#region 07 - ACTIVATION PARE-FEU
#==============================================================

function activation_parefeu_linux {
    logEvent "DEMANDE_ACTIVATION_PAREFEU"
    
    Write-Host "► Statut actuel du pare-feu :"
    Write-Host ""
    
    # Appel direct sans &
    bash_sudo_command "ufw status"
    Write-Host ""
    # Demande confirmation activation
    if ((Read-Host "► Voulez-vous activer le pare-feu linux ? (o/n)") -eq "o") {
        Write-Host "► Activation en cours..." -ForegroundColor Yellow
        # Activation du pare-feu
        bash_sudo_command "ufw --force enable"
        # Vérification de l'activation
        if ($LASTEXITCODE -eq 0) {
            logEvent "PAREFEU_ACTIVE"
            Write-Host "► Pare-feu activé avec succès" -ForegroundColor Green
            Write-Host ""
            Write-Host "► Nouveau statut :"
            bash_sudo_command "ufw status verbose"
        }
        else {
            logEvent "ERREUR_ACTIVATION_PAREFEU"
            Write-Host "► Erreur : impossible d'activer le pare-feu"
        }
    }
    else {
        logEvent "ACTIVATION_PAREFEU_ANNULEE"
        Write-Host "► Activation annulée" -ForegroundColor Red
    }
    Write-Host ""
    Read-Host "► Appuyez sur ENTRÉE pour continuer"
    computerMainMenu

}
#endregion


#==============================================================
#region 08 - EXECUTION DE SCRIPT LOCAL
#==============================================================
function exec_script_linux {

    logEvent "DEMANDE_CHEMIN_SCRIPT"
    
    Write-Host "► Entrez le chemin du script local à exécuter :"
    $scriptLocal = Read-Host "► "
    
    logEvent "SCRIPT_SÉLECTIONNÉ:$scriptLocal"

    # Vérification existence du fichier
    if (-not (Test-Path $scriptLocal)) {
        logEvent "SCRIPT_INTROUVABLE:$scriptLocal"
        Write-Host "► Erreur : fichier introuvable`n" -ForegroundColor Red
        Read-Host "► Appuyez sur ENTRÉE pour continuer"
        return
    }

    # Vérification extension .sh
    if ([System.IO.Path]::GetExtension($scriptLocal) -ne ".sh") {
        Write-Host "► Avertissement : Le fichier n'a pas l'extension .sh" -ForegroundColor Yellow
        if ((Read-Host "► Continuer quand même ? (o/n)") -ne "o") {
            logEvent "EXECUTION_ANNULEE"
            return
        }
    }

    logEvent "EXÉCUTION_SCRIPT:$scriptLocal"
    
    Write-Host "`n► Exécution du script sur : $global:remoteComputer"
    Write-Host "► Envoi en cours...`n"
    
    # Lecture et encodage du script en base64 pour éviter les problèmes d'échappement
    $contenu = Get-Content $scriptLocal -Raw -Encoding UTF8
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($contenu)
    $encoded = [Convert]::ToBase64String($bytes)
    
    # Exécution via décodage base64 sur la machine distante
    bash_sudo_command "echo '$encoded' | base64 -d | bash"
    
    # Affichage du résultat
    $message = if ($LASTEXITCODE -eq 0) {
        logEvent "SCRIPT_EXECUTE_SUCCESS"
        "► Script exécuté avec succès"
    } else {
        logEvent "ERREUR_EXECUTION_SCRIPT:$scriptLocal"
        "► Erreur lors de l'exécution"
    }
    
    Write-Host "$message`n" -ForegroundColor $(if ($LASTEXITCODE -eq 0) { "Green" } else { "Red" })
    Read-Host "► Appuyez sur ENTRÉE pour continuer"

}
#endregion

