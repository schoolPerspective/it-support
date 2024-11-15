#!/usr/bin/bash

# Скрипт убирает из окна выбора принтера для печати все сетевые устройства,
# остаются только те, что были добавлены в систему

sudo -v
if [ $? -eq 0 ]; then
    # Делаем бекап файла конфигурации
    sudo cp /etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf.bak
    # Заменяем "use-ipv4=yes" на "use-ipv4=no"
    sudo sed -i 's/use-ipv4=yes/use-ipv4=no/' /etc/avahi/avahi-daemon.conf
    # Перезагрузка демона Avahi
    sudo systemctl restart avahi-daemon
    echo 'Скрипт успешно выполнен!'
else
  echo "Используйте учетную запись с правами администратора!"
fi
