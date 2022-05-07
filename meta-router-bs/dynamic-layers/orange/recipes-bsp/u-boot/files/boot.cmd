# Default to (primary) SD
# Off for SWUpdate
# rootdev=mmcblk0p2
###if itest.b *0x28 == 0x02 ; then
#	# U-Boot loaded from eMMC or secondary SD so use it for rootfs too
#	echo "U-boot loaded from eMMC or secondary SD"
#	rootdev=mmcblk1p2
#fi

if env exists opipart;then echo Booting from mmcblk0p${opipart};else setenv opipart 2;echo opipart not set, default to ${opipart};fi

setenv bootargs console=${console} console=tty1 root=/dev/mmcblk0p${opipart} rootwait panic=10 ${extra}
load mmc 0:${opipart} ${fdt_addr_r} ${fdtfile} || load mmc 0:${opipart} ${fdt_addr_r} boot/${fdtfile}
load mmc 0:${opipart} ${kernel_addr_r} zImage || load mmc 0:${opipart} ${kernel_addr_r} boot/zImage || load mmc 0:${opipart} ${kernel_addr_r} uImage || load mmc 0:${opipart} ${kernel_addr_r} boot/uImage
bootz ${kernel_addr_r} - ${fdt_addr_r} || bootm ${kernel_addr_r} - ${fdt_addr_r}
