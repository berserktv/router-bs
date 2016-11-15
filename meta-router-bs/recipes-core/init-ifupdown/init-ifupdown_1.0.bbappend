FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://interfaces-router"

do_configure_append() {
    # заменяю скрипт /etc/network/interfaces
    install -d ${D}/etc/network
    install -m 0644 ${WORKDIR}/interfaces-router ${WORKDIR}/interfaces
}
