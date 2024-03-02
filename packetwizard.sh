#!/bin/bash

red="\033[38;5;196m"
green="\033[38;5;82m"
yellow="\033[0;33m"
blue="\033[38;5;51m"
reset="\033[0m" # Reset color to default

clear

toilet -f mono12 -F metal -W PACKET_ WIZARD | lolcat
echo -e "NETWORK ANALYSIS TOOLKIT" | lolcat
cowsay -f dragon-and-cow PROFESSOR VISHAL professorvishal31@gmail.com | lolcat

while true; do

    figlet CHOOSE A PACKET ANALYSIS METHOD -c | lolcat

    echo -e "\n${yellow}[1] NETWORK PACKET CAPTURER${reset}"
    echo -e "${blue}[2] HTTP PASSWORD CAPTURER${reset}"
    echo -e "${green}[3] OPEN THE PCAP FILES IN GUI${reset}"
    echo -e "${red}[4] OPEN WIRESHARK-GUI${reset}"

    echo -e "\n${blue}"
    iwconfig
    echo -e "${reset}"

    echo -e "\n${green}"
    python3 /opt/predatorshell/packetwizard/ai.py

    file_path="/opt/predatorshell/packetwizard/finger_count.txt"

    if grep -q "1" "$file_path"; then
        echo -e "\nEnter the interface to start the scan : " | lolcat
        read -p "Interface: " interf

        echo -e "\nEnter the file name to save (with [.pcap] extension) :" | lolcat
        read -p "File Name: " file

        echo -e "\nPress Ctrl+C to stop when you would like to ..." | lolcat
        sudo tshark -i "$interf" -w "/tmp/$file"

        echo -e "\n${yellow}DO YOU WANT TO SAVE THE PCAP FILE?${reset}" | lolcat

        echo -e "${green}1) YES${reset}"
        echo -e "${red}2) NO${reset}"

        echo -e "${blue}"
        python3 /opt/predatorshell/packetwizard/ai.py

        file_path="/opt/predatorshell/packetwizard/finger_count.txt"

        if grep -q "1" "$file_path"; then
            echo -e "${green}OK!${reset}"
        elif grep -q "2" "$file_path"; then
            rm -rv "/tmp/$file"
            echo -e "${red}REMOVED THE PCAP FILE SUCCESSFULLY!${reset}"
        else
            echo -e "${red}INVALID OPTION!${reset}"
        fi

    elif grep -q "2" "$file_path"; then
        echo -e "Enter the interface to start the scan : " | lolcat
        read -p "Interface: " interf

        echo -e "\nEnter the file name to save (with [.pcap] extension) :" | lolcat
        read -p "File Name: " file

        echo -e "\nPress Ctrl+C to stop" | lolcat

        sudo tshark -i "$interf" -w "/tmp/$file" -f "tcp port 80 and http"

        chmod +x "/tmp/$file"
        chmod -R 777 "/tmp/$file"

        echo -e "\nDisplaying captured HTTP packet's information" | lolcat
        sleep 3
        tshark -r "$file" | grep HTTP | grep POST

        echo -e "\nSHOWING THE PASSWORD OF THE CAPTURED PACKET\n" | lolcat
        sleep 3
        tshark -r "$file" -T fields -e http.cookie | grep login= | lolcat

        echo -e "\n${yellow}DO YOU WANT TO SAVE THE PCAP FILE?${reset}" | lolcat

        echo -e "${green}1) YES${reset}"
        echo -e "${red}2) NO${reset}"

        echo -e "${blue}"
        python3 /opt/predatorshell/packetwizard/ai.py

        file_path="/opt/predatorshell/packetwizard/finger_count.txt"

        if grep -q "1" "$file_path"; then
            echo -e "${green}OK!${reset}"
            chmod +x "/tmp/$file"
            chmod -R 777 "/tmp/$file"
        elif grep -q "2" "$file_path"; then
            rm -rv "/tmp/$file"
            echo -e "${red}REMOVED THE PCAP FILE SUCCESSFULLY!${reset}"
        else
            echo -e "${red}INVALID OPTION!${reset}"
        fi

    elif grep -q "3" "$file_path"; then
        echo -e "\nEnter the file name to open in Wireshark" | lolcat
        read -p "File Name: " file
        sleep 2

        echo -e "\nLOADING GUI COMPONENTS .... " | lolcat
        sleep 5

        sudo wireshark "$file"

    elif grep -q "4" "$file_path"; then
        echo -e "\nLOADING WIRESHARK-GUI ..." | lolcat
        sleep 5
        sudo wireshark

    else
        echo -e "${red}INVALID OPTION :( ${reset}\n" | lolcat
    fi

    echo -e "\n${yellow}Want to scan more networks?\n${reset}"
    echo -e "${green}1. CONTINUE${reset}"
    echo -e "${red}2. EXIT${reset}\n"

    echo -e "${yellow}"
    python3 /opt/predatorshell/packetwizard/ai.py

    file_path="/opt/predatorshell/packetwizard/finger_count.txt"

    if grep -q "1" "$file_path"; then
        echo -e "${green}OK${reset}"
    elif grep -q "2" "$file_path"; then
        cowsay -f kiss "COME BACK SOON !!!" | lolcat
        break
    else
        echo "${red}INVALID OPTION!${reset}"
        break
    fi

    sleep 5.5

    echo -e "${reset}"

done
