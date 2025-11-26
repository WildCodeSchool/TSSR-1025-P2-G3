#!/bin/bash
#---------------------------------Fonctions-------------------------------------------

fonc_add_user_admin()
{
# choix de l'ulisateur:
read -p "Quel utilisateur souhaitez vous ajouter en admin ? : " useraddadmin

# l'utilisateur existe ?
if 
cat /etc/passwd | grep $useraddadmin

# si il existe on ajoute au groupe sudo
then
usermod -aG sudo $useraddadmin
# On verfie si l'utilisateur a bien été ajouté

    if
    cat /etc/group | grep sudo | grep $useraddadmin
    then
    echo "l'utililateur a bien été ajouté au groupe sudo"
    
        echo " souhaitez-vous ajouter un autre utilisateur au groupe sudo ? "
        read -p "tape o pour oui ou autre chose pour non " choix
    
        if [ $choix = "o" ]
        # si oui on relance la fonction
        then fonc_add_user_admin 
        else 
         # retour au menu
        fonc_menu_group
        fi

    else
    echo "erreur" 
    exit 130

    fi
# si il n'existe pas
else
echo " l'utilisateur demandé n'existe pas, souhaitez vous choisir un autre utilisateur ?  "
read -p "tape o pour oui ou autre chose non" choix
    
    if [ $choix = "o" ]
    # si oui on relance la fonction
    then fonc_add_user_admin 
    else 
    fonc_menu_group
    fi

fi

}

fonc_add_user_group()
{
    # choix de l'ulisateur:
    read -p "Quel utilisateur souhaitez vous ajouter au groupe ? : " useraddgroup
# l'utilisateur existe ?
if 
cat /etc/passwd | grep -w $useraddgroup
# si il existe on demande le groupe auquel ajouter l'utilisateur
then
echo "Ok pour cet utilisateur, a quel groupe souhaitez vous l'ajouter ?"
read namegroup
    #si le groupe existe
    if 
    cat etc/group | grep $namegroup
    then usermod -aG $namegroup $useraddgroup
    # on confirme l'ajout de l'utilisateur au groupe.
        if  cat /etc/group | grep $namegroup | grep $useraddgroup
        then
        echo " l'utilisateur a bien été ajouté au groupe "
        else
        echo "erreur"
        exit 130
        fi
    #si le groupe n'existe pas
    else
    echo "le groupe n'existe pas, souhaitez vous le créer et y ajouter l'utilisateur ? "    
    read -p "tape o pour oui ou autre chose non" choix

        if [ $choix = "o" ]
        # si oui on crée le groupe et on ajoute l'utilisateur
        then groupadd $namegroup && usermod -aG $namegroup $useraddgroup
        else 
        fonc_menu_group
        fi
    fi

else
echo "Cet utilisateur n'existe pas, souhaitez vous choisir un autre utilisateur ?  "
read -p "tape o pour oui ou autre chose non" choix
    
    if [ $choix = "o" ]
    # si oui on relance la fonction
    then fonc_add_user_group
    else 
    fonc_menu_group

    fi
fi
}

fonc_exit_group()

    {

echo " en construction "
    
}

fonc_exit_menu()

{

echo "retour au menu précédent"
exit 0

}
#-------------------------------Menu--------------------------------

fonc_menu_group()
    {
echo "bonjour que voulez vous faire"
echo ""
echo "1) Ajouter un utilisateur au groupe sudo"
echo "2) Ajouter un utilisateur à un groupe"
echo "3) Retirer un utilisateur d'un groupe"
echo "4) Retour au menu précédent"
echo  ""
echo -n "Votre choix (1-4): "

}


fonc_menu_group

while true;
do
    read selection

    case $selection in

1)
    fonc_add_user_admin
    ;;
2)
    fonc_add_user_group
    ;;
3)
    fonc_exit_group
    ;;
4)

    fonc_exit_menu
    ;;
*)
    echo "Erreur de saisie"
    fonc_menu_group
    ;;

esac
done






    