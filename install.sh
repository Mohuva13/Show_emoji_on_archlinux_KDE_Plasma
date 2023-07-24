# Check this distrubution is Arch based or not
if [ -f /etc/arch-release ]; then
    echo "\n Solve emoji show on Arch Linux with KDE Plasma!"
else
    echo "\n This is not Arch based distribution"
    exit 1
fi


# Check desktop environment is KDE Plasma or not
if [ -f /usr/bin/plasmashell ]; then
    echo "\n ----------------------------------------------"
else
    echo "\n This is not KDE Plasma"
    exit 1
fi

# Check user has root permission or not
if [ "$EUID" -ne 0 ]; then
    echo "\n Please run as root"
    exit 1
fi

#Check Internet connection with DL Host
if ping -q -c 1 -W 1 archlinux.com >/dev/null; then
  loadingAnimation &
  sleep 1
  selfID=$!
  kill $selfID >/dev/null 2>&1
else
  echo "\n Please check your internet connection and try again."
  exit 1
fi

# Check user has installed noto-fonts-emoji or not
if pacman -Qi noto-fonts-emoji >/dev/null; then
    echo "\n noto-fonts-emoji is already installed"
else
    echo "\n Installing noto-fonts-emoji"
    pacman -S noto-fonts-emoji --noconfirm
fi

# ask user solve show emoji for all user or this user only
echo "\n Do you want to solve show emoji for all user or this user only?"
echo " 1. All user"
echo " 2. This user only"
read -p " Please enter your choice: " choice


if [ $choice -eq 1 ]; then
    config="$HOME/.config/fontconfig/fonts.conf"
elif [ $choice -eq 2 ]; then
    config="/etc/fonts/local.conf"
else
    echo "\n Invalid choice"
    exit 1
fi

# cp -r ./font_config.conf to $config
cp -r ./font_config.conf $config
if [ $? -eq 0 ]; then
    echo "\n Success"
else
    echo "\n Error"
    exit 1
fi

# Update font cache
fc-cache -f -v


echo "\n Success"
echo "\n Please logout or reboot to apply changes"
echo "\n ----------------------------------------------"
echo "\n"
echo "GitHub: Mohuva13"