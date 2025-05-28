#!/usr/bin/bash

# Скрипт добавляет режим печати 2 картинок на одном листе бумаги
# для работы требуется установить пакет: sudo dnf install -y imagemagick

mkdir -p ~/.local/share/kservices5/ServiceMenus/
touch ~/.local/share/kservices5/ServiceMenus/multiprint.desktop
cat >>~/.local/share/kservices5/ServiceMenus/multiprint.desktop <<'EOF'
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=image/jpeg;image/png;image/gif;image/webp;
Actions=Print2Copies;

[Desktop Action Print2Copies]
Type=Application
Name=Печать 2 копии на листе
Icon=printer
Exec=~/.local/bin/multiprint-kde.sh %f
Terminal=false
MimeType=image/jpeg;image/png;
Categories=Utility;Printing;
EOF

mkdir -p  ~/.local/bin/
touch ~/.local/bin/multiprint-kde.sh
cat >>~/.local/bin/multiprint-kde.sh <<'EOF'
#!/bin/bash

# Явно задаем основные переменные окружения
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export HOME="/home/$USER"

# Полные пути к программам
CONVERT="/usr/bin/convert"
LP="/usr/bin/lp"
RM="/bin/rm"
DATE="/bin/date"

# Входной файл (первый аргумент)
input_file="$1"

# Уникальное имя временного файла
tmp_pdf="/tmp/multiprint_$($DATE +%s).pdf"

# Проверка наличия файла
if [ ! -f "$input_file" ]; then
    notify-send "Ошибка печати" "Файл $input_file не найден!"
    exit 1
fi

# Конвертация
if ! $CONVERT "$input_file" -duplicate 1 "$tmp_pdf"; then
    notify-send "Ошибка печати" "Не удалось обработать изображение"
    exit 2
fi

# Печать
if ! $LP -o number-up=2 -o fit-to-page "$tmp_pdf"; then
    notify-send "Ошибка печати" "Не удалось отправить на печать"
    $RM -f "$tmp_pdf"
    exit 3
fi

# Задержка перед удалением (чтобы успела начаться печать)
sleep 2
$RM -f "$tmp_pdf"

notify-send "Печать" "Задание отправлено на принтер"
EOF
chmod +x ~/.local/bin/multiprint-kde.sh

update-desktop-database ~/.local/share/applications
kbuildsycoca5

echo 'Успешно выполнено!'
