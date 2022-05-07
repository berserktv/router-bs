###https://stackoverflow.com/questions/58610052/how-to-get-thisdir-inside-do-unpack-append-in-bbappend-file
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append += " file://boot.cmd"
SAVED_DIR := "${THISDIR}/files"

do_unpack_append(){
    bb.build.exec_func('replace_file', d)
}

replace_file(){
    cp -f ${SAVED_DIR}/boot.cmd ${WORKDIR}/boot.cmd
}
