# дополнительный параметры конфигурации описываются в router-extra.cfg
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://router-extra.cfg"

# в BSP слое meta-raspberrypi не работают фрагменты конфигураций
# https://github.com/agherzan/meta-raspberrypi/issues/14
# поэтому делаю напрямую
# в методе do_kernel_configme конфигурация ядра копируется из базы архитектур arch/ в рабочий каталог
do_kernel_configme_append() {
    cat ${WORKDIR}/router-extra.cfg >> ${WORKDIR}/defconfig
}

