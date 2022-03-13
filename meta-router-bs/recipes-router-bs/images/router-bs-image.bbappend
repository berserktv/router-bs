IMAGE_INSTALL += " \
                  base-files \
                  base-passwd \
                  busybox \
                  mtd-utils \
                  mtd-utils-ubifs \
                  libconfig \
                  ${@bb.utils.contains('SWUPDATE_INIT', 'tiny', 'virtual/initscripts-swupdate', 'initscripts sysvinit', d)} \
                  util-linux-sfdisk \
                  swupdate \
                  swupdate-www \
                 "
