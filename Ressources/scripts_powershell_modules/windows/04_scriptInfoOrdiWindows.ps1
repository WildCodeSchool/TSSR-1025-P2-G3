﻿# Script Informations Système Windows en Powershell


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
# 1- FONCTION : MENU GESTION DISQUES
#==============================================================
function gestion_disques_menu_windows {
    
    # Boucle infinie pour maintenir le menu actif
    while ($true) {
        
        # Affichage du menu avec bordures ASCII
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

        # Lecture du choix utilisateur
        $choix = Read-Host "► Choisissez une option "

        # Structure switch pour traiter le choix
        switch ($choix) {
            '1' {
                # Appel de la fonction pour compter les disques
                logEvent "SELECTION_NOMBRE_DISQUES"
                fonction_nombre_disques_windows
            }
            
            '2' {
                # Appel de la fonction pour lister les partitions
                logEvent "SELECTION_PARTITIONS"
                fonction_partitions_windows
            }
            
            '3' {
                # Appel de la fonction pour afficher les lecteurs montés
                logEvent "SELECTION_LECTEURS_MONTES"
                fonction_lecteurs_montes_windows
            }
            
            '4' {
                # Retour au menu principal
                logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
                Write-Host "► Retour au menu précédent"
                # Appel de la fonction du menu principal (doit être définie ailleurs)
                informationMainMenu
                return
            }
            default {
                # Gestion des choix invalides
                Write-Host "► Option invalide."
            }
        }
    }
}


