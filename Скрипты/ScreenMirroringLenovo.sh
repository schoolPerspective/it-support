#!/usr/bin/bash

username=user
mkdir /home/$username/Scripts

https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Robotics/Scratch.sh -P /home/$username/Scripts/

wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Lenovo/ScreenMirroring/projector.png -P /home/$username/Scripts/
wget https://github.com/schoolPerspective/it-support/raw/main/Скрипты/Служебные/Lenovo/ScreenMode.sh -P /home/$username/Scripts/
chmod +x /home/$username/Scripts/ScreenMode.sh


touch /home/$username/Рабочий\ стол/ScreenMode.desktop
echo "[Desktop Entry]
Name=Режим экрана
Exec=\"/home/${username}/Scripts/ScreenMode.sh\"
Icon=/home/${username}/Scripts/projector.png

Type=Application
Categories=Application;" | tee /home/$username/Рабочий\ стол/ScreenMode.desktop > /dev/null
