#!/usr/bin/bash

# Скрипт возращает в окна выбора принтера для печати все сетевые устройства
FILE="/etc/avahi/avahi-daemon.conf.bak"
sudo -v
if [ $? -eq 0 ]; then
    # Возращаем конфигурацию из бэкапа
    if [ ! -f "$FILE" ]; then
        # Если бэкап был утрачен, скачать его с гитхаба
        sudo wget -O /etc/avahi/avahi-daemon.conf https://github.com/schoolPerspective/it-support/raw/refs/heads/main/%D0%9A%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D0%B8/avahi-daemon.conf
    else
        sudo mv -f /etc/avahi/avahi-daemon.conf.bak /etc/avahi/avahi-daemon.conf
    fi

    # Перезагрузка демона Avahi
    sudo systemctl restart avahi-daemon
    if [ $? -eq 0 ]; then
        echo 'Скрипт успешно выполнен!'
    fi
else
  echo "Используйте учетную запись с правами администратора!"
fi
