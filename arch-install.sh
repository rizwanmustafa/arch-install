# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Confirm boot mode
UEFI=$([ -d /sys/firmware/efi/efivars ] && echo "true" || echo "false")
echo -e "UEFI Boot Mode: $( [ "$UEFI"="true" ] && echo $GREEN || echo $RED )${UEFI}${NC}"

# Connect to the internet
while [ "$INTERNET" != true ]; do
    curl -s archlinux.org -o /dev/null
    if [ $? -eq 0 ]; then
        INTERNET="true"
        echo -e "Internet available: ${GREEN}true${NC}"
    else
        INTERNET="false"
        echo -e "Internet available: ${RED}false${NC}"
        echo -e "Executing: ip link\n"
        ip link
        echo -en "\nEthernet (E) / Wifi (W)? "
        read NET_CHOICE
        NET_CHOICE=${NET_CHOICE,,}
        if [ "$NET_CHOICE" = "w" ]; then
            echo "Executing: iwctl"
            iwctl
        else
            read -p "Press Enter after plugging in an ethernet cable... "
        fi
    fi
done;

timedatectl set-ntp true # Update the system clock
