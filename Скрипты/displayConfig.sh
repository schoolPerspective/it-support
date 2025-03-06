#!/usr/bin/bash
# Скрипт для получения общих разрешений всех мониторов

getDisplayResolutions() {
    local display_name="$1"
    local resolution
    resolution=$(xrandr --query | awk -v display="$display_name" '
        $0 ~ display " connected" {flag=1; next}
        flag && /^[^ \t]/ {exit}
        flag {print $1}
    ')
    echo "$resolution"
}

# Получаем список активных экранов
active_displays=$(xrandr --listactivemonitors | awk '/^ / {print $4}')
displays_count=$(wc -w <<< "$active_displays")
if [ "$displays_count" -eq 1 ]; then
  echo -e  "\033[33m Ошибка: \033[37mобнаружен только один экран! Включите все экраны, для которых необходимо осуществить настройку"
  exit 1
fi

# Создаем временный файл для поиска общих разрешений
temp_file=temp_displays.txt
touch ./$temp_file

# Поиск общих разрешений
for display in $active_displays; do
  resolutions=$(getDisplayResolutions "$display")
  echo "$resolutions" >> "$temp_file"
done
common_resolutions=$(sort "$temp_file" | uniq -c | awk '$1 == '"$(echo "$active_displays" | wc -w)"' {print $2}')
rm -f "$temp_file"
mkdir -p ~/Scripts

if [ -z "$common_resolutions" ]; then
  echo -e "\033[33m Общих разрешений не обнаружено.\033[37m"
  main_display=$(xrandr --listactivemonitors | grep "*" | awk '{print $4}')
  check_exist=$(getDisplayResolutions "$main_display")
  target_resolution="1152x864" #XGA+
  if [[ "$check_exist" == *"$target_resolution"* ]]; then
    echo "У основного экрана уже существует конфигурация разрешения $target_resolution"
    echo -e "\033[33m Необходимо в ручном режиме подобрать оптимальное общее разрешение\033[37m"
    exit 1
  else
    echo "Для основного экрана будет создана конфигурация разрешения $target_resolution"
  cat >~/Scripts/setupDisplay.sh <<EOF
#!/usr/bin/bash

resolution="$target_resolution"
framerate=60 # При необходимости изменить
output="$main_display"
EOF
  cat >>~/Scripts/setupDisplay.sh <<'EOF'
display_mode="$(cvt ${resolution%x*} ${resolution#*x} $framerate | grep "Modeline" | sed 's/Modeline//' | sed 's/"//g')"
mode_name=$(echo "$display_mode" | awk '{print $1}')

xrandr --newmode $display_mode
xrandr --addmode $output "$mode_name"
xrandr --output $output --mode "$mode_name"
EOF
  chmod +x ~/Scripts/setupDisplay.sh
  # Конфигурацию xrandr необходимо добавить в автозапуск
  cat >~/.config/autostart/setupDisplay.sh.desktop <<EOF
[Desktop Entry]
Exec=/home/$USER/Scripts/setupDisplay.sh
Icon=dialog-scripts
Name=setupDisplay.sh
Type=Application
X-KDE-AutostartScript=true
EOF
  bash ~/Scripts/setupDisplay.sh
  mirror_resolution="$target_resolution" # Зеркалирование будет осуществляться с этим разрешением
  fi
else
  echo -e "\033[33m Общие разрешения для всех мониторов:\033[37m"
  echo "$common_resolutions"
  read -r mirror_resolution _ <<< "$common_resolutions"
  echo -e "Для зеркалирования будет использоваться: \033[33m$mirror_resolution\033[37m"
fi

main_display=$(xrandr --listactivemonitors | grep "*" | awk '{print $4}')
resolutions=$(getDisplayResolutions "$main_display")
read -r main_max _ <<< "$resolutions"
secondary_displays=($(xrandr --listactivemonitors | grep -v "*" | awk '{print $4}'))

# Скрипт дублирования для случаев, когда разрешение главного экрана
# совпадает с общим разрешением всех экранов системы
if [[ "$main_max" == "$mirror_resolution" ]]; then
  cat >~/Scripts/ScreenMode.sh << 'EOF'
#!/usr/bin/bash

main_display=$(xrandr --listactivemonitors | grep "*" | awk '{print $4}')
secondary_displays=($(xrandr | grep " connected " | awk '{ print$1 }' | grep -v "$main_display"))

for display in $secondary_displays; do
  if xrandr | grep "$display connected" | grep -q "[0-9]\+x[0-9]\++"; then
    xrandr --output $display --off
  else
   xrandr --output $display --mode "$(xrandr --query | grep "*" | awk '{print $1}')" --rate 60 --same-as $main_display
  fi
done
EOF
else
 cat >~/Scripts/ScreenMode.sh << EOF
#!/usr/bin/bash

# Максимальное разрешение системы, которое мы планируем использовать
main_max_resolution="$main_max"
# Минимальное разрешение системы
common_resolution="$mirror_resolution"
# Установить переменным монитор и проектор значения соответсвующие тому,
# как они подключены на вашем компьютере (исп. для просмотра: xrandr --query)
EOF
cat >>~/Scripts/ScreenMode.sh << 'EOF'
main_display=$(xrandr --listactivemonitors | grep "*" | awk '{print $4}')
secondary_displays=($(xrandr | grep " connected " | awk '{ print$1 }' | grep -v "$main_display"))
current_main_res=$(xrandr --query | grep "*" | awk '{print $1}')
display_mode="$(cvt ${common_resolution%x*} ${common_resolution#*x} $framerate | grep "Modeline" | sed 's/Modeline//' | sed 's/"//g')"
mode_name=$(echo "$display_mode" | awk '{print $1}')

if [[ "$current_main_res" == "$main_max_resolution" ]]; then
  # Перевести главный экран в режим совместимого разрешения
  xrandr --output $main_display --mode $mode_name
  for display in $secondary_displays; do
    xrandr --addmode $display $mode_name
    xrandr --output $display --mode $mode_name --rate 60 --same-as $main_display
  done
else
  # Из режима с минимальны разрешением перейти в максимальное
  xrandr --output $main_display --mode $main_max_resolution
  for display in $secondary_displays; do
    xrandr --output $display --off
  done
fi
EOF
fi
chmod +x /home/$USER/Scripts/ScreenMode.sh

# Base64-кодированное изображение для ярлыка скрипта
IMAGE_BASE64="iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAA
81BMVEUAAADYwp3e1cGFlqLy0Z28ytT+zoX+zoXO3OP+zoWJmaX+zoWfrLrD0NqfrLqOnal8jpr+
zoXW5OmWpLL+zoX+zoWNnKjM2uJ7jZn+zoXG1N7Z5+yNnKj+zoV7jJh6jJjT4ejG1N7+zoWfrLqP
nqv+zoWNnKj+zoXb6e7Z6O3X5evT4efN2+L+zoXI1t/F093Azta6yNGywMqrusOntMCgrrufrLqe
q7mbqbWUo7DFiZCNnKiKmaabj5l1mLKElJ+xgId/kJrBcnh6i5dQjrrpUVFwgY1neYM6gbVgc31b
bnhZbHZYbHZYa3UZdLcHecgGa7dx3YT/AAAAKHRSTlMABhAWHy40QUlRUGNpam9vcHh8i5Gjo6iq
t8PH0trb2uTp6urq8vT5n12iyQAAA/ZJREFUeNrtmG1Xm0oUhQExao22xuZ6bfReTW0b3gKEIERo
MCUNThDr//81Hc6A00mXEIi2X3g+uMzStTfn7DPMTLiGhoaGhoYGTGtf5F4T8Vx7/7oFfNJO+cbg
zxkILX4tA1Hk6+l3+0f8GgbiaX+/3kj2tU975QZ8V6s5uvx7TTsXSw32v2j9nZqr6lTTunyJQetc
0464muz0tS/7rFx/xVLAD3EqcHU5wk1qMW076raK/6OckufjC2qsAXS4NKX6wIyci4UtFLmN4LtY
osC+v8dtiLDXom7CNkakofA7Oy/4ZtrtnPQuLoaXlx9ODrZ57oXZ7vRkaSBhFGWo65cnBwL3ggid
C0mSsTr8lFVsoX/Y5Z+Jbbt9WJGDXqado6h6WsUh5S3wBnsKxx+vKzJScu0BkHqpOsYcX+e4Ew/z
+XiLO76uipmry6pp2a5tGUruYPzi4KX4x1z158/0FdNboDhJkhiFri5Jqw4TcLjiqupbigQYAcLa
ADaJXJU4mDY1ADiHpUx/rJJ8rQirU5I4NOShjhmtGixYZm6xgUH0bZTELMnCVPSUscMaJCxLzy6Q
d7IGjZdUH2IAByNrEmuwZIkmdnkBZpRQdbSYLcAvmQ31FMthDDyWSXECUIAyy/TvYxQtLEVWbXQf
Y2xwMGFKb759uwUDe4UifYeM6GgZE1AYeCass0lCmpSPqnPzHfO18hQZkHBeQBR4ngs1DUwUkxLy
HhGDqlNkw4zqEQk11fcckrqOSAp6PqnOze3t16pT5EAEAysmhJAZeA5GS+JpPoVg15gix4IIXFIA
8kEABlf1slBGT4PqTqd+pSmiGXtZhzzC2NBNJyC5L600BAMbTH88PN75FaaIGsh+tq68XwgQMRhn
Bs78x+Pj47R4isoroPxewd3DA6lgwRK61+tlcI8zoISrGdjOxPc2n6IcP0qYKar5LrKZdRCjgCmA
WQf2ZH53N682RXQlB3QlA34ICTArGUIONnwXJWgR+H4QRvCZvouwBhg8wBT5LOu/TYElQih++mTT
Pc2dzuezl9gP7vPf6H4wdiCvzXY0dsfMGzQkQ7rJnuyU7MmwG7AGq6O4/qkiWTlVKDQBxqAazrPn
Ipk2iDGofbKT85PdEoWOLsnPnOzqnE2zGgZSejZ17FHh2bTm6Vpa+3QN94N2+2yS4vmYq8N2GQc9
WWKAfI1O+/Aq1wmCM3w/oDerf7yUIMT8v7XmDYe9fsANZ+sMdGYh5l+Owhj8BwZliJ2eQrJWVLij
7QocxxrwdQ3YW+YlvWUWGFRqEYUXROaeXNCit58Z57rw8KA+6Lxj//IGZ/4OgALqsvWkgy+YrwLf
fJ3f0NDQ0PBX+AkBcuZ+9/xosQAAAABJRU5ErkJggg=="
echo "$IMAGE_BASE64" | base64 --decode > /home/$USER/Scripts/projector.png

# Создаем ярлык "Дублирование экрана"
touch /home/$USER/Рабочий\ стол/ScreenMode.desktop
echo "[Desktop Entry]
Name=Режим экрана
Exec=\"/home/$USER/Scripts/ScreenMode.sh\"
Icon=/home/$USER/Scripts/projector.png

Type=Application
Categories=Application;" | tee /home/$USER/Рабочий\ стол/ScreenMode.desktop > /dev/null
