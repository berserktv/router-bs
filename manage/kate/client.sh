#!/usr/bin/env bash

# Подключение к шлюзу по протоколу sshfs для изменения конфигурации:
# Удаленная конфигурация шлюза (каталог /etc) монтируется в локальную файловую систему
# и открывается в удобном текстовом редакторе Visual Studio Code или Kate
# (в зависимости от каталога из которого запущен скрипт client.sh)

# общие переменные скрипта
source ../config.txt

# аргументы скрипта
# arg1 - первым аргументом можно задать адрес шлюза, иначе берется из config.txt
if [ -n "$1" ]; then
    IP_GATEWAY="$1"
fi

CUR_DIR=`pwd`
CUR=`basename ${CUR_DIR}`

# 1) Монтирование конфигурацию шлюза в текущий каталог
test -d ${CONF_DIR} || mkdir ${CONF_DIR}
echo "sshfs root@${IP_GATEWAY}:/etc ${CONF_DIR}"
sshfs root@${IP_GATEWAY}:/etc ${CONF_DIR}

# 2) Запуск программ для редактирования конфигурации в редакторе kate или visual studio code,
#    в Kate структуру можно посмотреть во вкладке Проекты (см. ${CONF_DIR}/.git)
if [ "${CUR}" == "kate" ] ; then kate ${CONF_DIR}/shorewall/shorewall.conf & fi
if [ "${CUR}" == "vscode" ] ; then code ${CONF_DIR}/shorewall & fi

echo "When you are done, unmount dir ${CONF_DIR}"
echo "Press any key to unmount and exit, wait ..."
read -n 1

echo "fusermount -u ${CONF_DIR}"
fusermount -u ${CONF_DIR}

if [ $? -ne 0 ]; then
    echo "The directory is in use => ${CONF_DIR}"
    echo "close applications using the directory"
    echo "run the command again"
    echo "fusermount -u ${CONF_DIR}"
else
    rmdir ${CONF_DIR}
fi



