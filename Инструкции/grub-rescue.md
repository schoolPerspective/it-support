# >grub rescue
## Проблема с ОС
**Метки:** система, не стартует, не загружается, не запускается, загрузчик, grub, grub2

Иногда МОС12 может сломаться "на ровном месте" и отказываться загружаться, в таком случае есть способ загрузиться в систему, и восстановить ее работу.
1. Введите команду `ls`, строка вывода отобразит жесткие диски (логические разделы) обнаруженные в системе
2. с помощью `ls` посмотреть содержимое всех разделов, пока не найдете раздел, содержащий каталог `/boot`. Для того чтобы посмотреть содержимое каталога, обязательно вводите путь к диску с последним символом `/`,
в моем случае удалось просмотреть только один раздел (остальные не понятны для `grub`, по скольку не являются разделами linux). Пример команды:
```
ls (hd0,gpt6)/
```
По всей видимости, при использовании `btrfs` создается подкаталог, поэтому `boot` у меня хранится по такому пути:
`ls (hd0,gpt6)/01/boot/`

3. После того как вы нашли раздел необходимо задать переменные `root` и `prefix`, делается это так:
```
set root=(hd0,gpt6)
set prefix=(hd0,gpt6)/01/boot/grub2
```

Обратите внимание, в МОС12 нет каталога `grub`, есть только каталог `grub2`  

4. Выполните загрузку модуля ядра `normal` командой:
```
insmod normal
```
В случае возникновения ошибки на этом этапе, проверьте указанные вами ранее пути в переменных, если указать каталог не `grub2`, а несуществующий `grub`, средство восстановления не сможет найти модуль `normal`

5. После успешной загрузки модуля можно вызвать стандартное меню `grub2`, для этого воспользуйтесь командой:
```
normal
```
Будет загружено обычное меню grub2 и система запустится в штатном режиме, при условии, что она не была повреждена критически.
