#!/bin/bash

##################################### Menu Gestion Disques ####################################

# Menu principal de gestion des disques
gestion_disques_menu_windows() {

    logEvent "MENU_GESTION_DISQUES"

    while true; do

        echo ""
        echo "╭──────────────────────────────────────────╮"
        echo "|             Gestion Des Disques          │"
        echo "├──────────────────────────────────────────┤"
        echo "│                                          │"
        echo "│  1. Nombre de disques                    │"
        echo "│  2. Afficher les partitions              │"
        echo "│  3. Afficher les lecteurs montés         │"
        echo "│  4. Retour au menu précédent             │"
        echo "│                                          │"
        echo "╰──────────────────────────────────────────╯"
        echo ""

        read -p "► Choisissez une option : " choix

        logEvent " Choisie ${choix^^} "

        case "$choix" in

        1)
            # Appel de la fonction pour compter les disques
            logEvent "SELECTION_NOMBRE_DISQUES"
            fonction_nombre_disques_windows
            ;;

        2)
            # Appel de la fonction pour lister les partitions
            logEvent "SELECTION_PARTITIONS"
            fonction_partitions_windows
            ;;

        3)
            # Appel de la fonction pour afficher les lecteurs montés
            logEvent "SELECTION_LECTEURS_MONTES"
            fonction_lecteurs_montes_windows
            ;;

        4)
            # Retour au menu principal
            logEvent "RETOUR_MENU_PRECEDENT"
            echo "► Retour au menu précédent"
            informationMainMenu
            ;;

        *)
            # Gestion des choix invalides
            logEvent "OPTION_INVALIDE_GESTION_DISQUES"
            echo " ► Option invalide. "
            ;;
        esac

    done
}

#################################### Fonction Nombre de disques ##########################################

# Compte et affiche le nombre de disques physiques
fonction_nombre_disques_windows() {
    logEvent "DEMANDE_NOMBRE_DISQUES"
    echo " ► Nombre de disques : "
    
    # Liste les disques et compte leur nombre (avec affichage)
    nombreDisques=$(powershell_command "(Get-Disk).Count | Tee-Object -FilePath /dev/tty")
    
    infoFile "$HOSTNAME" "Nombre de disques:" "$nombreDisques"
    
    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    gestion_disques_menu_windows
}
#################################### Fonction Partitions ###################################################

# Affiche les partitions avec leurs détails et leur nombre total
fonction_partitions_windows() {

    logEvent "DEMANDE_LISTE_PARTITIONS"
    echo " ► Partitions Nom, FS, Taille : "

    # Affiche les partitions avec nom, type de système de fichiers et taille
    partitionsList=$(powershell_command "Get-Volume | Where-Object DriveLetter | Select-Object DriveLetter, FileSystemType, Size" | tee /dev/tty)

    infoFile $HOSTNAME "Liste de partitions:" $partitionsList

    nombrePartitions=$(powershell_command "(Get-Partition | Measure-Object).Count" | tee /dev/tty)

    echo " ► Nombre de partitions : "
    # Compte le nombre total de partitions
    
    infoFile "$HOSTNAME" "Nombre de partitions:" "$nombrePartitions"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    gestion_disques_menu_windows
}

#################################### Fonction Lecteurs montés ############################################

# Affiche tous les lecteurs physiques actuellement montés
fonction_lecteurs_montes_windows() {

    logEvent "DEMANDE_LECTEURS_MONTES"
    echo "► Lecteurs montés disque, USB, CD, etc.: "

    # Affiche les lecteurs montés avec leur espace disque
  lecteursList=$(powershell_command "Get-PSDrive -PSProvider FileSystem | Format-Table" | tee /dev/tty)

    infoFile "$HOSTNAME" "Lecteurs montés:" "$lecteursList"
    
    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    gestion_disques_menu_windows

}

#################################### Fonction liste utilisateurs locaux #################################

