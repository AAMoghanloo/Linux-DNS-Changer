#!/bin/bash
# Change DNS with one click (DNS Changer) - v1.0.0
# Author: https://github.com/AAMoghanloo

clear

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

printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
echo ""
echo -ne "${YELLOW}"
echo -e "$(center_text '░█▀▀▄ ░█▄─░█ ░█▀▀▀█ 　 ░█▀▀█ ░█─░█ ─█▀▀█ ░█▄─░█ ░█▀▀█ ░█▀▀▀ ░█▀▀█')"
echo -e "$(center_text '░█─░█ ░█░█░█ ─▀▀▀▄▄ 　 ░█─── ░█▀▀█ ░█▄▄█ ░█░█░█ ░█─▄▄ ░█▀▀▀ ░█▄▄▀')"
echo -e "$(center_text '░█▄▄▀ ░█──▀█ ░█▄▄▄█ 　 ░█▄▄█ ░█─░█ ░█─░█ ░█──▀█ ░█▄▄█ ░█▄▄▄ ░█─░█')"
echo ""
echo -e "$(center_text 'Change DNS with one click')"
echo -ne "${NC}"
echo ""
echo -e "  ${LIGHT_GREEN}Script Version:${NC} ${YELLOW}1.0.0${NC}"
printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'

echo ""
echo -e "  ${YELLOW}Current DNS:${NC}"
echo ""
if [ -f /etc/resolv.conf ]; then
    grep '^nameserver' /etc/resolv.conf | while read -r line; do
        echo -e "    ${LIGHT_GREEN}$line${NC}"
    done
else
    echo -e "    ${RED}No resolv.conf found.${NC}"
fi

dns_names=(
    "Google"
    "Shecan"
    "Electro"
    "Asiatech"
    "Begzar"
    "CloudFlare"
    "Norton"
    "Comodo Secure"
)

dns_values=(
    "8.8.8.8 4.4.4.4"               # Google
    "178.22.122.100 185.51.200.2"   # Shecan
    "78.157.42.100 78.157.42.101"   # Electro
    "194.36.174.161 178.22.122.100" # Asiatech
    "185.55.226.26 185.55.225.25"   # Begzar
    "1.1.1.1 1.0.0.1"               # CloudFlare
    "199.85.126.10 199.85.127.10"   # Norton
    "8.26.56.26 8.20.247.20"        # Comodo Secure
)

echo ""
echo -e "  ${YELLOW}Please select the desired DNS:${NC}"
echo ""
for i in "${!dns_names[@]}"; do
    printf "    ${RED}%2d)${NC}  %-15s ${CYAN_BOLD}[%s]${NC}\n" \
        "$((i+1))" "${dns_names[$i]}" "$(echo ${dns_values[$i]} | sed 's/ /, /g')"
done
echo ""
echo -e "    ${RED} 0)${NC}  EXIT"
echo ""

echo -ne "  ${YELLOW}Enter option: ${NC}"
read choice

if [[ "$choice" == "0" ]]; then
    clear
    exit 0
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#dns_names[@]} )); then
    echo ""
    echo -e "${RED}  Invalid option!${NC}"
    exit 1
fi

index=$((choice-1))
rm -f /etc/resolv.conf
{
    echo "# DNS: ${dns_names[$index]}"
    for ip in ${dns_values[$index]}; do
        echo "nameserver $ip"
    done
} > /etc/resolv.conf

echo ""
printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
printf "${CYAN_BOLD}%*s\n${NC}" "$cols" '' | tr ' ' '_'
echo ""
echo -e "${LIGHT_GREEN}$(center_text "${dns_names[$index]} DNS has been set successfully")${NC}"
echo ""
