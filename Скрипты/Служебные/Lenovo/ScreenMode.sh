#!/usr/bin/bash

# Максимальное разрешение системы, которое мы планируем использовать
max_res="1600x900"
# Минимальное разрешение системы
min_res="1024x768_60.00"
# Установить переменным монитор и проектор значения соответсвующие тому,
# как они подключены на вашем компьютере (исп. для просмотра: xrandr --query)
monitor=eDP-1
projector=HDMI-1

x_query=$(xrandr --query | grep "*" | awk '{print $1}')
all_display_res=($x_query)

for display_res in "${all_display_res[@]}"; do
  if [[ "$display_res" == "$max_res" ]]; then
    max_trigger=1
  fi
done

if [[ $max_trigger ]]; then
  # Из режима с максимальным разрешением перейти в минимальное
  xrandr --output $monitor --mode $min_res
  # Режим дублирования
  xrandr --output $monitor --output $projector --same-as $monitor
else
  # Из режима с минимальны разрешением перейти в максимальное
  xrandr --output $monitor --mode $max_res
  # Режим расширения
  xrandr --output $monitor --output $projector --right-of $monitor
fi
