# Script Informations Système Windows en Powershell


# Liste des fonctions :
# 1. FONCTION : MENU GESTION DISQUE
# 2. FONCTION : NOMBRE DE DISQUES
# 3. FONCTION : PARTITIONS
# 4. FONCTION : LECTEURS MONTÉS
# 5. FONCTION : LISTE UTILISATEURS LOCAUX
# 6. FONCTION : 5 DERNIERS LOGINS
# 7. FONCTION : INFORMATIONS RÉSEAU
# 8. FONCTION : VERSION DU OS
# 9. FONCTION : MISES À JOUR CRITIQUES
# 10. FONCTION : MARQUE ET MODÈLE DE L'ORDINATEUR
# 11. FONCTION : VÉRIFIER UAC


#==============================================================
# MENU GESTION DISQUES
#==============================================================
function gestion_disques_menu_windows {
    
    logEvent "MENU_GESTION_DISQUES"
    
    while ($true) {
        Write-Host ""
        Write-Host "╭──────────────────────────────────────────╮"
        Write-Host "│             Gestion Des Disques          │"
        Write-Host "├──────────────────────────────────────────┤"
        Write-Host "│                                          │"
        Write-Host "│  1. Nombre de disques                    │"
        Write-Host "│  2. Afficher les partitions              │"
        Write-Host "│  3. Afficher les lecteurs montés         │"
        Write-Host "│  4. Retour au menu précédent             │"
        Write-Host "│                                          │"
        Write-Host "╰──────────────────────────────────────────╯"
        Write-Host ""

        $choix = Read-Host "► Choisissez une option "

        switch ($choix) {
            '1' { 
                logEvent "SELECTION_NOMBRE_DISQUES"
                fonction_nombre_disques_windows 
            }
            '2' { 
                logEvent "SELECTION_PARTITIONS"
                fonction_partitions_windows 
            }
            '3' { 
                logEvent "SELECTION_LECTEURS_MONTES"
                fonction_lecteurs_montes_windows 
            }
            '4' { 
                logEvent "RETOUR_MENU_PRECEDENT"
                Write-Host "► Retour au menu précédent"
                informationMainMenu
                return 
            }
            default { 
                logEvent "OPTION_INVALIDE_GESTION_DISQUES"
                Write-Host "► Option invalide." 
            }
        }
    }
}


