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
Add_Output(){
    echo "What rules would you like to append to output?"
    options=("Allow Established Outgoing Connections" "Blocking Outgoing SMTP Mail")
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
            *)echo "invalid option $REPLY"
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
add_Rule_Menu(){
    echo "What chain would you like to add a rule to?"
    options=("INPUT" "OUTPUT" "FORWARDING" "Compound" "Go Back") 
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
            "Compound")
                echo "You selected the ouption that adds both input and output rules"
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
