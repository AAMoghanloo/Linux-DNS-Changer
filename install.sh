#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[38;5;35m'
YELLOW='\033[1;33m'
CYAN_BOLD="\e[36m\e[1m"
NC='\033[0m' # No Color

# --- Configuration ---
SCRIPT_URL="https://raw.githubusercontent.com/aamoghanloo/linux-dns-changer/main/dns.sh"
INSTALL_PATH="/usr/local/bin/dns"
TEMP_FILE="/tmp/dns_script_download_$$.sh" # Use $$ for a unique temp file

echo -e "${CYAN_BOLD}✨ Starting DNS Changer script installation...${NC}"

# 1. Download the main script (dns.sh)
echo -e "${YELLOW}⬇️ Downloading script from GitHub: ${SCRIPT_URL}${NC}"
if curl -Ls "${SCRIPT_URL}" -o "${TEMP_FILE}"; then
    echo -e "${GREEN}✅ Download successful.${NC}"
else
    echo -e "${RED}❌ ERROR: Failed to download the script. Please check the URL and your connection.${NC}"
    exit 1
fi

# 2. Grant execution permission
echo -e "${YELLOW}🔑 Setting executable permissions for the script...${NC}"
chmod +x "${TEMP_FILE}"

# 3. Install to an executable path (Requires sudo)
echo -e "${YELLOW}🔄 Copying script to ${CYAN_BOLD}${INSTALL_PATH}${YELLOW}... (Requires sudo)${NC}"

# Check if we have sudo rights
if ! command -v sudo &> /dev/null; then
    echo -e "${RED}❌ ERROR: 'sudo' command not found. Cannot install to ${INSTALL_PATH}.${NC}"
    exit 1
fi

# Move the temporary file to the installation path
if sudo mv "${TEMP_FILE}" "${INSTALL_PATH}"; then
    echo -e "${LIGHT_GREEN}✅ Installation successful! The script is now available as 'dns'.${NC}"
    echo -e "${CYAN_BOLD}---${NC}"
    echo -e "${LIGHT_GREEN}🎉 Installation Complete! 🎉${NC}"
    echo -e "${YELLOW}You can now run the DNS changer using the command:${NC}"
    echo -e "${CYAN_BOLD}    $ dns${NC}"
    echo -e "${CYAN_BOLD}---${NC}"
else
    echo -e "${RED}❌ ERROR: Failed to copy the script to ${INSTALL_PATH}.${NC}"
    echo -e "${RED}    Check if you have the necessary permissions or if the path exists.${NC}"
    # Clean up temp file if the move failed
    if [ -f "${TEMP_FILE}" ]; then
        rm "${TEMP_FILE}"
    fi
    exit 1
fi
