LICENSE = "GPL"
LIC_F = "file://${COREBASE}/meta/files/common-licenses/GPL-1.0"
SUM_F = "md5=e9e36a9de734199567a4d769498f743d"
LIC_FILES_CHKSUM = "${LIC_F};${SUM_F}"

SUB_PR = ".3"
require shorewall.inc
# this version (4.4) requires some deps (perl)
require shorewall-deps.inc

S = "${WORKDIR}/${PN}-${PV}${SUB_PR}"

# запуск стартового скрипта /etc/init.d/shorewall на определенном уровне исполнения
# последовательность запуска, перед сервисом ssh и dhcp
###inherit update-rc.d
###INITSCRIPT_NAME = "shorewall"
###INITSCRIPT_PARAMS = "start 08 2 3 4 5 . stop 92 0 6 1 ."

inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "shorewall.service"

PR = "${INC_PR}.0"
SRC_URI = "\
    http://www.shorewall.net/pub/shorewall/4.4/shorewall-${PV}/${PN}-${PV}${SUB_PR}.tar.bz2 \
    file://zones \
    file://interfaces \
    file://policy \
    file://masq \
    file://rules \
    file://routestopped \
    file://shorewall.conf \
    file://systemd/shorewall.service \
    file://systemd/etc-default-shorewall \
    "


# отключаю секцию do_compile, так как /sbin/shorewall является исполняемым скриптом
# и не требует компиляции
do_compile[noexec] = "1"

SRC_URI[md5sum] = "9f0ef6b547526aa33e34941a211ca602"
SRC_URI[sha256sum] = "1f95a04af2cbdd3449aa6fb26ea1b001e7cccd1ad4ed6d7ed8648247ae5d09bb"


do_install_append () {

    install -m 0644 ${WORKDIR}/zones ${D}${sysconfdir}/shorewall/zones
    install -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/shorewall/interfaces
    install -m 0644 ${WORKDIR}/policy ${D}${sysconfdir}/shorewall/policy
    install -m 0644 ${WORKDIR}/masq ${D}${sysconfdir}/shorewall/masq
    install -m 0644 ${WORKDIR}/rules ${D}${sysconfdir}/shorewall/rules
    install -m 0644 ${WORKDIR}/routestopped ${D}${sysconfdir}/shorewall/routestopped
    install -m 0644 ${WORKDIR}/shorewall.conf ${D}${sysconfdir}/shorewall/shorewall.conf

    # дополнительно устанавливаю примеры конфигураций брандмауэра
    install -d ${D}${docdir}/shorewall/examples
    cp -R ${S}/Samples/* ${D}${docdir}/shorewall/examples/

    # файлы для запуска сервиса под управлением systemd
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/systemd/etc-default-shorewall ${D}${sysconfdir}/default/shorewall
    install -m 0644 ${WORKDIR}/systemd/shorewall.service ${D}${systemd_unitdir}/system
}
