#!/usr/bin/bash

#Создаем файл со скриптом
mkdir ~/Scripts
cat >~/Scripts/displayScrips.sh <<EOL
#!/usr/bin/bash

xrandr --newmode "1024x768_60.00"   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync
xrandr --addmode eDP-1 1024x768_60.00
xrandr --output eDP-1 --mode 1024x768_60.00
EOL
chmod +x ~/Scripts/displayScrips.sh

#Прописываем его в автозапуск
cat >~/.config/autostart/displayScrips.sh.desktop <<EOL
[Desktop Entry]
Exec=/home/user/Scripts/displayScrips.sh
Icon=dialog-scripts
Name=displayScrips.sh
Type=Application
X-KDE-AutostartScript=true
EOL

echo "Скрипт успешно завершил свою работу!"


