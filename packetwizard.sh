#!/bin/bash

red="\033[38;5;196m"
green="\033[38;5;82m"
yellow="\033[0;33m"
blue="\033[38;5;51m"
reset="\033[0m" # Reset color to default

toilet -f mono12 -F metal -W PACKET_ WIZARD | lolcat
echo -e "NETWORK ANALYSIS TOOLKIT" | lolcat
cowsay -f dragon-and-cow PROFESSOR VISHAL professorvishal31@gmail.com | lolcat

while true
do

        figlet CHOOSE A PACKET ANALYSIS METHOD -c | lolcat

        echo -e "${yellow}[1]NETWORK PACKET CAPTURER${reset}"
        echo -e "${blue}[2]HTTP PASSWORD CAPTURER${reset}"
	echo -e "${green}[3]OPEN THE PCAP FILES IN GUI${reset}"
	echo -e "${red}[4]OPEN WIRESHARK-GUI${reset}"

	read pacmethod;

	case $pacmethod in

		1)
                        echo -e "\nEnter the interface to start the scan : " | lolcat
                        read interf

                        echo -e "\nEnter the file name to save(with[.pcap]extention)" | lolcat
                        read file
			
			echo -e "\nPress Ctrl+c to stop when you would like to ..." | lolcat
			sudo tshark -i $interf -w /tmp/$file
			
			echo -e "\nDO YOU WANT TO SAVE THE PCAP FILE?"

			echo -e "${green}1) YES${reset}"
			echo -e "${red}2) NO${reset}"

			read ans

			if [ $ans -eq 1 ]
			then
				echo -e "${green}OK!${reset}"
				chmod +x /tmp/$file
				chmod -R 777 /tmp/$file

			else
				rm -rv /tmp/$file
				echo -e "${red}REMOVED THE PCAP FILE SUCCESSFULLY !${reset}"
			fi
			
			;;
		2)
			echo -e "Enter the interface to start the scan : " | lolcat
			read interf

			echo -e "\nEnter the file name to save" | lolcat
			read file

			echo -e "\nPress ctrl+c to stop" | lolcat

			sudo tshark -i "$interf" -w "/tmp/$file" -f "tcp port 80 and http"

			chmod +x "/tmp/$file"
			chmod -R 777 "/tmp/$file"

			cd /tmp
			echo -e "\nDisplaying captured http packet's information" | lolcat
			sleep 3
			tshark -r $file | grep HTTP | grep POST

			echo -e "\nSHOWING THE PASSWORD OF THE CAPTURED PACKET\n" | lolcat
			sleep 3
			tshark -r $file -T fields -e http.cookie | grep login= | lolcat

                        echo -e "\nDO YOU WANT TO SAVE THE PCAP FILE?"

                        echo -e "${green}1) YES${reset}"
                        echo -e "${red}2) NO${reset}"

                        read ans

                        if [ $ans -eq 1 ]
                        then
                                echo -e "${green}OK!${reset}"
                                chmod +x /tmp/$file
                                chmod -R 777 /tmp/$file

                        else
                                rm -rv /tmp/$file
                                echo -e "${red}REMOVED THE PCAP FILE SUCCESSFULLY !${reset}"
                        fi

			;;

		3)
                        echo -e "\nEnter the file name to open in wireshark" | lolcat
                        read file
 			sleep 2

			echo -e "\nLOADING GUI COMPONENTS .... " |lolcat
			sleep 5

			sudo wireshark $file

			;;

		4)
			echo -e "\nLOADING WIRESHARK-GUI ..." | lolcat
			sleep 5
			sudo wireshark

			;;

		*) 
			echo -e "${red}INVALID OPTION :( \n${reset}"

			;;

	esac

        echo -e "\n${yellow}Want to scan more networks?\n${reset}"
        echo -e "${green}1.CONTINUE${reset}"
        echo -e "${red}2.EXIT\n${reset}"
        read conti

        if [ $conti -eq 1 ]
        then
                echo -e "${green}OK${reset}"
        else
                cowsay -f kiss COME BACK SOON !!! | lolcat
                break

        fi
        num=$(( $num+1 ))
        sleep 5.5

        echo -e "${reset}"

done
