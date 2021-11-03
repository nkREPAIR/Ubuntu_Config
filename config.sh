# System Updates
sudo apt update && sudo apt upgrade -y && flatpak update -y

# Wine Config
sudo dpkg --add-architecture i386

# Boot Optimize ===================================================================================

# ModemManager
:'
DBus-activated daemon that controls mobile broadband (2G/3G/4G) interfaces
'

# If there is no mobile broadband interface, then it is unnecessary
sudo systemctl disable ModemManager.service
sudo systemctl mask ModemManager.service

# Plymouth
sudo kernelstub --delete-options "quiet systemd.show_status=false splash"

# Apport, stores sensitive data
sudo systemctl disable apport.service
sudo systemctl mask apport.service

# Apt-daily-upgrade solves long boot up time with apt-daily-upgrade
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service


:'
 Systemd-resolved [Restart Required] is a system service that provides network name resolution to
local applications. It implements a caching and validating DNS/DNSSEC stub resolver.
'
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo systemctl mask systemd-resolved.service

#
sudo rm /etc/resolv.conf

# System76 Power (Only Needed For Laptops)
sudo systemctl disable system76-power.service
sudo systemctl mask system76-power.service

# RAM Optimize ====================================================================================
: '
Swap space is area on a disk where the contents of RAM can be dumped. The value assigned is the
empty RAM to hit before swapping.
Default is 60% so the RAM usage must be at 40% before swapping takes place
General Ratio: 32:0, 16:10, 8:20, 4:50, 2:70, 1:90
'
sudo sysctl vm.swappiness=10

# Cache Pressure
:'
General Ratio: 1:100, 2:90, 4:80, 8:60, 16:50 32, 40
'
sudo sysctl vm.vfs_cache_pressure=40

sudo nano /etc/sysctl.conf

# Early OOM
:'
Frees memory when the ram or the swap gets close to full (over 90%). Beneficial feature for heavy
usage. Very important feature for old hardware and only consumes 0.5 to 2 MB in the background. 
'
#sudo apt install earlyoom -y

# QoL =============================================================================================

# Disables <Super>+P 
:'
Pop!_OS has a lot of keyboard shortcuts and I find this shortcut annoying since I do not often need
to switch monitor at my desktop. 
One of these 3 work
'

sudo dconf write /org/gnome/settings-daemon/plugins/media-keys/video-out ''
sudo dconf write /org/gnome/settings-daemon/plugins/media-keys/screenshot ''
sudo dconf write /org/gnome/mutter/keybindings//switch monitor ''

# Package Install =================================================================================
# Reads text file for deb pkgs and installs them
xargs sudo apt-get install <pkg_deb.txt -y

# Reads text file for flatpak pkgs and installs them
xargs flatpak install flathub <pkg_flakpak.txt -y

# Reads text file for deb pkgs and purges them
xargs sudo apt purge <pkg_remove.txt -y

# Final Clean =====================================================================================
sudo apt --purge autoremove
sudo rm -rf ~/.cache/thumbnails/*
sudo apt clean
sudo apt autoclean

