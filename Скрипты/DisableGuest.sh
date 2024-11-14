#!/usr/bin/bash

# Скрипт отключает кнопки авторизации под гостевым пользователем

sudo -v
if [ $? -eq 0 ]; then
sudo sed -i '/# Hidden users/{
  /^HideUsers=guest/b
  a\HideUsers=guest
}' /etc/sddm.conf.d/50-default.conf
  sudo sed -i 's/#guest-enabled=true/guest-enabled=false/g' /etc/mos-auth/mos-auth.conf
  echo "Выполнение завершено!"
else
  echo "Используйте учетную запись с правами администратора!"
fi
