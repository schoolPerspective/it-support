#!/usr/bin/bash
# Переключение смены расскладки на глобальную
kwriteconfig5 --file kxkbrc --group Layout --key SwitchMode --type string Global
# Включение NumLock в системе
kwriteconfig5 --file kcminputrc --group Keyboard --key NumLock --type int 0
# Отключение "Края экрана"
kwriteconfig5 --file kwinrc --group ElectricBorders --key TopLeft --delete
kwriteconfig5 --file kwinrc --group Windows --key ElectricBorders 0

# Настройка режимов работы электропитания
cp ~/.config/powermanagementprofilesrc ~/.config/powermanagementprofilesrc.bak
wget -O ~/.config/powermanagementprofilesrc https://github.com/schoolPerspective/it-support/raw/refs/heads/main/%D0%9A%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D0%B8/%D0%9E%D0%93%D0%AD/powermanagementprofilesrc

# Убираем лишнее с рабочего стола
rm -rf ~/Рабочий\ стол/Документация
rm -rf ~/Рабочий\ стол/mos-appstore.desktop

echo "Скрипт завершил свою работу!"
curr_file="$0"
rm -r "$curr_file"
