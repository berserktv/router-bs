# Минималистический дистрибутив Linux, выполняющий функции "Маршрутизатора"
# для платформы Raspberry PI собранный в "Yocto Project",
# autor Alexander Demachev, site https://berserk.tv
DESCRIPTION = "The Router BS -  is a simple image to Raspberry PI platform"
LICENSE = "MIT"
MD5_MIT = "md5=0835ade698e0bcf8506ecda2f7b4f302"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;${MD5_MIT}"


# добавление нескольких стандартных пакетов в базовый образ
IMAGE_FEATURES += "ssh-server-openssh splash"

# Образ базируется на рецепте сборки содержащем минимальный набор пакетов
# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# Установка пароля по умолчанию для пользователя "root"
# - основная административная учетная запись в системе
# Set default password for 'root' user
inherit extrausers
ROOTUSERNAME = "root"
ROOTPASSWORD = "routerbs"
EXTRA_USERS_PARAMS = "usermod -P ${ROOTPASSWORD} ${ROOTUSERNAME};"

# стартовая заставка, которая выводиться во время загрузки,
# в случае подключения кабеля HDMI к монитору или к телевизору
SPLASH = "psplash-berserk"



###########################################################################
# набор установочных пакетов входящих в образ, разбитый на категории
###########################################################################

# отладочные пакеты
# ROUTER_DEBUG_TOOLS = "ldd strace ltrace"

# пакеты библиотеки libc входящие в образ, локализация,
# символьные таблицы для различных языков и т.п.
ROUTER_GLIBC = " \
            glibc-thread-db \
            glibc-gconv-utf-16 \
            glibc-gconv-utf-32 \
            glibc-gconv-koi8-r \
            glibc-gconv-cp1251 \
            glibc-gconv-ibm866 \
            glibc-binary-localedata-en-us \
            glibc-binary-localedata-ru-ru \
            glibc-binary-localedata-ru-ru.koi8-r \
            glibc-charmap-cp1251 \
            glibc-charmap-koi8-r \
            glibc-charmap-utf-8 \
            "

# базовые пакеты
ROUTER_BASE = " \
           procps \
           kernel-modules \
           lsb \
           pciutils \
           "

# сетевые пакеты и модули ядра
ROUTER_NET = "kernel-module-asix \
             "

# приложения входящие в образ
ROUTER_SOFT = " \
        mc \
        ntp \
        resolvconf \
        dhcp-server \
        init-ifupdown \
        shorewall \
        shorewall-doc \
        "


# указание всех дополнительных пакетов дистрибутива "Router-bs"
# Include modules in rootfs
IMAGE_INSTALL += " \
    ${ROUTER_BASE} \
    ${ROUTER_GLIBC} \
    ${ROUTER_NET} \
    ${ROUTER_SOFT} \
    "



#    ${ROUTER_DEBUG_TOOLS} \
#



    
