#!/usr/bin/bash
#Скрипт для "установки" программ по английскому языку
#Spotlight в МОС


create_desktop() {
  path=$1
  num=${path: -1}

  if [[ -f "$path.exe" ]]; then
  cat >>"$HOME/Рабочий стол/SL$num.desktop"<<EOF
[Desktop Entry]
Name=Spotlight $num
Exec=wine "$path.exe"
Icon=$path.ico
Type=Application
Categories=Application;
EOF
  else
    echo "Нет файлов программы Spotlight, скопируйте файлы в каталог /opt"
    exit
  fi
}

paths=("/opt/Spotlight/2 interactive/SL2" "/opt/Spotlight/3 interactive/SL3" "/opt/Spotlight/4 interactive/SL4")
for path in "${paths[@]}"; do
  create_desktop "$path"
done

echo "Скрипт завершил свою работу!"
