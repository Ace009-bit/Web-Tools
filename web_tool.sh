#!/bin/bash

# Web Pentesting Tool for Linux
# Author: SAURABH AKA (Ace)
# Description: This script automates web pentesting tasks such as subdomain enumeration, directory brute-forcing, vulnerability scanning, etc.
# Version: 1.0

# Set color variables for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
RESET='\033[0m'

# ASCII Art Header
function banner() {
    clear
    echo -e "${CYAN}"
    echo "██╗    ██╗███████╗███████╗ █████╗ ██████╗ ████████╗███████╗"
    echo "██║    ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝"
    echo "██║    ██║█████╗  █████╗  ███████║██████╔╝   ██║   █████╗  "
    echo "██║    ██║██╔══╝  ██╔══╝  ██╔══██║██╔══██╗   ██║   ██╔══╝  "
    echo "██║    ██║███████╗███████╗██║  ██║██████╔╝   ██║   ███████╗"
    echo "╚═╝    ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚══════╝"
    echo -e "${RESET}"
    echo -e "${GREEN}WEB HACKING TOOL${RESET}"
    echo -e "${CYAN}--------------------------------------------${RESET}"
    echo -e "${YELLOW}Author: SAURABH AKA (Ace)${RESET}"
    echo -e "${CYAN}--------------------------------------------${RESET}"
}

# Check if necessary tools are installed
function check_tools() {
    echo -e "${BLUE}[*] Checking required tools...${RESET}"
    tools=("sublist3r" "dirb" "nikto" "sqlmap" "XSStrike")

    for tool in "${tools[@]}"; do
        command -v $tool &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[+] $tool is installed${RESET}"
        else
            echo -e "${RED}[-] $tool is NOT installed. Installing...${RESET}"
            install_tool $tool
        fi
    done
}

# Install missing tools
function install_tool() {
    tool=$1
    if [[ "$tool" == "sublist3r" ]]; then
        git clone https://github.com/aboul3la/Sublist3r.git
        cd Sublist3r && pip3 install -r requirements.txt
        cd ..
    elif [[ "$tool" == "XSStrike" ]]; then
        git clone https://github.com/s0md3v/XSStrike.git
        cd XSStrike && pip3 install -r requirements.txt
        cd ..
    elif [[ "$tool" == "dirb" ]]; then
        sudo apt-get install dirb -y
    elif [[ "$tool" == "nikto" ]]; then
        sudo apt-get install nikto -y
    elif [[ "$tool" == "sqlmap" ]]; then
        git clone https://github.com/sqlmapproject/sqlmap.git
    fi
}

# Subdomain enumeration using Sublist3r
function subdomain_enum() {
    echo -e "${BLUE}[*] Running Subdomain Enumeration...${RESET}"
    read -p "Enter the target domain (e.g., example.com): " domain
    sublist3r -d $domain -o subdomains.txt
    echo -e "${GREEN}[+] Subdomain enumeration complete. Results saved in subdomains.txt${RESET}"
}

# Directory and file enumeration using Dirb
function dirb_enum() {
    echo -e "${BLUE}[*] Running Directory/Files Brute-Force using Dirb...${RESET}"
    read -p "Enter the target URL (e.g., http://example.com): " target_url
    dirb $target_url
}

# Nikto vulnerability scanning
function nikto_scan() {
    echo -e "${BLUE}[*] Running Nikto Vulnerability Scan...${RESET}"
    read -p "Enter the target URL (e.g., http://example.com): " target_url
    nikto -h $target_url
}

# SQL Injection testing using sqlmap
function sql_injection() {
    echo -e "${BLUE}[*] Running SQL Injection Test using sqlmap...${RESET}"
    read -p "Enter the target URL (with a vulnerable parameter, e.g., http://example.com?id=1): " target_url
    sqlmap -u $target_url --batch --crawl=1 --threads=5
}

# XSS testing using XSStrike
function xss_testing() {
    echo -e "${BLUE}[*] Running XSS Testing using XSStrike...${RESET}"
    read -p "Enter the target URL (e.g., http://example.com/search): " target_url
    python3 XSStrike/XSStrike.py -u $target_url --crawl
}

# Main menu function
function main_menu() {
    banner
    echo -e "${YELLOW}Choose an option to run the tool:${RESET}"
    echo -e "${GREEN}1) Subdomain Enumeration${RESET}"
    echo -e "${GREEN}2) Directory/Files Brute-Forcing${RESET}"
    echo -e "${GREEN}3) Nikto Vulnerability Scan${RESET}"
    echo -e "${GREEN}4) SQL Injection Test${RESET}"
    echo -e "${GREEN}5) XSS Testing${RESET}"
    echo -e "${CYAN}0) Exit${RESET}"
    echo -e "${YELLOW}--------------------------------------------${RESET}"
    read -p "Enter choice: " choice

    case $choice in
        1)
            subdomain_enum
            ;;
        2)
            dirb_enum
            ;;
        3)
            nikto_scan
            ;;
        4)
            sql_injection
            ;;
        5)
            xss_testing
            ;;
        0)
            echo -e "${CYAN}[*] Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}[-] Invalid option! Please try again.${RESET}"
            ;;
    esac
}

# Ensure the tools are installed
check_tools

# Show the main menu
while true; do
    main_menu
done
