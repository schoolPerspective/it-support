#!/bin/bash

# Замените SOURCE и DESTINATION на пути к вашим дискам
SOURCE="/media/user/56A5-9479"
DESTINATION="/media/user/2076181A5A4D890E"

# Синхронизация с сохранением структуры каталогов, копированием только отличающихся файлов и сохранением атрибутов
rsync -s -av --delete --progress $SOURCE/ $DESTINATION/
