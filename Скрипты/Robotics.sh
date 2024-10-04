#!/usr/bin/bash

# Скрипт настраивает работу Lego роботов в МОС12
# Подставить вместо user имя пользователя, для которого будет выполнена настройка
username=user

# Scratch+Link
sudo dnf install libcap-utils -y
sudo dnf install python3-pyscrlink -y
sudo dnf install python3-pip -y
python3-pip install pyopenssl --upgrade
sudo dnf install scratch-desktop -y

sudo mkdir /home/$username/Scripts
sudo wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Robotics/Scratch.sh -P /home/$username/Scripts/
sudo wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Robotics/Scratch.png -P /home/$username/Scripts/
sudo chmod +x /home/$username/Scripts/Scratch.sh

sudo touch /home/$username/Рабочий\ стол/Scratch.desktop
echo "[Desktop Entry]
Name=Scratch
Exec=\"/home/${username}/Scripts/Scratch.sh\"
Icon=/home/${username}/Scripts/Scratch.png

Type=Application
Categories=Application;" | sudo tee /home/$username/Рабочий\ стол/Scratch.desktop > /dev/null

sudo bluepy_helper_cap

# Lego_EV3
sudo dnf install trik-studio -y
#gpasswd -a $username mindstormusers - Не актульно в МОС12

# Spike
gpasswd -a $username dialout
reboot
