do_install_append() {
    # Uncomment the following to stop low-level messages on console
    # Default => kernel.printk = 4 4 1 7
    # console_loglevel default_message_loglevel minimum_console_loglevel default_console_loglevel
    COMM1="### router-bs ###\n"
    COMM2="### turn off kernel mess shorewall for tty consoles\n"
    VAL="kernel.printk = 3 4 1 7"
    sed -i "s|#kernel.printk.*|&\n${COMM1}${COMM2}${VAL}|" ${D}/etc/sysctl.conf
}
