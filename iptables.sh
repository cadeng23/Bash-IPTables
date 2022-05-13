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
#this is the start of the menus for add to chains
Add_Forwarding(){
    echo "What rules would you like to add to the forwarding chain?"
    options=("Allow Internal Network to Access External" "Go Back")
    select opt in "${options[@]}"
    do 
        case $opt in
            "Allow Internal Network to Access External" "Go Back")
                echo "You chose to allow internal network to access external"
                sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
                main 
                continue
                ;;
            "Go Back")
                echo "You chose to go back"
                add_Rule_Menu
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done
}
Add_Output(){
    echo "What rules would you like to append to output?"
    options=("Allow Established Outgoing Connections" "Blocking Outgoing SMTP Mail" "Go Back")
    select opt in "${options[@]}"
    do
        case $opt in
            "Allow Established Outgoing Connections")
                echo "You chopse to allow established outgoing connections"
                sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
                main
                continue 
                ;;
            "Blocking Outgoing SMTP Mail")
                echo "You chose to block outgoing SMTP mail"
                sudo iptables -A OUTPUT -p tcp --dport 25 -j REJECT
                main
                continue
                ;;
            "Go Back")
                echo "You chose to go back."
                add_Rule_Menu
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done
}

Add_Compound(){
    echo "What compound rules would you like to add?"
    options=("Allow All Incoming SMTP" "Allow All Incoming IMAP" "Allow All Incoming POP3")
    select opt in "${options[@]}"
    do 
        case $opt in 
            "Allow All Incoming SMTP")
                echo "You chose to allow all incoming SMTP"
                sudo iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
                sudo iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT
                main
                continue
                ;;
            "Allow All Incoming IMAP")
                echo "You chose to allow all incoming IMAP"
                sudo iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
                sudo iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT
                main
                continue
                ;;
            "Allow All Incoming POP3")
                echo "You chose to allow all incoming POP3"
                sudo iptables -A INPUT -p tcp --dport 110 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
                sudo iptables -A OUTPUT -p tcp --sport 110 -m conntrack --ctstate ESTABLISHED -j ACCEPT
                main
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done

}

Add_Input(){
    echo "What rules would you like to append to Input?"
    options=("Allow Established and Related Incoming Connections" "Drop Invalid Packets" "Blocking an IP Address")
    select opt in "${options[@]}"
    do 
        case $opt in 
            "Allow Established and Related Incoming Connections")
                echo "You have decided to allow established and related incoming connections"
                sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
                main
                continue
                ;;
            "Drop Invalid Packets")
                echo "You have decided to drop invalid packets"
                sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
                main
                continue
                ;;
            "Blocking an IP Address")
                echo "You have decided to block a specific IP address"
                echo ""
                echo "Please input the ip address you wish to block. Remember IP addresses are in the format 123.1.123.12"
                read ipAddress
                sudo iptables -A INPUT -s $ipAddress -j DROP
                main
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done
}
#END of the final adding Rules Menus
#Below is the menu to choose which chain is to be added to
add_Rule_Menu(){
    echo "What chain would you like to add a rule to?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Compound" "Go Back") 
    select opt in "${options[@]}"
    do
        case $opt in
            "INPUT")
                echo "Adding a Rule to INPUT"
                Add_Input
                continue
                ;;
            "OUTPUT")
                echo "Adding a Rule to OUTPUT"
                Add_Output
                continue
                ;;
            "FORWARDING")
                echo "Adding a Rule to FORWARDING"
                
                continue
                ;;
            "Compound")
                echo "You selected the ouption that adds both input and output rules"
                Add_Compound
                continue
                ;;

            "Go Back")
                change_menu
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}
#END of chain choosing for ADD RULE Menu
delete_INPUT(){
    echo "You chose to delete rules in the INPUT chain"
    options=("Delete and Reset all rules regarding INPUT?" "Go Back")
    select opt in "${options[@]}"
    do 
        case $opt in
            "Delete and Reset all rules regarding INPUT?")
                echo "Are you sure you would like to reset all rules in INPUT chain? (y/n)"
                read choice
                if [$choice == 'y']
                then 
                    sudo iptables -P INPUT ACCEPT
                    sudo iptables -F INPUT
                    echo "The rules regarding INPUT chain are now reset"
                    main
                else
                    echo "You have chosen to not reset the INPUT chain"
                    delete_INPUT
                fi
                continue
                ;;
            "Go Back")
                echo "You chose to go back"
                delete_Rule_Menu
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done                
}
delete_OUTPUT(){
    echo "You chose to delete rules in the OUTPUT chain"
    options=("Delete and Reset all rules regarding OUTPUT?" "Go Back")
    select opt in "${options[@]}"
    do 
        case $opt in
            "Delete and Reset all rules regarding OUTPUT?")
                echo "Are you sure you would like to reset all rules in OUTPUT chain? (y/n)"
                read choice
                if [$choice == 'y']
                then 
                    sudo iptables -P OUTPUT ACCEPT
                    sudo iptables -F OUTPUT
                    echo "The rules regarding OUTPUT chain are now reset"
                    main
                else
                    echo "You have chosen to not reset the OUTPUT chain"
                    delete_OUTPUT
                fi
                continue
                ;;
            "Go Back")
                echo "You chose to go back"
                delete_Rule_Menu
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done      
}
delete_FORWARD(){
    echo "You chose to delete rules in the FORWARD chain"
    options=("Delete and Reset all rules regarding FORWARD?" "Go Back")
    select opt in "${options[@]}"
    do 
        case $opt in
            "Delete and Reset all rules regarding FORWARD?")
                echo "Are you sure you would like to reset all rules in FORWARD chain? (y/n)"
                read choice
                if [$choice == 'y']
                then 
                    sudo iptables -P FORWARD ACCEPT
                    sudo iptables -F FORWARD
                    echo "The rules regarding FORWARD chain are now reset"
                    main
                else
                    echo "You have chosen to not reset the FORWARD chain"
                    delete_FORWARD
                fi
                continue
                ;;
            "Go Back")
                echo "You chose to go back"
                delete_Rule_Menu
                continue
                ;;
            *) echo "invalid option $REPLY"
        esac
    done      
}

#Below is the menu to choose the chain to delete from
delete_Rule_Menu(){
    echo "What chain would you like to delete a rule from?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Go Back")
    select opt in "${options[@]}"
    do
        case $opt in
            "INPUT")
                echo "Deleting a Rule from INPUT"
                delete_INPUT
                continue
                ;;
            "OUTPUT")
                echo "Deleting a Rule from OUTPUT"
                delete_OUTPUT
                continue
                ;;
            "FORWARDING")
                echo "Deleting a Rule from FORWARD"
                delete_FORWARD
                continue
                ;;
            "Go Back")
                change_menu
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}
#END of the menu to choose the chain to delete rules from
#BEGIN MODIFY rules
modify_INPUT(){
    echo "ipV4 Rules:"
    sudo iptables -S
    read change
    echo "What would you like to change the INPUT chain to? "
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
#Below is the menu where you choose whether you would like to add change or modify the rules
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
                    change_menu
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