#==============================================================
# 2-FONCTION : NOMBRE DE DISQUES
#==============================================================
function fonction_nombre_disques_windows {
    
    Write-Host ""
    logEvent "DEMANDE_NOMBRE_DISQUES"
    Write-Host "► NOMBRE DE DISQUES"
    Write-Host ""
    
    try {
        # Get-Disk récupère tous les disques physiques
        # Measure-Object compte le nombre d'objets
        # .Count récupère le nombre total
        $disks = Get-Disk
        $nombreDisques = ($disks | Measure-Object).Count
        
        Write-Host "► Nombre de disques : $nombreDisques"
        Write-Host ""
        
        # Affichage détaillé de chaque disque
        Write-Host "► Détails des disques :"
        $disks | Select-Object Number, FriendlyName, Size, PartitionStyle | Format-Table -AutoSize
        
        # Enregistrement dans le fichier d'informations (fonction du script principal)
        # infoFile doit être définie dans le script principal
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération du nombre de disques"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# 3-FONCTION : PARTITIONS
#==============================================================
function fonction_partitions_windows {
    
    Write-Host ""
    logEvent "DEMANDE_LISTE_PARTITIONS"
    Write-Host "► PARTITIONS (Nom, FS, Taille)"
    Write-Host ""
    
    try {
        # Get-Volume récupère tous les volumes/partitions
        # Where-Object filtre pour ne garder que ceux qui ont une lettre de lecteur
        # Select-Object sélectionne les propriétés à afficher
        $partitionsList = Get-Volume | Where-Object { $_.DriveLetter } | 
        Select-Object DriveLetter, FileSystemType, 
        @{Name = "SizeGB"; Expression = { [math]::Round($_.Size / 1GB, 2) } },
        @{Name = "FreeSpaceGB"; Expression = { [math]::Round($_.SizeRemaining / 1GB, 2) } }
        
        # Affichage formaté en tableau
        $partitionsList | Format-Table -AutoSize
        
        # Compte le nombre total de partitions
        # Get-Partition récupère toutes les partitions (même sans lettre)
        $nombrePartitions = (Get-Partition | Measure-Object).Count
        
        Write-Host "► Nombre total de partitions : $nombrePartitions"
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $partitionsText = $partitionsList | Out-String
            infoFile $env:COMPUTERNAME "Liste de partitions:" $partitionsText
            infoFile $env:COMPUTERNAME "Nombre de partitions:" $nombrePartitions
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des partitions"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# FONCTION : LECTEURS MONTÉS
#==============================================================
function fonction_lecteurs_montes_windows {
    
    Write-Host ""
    logEvent "DEMANDE_LECTEURS_MONTES"
    Write-Host "► LECTEURS MONTÉS (disques, USB, CD, etc.)"
    Write-Host ""
    
    try {
        # Get-PSDrive récupère tous les lecteurs PowerShell
        # -PSProvider FileSystem filtre pour ne garder que les lecteurs de fichiers
        # Cela inclut : disques durs, USB, CD-ROM, lecteurs réseau mappés
        $lecteursList = Get-PSDrive -PSProvider FileSystem | 
        Select-Object Name, 
        @{Name = "UsedGB"; Expression = { [math]::Round($_.Used / 1GB, 2) } },
        @{Name = "FreeGB"; Expression = { [math]::Round($_.Free / 1GB, 2) } },
        Root
        
        # Affichage formaté en tableau
        $lecteursList | Format-Table -AutoSize
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $lecteursText = $lecteursList | Out-String
            infoFile $env:COMPUTERNAME "Lecteurs montés:" $lecteursText
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des lecteurs montés"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}


#==============================================================
# FONCTION : LISTE UTILISATEURS LOCAUX
#==============================================================
function fonction_liste_utilisateurs_windows {
    
    Write-Host ""
    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    Write-Host "► LISTE DES UTILISATEURS LOCAUX"
    Write-Host ""
    
    try {
        # Get-LocalUser récupère tous les utilisateurs locaux
        # Where-Object filtre pour ne garder que les comptes activés
        # Select-Object sélectionne les propriétés à afficher
        $userList = Get-LocalUser | Where-Object { $_.Enabled -eq $true } | 
        Select-Object Name, Enabled, LastLogon, Description
        
        # Affichage formaté en tableau
        $userList | Format-Table -AutoSize
        
        # Compte du nombre d'utilisateurs actifs
        $nombreUtilisateurs = ($userList | Measure-Object).Count
        Write-Host "► Nombre d'utilisateurs actifs : $nombreUtilisateurs"
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $usersText = $userList | Out-String
            infoFile $env:COMPUTERNAME "Liste d'utilisateurs:" $usersText
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des utilisateurs locaux"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}



#==============================================================
# FONCTION : 5 DERNIERS LOGINS
#==============================================================
function fonction_5_derniers_logins_windows {
    
    Write-Host ""
    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    Write-Host "► LES 5 DERNIERS LOGINS"
    Write-Host ""
    
    try {
        # Get-EventLog récupère les événements du journal de sécurité Windows
        # -LogName Security : journal de sécurité
        # -InstanceId 4624 : ID d'événement pour les connexions réussies
        # -Newest 5 : limite aux 5 événements les plus récents
        # Note : Nécessite des privilèges administrateur
        $loginsList = Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 -ErrorAction Stop | 
        Select-Object TimeGenerated, 
        @{Name = "Utilisateur"; Expression = {
                # Extraction du nom d'utilisateur depuis le message
                if ($_.Message -match "Account Name:\s+(\S+)") { $matches[1] } else { "N/A" }
            }
        },
        @{Name = "Domaine"; Expression = {
                # Extraction du domaine depuis le message
                if ($_.Message -match "Account Domain:\s+(\S+)") { $matches[1] } else { "N/A" }
            }
        }
        
        # Affichage formaté en tableau
        $loginsList | Format-Table -AutoSize
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $loginsText = $loginsList | Out-String
            infoFile $env:COMPUTERNAME "5 derniers logins:" $loginsText
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des derniers logins"
        Write-Host "► Détails : $($_.Exception.Message)"
        Write-Host "► Note : Cette fonction nécessite des privilèges administrateur"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}


#==============================================================
# FONCTION : INFORMATIONS RÉSEAU (IP, MASQUE, PASSERELLE)
#==============================================================
function fonction_infos_reseau_windows {
    
    Write-Host ""
    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    Write-Host "► INFORMATIONS RÉSEAU"
    Write-Host ""
    
    try {
        Write-Host "► Adresse IP et masque de sous-réseau :"
        Write-Host ""
        
        # Get-NetIPAddress récupère les configurations IP
        # Where-Object filtre :
        #   - AddressFamily -eq 'IPv4' : uniquement les adresses IPv4
        #   - InterfaceAlias -ne 'Loopback*' : exclut l'interface de loopback
        # Select-Object sélectionne les propriétés à afficher
        $ipMasque = Get-NetIPAddress | Where-Object { 
            $_.AddressFamily -eq 'IPv4' -and 
            $_.InterfaceAlias -notlike 'Loopback*' 
        } | Select-Object InterfaceAlias, IPAddress, PrefixLength
        
        # Affichage formaté
        $ipMasque | Format-Table -AutoSize
        
        Write-Host ""
        Write-Host "► Passerelle par défaut :"
        Write-Host ""
        
        # Get-NetRoute récupère les routes réseau
        # Where-Object filtre pour la route par défaut (0.0.0.0/0)
        # NextHop contient l'adresse de la passerelle
        $passerelle = Get-NetRoute | Where-Object { 
            $_.DestinationPrefix -eq '0.0.0.0/0' 
        } | Select-Object InterfaceAlias, NextHop
        
        # Affichage formaté
        $passerelle | Format-Table -AutoSize
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $ipText = $ipMasque | Out-String
            $passerelleText = $passerelle | Out-String
            infoFile $env:COMPUTERNAME "Adresse IP et masque:" $ipText
            infoFile $env:COMPUTERNAME "Passerelle par défaut:" $passerelleText
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des informations réseau"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}


#==============================================================
# FONCTION : VERSION DU SYSTÈME D'EXPLOITATION
#==============================================================
function fonction_version_os_windows {
    
    Write-Host ""
    Write-Host "► VERSION DU SYSTÈME D'EXPLOITATION"
    Write-Host ""
    
    try {
        # Get-ComputerInfo récupère des informations détaillées sur l'ordinateur
        # Select-Object sélectionne les propriétés liées au système d'exploitation
        $versionOS = Get-ComputerInfo | Select-Object `
        WindowsProductName,     # Nom du produit 
        WindowsVersion,         # Version 
        OsVersion,              # Version complète
        OsBuildNumber,          # Numéro de build
        WindowsEditionId        # Édition 
        
        # Affichage formaté
        Write-Host "Nom du produit : $($versionOS.WindowsProductName)"
        Write-Host "Édition        : $($versionOS.WindowsEditionId)"
        Write-Host "Version        : $($versionOS.WindowsVersion)"
        Write-Host "Build          : $($versionOS.OsBuildNumber)"
        Write-Host "Version OS     : $($versionOS.OsVersion)"
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            $osText = $versionOS | Out-String
            infoFile $env:COMPUTERNAME "Version OS:" $osText
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération de la version OS"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}


#==============================================================
# FONCTION : MISES À JOUR CRITIQUES
#==============================================================
function fonction_mises_a_jour_windows {
    
    Write-Host ""
    logEvent "DEMANDE_MISES_A_JOUR"
    Write-Host "► MISES À JOUR CRITIQUES MANQUANTES"
    Write-Host ""
    
    try {
        # Note : Cette fonction nécessite le module PSWindowsUpdate
        # Installation : On peut l'intaller avec cette command ( Install-Module PSWindowsUpdate -Force )
        
        # Vérification si le module est disponible
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            
            Write-Host "► Recherche des mises à jour de sécurité..."
            Write-Host ""
            
            # Import du module
            Import-Module PSWindowsUpdate -ErrorAction Stop
            
            # Get-WindowsUpdate récupère les mises à jour disponibles
            # -Category filtre par catégorie (mises à jour de sécurité et critiques)
            $majList = Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates' -ErrorAction Stop
            
            # Affichage des mises à jour
            if ($majList) {
                $majList | Select-Object Title, KB, Size | Format-Table -AutoSize
                
                $updateCount = ($majList | Measure-Object).Count
                Write-Host ""
                Write-Host "► $updateCount mise(s) à jour de sécurité disponible(s)" -ForegroundColor Yellow
            }
            else {
                Write-Host "► Aucune mise à jour de sécurité en attente" -ForegroundColor Green
            }
            
            # Enregistrement dans le fichier d'informations
            if (Get-Command infoFile -ErrorAction SilentlyContinue) {
                $majText = $majList | Out-String
                infoFile $env:COMPUTERNAME "Mises à jour de sécurité:" $majText
            }
        }
        else {
            # Module PSWindowsUpdate non installé
            Write-Host "► Le module PSWindowsUpdate n'est pas installé" -ForegroundColor Yellow
            Write-Host "► Pour installer : Install-Module PSWindowsUpdate -Force"
            Write-Host ""
            Write-Host "► Utilisation de la méthode alternative (Windows Update COM)..."
            Write-Host ""
            
            # Méthode alternative utilisant l'objet COM Windows Update
            $updateSession = New-Object -ComObject Microsoft.Update.Session
            $updateSearcher = $updateSession.CreateUpdateSearcher()
            
            Write-Host "► Recherche en cours..."
            # Recherche des mises à jour non installées
            $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software'")
            
            if ($searchResult.Updates.Count -gt 0) {
                Write-Host ""
                Write-Host "► Mises à jour disponibles :"
                
                # Parcours et affichage des mises à jour
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
        Write-Host "► Détails : $($_.Exception.Message)"
        Write-Host ""
        Write-Host "► Conseil : Vérifiez manuellement via Windows Update"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}


#==============================================================
# FONCTION : MARQUE ET MODÈLE DE L'ORDINATEUR
#==============================================================
function fonction_marque_modele_windows {
    
    Write-Host ""
    logEvent "DEMANDE_MARQUE_MODELE"
    Write-Host "► MARQUE / MODÈLE DE L'ORDINATEUR"
    Write-Host ""
    
    try {
        # Get-WmiObject (ou Get-CimInstance) récupère les informations WMI
        # Win32_ComputerSystem contient les infos système générales
        
        Write-Host "► Fabricant :"
        # Récupération du fabricant
        $fabricant = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer
        Write-Host "  $fabricant"
        Write-Host ""
        
        Write-Host "► Modèle :"
        # Récupération du modèle
        $modele = (Get-CimInstance -ClassName Win32_ComputerSystem).Model
        Write-Host "  $modele"
        Write-Host ""
        
        Write-Host "► Version :"
        # Win32_ComputerSystemProduct contient des infos supplémentaires sur le produit
        $version = (Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version
        Write-Host "  $version"
        Write-Host ""
        
        Write-Host "► Numéro de série :"
        # Récupération du numéro de série (utile pour l'inventaire)
        $serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
        Write-Host "  $serial"
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            infoFile $env:COMPUTERNAME "Fabricant:" $fabricant
            infoFile $env:COMPUTERNAME "Modèle:" $modele
            infoFile $env:COMPUTERNAME "Version:" $version
            infoFile $env:COMPUTERNAME "Numéro de série:" $serial
        }
    }
    catch {
        Write-Host "► Erreur lors de la récupération des informations matérielles"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}


#==============================================================
# FONCTION : VÉRIFIER UAC (CONTRÔLE DE COMPTE UTILISATEUR)
#==============================================================
function fonction_verifier_uac_windows {
    
    Write-Host ""
    logEvent "DEMANDE_VERIFICATION_UAC"
    Write-Host "► STATUT DU CONTRÔLE DE COMPTE UTILISATEUR (UAC)"
    Write-Host ""
    
    try {
        # Lecture de la valeur UAC dans le registre Windows
        # Get-ItemProperty lit une clé de registre
        # Le chemin HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
        # contient les paramètres de stratégie système
        # EnableLUA : valeur qui active/désactive UAC
        #   1 = UAC activé (sécurisé)
        #   0 = UAC désactivé (non sécurisé)
        
        $uacValue = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA).EnableLUA
        
        # Vérification de la valeur et affichage du statut
        if ($uacValue -eq 1) {
            Write-Host "► UAC est ACTIVÉ (Sécurisé)" -ForegroundColor Green
            Write-Host ""
            Write-Host "  Le contrôle de compte utilisateur protège votre système en"
            Write-Host "  demandant une confirmation pour les actions administratives."
            $uacStatus = "UAC est ACTIVÉ (Sécurisé)"
        }
        else {
            Write-Host "► UAC est DÉSACTIVÉ (Non sécurisé)" -ForegroundColor Red
            Write-Host ""
            Write-Host "  ⚠ ATTENTION : Le contrôle de compte utilisateur est désactivé."
            Write-Host "  Votre système est plus vulnérable aux programmes malveillants."
            Write-Host ""
            Write-Host "  Pour activer UAC :"
            Write-Host "  1. Ouvrir le Panneau de configuration"
            Write-Host "  2. Comptes d'utilisateurs > Modifier les paramètres de contrôle de compte d'utilisateur"
            Write-Host "  3. Déplacer le curseur vers le haut"
            $uacStatus = "UAC est DÉSACTIVÉ (Non sécurisé)"
        }
        
        # Enregistrement dans le fichier d'informations
        if (Get-Command infoFile -ErrorAction SilentlyContinue) {
            infoFile $env:COMPUTERNAME "Statut UAC:" $uacStatus
        }
    }
    catch {
        Write-Host "► Erreur lors de la vérification du statut UAC"
        Write-Host "► Détails : $($_.Exception.Message)"
    }
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    # Retour au menu d'informations
    informationMainMenu
}
