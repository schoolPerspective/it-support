#!/usr/bin/bash

# Задайте имя и пароль для пользователя, который будет использоваться для проведения олимпиад
username=olimp
password=1234
sudo_username="$(who am i | awk '{print $1}')"


function installPackage {
# Функция проверки наличия и установки пакетов
if dnf list installed | grep "$1" > /dev/null; then
  echo "* Пакет $1 уже установлен!"
else
  echo "* Установка $1 из репозитория:"
  sudo dnf install -y $1
fi
}

function createShortcut {
# Функция создания ярлыка приложения
  sudo ln -s /usr/share/applications/"$1".desktop /home/$username/'Рабочий стол'/"$1".desktop
}


sudo -v
if [ $? -eq 0 ]; then
  # Установка ПО
  echo -e "\n\033[33m Установка ПО \n\033[37m"
  for var in wing-101 pycharm-community vscode gcc-c++ gdb codeblocks pascalabcnet yandex-browser java-17-openjdk-devel dotnet dotnet-sdk-6.0
  do
    installPackage $var
  done

  grep "$username" /etc/passwd >/dev/null
  if [ $? -eq 0 ]; then
    echo -e "\033[0m\n\033[0m\033[31m !!! - Внимание - !!!\n\033[37m"
    echo "Пользователь $username уже существует в системе! Выполнение скрипта будет прервано."
    exit
  fi

  # Создаем олимпиадного пользователя
  echo -e "\033[33m Работа с пользователями ОС \033[37m"
  sudo useradd $username
  echo "+ Пользователь $username успешно добавлен в систему!"
  echo $username:$password | sudo chpasswd
  echo "+ Пользователю $username задан пароль!"

  # Добавляем ярлыки на рабочий стол пользователя
  for var in rosa-tkinter3 wing-101-10 pycharm-community vscode codeblocks libreoffice-calc PascalABCNETLinux kumir2-classic yandex-browser
  do
    createShortcut $var
  done

  echo -e "\033[33m Установка расширений VS-Code для пользователя $username \n\033[37m"
  sudo code --install-extension ms-vscode.cpptools --extensions-dir /home/$username/.vscode/extensions --user-data-dir /home/$username/.vscode
  sudo code --install-extension ms-python.python --extensions-dir /home/$username/.vscode/extensions --user-data-dir /home/$username/.vscode
  sudo code --install-extension ms-dotnettools.csharp --extensions-dir /home/$username/.vscode/extensions --user-data-dir /home/$username/.vscode
  sudo code --install-extension vscjava.vscode-java-pack --extensions-dir /home/$username/.vscode/extensions --user-data-dir /home/$username/.vscode

  # Настройка ограничений в сети
  echo -e "\n\033[33m Конфигурация ограничений интернета \n\033[37m"
  sudo cp /etc/sysconfig/nftables.conf /etc/sysconfig/nftables.conf.bak
  sudo wget -O /etc/sysconfig/nftables.conf https://github.com/schoolPerspective/it-support/raw/refs/heads/main/%D0%9A%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D0%B8/nftables.conf

  echo -e "\033[0m\n\033[0m\033[31m !!! - Внимание - !!!\n\033[37m"
  echo "Скрипт завершил свою работу, для применения настроек блокировки интернет источников воспользуйтесь командой:"
  echo -e "\033[47m\033[30m фильтр_вкл \033[40m\033[37m"

  echo "alias фильтр_вкл='sudo systemctl enable --now nftables'" >> "/home/$sudo_username/.bashrc"
  echo "alias фильтр_откл='sudo systemctl disable --now nftables'" >> "/home/$sudo_username/.bashrc"

else
  echo -e "\033[0m\n\033[0m\033[31m !!! - Внимание - !!!\n\033[37m"
  echo "Используйте учетную запись с правами администратора!"
fi




