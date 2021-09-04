# подменяю конфигурационный файл
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# включаю запуск через systemd
SYSTEMD_AUTO_ENABLE = "enable"

SRC_URI += " \
    file://kea-dhcp4.conf \
"

FILES_${PN} += " \
    ${sysconfdir}/kea/kea-dhcp4.conf \
"

do_install_append() {
    install -d ${D}${sysconfdir}/kea
    install -m 0644 ${WORKDIR}/kea-dhcp4.conf ${D}${sysconfdir}/kea
}
