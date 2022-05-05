#!/bin/bash
print_rules(){
    echo "IPv4 Rules:"
    sudo iptables -S
    echo ""
    echo "IPv6 Rules:"
    sudo ip6tables -S
    echo ""
    echo "All Table Rules:"
    sudo iptables -L -v -n | more
}
Add_Input(){
    echo "What rules would you like to append"
    
}
add_Rule_Menu(){
    echo "What chain would you like to add a rule to?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Go Back") 
    select opt in "${options[@]}"
    do
        case $opt in
            "INPUT")
                echo "Adding a Rule to INPUT"

                continue
                ;;
            "OUTPUT")
                echo "Adding a Rule to OUTPUT"

                continue
                ;;
            "FORWARDING")
                echo "Adding a Rule to FORWARDING"
                
                continue
                ;;
            "Go Back")
                change_menu
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}
delete_Rule_Menu(){
    echo "What chain would you like to delete a rule from?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Go Back")
    select opt in "${options[@]}"
    do
        case $opt in
            "INPUT")
                echo "Deleting a Rule from INPUT"

                continue
                ;;
            "OUTPUT")
                echo "Deleting a Rule from OUTPUT"

                continue
                ;;
            "FORWARDING")
                echo "Deleting a Rule from FORWARDING"
                
                continue
                ;;
            "Go Back")
                change_menu
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done

}
modify_Rule_Menu(){
    echo "What chain would you like to add a rule to?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Go Back")
    select opt in "${options[@]}"
    do
        case $opt in
            "INPUT")
                echo "Modifying a Rule from INPUT"

                continue
                ;;
            "OUTPUT")
                echo "Modifying a Rule from OUTPUT"

                continue
                ;;
            "FORWARDING")
                echo "Modifying a Rule from FORWARDING"
                
                continue
                ;;
            "Go Back")
                change_menu
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}
change_menu(){
    echo "Choose whether you would like to add or delete a rule:"
    options=("Add Rule" "Delete Rule" "Modify Rule" "Go Back")
    select opt in "${options[@]}"
    do 
        case $opt in
            "Add Rule")
                echo "You chose to add a new rule"
                add_Rule_Menu
                ;;
            "Delete Rule")
                echo "You chose to delete a rule"
                delete_Rule_Menu
                ;;
            "Modify Rule")
                echo "You chose to modify a rule"
                modify_Rule_Menu
                ;;
            "Go Back")
                main
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done

}
main(){
    while true; do
        echo "Please Select an option below regarding your IPTable"
        options=("Change My Rules" "Print My Rules" "Quit")
        select opt in "${options[@]}"
        do  
            case $opt in
                "Change My Rules")
                    echo "You chose to change your IPTable Rules"
                    #other menu goes here
                    main
                    ;;
                "Print My Rules")
                    #All of these echos are just being used for formatting purposes
                    echo ""
                    echo "You chose to print your iptable rules"
                    echo ""
                    print_rules
                    echo ""
                    echo""
                    echo "---------------------------------------------------------"
                    main
                    ;;
                "Quit")
                    echo "You chose to quit"
                    exit 
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    done
}

#this is calling the driver function of the script
main
