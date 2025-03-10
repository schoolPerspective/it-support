#!/bin/bash


xpad &
sleep 2

# Поиск окна xpad, ищем последнее, так как в моем дистрибутиве первые два процесса это вспомоготальные, не являющиеся заметкой
xpad_window=$(xdotool search --class "xpad" | tail -n 1)

# xdotool помогает работать с программами
xdotool windowactivate --sync $xpad_window type "Текст заметки"
xdotool key Return

# Дописываем еще текст
xdotool windowactivate --sync $xpad_window type "Дополнительный текст"
xdotool key Return

sleep 10 # Можешь что-то дописать сам

echo -e  "\033[33m Что было написано в заметку: \033[37m"
xdotool windowactivate --sync $xpad_window key Ctrl+a Ctrl+c
xclip -o -selection clipboard


