#!/usr/bin/bash

# Скрипт "установки" программы Imaginator
username=admin

sudo -v
if [ $? -eq 0 ]; then
  sudo mkdir /opt/imaginator/
  sudo wget -O /opt/imaginator/imaginator.py https://github.com/schoolPerspective/it-support/raw/refs/heads/main/%D0%9F%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B/imaginator.py
  sudo chmod +x /opt/imaginator/imaginator.py
  sudo wget -O /opt/imaginator/imaginator.png https://raw.githubusercontent.com/schoolPerspective/it-support/refs/heads/main/%D0%9F%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D1%8B/icon.png
  echo "
[Desktop Entry]
Name=Imaginator
Exec=python /opt/imaginator/imaginator.py
Type=Application
StartupNotify=true
Comment=Программа для склеивания изображений
Path=/opt/imaginator/
Icon=/opt/imaginator/imaginator.png" | sudo tee /home/"$username"/Рабочий\ стол/Imaginator.desktop >/dev/null



else
  echo "Используйте учетную запись с правами администратора!"
fi
