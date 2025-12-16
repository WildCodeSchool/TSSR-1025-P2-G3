# Script Information Utilisateurs Windows en Powershell


# Liste des fonctions :
# 01. Date dernière connexion
# 02. Date dernière modification mot de passe
# 03. Liste des sessions ouvertes


#==============================================================
#region 01 - DATE DERNIERE CONNEXION
#==============================================================
function date_lastconnection_windows {

    logEvent "MENU_DERNIERE_CONNEXION"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│             DATE DERNIERE CONNEXION              │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""
    
    $dateLastConnection = Read-Host "► Choisissez une option "

    switch ($dateLastConnection) {

        1 {
            logEvent "MENU_DERNIERE_CONNEXION:SAISIE_NOM_UTILISATEUR"
            
            $continueChoice = "o"

            while ($continueChoice -eq "o") {

                Write-Host ""
                Write-Host "► Voici la liste des utilisateurs : "
                $users = command_ssh "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Select-Object -ExpandProperty Name"
                $users
                Write-Host ""

                $userlastconnect = Read-Host "► Quel utilisateur choisissez-vous ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${userlastconnect}"

                # Vérification si l'utilisateur existe
                $userExists = command_ssh "if (Get-LocalUser -Name '$userlastconnect' -ErrorAction SilentlyContinue) { 'true' } else { 'false' }"

                if ($userExists -eq "true") {
                    Write-Host ""
                    Write-Host "► Dernière connexion de l'utilisateur ${userlastconnect} : "
                    Write-Host ""
                    
                    # Récupération de la dernière connexion via net user (plus fiable)
                    $lastLogon = command_ssh "net user '$userlastconnect' | Select-String 'Derni|Last logon'"
                    
                    if ($lastLogon) {
                        Write-Host $lastLogon
                    }
                    else {
                        # Essai alternatif avec Get-WmiObject
                        $lastLogonWmi = command_ssh "try { `$user = Get-WmiObject -Class Win32_UserAccount -Filter `"Name='$userlastconnect'`"; `$userSID = `$user.SID; `$profile = Get-WmiObject -Class Win32_UserProfile -Filter `"SID='`$userSID'`"; if (`$profile.LastUseTime) { [System.Management.ManagementDateTimeConverter]::ToDateTime(`$profile.LastUseTime).ToString('dd/MM/yyyy HH:mm:ss') } else { 'Jamais connecté' } } catch { 'Information non disponible' }"
                        Write-Host $lastLogonWmi
                    }
                    Write-Host ""
                    logEvent "DERNIERE_CONNEXION_AFFICHEE:${userlastconnect}"

                    $continueChoice = Read-Host "► Voulez-vous consulter un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► L'utilisateur ${userlastconnect} n'existe pas."
                    logEvent "UTILISATEUR_INEXISTANT:${userlastconnect}"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            date_lastconnection_windows
        }

        2 {
            logEvent "MENU_DERNIERE_CONNEXION:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_DERNIERE_CONNEXION:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            date_lastconnection_windows
        }
    }
}
#endregion



#==============================================================
#region 02 - DATE DERNIERE MODIFICATION MOT DE PASSE
#==============================================================
function date_lastpassmodif_windows {

    logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│  DATE DE DERNIÈRE MODIFICATION DE MOT DE PASSE   │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $dateLastPassModif = Read-Host "► Choisissez une option "

    switch ($dateLastPassModif) {

        1 {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:SAISIE_NOM_UTILISATEUR"

            $continueChoice = "o"

            while ($continueChoice -eq "o") {

                Write-Host ""
                Write-Host "► Voici la liste des utilisateurs : "
                $users = command_ssh "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Select-Object -ExpandProperty Name"
                $users
                Write-Host ""

                $userlastpass = Read-Host "► Quel utilisateur choisissez-vous ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${userlastpass}"

                # Vérification si l'utilisateur existe
                $userExists = command_ssh "if (Get-LocalUser -Name '$userlastpass' -ErrorAction SilentlyContinue) { 'true' } else { 'false' }"

                if ($userExists -eq "true") {
                    Write-Host ""
                    Write-Host "► Dernière modification du mot de passe de ${userlastpass} : "
                    Write-Host ""
                    
                    # Récupération via net user (plus fiable pour l'affichage)
                    $passLastSet = command_ssh "net user '$userlastpass' | Select-String 'Mot de passe modifi|Password last set'"
                    
                    if ($passLastSet) {
                        Write-Host $passLastSet
                    }
                    else {
                        # Méthode alternative avec Get-LocalUser formaté en texte
                        $passLastSetAlt = command_ssh "(Get-LocalUser -Name '$userlastpass').PasswordLastSet.ToString('dd/MM/yyyy HH:mm:ss')"
                        if ($passLastSetAlt) {
                            Write-Host "Date : $passLastSetAlt"
                        }
                        else {
                            Write-Host "► Information non disponible"
                        }
                    }
                    Write-Host ""
                    logEvent "DATE_MODIFICATION_MDP_AFFICHEE:${userlastpass}"

                    $continueChoice = Read-Host "► Voulez-vous consulter un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► L'utilisateur ${userlastpass} n'existe pas."
                    logEvent "UTILISATEUR_INEXISTANT:${userlastpass}"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            date_lastpassmodif_windows
        }

        2 {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            date_lastpassmodif_windows
        }
    }
}
#endregion


#==============================================================
#region 03 - LISTE DES SESSIONS OUVERTES
#==============================================================
function list_opensessions_windows {

    logEvent "MENU_SESSION_OUVERTE"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│  LISTE DES SESSIONS OUVERTES PAR L'UTILISATEUR   │"
    Write-Host "├──────────────────────────────────────────────────┤"
    Write-Host "│                                                  │"
    Write-Host "│  1. Saisir un nom d'utilisateur                  │"
    Write-Host "│  2. Retour au menu précédent                     │"
    Write-Host "│                                                  │"
    Write-Host "╰──────────────────────────────────────────────────╯"
    Write-Host ""

    $openSession = Read-Host "► Choisissez une option "

    switch ($openSession) {

        1 {
            logEvent "MENU_SESSION_OUVERTE:SAISIE_NOM_UTILISATEUR"

            $continueChoice = "o"

            while ($continueChoice -eq "o") {

                Write-Host ""
                Write-Host "► Voici la liste des utilisateurs : "
                $users = command_ssh "Get-LocalUser | Where-Object { `$_.Enabled -eq `$true } | Select-Object -ExpandProperty Name"
                $users
                Write-Host ""

                $usersession = Read-Host "► Quel utilisateur souhaitez-vous consulter ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${usersession}"

                # Vérification si l'utilisateur existe
                $userExists = command_ssh "if (Get-LocalUser -Name '$usersession' -ErrorAction SilentlyContinue) { 'true' } else { 'false' }"

                if ($userExists -eq "true") {
                    Write-Host ""
                    Write-Host "► Sessions de l'utilisateur ${usersession} : "
                    
                    # Utilisation de query user pour voir les sessions (fonctionne sur Windows)
                    $sessions = command_ssh "query user $usersession 2>&1"
                    
                    if ($sessions -match "Aucun utilisateur" -or $sessions -match "No User exists") {
                        Write-Host "► Aucune session active trouvée pour ${usersession}"
                        logEvent "AUCUNE_SESSION_TROUVEE:${usersession}"
                    }
                    else {
                        $sessions
                        logEvent "SESSIONS_AFFICHEES:${usersession}"
                    }
                    Write-Host ""

                    $continueChoice = Read-Host "► Voulez-vous consulter un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► L'utilisateur ${usersession} n'existe pas."
                    logEvent "UTILISATEUR_INEXISTANT:${usersession}"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            list_opensessions_windows
        }

        2 {
            logEvent "MENU_SESSION_OUVERTE:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_SESSION_OUVERTE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            list_opensessions_windows
        }
    }
}
#endregion

