#!/usr/bin/bash

# Скрипт создает конфигурационный файл alsa,
# решает проблему функционирования микрофона в МОС 12\Rosa Linux на ноутбуках Ancomp A15-501

sudo -v
if [ $? -eq 0 ]; then
  sudo touch /etc/modprobe.d/alsa-base.conf
  echo "options snd_soc_sof_8336 quirk=0x01" | sudo tee /etc/modprobe.d/alsa-base.conf >/dev/null
  echo "Выполнение завершено! Подключите любое устройство в jack 3.5"
else
  echo "Используйте учетную запись с правами администратора!"
fi


