
#!/bin/bash

#################################### Fonction liste utilisateurs locaux #################################

fonction_liste_utilisateurs() {
    #logEvent " Demande affichage liste des utilisateurs locaux "
    echo "► Liste des utilisateurs locaux"

    # Affiche uniquement juste le nom des utilisateurs réels
    awk -F':' '$3>=1000 { print $1 }' /etc/passwd


}

#################################### Fonction 5 derniers logins #######################################

fonction_5_derniers_logins() {
    #logEvent " Demande : 5 derniers logins "
    echo "► Les 5 derniers logins :"

    # Affiche les 5 dernières connexions utilisateurs
    last -n 5
}


#################################### Fonction IP, masque, passerelle ####################################

fonction_infos_reseau() {
    #logEvent " Demande : informations réseau "

    echo -e "► Adresse IP et masque :\n"

    # affiche info IP + masque
    ip -4 -o addr show | awk '$2 != "lo" {print "→ " $4}'
   #logEvent " Demande : informations réseau "
    echo -e "\n► Passerelle par défaut :\n"

    # affiche info Passerelle
    ip route | awk '/default/ {print "→ " $3}'
    
}




fonction_liste_utilisateurs

fonction_5_derniers_logins

fonction_infos_reseau