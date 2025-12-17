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
    
    Write-Host "Nombre de disques"
    
    $output = command_ssh "Get-Disk"
    
    # Filtre les lignes vides et les séparateurs (----)
    $nombreDisques = ($output -split "`n" | Where-Object { 
            $_ -match '^\d+\s+' 
        }).Count
    
    Write-Host "► Nombre de disques : $nombreDisques"

    infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques
    infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques
    
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    gestion_disques_menu_windows
}
#endregion


#==============================================================
#region 03 - PARTITIONS
#==============================================================

function partitions_windows {
    logEvent "DEMANDE_LISTE_PARTITIONS"
    Write-Host "► Partitions"
    
    $partitions = command_ssh "Get-Volume | FT -Auto"
    $partitions -split "`n" | ForEach-Object {
        Write-Host $_
    }
    Write-Host ""
    
    $nombre = command_ssh "(Get-Partition).Count"
    Write-Host "► Nombre : $nombre"
    Write-Host ""
    
    infoFile $env:COMPUTERNAME "Partitions:" $partitions
    infoFile $env:COMPUTERNAME "Nombre:" $nombre
    
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    gestion_disques_menu_windows
}
#endregion


#==============================================================
#region 04 - LECTEURS MONTÉS
#==============================================================
function lecteurs_montes_windows {
    logEvent "DEMANDE_LECTEURS_MONTES"
    
    Write-Host "Lecteurs montés"
    
    $lecteurs = command_ssh "Get-PSDrive -PSProvider FileSystem | Where Used | FT Name, Used, Free -Auto"
    $lecteurs -split "`n" | ForEach-Object {
        Write-Host $_
    }
    
    infoFile $env:COMPUTERNAME "Lecteurs:" $lecteurs
    
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    gestion_disques_menu_windows
}
#endregion


#==============================================================
#region 05 - LISTE UTILISATEURS LOCAUX
#==============================================================
function liste_utilisateurs_windows {
    
    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    
    Write-Host ""
    Write-Host "► Liste des utilisateurs locaux"
    Write-Host ""
    
    $userList = command_ssh "Get-LocalUser | Select-Object -ExpandProperty Name"
    
    Write-Host $userList
    
    $nombreUtilisateurs = (command_ssh "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Measure-Object").Count
    Write-Host "► Nombre d'utilisateurs actifs : $nombreUtilisateurs"
    
    infoFile $env:COMPUTERNAME "Liste d'utilisateurs:" $userList
 
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 06 - 5 DERNIERS LOGINS
#==============================================================
function cinq_derniers_logins_windows {
    
    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    Write-Host "Les 5 derniers logins"
    
    try {
        # Récupération simple des 5 derniers logins
        $logins = command_ssh "Get-EventLog Security -Newest 5 -InstanceId 4624"
        Write-Host $logins
        
        infoFile $script:remoteComputerName "5 derniers logins:" $logins 
        
    }
    catch {
        Write-Host "► Erreur : Privilèges admin requis" -ForegroundColor Red
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
    Write-Host "Informations Réseaux"
    
    # Affichage des adresses IP
    Write-Host "► Adresses IP :`n"
    $ip = command_ssh "Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress, InterfaceAlias, PrefixLength | Format-Table -AutoSize"

    $ip -split "`n" | ForEach-Object {
        Write-Host $_
    }
    # Affichage de la passerelle
    Write-Host "`n► Passerelle :`n"
    $gw = command_ssh "Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object ifIndex, DestinationPrefix, NextHop, RouteMetric | Format-Table -AutoSize"
    $gw -split "`n" | ForEach-Object {
        Write-Host $_
    }
    
    infoFile $env:COMPUTERNAME "IP:" $ip_brut
    infoFile $env:COMPUTERNAME "Passerelle:" $gw_brut
    
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
    Write-Host "► Version du système"
    Write-Host ""

    $versionOS = command_ssh "Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsVersion, OsBuildNumber, WindowsEditionId"
    
    Write-Host $versionOS
    
    infoFile $env:COMPUTERNAME "Version OS:" $versionOS
 
    
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
    Write-Host "► Mises à jour critiques"
    Write-Host ""
    
    try {
        Write-Host "► Recherche des mises à jour..."
        Write-Host ""
        
        command_ssh "Import-Module PSWindowsUpdate"
        
        $majList = command_ssh "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates'"
        
        if ($majList) {

            Write-Host $majList
            
            $updateCount = (command_ssh "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates' | Measure-Object").Count
            Write-Host ""
            Write-Host "► $updateCount mise(s) à jour disponible(s)" -ForegroundColor Yellow
        }
        else {
            Write-Host "► Aucune mise à jour en attente" -ForegroundColor Green
        }
        
    }
    catch {
        Write-Host "► Erreur lors de la vérification des mises à jour" -ForegroundColor Red
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
    Write-Host "► Marque / Modèle"
    Write-Host ""
    

    $fabricant = command_ssh "(Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer"
    Write-Host "► Fabricant : $fabricant"

    $modele = command_ssh "(Get-CimInstance -ClassName Win32_ComputerSystem).Model"
    Write-Host "► Modèle    : $modele"
    

    $version = command_ssh "(Get-CimInstance -ClassName Win32_ComputerSystemProduct).Version"
    Write-Host "► Version   : $version"
    

    $serial = command_ssh "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber"
    Write-Host "► N° série  : $serial"
    

    infoFile $env:COMPUTERNAME "Fabricant:" $fabricant
    infoFile $env:COMPUTERNAME "Modèle:" $modele
    infoFile $env:COMPUTERNAME "Version:" $version
    infoFile $env:COMPUTERNAME "Numéro de série:" $serial

    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 11 - VÉRIFIER UAC
#==============================================================
function status_uac_windows {
    
    logEvent "DEMANDE_VERIFICATION_UAC"
    
    Write-Host ""
    Write-Host "► Status UAC"
    Write-Host ""
    
    $uacValue = command_ssh "(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA).EnableLUA"
    
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
    
    infoFile $env:COMPUTERNAME "Statut UAC:" $uacStatus

    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion




















