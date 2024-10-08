#!/bin/bash

# Function to generate random colors
random_color() {
    echo -e "\e[38;5;$((RANDOM % 256))m$1\e[0m"
}

# Function to display ASCII art
display_ascii_art() {
    echo -e "$(random_color '██████╗ ██╗██╗  ██╗██████╗ ███████╗███████╗██████╗ ████████╗███████╗')"
    echo -e "$(random_color '██╔══██╗██║██║  ██║██╔══██╗██╔════╝██╔════╝██╔══██╗╚══██╔══╝██╔════╝')"
    echo -e "$(random_color '███████║██║███████║██████╔╝█████╗  █████╗  ██████╔╝   ██║   █████╗  ')"
    echo -e "$(random_color '██╔══██║██║██╔══██║██╔═══╝ ██╔══╝  ██╔══╝  ██╔══██╗   ██║   ██╔══╝  ')"
    echo -e "$(random_color '██║  ██║██║██║  ██║██║     ███████╗███████╗██║  ██║   ██║   ███████╗')"
    echo -e "$(random_color '╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝')"
}

# Function to display loading animation
loading_animation() {
    spin='|/-\'
    i=0
    while [ "$i" -le 100 ]; do
        for j in $spin; do
            echo -ne "\b$j"
            sleep 0.1
        done
        i=$((i+1))
    done
}

# Banner display
clear
display_ascii_art
echo "------------------------------------"
echo -e "$(random_color '     Made by Cyber Vigilance PK')"
echo -e "$(random_color '        and Faraz Ahmed')"
echo "------------------------------------"

# Function to install Tor if not already installed
install_tor() {
    if ! command -v tor &> /dev/null; then
        echo -e "$(random_color 'Tor is not installed. Installing Tor...')"
        pkg update && pkg install tor -y
    else
        echo -e "$(random_color 'Tor is already installed.')"
    fi
}

# Function to change IP using Tor
change_ip() {
    echo -e "$(random_color 'Starting Tor and changing IP...')"

    # Start Tor in the background and redirect output to a log file
    tor > tor_log.txt 2>&1 &

    # Display loading animation while waiting for Tor to complete bootstrapping
    loading_animation &

    # Wait for Tor to bootstrap completely
    grep -m 1 "Bootstrapped 100% (done): Done" <(tail -f tor_log.txt)

    # Kill the loading animation
    pkill -f "loading_animation"

    # Get the new IP address using a different service
    new_ip=$(curl --socks5 127.0.0.1:9050 -s https://api.ipify.org)

    if [ $? -eq 0 ]; then
        echo -e "$(random_color "Your new IP address is: $new_ip")"
    else
        echo -e "$(random_color 'Failed to fetch IP address.')"
    fi

    # Kill the Tor process to disconnect
    pkill tor
}

# Install Tor
install_tor

# Main loop to keep changing the IP
while true; do
    change_ip
    # Wait for 5 minutes before changing the IP again
    sleep 300
done