# Liste les utilisateurs locaux (non système)
fonction_liste_utilisateurs_windows() {

    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    echo "► Liste des utilisateurs locaux :"

    # Affiche les utilisateurs avec UID >= 1000
    userList=$(powershell_command "Get-LocalUser | Where-Object { \$_.Enabled -eq \$true } | Select-Object Name, Enabled, LastLogon | Format-Table" | tee /dev/tty)

    infoFile "$HOSTNAME" "Liste d'utilisateurs:" "$userList"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction 5 derniers logins #######################################

# Affiche les 5 dernières connexions utilisateurs
fonction_5_derniers_logins_windows() {

    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    echo "► Les 5 derniers logins :"

    # Affiche l'historique des 5 dernières connexions
    loginsList=$(powershell_command "Get-EventLog -LogName Security -InstanceId 4624 -Newest 5 | Select-Object TimeGenerated, Message | Format-Table" | tee /dev/tty)

    infoFile "$HOSTNAME" "5 derniers logins:" "$loginsList"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction IP, masque, passerelle ####################################

# Affiche les informations réseau (IP, masque et passerelle)
fonction_infos_reseau_windows() {

    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    echo "► Adresse IP et masque "

    # Affiche l'adresse IP et le masque
    ipMasque=$(powershell_command "(Get-NetIPAddress | Where-Object { \$_.AddressFamily -eq 'IPv4' -and \$_.InterfaceAlias -ne 'lo' } | Select-Object IPAddress, PrefixLength)" | tee /dev/tty)


    echo "► Passerelle par défaut "

    # Affiche la passerelle par défaut
    passerelle=$(powershell_command "(Get-NetRoute | Where-Object { \$_.DestinationPrefix -eq '0.0.0.0/0' } | Select-Object NextHop)" | tee /dev/tty)

    infoFile "$HOSTNAME" "Adresse IP et masque:" "$ipMasque"
    infoFile "$HOSTNAME" "Passerelle par défaut:" "$passerelle"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction : Version OS ####################################

# Affiche la version du système d'exploitation
fonction_version_os_windows() {

    logEvent "DEMANDE_VERSION_OS"
    echo "► Version de l'OS :"

    # Affiche les informations de version (distribution, release, codename)
    versionOS=$(powershell_command "(Get-ComputerInfo | Select-Object OsName, OsVersion)" | tee /dev/tty)

    infoFile "$HOSTNAME" "Version OS:" "$versionOS"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction : Mises à jour critiques ####################################

# Liste les mises à jour disponibles
fonction_mises_a_jour_windows() {
    
    logEvent "DEMANDE_MISES_A_JOUR"
    echo "► Mises à jour critiques manquantes: "
    
    majList=$(powershell_command "$updates = Get-WindowsUpdate -Category 'Security Updates','Critical Updates'" | tee /dev/tty)
    
    infoFile "$HOSTNAME" "Mises à jour de sécurité:" "$majList"
     echo ""
        
    
    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction : Marque / Modèle ####################################

# Affiche les informations matérielles marque et modèle
fonction_marque_modele_windows() {

    logEvent "DEMANDE_MARQUE_MODELE"
    echo "► Marque / Modèle de l'ordinateur :"

    # Fabricant
    echo "► Fabricant:"
    fabricant=$(powershell_command "(Get-WmiObject -Class Win32_ComputerSystem | Select-Object Manufacturer)" | tee /dev/tty)

    # Nom du modèle
    echo "► Modèle:"
    modele=$(powershell_command "(Get-WmiObject -Class Win32_ComputerSystem | Select-Object Model)" | tee /dev/tty)

    # Version
    echo "► Version:"
    version=$(powershell_command "(Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object Version)" | tee /dev/tty)

    infoFile "$HOSTNAME" "Fabricant:" "$fabricant"
    infoFile "$HOSTNAME" "Modèle:" "$modele"
    infoFile "$HOSTNAME" "Version:" "$version"

    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}

#################################### Fonction : Vérifier UAC ####################################

fonction_verifier_uac_windows() {
    logEvent "DEMANDE_VERIFICATION_UAC"
    echo "► Statut du contrôle de compte utilisateur (UAC) :"
    
    uacStatus=$(powershell_command "\$uac = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System').EnableLUA; if (\$uac -eq 1) { Write-Output 'UAC est ACTIVÉ (Sécurisé)' } else { Write-Output 'UAC est DÉSACTIVÉ (Non sécurisé)' }" | tee /dev/tty)
    
    infoFile "$HOSTNAME" "Statut UAC:" "$uacStatus"
    echo ""
    read -p "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    informationMainMenu
}
