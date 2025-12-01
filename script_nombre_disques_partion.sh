
#!/bin/bash

########################
#      FONCTIONS       #
########################

# 1. Nombre de disques
nombre_disques() {
    echo "===== Nombre de disques ====="
    lsblk -dn -o NAME,TYPE | awk '$2=="disk"{count++} END{print "Total :", count+0}'
    echo
}

# 2. Partitions
partitions() {
    echo "===== Partitions ====="
    lsblk -o NAME,FSTYPE,SIZE,TYPE | awk '
        NR==1 {
            printf "%-15s %-10s %-10s %-10s\n", $1, $2, $3, $4
            next
        }
        $4=="part" {
            fs = ($2 == "" ? "(none)" : $2)
            printf "%-15s %-10s %-10s %-10s\n", $1, fs, $3, $4
        }
    '
    echo
}

# 3. Lecteurs montés
lecteurs_montes() {
    echo "===== Lecteurs montés ====="
    lsblk -o NAME,TYPE,MOUNTPOINT,FSTYPE,SIZE | awk '
        NR==1 {
            printf "%-15s %-10s %-25s %-10s %-10s\n", $1, $2, $3, $4, $5
            next
        }
        $2!="loop" && $3!="" {
            mp = ($3 == "" ? "-" : $3)
            fs = ($4 == "" ? "(none)" : $4)
            printf "%-15s %-10s %-25s %-10s %-10s\n", $1, $2, mp, fs, $5
        }
    '
    echo
}

# 4. Systèmes de fichiers montés
systemes_de_fichiers_montes() {
    echo "===== Systèmes de fichiers montés ====="
    df -hT | awk '
        NR==1 { print; next }
        $1 ~ "^/dev/" { print }
    '
    echo
}

########################
#        MENU          #
########################

menu() {
    while true; do
        echo "==============================="
        echo "     MENU GESTION DISQUES     "
        echo "==============================="
        echo "1) Afficher le nombre de disques"
        echo "2) Afficher les partitions"
        echo "3) Afficher les lecteurs montés"
        echo "4) Afficher les systèmes de fichiers montés"
        echo "0) Quitter"
        echo "-------------------------------"
        read -rp "Votre choix : " choix
        echo

        case "$choix" in
            1)
                nombre_disques
                read -rp "Appuyez sur Entrée pour revenir au menu..." _
                clear
                ;;
            2)
                partitions
                read -rp "Appuyez sur Entrée pour revenir au menu..." _
                clear
                ;;
            3)
                lecteurs_montes
                read -rp "Appuyez sur Entrée pour revenir au menu..." _
                clear
                ;;
            4)
                systemes_de_fichiers_montes
                read -rp "Appuyez sur Entrée pour revenir au menu..." _
                clear
                ;;
            0)
                echo "Au revoir !"
                exit 0
                ;;
            *)
                echo "Choix invalide."
                sleep 1
                clear
                ;;
        esac
    done
}

# Lancement du menu
menu
