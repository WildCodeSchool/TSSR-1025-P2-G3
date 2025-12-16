# Script Informations Système Windows en Powershell
# Auteur : Safi


# Sommaire :
# 01 - MENU GESTION DISQUE
# 02 - NOMBRE DE DISQUES
# 03 - PARTITIONS
# 04 - LECTEURS MONTÉS
# 05 - LISTE UTILISATEURS LOCAUX
# 06 - 5 DERNIERS LOGINS
# 07 - INFORMATIONS RÉSEAU
# 08 - VERSION DU OS
# 09-  MISES À JOUR CRITIQUES
# 10 - MARQUE ET MODÈLE DE L'ORDINATEUR
# 11 - VÉRIFIER UAC



#==============================================================
#region 01 - MENU GESTION DISQUES
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
                # Appel de la fonction nombre_disques_windows
                nombre_disques_windows 
            }
            '2' { 
                logEvent "SELECTION_PARTITIONS"
                # Appel de la fonction partitions_windows
                partitions_windows 
            }
            '3' { 
                logEvent "SELECTION_LECTEURS_MONTES"
                # Appel de la fonction lecteurs_montes_windows
                lecteurs_montes_windows 
            }
            '4' { 
                logEvent "RETOUR_MENU_PRECEDENT"
                # Retour au menu précédent
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
#endregion


#==============================================================
#region 02 - NOMBRE DE DISQUES
#==============================================================
function nombre_disques_windows {
    
    logEvent "DEMANDE_NOMBRE_DISQUES"
    
    Write-Host ""
    Write-Host "► NOMBRE DE DISQUES"
    Write-Host ""
    
    # Je récupère tous les disques physiques
    $disks = ssh_command "Get-Disk"
    # Je compte le nombre de disques
    $nombreDisques = (ssh_command "Get-Disk | Measure-Object").Count
    
    Write-Host "► Nombre de disques : $nombreDisques"
    Write-Host ""
    
    # J'affiche les détails de chaque disque
    ssh_command "Get-Disk | Select-Object Number, FriendlyName, Size, PartitionStyle | Format-Table -AutoSize"
    
    # J'enregistre dans le fichier d'infos si la fonction existe
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques
        }
        
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 03 - PARTITIONS
#==============================================================
function partitions_windows {
    
    logEvent "DEMANDE_LISTE_PARTITIONS"
    
    Write-Host ""
    Write-Host "► PARTITIONS"
    Write-Host ""
    
    # Je récupère tous les volumes qui ont une lettre de lecteur
    $partitionsList = ssh_command "Get-Volume | Where-Object { `$_.DriveLetter } | Select-Object DriveLetter, FileSystemType, @{Name = 'SizeGB'; Expression = { [math]::Round(`$_.Size / 1GB, 2) } }, @{Name = 'FreeSpaceGB'; Expression = { [math]::Round(`$_.SizeRemaining / 1GB, 2) } }"
    
    # J'affiche le tableau
    Write-Host $partitionsList
    
    # Je compte le nombre total de partitions
    $nombrePartitions = (ssh_command "Get-Partition | Measure-Object").Count
    Write-Host "► Nombre total de partitions : $nombrePartitions"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Liste de partitions:" $partitionsList
        infoFile $env:COMPUTERNAME "Nombre de partitions:" $nombrePartitions
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 04 - LECTEURS MONTÉS
#==============================================================
function lecteurs_montes_windows {
    
    logEvent "DEMANDE_LECTEURS_MONTES"
    
    Write-Host ""
    Write-Host "► LECTEURS MONTÉS"
    Write-Host ""
    
    # Je récupère tous les lecteurs de type fichiers (disques, USB, CD, etc.)
    $lecteursList = ssh_command "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name = 'UsedGB'; Expression = { [math]::Round(`$_.Used / 1GB, 2) } }, @{Name = 'FreeGB'; Expression = { [math]::Round(`$_.Free / 1GB, 2) } }, Root"
    
    # J'affiche le tableau
    Write-Host $lecteursList
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Lecteurs montés:" $lecteursList
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 05 - LISTE UTILISATEURS LOCAUX
#==============================================================
function liste_utilisateurs_windows {
    
    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    
    Write-Host ""
    Write-Host "► LISTE DES UTILISATEURS LOCAUX"
    Write-Host ""
    
    # Je récupère tous les utilisateurs locaux activés
    $userList = ssh_command "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Select-Object Name, Enabled, LastLogon, Description"
    
    # J'affiche le tableau
    Write-Host $userList
    
    # Je compte les utilisateurs
    $nombreUtilisateurs = (ssh_command "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Measure-Object").Count
    Write-Host "► Nombre d'utilisateurs actifs : $nombreUtilisateurs"
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Liste d'utilisateurs:" $userList
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 06 - 5 DERNIERS LOGINS
#==============================================================
function 5_derniers_logins_windows {
    
    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    
    Write-Host ""
    Write-Host "► LES 5 DERNIERS LOGINS"
    Write-Host ""
    
    try {
        # Je récupère les 5 derniers événements de connexion réussie (ID 4624)
        $loginsList = ssh_command "Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 | Select-Object TimeGenerated, @{Name = 'Utilisateur'; Expression = { if (`$_.Message -match 'Account Name:\s+(\S+)') { `$matches[1] } else { 'N/A' } }}, @{Name = 'Domaine'; Expression = { if (`$_.Message -match 'Account Domain:\s+(\S+)') { `$matches[1] } else { 'N/A' } }}"
        
        # J'affiche le tableau
        Write-Host $loginsList
        
        # J'enregistre dans le fichier d'infos
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            infoFile $env:COMPUTERNAME "5 derniers logins:" $loginsList
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
#endregion


#==============================================================
#region 07 - INFORMATIONS RÉSEAU
#==============================================================
function infos_reseau_windows {
    
    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    
    Write-Host ""
    Write-Host "► INFORMATIONS RÉSEAU"
    Write-Host ""
    
    Write-Host "► Adresse IP et masque :"
    Write-Host ""
    
    # Je récupère les adresses IPv4 (sauf loopback)
    $ipMasque = ssh_command "Get-NetIPAddress | Where-Object { `$_.AddressFamily -eq 'IPv4' -and `$_.InterfaceAlias -notlike 'Loopback*' } | Select-Object InterfaceAlias, IPAddress, PrefixLength"
    
    # J'affiche le tableau
    Write-Host $ipMasque
    
    Write-Host ""
    Write-Host "► Passerelle par défaut :"
    Write-Host ""
    
    # Je récupère la passerelle par défaut (route 0.0.0.0/0)
    $passerelle = ssh_command "Get-NetRoute | Where-Object { `$_.DestinationPrefix -eq '0.0.0.0/0' } | Select-Object InterfaceAlias, NextHop"
    
    # J'affiche le tableau
    Write-Host $passerelle
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Adresse IP et masque:" $ipMasque
        infoFile $env:COMPUTERNAME "Passerelle par défaut:" $passerelle
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 08 - VERSION DU SYSTÈME
#==============================================================
function version_os_windows {
    
    logEvent "DEMANDE_VERSION_OS"
    
    Write-Host ""
    Write-Host "► VERSION DU SYSTÈME"
    Write-Host ""
    
    # Je récupère les infos du système
    $versionOS = ssh_command "Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsVersion, OsBuildNumber, WindowsEditionId"
    
    # J'affiche les informations
    Write-Host $versionOS
    
    # J'enregistre dans le fichier d'infos
    if (Get-Command infoFile -ErrorAction SilentlyContinue) {
        infoFile $env:COMPUTERNAME "Version OS:" $versionOS
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 09 - MISES À JOUR CRITIQUES
#==============================================================
function mises_a_jour_windows {
    
    logEvent "DEMANDE_MISES_A_JOUR"
    
    Write-Host ""
    Write-Host "► MISES À JOUR CRITIQUES"
    Write-Host ""
    
    try {
        # Je vérifie si le module PSWindowsUpdate est installé
        $moduleCheck = ssh_command "Get-Module -ListAvailable -Name PSWindowsUpdate"
        
        if ($moduleCheck) {
            
            Write-Host "► Recherche des mises à jour..."
            Write-Host ""
            
            # J'importe le module
            ssh_command "Import-Module PSWindowsUpdate"
            
            # Je récupère les mises à jour de sécurité et critiques
            $majList = ssh_command "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates'"
            
            if ($majList) {
                # J'affiche les mises à jour disponibles
                Write-Host $majList
                
                $updateCount = (ssh_command "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates' | Measure-Object").Count
                Write-Host ""
                Write-Host "► $updateCount mise(s) à jour disponible(s)" -ForegroundColor Yellow
            }
            else {
                Write-Host "► Aucune mise à jour en attente" -ForegroundColor Green
            }
            
            # J'enregistre dans le fichier d'infos
            if (Get-Command infoFile -ErrorAction SilentlyContinue) {
                infoFile $env:COMPUTERNAME "Mises à jour de sécurité:" $majList
            }
        }
        else {
            Write-Host "► Le module PSWindowsUpdate n'est pas installé" -ForegroundColor Yellow
            Write-Host "► Pour installer : Install-Module PSWindowsUpdate -Force"
            Write-Host ""
            
            # J'utilise la méthode alternative avec COM
            Write-Host "► Recherche en cours..."
            
            # Je cherche les mises à jour non installées
            $searchResult = ssh_command "`$updateSession = New-Object -ComObject Microsoft.Update.Session; `$updateSearcher = `$updateSession.CreateUpdateSearcher(); `$updateSearcher.Search('IsInstalled=0 and Type=''Software''').Updates.Count"
            
            if ($searchResult -gt 0) {
                Write-Host ""
                Write-Host "► Mises à jour disponibles :"
                
                # J'affiche chaque mise à jour
                ssh_command "`$updateSession = New-Object -ComObject Microsoft.Update.Session; `$updateSearcher = `$updateSession.CreateUpdateSearcher(); `$searchResult = `$updateSearcher.Search('IsInstalled=0 and Type=''Software'''); foreach (`$update in `$searchResult.Updates) { Write-Host '  - ' `$update.Title }"
                
                Write-Host ""
                Write-Host "► $searchResult mise(s) à jour disponible(s)" -ForegroundColor Yellow
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
#endregion


#==============================================================
#region 10 - MARQUE ET MODÈLE
#==============================================================
function marque_modele_windows {
    
    logEvent "DEMANDE_MARQUE_MODELE"
    
    Write-Host ""
    Write-Host "► MARQUE / MODÈLE"
    Write-Host ""
    
    # Je récupère le fabricant
    $fabricant = ssh_command "(Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer"
    Write-Host "► Fabricant : $fabricant"
    
    # Je récupère le modèle
    $modele = ssh_command "(Get-CimInstance -ClassName Win32_ComputerSystem).Model"
    Write-Host "► Modèle    : $modele"
    
    # Je récupère la version
    $version = ssh_command "(Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version"
    Write-Host "► Version   : $version"
    
    # Je récupère le numéro de série
    $serial = ssh_command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber"
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
#endregion


#==============================================================
#region 11 - VÉRIFIER UAC
#==============================================================
function verifier_uac_windows {
    
    logEvent "DEMANDE_VERIFICATION_UAC"
    
    Write-Host ""
    Write-Host "► STATUT UAC (Contrôle de Compte Utilisateur)"
    Write-Host ""
    
    # Je lis la valeur UAC dans le registre (1=activé, 0=désactivé)
    $uacValue = ssh_command "(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA).EnableLUA"
    
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
#endregion

