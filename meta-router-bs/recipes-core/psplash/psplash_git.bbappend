FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://psplash-berserk-img.h"

do_configure_prepend() {
    # заменяю картинку из рецепта meta-raspberrypi/recipes-core/psplash
    install -m 0644 ${WORKDIR}/psplash-berserk-img.h ${WORKDIR}/psplash-raspberrypi-img.h
}