#!/bin/bash

IFS=$'\n'

# define ANSI color codes
COLOR_RESET='\e[0m'
COLOR_RED='\e[31m'
COLOR_YELLOW='\e[33m'
COLOR_GREEN='\e[32m'
COLOR_CYAN='\e[36m'

# function to print messages with color and type
print() {
    case "$2" in
        "info")
            echo -e "${COLOR_CYAN} $1 ${COLOR_RESET}"
            ;;
        "warning")
            echo -e "${COLOR_YELLOW} $1 ${COLOR_RESET}"
            ;;
        "error")
            echo -e "${COLOR_RED} $1 ${COLOR_RESET}"
            ;;
        "ok")
            echo -e "${COLOR_GREEN} $1 ${COLOR_RESET}"
            ;;
        *)
            echo -e "\t$1"
            ;;
    esac
}

# help function
help() {
    print "Those arguments are accepted: " "info"
    print " --enable  | -e : enables the nvidia gpu "
    print " --disable | -d : disables the nvidia gpu "
    print " --status  | -s : print the nvidia gpu status "
    print " --info    | -i : print the nvidia gpu info "
    print " --help    | -h : print help menu "
}

check_nvidia_gpu_status() {
    local commented_device
    commented_device=$(sed -n "/^\s*Section \"Screen\"/,/^EndSection/{/#\s*Device\s* \"$1\"/p}" "$XORG_CONFIG")
    if [[ -n $commented_device ]]; then
        print "Nvidia GPU is disabled." "warning"
        return 1  # Return false
    else
        print "Nvidia GPU is enabled." "ok"
        return 0  # Return true
    fi
}

# verify if the script was executed as root
if [ "$(id -u)" != "0" ]; then
    print "This script must be run with superuser privileges. Use 'sudo'." "error"
    exit 1
fi

# check x11 config file
XORG_CONFIG="/etc/X11/xorg.conf"
if ! [[ -f $XORG_CONFIG ]];then
    print "X11/xorg.conf not found" "error"
    exit 1
fi

# check nvidia device identifier
GPU_DEVICE=$(grep -B2 -E 'Driver\s+"nvidia"' "/etc/X11/xorg.conf" | grep "Identifier" | awk '{gsub(/"/, "", $2); print $2}')

if ! [[ -n $GPU_DEVICE ]];then
    print "Corespondent device for NVIDIA GPU was not found in $XORG_CONFIG." "error"
    exit 1
fi;


# extract the bus id of the nvidia board
NGPU=$(lspci | grep -i VGA | grep -i NVIDIA)

if [ -n "$NGPU" ]; then
    PCI=$(echo "$NGPU" | awk '{print $1}')
    NGPU_BUS_ID="0000:$PCI"
else
    print "Nvidia GPU not found." "error"
    exit 1
fi


ACTION=""
# check the command line arguments
if [[ $1 =~ ^(--enable|-e)$ ]]; then
    print "Enabling NVIDIA GPU..." "info"
    sed -i "/^\s*Section \"Screen\"/,/EndSection/ s/#//" $XORG_CONFIG
    ACTION="bind"
elif [[ $1 =~ ^(--disable|-d)$ ]]; then
    print "Disabling NVIDIA GPU..." "info"
    sed -i "/^\s*Section \"Screen\"/,/EndSection/ s/^\s*Device[[:space:]]*\"$GPU_DEVICE\"/#&/" $XORG_CONFIG
    ACTION="unbind"
elif [[ $1 =~ ^(--status|-s)$ ]]; then
    check_nvidia_gpu_status "$GPU_DEVICE"
elif [[ $1 =~ ^(--help|-h)$ ]]; then
    help
elif [[ $1 =~ ^(--info|-i)$ ]]; then
    nvidia-smi
else
    print "Invalid choice." "error"
    help
fi;

# e/d the nvidia gpu
if [[ -n $ACTION  ]]; then
    print "Your gnome session will be restarted in 5 seconds." "warning"
    sleep 5
    service gdm restart &
    echo -n $NGPU_BUS_ID > "/sys/bus/pci/drivers/nvidia/$ACTION";
fi;
