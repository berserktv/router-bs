#!/bin/bash

# скрипт предназначен для загрузки среды сборки дистрибутива "Router-bs" для
# одноплатного компьютера "Raspberry Pi", autor "Alexander Demachev", site berserk.tv
#
# система сборки "poky" устанавливается в каталог выше
# скрипт должен запускаться под обычным пользователем,
# но в начале выполнения требует установку пакетов через команду "sudo"
#
# cоздание дистрибутива Linux "Router-bs" для встраиваемых систем осуществляется
# с помощью Yocto Project
# Poky – это эталонная система сборки в рамках проекта Yocto Project.
# Она включает в себя BitBake, OpenEmbedded-Core, пакет поддержки платформы
# Board Support Package, BSP), а также прочие пакеты и компоненты,
# объединенные в единую сборку.


SYSTEM_BUILD="poky-router"
META_ROUTER="meta-router-bs"

BBLAYERS_CONFIG="build/conf/bblayers.conf"
LOCAL_CONFIG="build/conf/local.conf"
CONFIG_MACHINE="raspberrypi2"
TYPE_PACKAGE="deb"

# версия "yocto-project" выбраная в качестве базовой, ветка krogoth от 11 октября 2016
GIT_YOCTO="git://git.yoctoproject.org/poky.git"
REV_YOCTO="40f4a6d075236265086cc79400dea3c14720383a"


DIR_RASPBERRYPI="meta-raspberrypi"
GIT_RASPBERRYPI="http://git.yoctoproject.org/cgit/cgit.cgi/$DIR_RASPBERRYPI"
# перешел на ветку krogoth от 16 сентября 2016
REV_RASPBERRYPI="a5f9b07a820d50ae5fb62e07306cd4e72d8638a9"



get_git_project() {
    local git_path="$1"
    local git_rev="$2"
    local project_dir="$3"
    local cur_dir=`pwd`
    
    git clone --no-checkout $git_path $project_dir
    
    cd $project_dir
    git checkout $git_rev
    cd $cur_dir
}


sudo apt-get install -y --no-install-suggests --no-install-recommends \
     sed wget subversion git-core coreutils \
     unzip texi2html texinfo libsdl1.2-dev docbook-utils fop gawk \
     python-pysqlite2 diffstat make gcc build-essential xsltproc \
     g++ desktop-file-utils chrpath libgl1-mesa-dev libglu1-mesa-dev \
     autoconf automake groff libtool xterm libxml-parser-perl
     

old_dir=`pwd`
cd ..


get_git_project "$GIT_YOCTO" "$REV_YOCTO" "$SYSTEM_BUILD"

cd $SYSTEM_BUILD
poky_dir=`pwd`
get_git_project "$GIT_RASPBERRYPI" "$REV_RASPBERRYPI" "$DIR_RASPBERRYPI"


#####################################################################
# инициализация переменных Yocto Project
#####################################################################
source oe-init-build-env ""
cd $poky_dir
# создаем символическую ссылку на слой сборки дистрибутива "Router-bs"
ln -v -s $old_dir/$META_ROUTER $META_ROUTER


# изменение настроек по умолчанию в конфигурационном файле системы сборки "Poky"
# добавление собственного слоя в список слоев BBLAYERS
# и добавление слоя сборки для "Raspberry Pi"
sed -i "s|meta-yocto-bsp.*|&\n  $poky_dir/$META_ROUTER \\\|g" $BBLAYERS_CONFIG
sed -i "s|meta-yocto-bsp.*|&\n  $poky_dir/$DIR_RASPBERRYPI \\\|g" $BBLAYERS_CONFIG
sed -i "s|MACHINE ??=.*|MACHINE ??= \"$CONFIG_MACHINE\"|" $LOCAL_CONFIG

# тип бинарных пакетов для установки ПО 
F="PACKAGE_CLASSES ?= \"package_rpm\""
R="PACKAGE_CLASSES ?= \"package_$TYPE_PACKAGE\""
sed -i "s|$F|$R|" $LOCAL_CONFIG

# разрешаем использовать коммерческую лицензию для возможности сборки
# некоторых библиотек, например libdav"
echo "LICENSE_FLAGS_WHITELIST = \"commercial\"" >> $LOCAL_CONFIG
