#!/bin/bash

# Script de création, suppression d'utilisateur et modification de mot de passe utilisateurs.
# Auteur : Christian



while true;do

    #=====================================================
    # VARIABLES
    #=====================================================
    menuUser=""
    menuAddUser=""
    addUserCommand=""
    userCreationChoice=""
    delUserMenu=""
    delUserChoice=""



    #=====================================================
    # FONCTIONS
    #=====================================================

    # Sous menu "Utilisateurs"
    function userMenu(){

        echo ""
        echo "##################################################"
        echo "#               MENU UTILISATEUR                 #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Ajouter un utilisateur                     #"
        echo "#  2. Supprimer un utilisateur                   #"
        echo "#  3. Changer le mot de passe d'un Utilisateur   #"
        echo "#  4. Afficher les Utilisateurs                  #"
        echo "#  5. Retour au menu précédent                   #"
        echo "#                                                #"
        echo "##################################################"
        echo ""


        read -p "# Entrez un nombre : " menuUser

        case $menuUser in 

            1) 
                addUserMenu
                ;;

            2)
                deleteUserMenu
                ;;

            3)
                changePasswordUser
                ;;

            4)

                echo ""
                echo "Liste des utilisateurs : "
                awk -F':' '$3 >= 1000 {print $1, $3}' /etc/passwd | sort -k 2
                ;;

            5)
                userMainMenu
                ;;

            *)
                echo "Entrée invalide"
                userMenu
                ;;
        esac
    }


    # Ajouter un utilisateur
    function addUserMenu(){

        echo ""
        echo "##################################################"
        echo "#              AJOUTER UTILISATEUR               #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Saisir un nom d'utilisateur                #"
        echo "#  2. Retour au menu précédent                   #"
        echo "#                                                #"
        echo "##################################################"
        echo ""

        read -p "# Entrez un nombre : " menuAddUser

        case $menuAddUser in

            1)
                userCreationChoice="o"

                while [ "$userCreationChoice" = "o" ]; do
                
                    read -p "# Entrez un nom d'utilisateur : " addUserCommand        
                    grep "^$addUserCommand:" /etc/passwd > /dev/null

                    if [ $? = 1 ]
                    then 

                        read -p "# Voulez-vous créer l'utilisateur $addUserCommand ? (o/n) : " confirmUser

                        if [ "$confirmUser" = "o" ]
                        then 
                            useradd "$addUserCommand"
                            grep "^$addUserCommand:" /etc/passwd > /dev/null    
                            echo ""      
                            echo "## L'utilisateur $addUserCommand a été créé. ##"
                            echo ""

                            read -p "# Voulez-vous créer un autre utilisateur ? (o/n) : " userCreationChoice
                            echo ""

                        else 
                            echo "Retour au menu précédent"
                            echo ""
                            userCreationChoice="n"
                        fi

                    else
                        echo "L'utilisateur $addUserCommand existe déjà."
                        echo "Retour au menu précédent"
                        echo ""
                        addUserMenu
                    fi
                done
                userMenu
                ;;


            2)
                userMenu
                ;;

            *)
                echo "Entrée Invalide!!!"
                echo "Retour au menu précédent."
                echo ""
                addUserMenu
                ;;
        esac        

        addUser

    }

    # Supprimer un utilisateur
    function deleteUserMenu(){

        echo ""
        echo "##################################################"
        echo "#            SUPPRIMER UTILISATEUR               #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Saisir un nom d'utilisateur à supprimer    #"
        echo "#  2. Afficher la liste des utilisateurs         #"
        echo "#  3. Retour au menu précédent                   #"
        echo "#                                                #"
        echo "##################################################"
        echo ""

        read -p "Choisissez une option : " delUserMenu

        case $delUserMenu in 

            1)
                delAnotherUser="o"

                while [ "$delAnotherUser" = "o" ];do
                    read -p "Entrez un nom d'utilisateur : " delUserCommand
                    grep "^$delUserCommand:" /etc/passwd > /dev/null

                    if [ $? = 1 ]
                    then    
                        echo "L'utilisateur n'existe pas."
                        deleteUserMenu
                    else 
                        read -p "Souhaitez-vous supprimer l'utilisateur $delUserCommand ? (o/n) " delUserChoice

                        if [ "$delUserChoice" = "o" ]
                        then 
                            userdel $delUserCommand
                            echo "L'utilisateur $delUserCommand a été supprimé."
                            read -p "Voulez-vous supprimer un autre utilisateur ? (o/n) :" delAnotherUser

                        else
                            echo "Retour au menu."
                        fi
                    fi
                done
                ;;

            2) 
                echo ""
                echo "Liste des utilisateurs : "
                awk -F':' '$3 >= 1000 {print $1, $3}' /etc/passwd | sort
                deleteUserMenu
                ;;

            3) 
                userMenu
                ;;

            *)
                echo "Entrée invalide !"
                deleteUserMenu
                ;;

        esac
        deleteUserMenu 
    }

    # Changer mot de passe utilisateur
    function changePasswordUser(){
       
        echo ""
        echo "##################################################"
        echo "#       CHANGER MOT DE PASSE UTILISATEUR         #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Saisir un nom d'utilisateur                #"
        echo "#  2. Afficher la liste des utilisateurs         #"
        echo "#  3. Retour au menu précédent                   #"
        echo "#                                                #"
        echo "##################################################"
        echo ""
             
        read -p "Choisissez une option : " changePasswordMenu


        case $changePasswordMenu in

            1) 
                read -p "Entrer un nom d'utilisateur : " changePasswordUser
                grep "^$changePasswordUser:" /etc/passwd > /dev/null

                if [ $? = 1 ]
                then
                    echo "Cet utilisateur n'existe pas"
                else 
                    read -p "Souhaitez-vous changer le mot de passe de l'utilisateur $changePasswordUser ? (o/n) " changepasswordUserChoice
                    if [ "$changepasswordUserChoice" = "o" ]
                    then 
                        passwd $changePasswordUser
                        echo "Le mot de passe de l'utilisateur $changePasswordUser a été modifié."
                    else
                        echo "Retour au menu."
                    fi
                fi
                ;;

            2) 
                echo ""
                echo "Liste des utilisateurs : "
                awk -F':' '$3 >= 1000 {print $1, $3}' /etc/passwd | sort
                changePasswordUser
                ;;

            3) 
                userMenu
                ;;

            *)
                echo "Entrée invalide !"
                userMenu
                ;;
        esac


    }
    userMenu

done
