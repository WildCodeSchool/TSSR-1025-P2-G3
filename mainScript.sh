#!/bin/bash


# Scripts 

userScript='source scriptUserP2.sh'
groupScript='source scriptGroups.sh'


# Fonctions
while true; do

    #=====================================================
    # VARIABLES
    #=====================================================
    userChoiceMainMenu=""
    userMainMenu=""



    #=====================================================
    # FONCTIONS
    #=====================================================
    function mainMenu(){


        echo ""
        echo "##################################################"
        echo "#                MENU PRINCIPAL                  #"
        echo "##################################################"
        echo "#                                                #"
        echo "#  Choisissez une action :                       #"
        echo "#                                                #"
        echo "#  1. Gestion des Utilisateurs                   #"
        echo "#  2. Gestions des Ordinateurs                   #"
        echo "#  3. Informations Système                       #"
        echo "#  4. Recherche dans les logs                    #"
        echo "#  5. Quitter                                    #"
        echo "#                                                #"
        echo "##################################################"
        echo ""

        read -p "# Choisissez une action : " userChoiceMainMenu

        case $userChoiceMainMenu in 

            1) 
                userMainMenu
                ;;

            2)
                echo "test ordi"
                ;;

            3)
                echo "test information"
                ;;
            4) 
                echo "test logs"
                ;;
            5)
                echo "Fermeture du programme"
                exit 0
        esac

    }

function userMainMenu(){

    echo ""
    echo "##################################################"
    echo "#                MENU UTILISATEUR                #"
    echo "##################################################"
    echo "#                                                #"
    echo "#  Choisissez une action :                       #"
    echo "#                                                #"
    echo "#  1. Utilisateurs                               #"
    echo "#  2. Groupes                                    #"
    echo "#  3. Menu Principal                             #"
    echo "#                                                #"
    echo "##################################################"
    echo ""

    read -p "# Choisissez une action : " userMainMenu

    case $userMainMenu in

        1) 
            $userScript
            ;;
        
        2)
            $groupScript 
            ;;

        3) 
            echo "test2"
            ;;
        
        4)
            mainMenu
            ;;
    esac



}

# function computerMainMenu(){

# }

# function informationMainMenu(){

# }

# function logsMainMenu(){

# }
mainMenu

done
