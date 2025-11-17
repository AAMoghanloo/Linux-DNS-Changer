#!/bin/bash
# Author: https://github.com/AAMoghanloo

RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[38;5;35m'
YELLOW='\033[1;33m'
CYAN_BOLD="\e[36m\e[1m"
NC='\033[0m'

cols=$(tput cols)

center_text() {
    local text="$1"
    local padding=$(( (cols - ${#text}) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}

SCRIPT_URL="https://raw.githubusercontent.com/aamoghanloo/linux-dns-changer/main/dns.sh"
INSTALL_PATH="/usr/local/bin/dns"
TEMP_FILE="/tmp/dns_script_download_$$.sh"

echo -e "  ${CYAN_BOLD}Starting DNS Changer script installation...${NC}\n"

echo -e "  ${YELLOW}Downloading script from GitHub: https://raw.githubusercontent.com/aamoghanloo${NC}\n"
if curl -Ls "${SCRIPT_URL}" -o "${TEMP_FILE}"; then
    echo -e "  ${GREEN}Download successful.${NC}"
else
    echo -e "  ${RED}ERROR: Failed to download the script.${NC}\n"
    exit 1
fi

echo -e "  ${YELLOW}Setting executable permissions for the script...${NC}\n"
chmod +x "${TEMP_FILE}"

echo -e "  ${YELLOW}Copying script to ${CYAN_BOLD}${INSTALL_PATH}${YELLOW}... (Requires sudo)${NC}\n"

if ! command -v sudo &> /dev/null; then
    echo -e "  ${RED}ERROR: 'sudo' command not found. Cannot install to ${INSTALL_PATH}.${NC}\n"
    exit 1
fi

if sudo mv "${TEMP_FILE}" "${INSTALL_PATH}"; then
    echo -e "  ${LIGHT_GREEN}Installation successful! The script is now available as 'dns'.${NC}\n"
    printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
    printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
    echo -e "  ${YELLOW}Now you can manage the script by typing 'dns' command.${END}"
    echo -e "  ${YELLOW}e.g.${END} root@$(hostname):~# ${BLUE}6in4${END}"
    printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
    printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
else
    echo -e "   ${RED}ERROR: Failed to copy the script to ${INSTALL_PATH}.${NC}\n"
    echo -e "   ${RED}Check if you have the necessary permissions or if the path exists.${NC}\n"
    if [ -f "${TEMP_FILE}" ]; then
        rm "${TEMP_FILE}"
    fi
    exit 1
fi
