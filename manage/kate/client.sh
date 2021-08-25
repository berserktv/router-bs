#!/bin/bash

# Подключение к шлюзу для изменения конфигурации:
# аргументы скрипта
# arg1 - указание адреса шлюза
if [ -z "$1" ]; then
    echo "not arg1 => gateway ip address is not set, exit ..."
    exit 1
fi

CONF_DIR="tmp_etc"
IP_GATEWAY="$1"

CUR_DIR=`pwd`
CUR=`basename ${CUR_DIR}`

# 1) Монтирование конфигурацию шлюза в текущий каталог
test -d ${CONF_DIR} || mkdir ${CONF_DIR}
echo "sshfs root@${IP_GATEWAY}:/etc ${CONF_DIR}"
sshfs root@${IP_GATEWAY}:/etc ${CONF_DIR}

# 2) Запуск программ для редактирования конфигурации в редакторе kate или visual studio code
#    структуру можно посмотреть во вкладке Проекты (см. ${CONF_DIR}/.git)
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



