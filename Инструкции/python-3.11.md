# Python 3.11 МОС12
## Информатика
**Метки:** python, python3, pip, библиотеки

Для некоторых проектов может потребоваться более актуальная версия Python, чем та, что доступна в МОС12 по-умолчанию, на момент написания заметки (06.05.2024) версия Python в МОС 3.8.13. Обновлять интерпретатор языка глобально в linux - плохая идея, могут сломаться системные зависимости, для такого обновления необходимо чтобы потрудились авторы дистрибутива РОСА. Но в МОС все же есть способ использовать более актуальную версию интерпретатора языка программирования, для этого необходимо выполнить установку командой: 
```
sudo dnf install python3.11
```
После чего интерпретатор можно будет вызывать командой:
```
/usr/libexec/python3.11
```
Для упрощения вызова новой версии, можно создать псевдоним, для этого в конец файла ~/.bashrc нужно добавить строку:
```
alias python3.11='/usr/libexec/python3.11'
```
и выполнить команду:
```
exec bash
```
После чего интерпретатор можно будет вызывать просто вводя `python3.11`.  
Рекомендую для проектов с Python 3.11 создавать venv окружения, для этого необходимо выполнить команду:
```
/usr/libexec/python3.11 -m venv <путь_к_проекту>
```
После чего работать с локальным интерпретатором для установки библиотек и запуска проекта, не забывайте выбрать нужны интерпретатор нажатием сочетания клавиш `Ctrl+Shift+P`, если вы работаете в VSCode.
