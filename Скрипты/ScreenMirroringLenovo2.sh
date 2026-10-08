#!/usr/bin/bash

username=$(whoami)
mkdir /home/$username/Scripts

wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Lenovo/projector.png -P /home/$username/Scripts/
wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Lenovo/screenSwitcher.sh -P /home/$username/Scripts/
chmod +x /home/$username/Scripts/screenSwitcher.sh


touch /home/$username/Рабочий\ стол/ScreenMode.desktop
echo "[Desktop Entry]
Name=Режим экрана
Exec=\"/home/${username}/Scripts/screenSwitcher.sh\"
Icon=/home/${username}/Scripts/projector.png

Type=Application
Categories=Application;" | tee /home/$username/Рабочий\ стол/ScreenMode.desktop > /dev/null
