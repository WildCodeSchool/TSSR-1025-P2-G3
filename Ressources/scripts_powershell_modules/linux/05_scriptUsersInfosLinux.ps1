# Script Information Utilisateurs Linux en Powershell
# Auteur : Pierre-Jean

# Liste des fonctions :
# 1. Date dernière connexion
# 2. Date dernière modification mot de passe
# 3. Liste des sessions ouvertes


#==============================================================
# 1 - DATE DERNIERE CONNEXION
#==============================================================
function date_lastconnection_linux {

    logEvent "MENU_DERNIERE_CONNEXION"

    Write-Host ""
    Write-Host "╭──────────────────────────────────────────────────╮"
    Write-Host "│          DATE DE DERNIÈRE CONNEXION              │"
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
                bash_command 'awk -F'':'' ''$3>=1000 && $3 < 60000 { print $1 }'' /etc/passwd'
                Write-Host ""

                $userlastconnect = Read-Host "► Quel utilisateur choisissez-vous ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${userlastconnect}"

                # Vérification si l'utilisateur existe
                $userExists = bash_command "grep '^${userlastconnect}:' /etc/passwd"

                if ($userExists) {
                    Write-Host ""
                    Write-Host "► L'utilisateur ${userlastconnect} s'est connecté pour la dernière fois : "
                    
                    # Récupération de la dernière connexion via last
                    $lastconnection = bash_command "last -1 ${userlastconnect} | head -1 | awk '{print `$4, `$5, `$6, `$7}'"
                    
                    if ($lastconnection) {
                        Write-Host $lastconnection
                        infoFile "${userlastconnect}" "Dernière connexion" "${lastconnection}"
                    }
                    else {
                        Write-Host "► Aucune connexion trouvée pour cet utilisateur"
                    }
                    Write-Host ""
                    logEvent "AFFICHAGE_DE_LA_DERNIÈRE_CONNECTION_DE_L'UTILISATEUR"

                    $continueChoice = Read-Host "► Souhaitez vous choisir un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► Erreur de saisie, l'utilisateur ${userlastconnect} n'existe pas."
                    logEvent "ERREUR_DE_SAISIE,_RETOUR_AU_MENU_PRÉCÉDENT"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            date_lastconnection_linux
        }

        2 {
            logEvent "MENU_DERNIERE_CONNEXION:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_DERNIERE_CONNEXION:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            date_lastconnection_linux
        }
    }
}




#==============================================================
# 2 - DATE DERNIERE MODIFICATION MOT DE PASSE
#==============================================================
function date_lastpassmodif_linux {

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
                bash_command 'awk -F'':'' ''$3>=1000 && $3 < 60000 { print $1 }'' /etc/passwd'
                Write-Host ""

                $userlastpass = Read-Host "► Quel utilisateur choisissez-vous ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${userlastpass}"

                # Vérification si l'utilisateur existe
                $userExists = bash_command "grep '^${userlastpass}:' /etc/passwd"

                if ($userExists) {
                    Write-Host ""
                    Write-Host "► L'utilisateur ${userlastpass} a changé son mot de passe la dernière fois : "
                    
                    # Récupération via chage -l (nécessite sudo)
                    $lastpasschange = bash_sudo_command "chage -l ${userlastpass} | head -1 | awk '{print `$8, `$9, `$10}'"
                    
                    if ($lastpasschange) {
                        Write-Host $lastpasschange
                        infoFile "${userlastpass}" "À changé son mot de passe pour la dernière fois" "${lastpasschange}"
                    }
                    else {
                        Write-Host "► Information non disponible"
                    }
                    Write-Host ""
                    logEvent "AFFICHAGE_DE_LA_DATE_DU_DERNIER_CHANGEMENT_DE_MDP_DE_L'UTILISATEUR"

                    $continueChoice = Read-Host "► Souhaitez vous choisir un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► Erreur de saisie, l'utilisateur ${userlastpass} n'existe pas."
                    logEvent "ERREUR_DE_SAISIE"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            date_lastpassmodif_linux
        }

        2 {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_DATE_LAST_MODIFICATION_PASSWORD:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            date_lastpassmodif_linux
        }
    }
}



#==============================================================
# 3 - LISTE DES SESSIONS OUVERTES
#==============================================================
function list_opensessions_linux {

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
                bash_command 'awk -F'':'' ''$3>=1000 && $3 < 60000 { print $1 }'' /etc/passwd'
                Write-Host ""

                $userlastsession = Read-Host "► Quel utilisateur choisissez-vous ? "
                logEvent "ENTRÉE_D'UTILISATEUR:${userlastsession}"

                # Vérification si l'utilisateur existe
                $userExists = bash_command "grep '^${userlastsession}:' /etc/passwd"

                if ($userExists) {
                    Write-Host ""
                    Write-Host "► Voici la liste des sessions ouvertes par ${userlastsession} : "
                    
                    # Utilisation de who pour voir les sessions
                    $lastsession = bash_command "who --short | grep ${userlastsession}"
                    
                    if ($lastsession) {
                        Write-Host $lastsession
                        infoFile "${userlastsession}" "Sessions ouvertes" "${lastsession}"
                        logEvent "AFFICHAGE_DE_LA_LISTE_DES_SESSIONS_OUVERTES_PAR_L'UTILISATEUR"
                    }
                    else {
                        Write-Host "► Aucune session active trouvée pour ${userlastsession}"
                        logEvent "AUCUNE_SESSION_TROUVEE:${userlastsession}"
                    }
                    Write-Host ""

                    $continueChoice = Read-Host "► Souhaitez vous choisir un autre utilisateur ? (o/n) "
                    logEvent "CONTINUER_CONSULTATION:${continueChoice}"

                }
                else {
                    Write-Host ""
                    Write-Host "► Erreur de saisie, l'utilisateur ${userlastsession} n'existe pas."
                    logEvent "ERREUR_DE_SAISIE"

                    $continueChoice = Read-Host "► Voulez-vous réessayer ? (o/n) "
                    logEvent "REESSAYER:${continueChoice}"
                }
            }
            list_opensessions_linux
        }

        2 {
            logEvent "MENU_SESSION_OUVERTE:RETOUR_MENU_PRECEDENT"
            informationUserMainMenu
        }

        default {
            logEvent "MENU_SESSION_OUVERTE:OPTION_INVALIDE"
            Write-Host "► Entrée invalide !"
            list_opensessions_linux
        }
    }
}

