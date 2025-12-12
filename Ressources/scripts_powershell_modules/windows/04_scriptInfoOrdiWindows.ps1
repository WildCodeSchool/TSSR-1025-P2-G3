# Script Informations Système Windows en Powershell


# Liste des fonctions :
# 1. Liste des Utilisateurs
# 2. Afficher les 5 derniers logins
# 3. Afficher Adresse IP, Masque, Passerelle
# 4. Informations disques durs
# 5. Nombre de disque
# 6. Paritions
# 7. Lecteurs montés
# 8. Version de l'OS
# 9. Mise à jour critiques manquantes
# 10. Afficher Marque/Modèle de l'ordinateur
# 11. Status UAC


#==============================================================
# 1 - LISTE DES UTILISATEURS
#==============================================================
function liste_utilisateurs_windows {

    logEvent "DEMANDE_LISTE_UTILISATEURS_LOCAUX"
    Write-Host "► Liste des utilisateurs locaux "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 2 - AFFICHER LES 5 DERNIERS LOGINS
#==============================================================
function 5_derniers_logins_windows {

    logEvent "DEMANDE_5_DERNIERS_LOGINS"
    Write-Host "► Les 5 derniers logins "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 3 - AFFICHER ADRESSE IP, MASQUE, PASSERELLE
#==============================================================
function infos_reseau_windows {

    logEvent "DEMANDE_INFORMATIONS_RESEAU"
    Write-Host "► Adresse IP et masque "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Passerelle par défaut "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}


#==============================================================
# 4 - MENU GESTION DISQUES
#==============================================================
function gestion_disques_menu_windows {

    logEvent "MENU_GESTION_DES_DISQUES"
    
    while ($true) {

        Write-Host ""
        Write-Host "╭──────────────────────────────────────────────────╮"
        Write-Host "│               GESTION DES DISQUES                │"
        Write-Host "├──────────────────────────────────────────────────┤"
        Write-Host "│                                                  │"
        Write-Host "│  1. Nombre de disque durs                        │"
        Write-Host "│  2. Afficher les partitions                      │"
        Write-Host "│  3. Afficher les lecteurs montés                 │"
        Write-Host "│  4. Retour au menu précédent                     │"
        Write-Host "│                                                  │"
        Write-Host "╰──────────────────────────────────────────────────╯"
        Write-Host ""
        
        $repertoireMainMenu = Read-Host "► Choisissez une option "

        switch ($repertoireMainMenu) {

            1 {
                logEvent "SELECTION_NOMBRE_DISQUES"
                nombre_disques_windows
            }

            2 {
                logEvent "SELECTION_PARTITIONS"
                partitions_windows
            }

            3 {
                logEvent "SELECTION_LECTEURS_MONTES"
                lecteurs_montes_windows
            }    

            4 {
                logEvent "SÉLECTION_RETOUR_AU_MENU_PRÉCÉDENT"
                Write-Host "Retour au menu précédent"
                computerMainMenu
            }    

            default {
                logEvent "OPTION_INVALIDE"
                Write-Host "► Entrée invalide !"

            }
        }
    }
}



#==============================================================
# 5 - NOMBRE DISQUES DURS
#==============================================================
function nombre_disques_windows {

    logEvent "DEMANDE_NOMBRE_DISQUES"
    Write-Host "► Nombre de disques  "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 6 - PARTITIONS
#==============================================================
function partitions_windows {

    logEvent "DEMANDE_LISTE_PARTITIONS"
    Write-Host "► Partitions Nom, FS, Taille "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Nombre de partitions "

    ##########################  FONCTION A FAIRE ICI ##########################


    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 7 - LECTEURS MONTES
#==============================================================
function lecteurs_montes_windows {

    logEvent "DEMANDE_LECTEURS_MONTES"
    Write-Host "► Lecteurs montés disque, USB, CD, etc.: "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 8 - VERSION DE L'OS
#==============================================================
function version_os_windows {

    logEvent "DEMANDE_VERSION_OS"
    Write-Host "► Version de l'OS "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 9 - MISE A JOUR CRITIQUES MANQUANTES
#==============================================================
function mises_a_jour_windows {

    logEvent "DEMANDE_MISES_A_JOUR"
    Write-Host "► Mises à jour critiques manquantes "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 10 - AFFICHER MARQUE ET MODELE
#==============================================================
function marque_modele_windows {

    logEvent "DEMANDE_MARQUE_MODELE"
    Write-Host "► Marque / Modèle de l'ordinateur "

    Write-Host "► Fabricant"
    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Modèle"
    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Version"
    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""
}



#==============================================================
# 11 - STATUS UAC
#==============================================================
function status_uac_windows {

    logEvent "DEMANDE_STATUS_UAC"
    Write-Host "► Statut du contrôle de compte utilisateur (UAC) "

    ##########################  FONCTION A FAIRE ICI ##########################

    Write-Host "► Appuyez sur ENTRÉE pour revenir au menu précédent..."
    Read-Host ""

}
