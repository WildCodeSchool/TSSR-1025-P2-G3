# Script Informations Système Linux en Powershell
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
function gestion_disques_menu_linux {
    
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
                # Appel de la fonction nombre_disques_linux
                nombre_disques_linux 
            }
            '2' { 
                logEvent "SELECTION_PARTITIONS"
                # Appel de la fonction partitions_linux
                partitions_linux 
            }
            '3' { 
                logEvent "SELECTION_LECTEURS_MONTES"
                # Appel de la fonction lecteurs_montes_linux
                lecteurs_montes_linux 
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
function nombre_disques_linux {
    
    logEvent "DEMANDE_NOMBRE_DISQUES"
    
    Write-Host ""
    Write-Host "► NOMBRE DE DISQUES"
    Write-Host ""

    $disks = bash_command "lsblk -d -n -o NAME,SIZE,TYPE | grep disk"

    $nombreDisques = bash_command "lsblk -d -n -o NAME,TYPE | grep disk | wc -l"
    
    Write-Host "► Nombre de disques : $nombreDisques"
    Write-Host ""
    
    bash_command "lsblk -d -o NAME,SIZE,TYPE,MODEL | grep disk"
    
    infoFile $env:COMPUTERNAME "Nombre de disques:" $nombreDisques

    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 03 - PARTITIONS
#==============================================================
function partitions_linux {
    
    logEvent "DEMANDE_LISTE_PARTITIONS"
    
    Write-Host ""
    Write-Host "► PARTITIONS"
    Write-Host ""
    
    $partitionsList = bash_command "df -h --output=source,fstype,size,used,avail,target | grep -v tmpfs | grep -v devtmpfs"
    
    Write-Host $partitionsList
    
    $nombrePartitions = bash_command "lsblk -n -o TYPE | grep part | wc -l"
    Write-Host ""
    Write-Host "► Nombre total de partitions : $nombrePartitions"
    

    infoFile $env:COMPUTERNAME "Liste de partitions:" $partitionsList
    infoFile $env:COMPUTERNAME "Nombre de partitions:" $nombrePartitions
 
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 04 - LECTEURS MONTÉS
#==============================================================
function lecteurs_montes_linux {
    
    logEvent "DEMANDE_LECTEURS_MONTES"
    
    Write-Host ""
    Write-Host "► LECTEURS MONTÉS"
    Write-Host ""
    
    $lecteursList = bash_command "mount | grep -E '^/dev/' | awk '{print \$1, \$3, \$5}'"
    
    Write-Host $lecteursList
    Write-Host ""
    
    bash_command "df -h | grep -E '^/dev/'"
 
    infoFile $env:COMPUTERNAME "Lecteurs montés:" $lecteursList
    
    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
}
#endregion


#==============================================================
#region 05 - LISTE UTILISATEURS LOCAUX
#==============================================================
function liste_utilisateurs_linux {
    
    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    
    Write-Host ""
    Write-Host "► LISTE DES UTILISATEURS LOCAUX"
    Write-Host ""
    
    $userList = bash_command "awk -F: '\$3 >= 1000 && \$1 != \"nobody\" {print \$1, \$3, \$5}' /etc/passwd"
    
    Write-Host $userList
    
    $nombreUtilisateurs = bash_command "awk -F: '\$3 >= 1000 && \$1 != \"nobody\" {print \$1}' /etc/passwd | wc -l"
    Write-Host ""
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
function 5_derniers_logins_linux {
    
    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    
    Write-Host ""
    Write-Host "► LES 5 DERNIERS LOGINS"
    Write-Host ""
    
    try {
    
        $loginsList = bash_command "last -n 5 -w"
        
        Write-Host $loginsList
        
        infoFile $env:COMPUTERNAME "5 derniers logins:" $loginsList

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
function infos_reseau_linux {
    
    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    
    Write-Host ""
    Write-Host "► INFORMATIONS RÉSEAU"
    Write-Host ""
    
    Write-Host "► Adresse IP et masque :"
    Write-Host ""
    
    $ipMasque = bash_command "ip -4 addr show | grep -v '127.0.0.1' | grep inet"
    
    Write-Host $ipMasque
    
    Write-Host ""
    Write-Host "► Passerelle par défaut :"
    Write-Host ""
    
    $passerelle = bash_command "ip route | grep default"

    Write-Host $passerelle
    
    infoFile $env:COMPUTERNAME "Adresse IP et masque:" $ipMasque
    infoFile $env:COMPUTERNAME "Passerelle par défaut:" $passerelle

    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion


#==============================================================
#region 08 - VERSION DU SYSTÈME
#==============================================================
function version_os_linux {
    
    logEvent "DEMANDE_VERSION_OS"
    
    Write-Host ""
    Write-Host "► VERSION DU SYSTÈME"
    Write-Host ""
    
    $osName = bash_command "cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"'"
    $osVersion = bash_command "cat /etc/os-release | grep VERSION_ID | cut -d'=' -f2 | tr -d '\"'"
    $kernelVersion = bash_command "uname -r"
    $architecture = bash_command "uname -m"
    
    Write-Host "Nom du système : $osName"
    Write-Host "Version        : $osVersion"
    Write-Host "Kernel         : $kernelVersion"
    Write-Host "Architecture   : $architecture"

    infoFile $env:COMPUTERNAME "Version OS:" "$osName - $osVersion - Kernel: $kernelVersion"

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
        Write-Host "► Recherche des mises à jour..."
        Write-Host ""
        
        ssh_command "Import-Module PSWindowsUpdate"
        
        $majList = ssh_command "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates'"
        
        if ($majList) {

            Write-Host $majList
            
            $updateCount = (ssh_command "Get-WindowsUpdate -Category 'Security Updates', 'Critical Updates' | Measure-Object").Count
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
function marque_modele_linux {
    
    logEvent "DEMANDE_MARQUE_MODELE"
    
    Write-Host ""
    Write-Host "► MARQUE / MODÈLE"
    Write-Host ""
    
    # Je récupère le fabricant
    $fabricant = bash_sudo_command "dmidecode -s system-manufacturer"
    Write-Host "► Fabricant : $fabricant"
    
    # Je récupère le modèle
    $modele = bash_sudo_command "dmidecode -s system-product-name"
    Write-Host "► Modèle    : $modele"
    
    # Je récupère la version
    $version = bash_sudo_command "dmidecode -s system-version"
    Write-Host "► Version   : $version"
    
    # Je récupère le numéro de série
    $serial = bash_sudo_command "dmidecode -s system-serial-number"
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
function uac_info_linux {
    Write-Host " Pas de UAC sous Linux " -ForegroundColor Yellow

    Write-Host ""
    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    $null = Read-Host
    
    informationMainMenu
}
#endregion