#==============================================================
# FONCTION : NOMBRE DE DISQUES
#==============================================================
function fonction_nombre_disques_windows {
    
    logEvent "DEMANDE_NOMBRE_DISQUES"
    
    Write-Host ""
    Write-Host "► NOMBRE DE DISQUES"
    Write-Host ""
    
    # Je récupère tous les disques physiques
    $disks = Get-Disk
    # Je compte le nombre de disques
    $nombreDisques = ($disks | Measure-Object).Count
    
    Write-Host "► Nombre de disques : $nombreDisques"
    Write-Host ""
    
    # J'affiche les détails de chaque disque
    $disks | Select-Object Number, FriendlyName, Size, PartitionStyle | Format-Table -AutoSize
    
    # J'enregistre dans le fichier d'infos si la fonction existe
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# FONCTION : PARTITIONS
#==============================================================
function fonction_partitions_windows {
    
    logEvent "DEMANDE_LISTE_PARTITIONS"
    
    Write-Host ""
    Write-Host "► PARTITIONS"
    Write-Host ""
    
    # Je récupère tous les volumes qui ont une lettre de lecteur
    $partitionsList = Get-Volume | Where-Object { $_.DriveLetter } | 
        Select-Object DriveLetter, FileSystemType, 
            # Je convertis la taille en Go avec 2 décimales
            @{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB, 2) } },
            @{Name = "FreeSpaceGB"; Expression = { [math]::Round($_.SizeRemaining / 1GB, 2) } }
    
    # J'affiche le tableau
    $partitionsList | Format-Table -AutoSize
    
    # Je compte le nombre total de partitions
    $nombrePartitions = (Get-Partition | Measure-Object).Count
    Write-Host "► Nombre total de partitions : $nombrePartitions"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        $partitionsText = $partitionsList | Out-String
        infoFile $env:COMPUTERNAME "Liste de partitions:" $partitionsText
        infoFile $env:COMPUTERNAME "Nombre de partitions:" $nombrePartitions
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# FONCTION : LECTEURS MONTÉS
#==============================================================
function fonction_lecteurs_montes_windows {
    
    logEvent "DEMANDE_LECTEURS_MONTES"
    
    Write-Host ""
    Write-Host "► LECTEURS MONTÉS"
    Write-Host ""
    
    # Je récupère tous les lecteurs de type fichiers (disques, USB, CD, etc.)
    $lecteursList = Get-PSDrive -PSProvider FileSystem | 
        Select-Object Name, 
            # Je convertis l'espace utilisé en Go
            @{Name = "UsedGB"; Expression = { [math]::Round($_.Used / 1GB, 2) } },
            # Je convertis l'espace libre en Go
            @{Name = "FreeGB"; Expression = { [math]::Round($_.Free / 1GB, 2) } },
            Root
    
    # J'affiche le tableau
    $lecteursList | Format-Table -AutoSize
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        $lecteursText = $lecteursList | Out-String
        infoFile $env:COMPUTERNAME "Lecteurs montés:" $lecteursText
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# FONCTION : LISTE UTILISATEURS LOCAUX
#==============================================================
function fonction_liste_utilisateurs_windows {
    
    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    
    Write-Host ""
    Write-Host "► LISTE DES UTILISATEURS LOCAUX"
    Write-Host ""
    
    # Je récupère tous les utilisateurs locaux activés
    $userList = Get-LocalUser | Where-Object { $_.Enabled -eq $true } | 
        Select-Object Name, Enabled, LastLogon, Description
    
    # J'affiche le tableau
    $userList | Format-Table -AutoSize
    
    # Je compte les utilisateurs
    $nombreUtilisateurs = ($userList | Measure-Object).Count
    Write-Host "► Nombre d'utilisateurs actifs : $nombreUtilisateurs"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        $usersText = $userList | Out-String
        infoFile $env:COMPUTERNAME "Liste d'utilisateurs:" $usersText
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : 5 DERNIERS LOGINS
#==============================================================
function fonction_5_derniers_logins_windows {
    
    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    
    Write-Host ""
    Write-Host "► LES 5 DERNIERS LOGINS"
    Write-Host ""
    
    try {
        # Je récupère les 5 derniers événements de connexion réussie (ID 4624)
        $loginsList = Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 -ErrorAction Stop | 
            Select-Object TimeGenerated, 
                # J'extrais le nom d'utilisateur du message
                @{Name = "Utilisateur"; Expression = {
                    if ($_.Message -match "Account Name:\s+(\S+)") { $matches[1] } else { "N/A" }
                }},
                # J'extrais le domaine du message
                @{Name = "Domaine"; Expression = {
                    if ($_.Message -match "Account Domain:\s+(\S+)") { $matches[1] } else { "N/A" }
                }}
        
        # J'affiche le tableau
        $loginsList | Format-Table -AutoSize
        
        # J'enregistre dans le fichier d'infos
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $loginsText = $loginsList | Out-String
            infoFile $env:COMPUTERNAME "5 derniers logins:" $loginsText
        }
    }
    catch {
        Write-Host "► Erreur : Cette fonction nécessite des privilèges administrateur"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : INFORMATIONS RÉSEAU
#==============================================================
function fonction_infos_reseau_windows {
    
    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    
    Write-Host ""
    Write-Host "► INFORMATIONS RÉSEAU"
    Write-Host ""
    
    Write-Host "► Adresse IP et masque :"
    Write-Host ""
    
    # Je récupère les adresses IPv4 (sauf loopback)
    $ipMasque = Get-NetIPAddress | Where-Object { 
        $_.AddressFamily -eq 'IPv4' -and 
        $_.InterfaceAlias -notlike 'Loopback*' 
    } | Select-Object InterfaceAlias, IPAddress, PrefixLength
    
    # J'affiche le tableau
    $ipMasque | Format-Table -AutoSize
    
    Write-Host ""
    Write-Host "► Passerelle par défaut :"
    Write-Host ""
    
    # Je récupère la passerelle par défaut (route 0.0.0.0/0)
    $passerelle = Get-NetRoute | Where-Object { 
        $_.DestinationPrefix -eq '0.0.0.0/0' 
    } | Select-Object InterfaceAlias, NextHop
    
    # J'affiche le tableau
    $passerelle | Format-Table -AutoSize
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        $ipText = $ipMasque | Out-String
        $passerelleText = $passerelle | Out-String
        infoFile $env:COMPUTERNAME "Adresse IP et masque:" $ipText
        infoFile $env:COMPUTERNAME "Passerelle par défaut:" $passerelleText
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : VERSION DU SYSTÈME
#==============================================================
function fonction_version_os_windows {
    
    logEvent "DEMANDE_VERSION_OS"
    
    Write-Host ""
    Write-Host "► VERSION DU SYSTÈME"
    Write-Host ""
    
    # Je récupère les infos du système
    $versionOS = Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsVersion, OsBuildNumber, WindowsEditionId
    
    # J'affiche les informations
    Write-Host "Nom du produit : $($versionOS.WindowsProductName)"
    Write-Host "Édition        : $($versionOS.WindowsEditionId)"
    Write-Host "Version        : $($versionOS.WindowsVersion)"
    Write-Host "Build          : $($versionOS.OsBuildNumber)"
    Write-Host "Version OS     : $($versionOS.OsVersion)"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        $osText = $versionOS | Out-String
        infoFile $env:COMPUTERNAME "Version OS:" $osText
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : MISES À JOUR CRITIQUES
#==============================================================
function fonction_mises_a_jour_windows {
    
    logEvent "DEMANDE_MISES_A_JOUR"
    
    Write-Host ""
    Write-Host "► MISES À JOUR CRITIQUES"
    Write-Host ""
    
    try {
        # Je vérifie si le module PSWindowsUpdate est installé
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            
            Write-Host "► Recherche des mises à jour..."
            Write-Host ""
            
            # J'importe le module
            Import-Module PSWindowsUpdate -ErrorAction Stop
            
            # Je récupère les mises à jour de sécurité et critiques
            $majList = Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates' -ErrorAction Stop
            
            if ($majList) {
                # J'affiche les mises à jour disponibles
                $majList | Select-Object Title, KB, Size | Format-Table -AutoSize
                
                $updateCount = ($majList | Measure-Object).Count
                Write-Host ""
                Write-Host "► $updateCount mise(s) à jour disponible(s)" -ForegroundColor Yellow
            }
            else {
                Write-Host "► Aucune mise à jour en attente" -ForegroundColor Green
            }
            
            # J'enregistre dans le fichier d'infos
            if (Get-Command infoFile -ErrorAction SilentlyContinue) {
                $majText = $majList | Out-String
                infoFile $env:COMPUTERNAME "Mises à jour de sécurité:" $majText
            }
        }
        else {
            Write-Host "► Le module PSWindowsUpdate n'est pas installé" -ForegroundColor Yellow
            Write-Host "► Pour installer : Install-Module PSWindowsUpdate -Force"
            Write-Host ""
            
            # J'utilise la méthode alternative avec COM
            $updateSession = New-Object -ComObject Microsoft.Update.Session
            $updateSearcher = $updateSession.CreateUpdateSearcher()
            
            Write-Host "► Recherche en cours..."
            
            # Je cherche les mises à jour non installées
            $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")
            
            if ($searchResult.Updates.Count -gt 0) {
                Write-Host ""
                Write-Host "► Mises à jour disponibles :"
                
                # J'affiche chaque mise à jour
                foreach ($update in $searchResult.Updates) {
                    Write-Host "  - $($update.Title)"
                }
                
                Write-Host ""
                Write-Host "► $($searchResult.Updates.Count) mise(s) à jour disponible(s)" -ForegroundColor Yellow
            }
            else {
                Write-Host "► Aucune mise à jour en attente" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "► Erreur lors de la vérification des mises à jour"
        Write-Host "► Conseil : Vérifiez manuellement via Windows Update"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : MARQUE ET MODÈLE
#==============================================================
function fonction_marque_modele_windows {
    
    logEvent "DEMANDE_MARQUE_MODELE"
    
    Write-Host ""
    Write-Host "► MARQUE / MODÈLE"
    Write-Host ""
    
    # Je récupère le fabricant
    $fabricant = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer
    Write-Host "► Fabricant : $fabricant"
    
    # Je récupère le modèle
    $modele = (Get-CimInstance -ClassName Win32_ComputerSystem).Model
    Write-Host "► Modèle    : $modele"
    
    # Je récupère la version
    $version = (Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version
    Write-Host "► Version   : $version"
    
    # Je récupère le numéro de série
    $serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
    Write-Host "► N° série  : $serial"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Fabricant:" $fabricant
        infoFile $env:COMPUTERNAME "Modèle:" $modele
        infoFile $env:COMPUTERNAME "Version:" $version
        infoFile $env:COMPUTERNAME "Numéro de série:" $serial
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}


#==============================================================
# FONCTION : VÉRIFIER UAC
#==============================================================
function fonction_verifier_uac_windows {
    
    logEvent "DEMANDE_VERIFICATION_UAC"
    
    Write-Host ""
    Write-Host "► STATUT UAC (Contrôle de Compte Utilisateur)"
    Write-Host ""
    
    # Je lis la valeur UAC dans le registre (1=activé, 0=désactivé)
    $uacValue = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA).EnableLUA
    
    if ($uacValue -eq 1) {
        Write-Host "► UAC est ACTIVÉ (Sécurisé)" -ForegroundColor Green
        $uacStatus = "UAC est ACTIVÉ (Sécurisé)"
    }
    else {
        Write-Host "► UAC est DÉSACTIVÉ (Non sécurisé)" -ForegroundColor Red
        Write-Host ""
        Write-Host "  ⚠ ATTENTION : Système vulnérable"
        Write-Host "  Pour activer : Panneau de configuration > Comptes d'utilisateurs"
        $uacStatus = "UAC est DÉSACTIVÉ (Non sécurisé)"
    }
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Statut UAC:" $uacStatus
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}