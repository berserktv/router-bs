FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# config ntp servers
do_install_append() {
    echo "##### router-bs #####" >> ${D}/etc/ntp.conf
    echo "#https://www.pool.ntp.org/ru/use.html" >> ${D}/etc/ntp.conf
    echo "server 0.pool.ntp.org" >> ${D}/etc/ntp.conf
    echo "server 1.pool.ntp.org" >> ${D}/etc/ntp.conf
    echo "server 2.pool.ntp.org" >> ${D}/etc/ntp.conf
    echo "server 3.pool.ntp.org" >> ${D}/etc/ntp.conf
}