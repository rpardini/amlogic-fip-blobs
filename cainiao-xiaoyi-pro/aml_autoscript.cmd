# This bootcmd hijacking script is designed for the vendor U-Boot of CAINIAO XiaoYi Pro with Secure Boot enabled.
# It will only be executed once.

setenv bootcmd 'echo '**********run auto boot cmd**********'; run autobootcmd'

# autobootcmd:
# run regulator_cmd
# echo 'try boot from emmc'
# run try_emmc_bootcmd
# echo 'try boot from usb drive'
# if usb start; then
# 	run try_usbdrive_bootcmd
# fi
# echo 'fallback to vendor boot'
# run storeboot

setenv autobootcmd 'run regulator_cmd; echo 'try boot from emmc'; run try_emmc_bootcmd; echo 'try boot from usb drive'; if usb start; then run try_usbdrive_bootcmd; fi; echo 'fallback to vendor boot'; run storeboot'

setenv regulator_cmd 'gpio set GPIOA_0'

setenv try_emmc_bootcmd 'if fatload mmc 1 0x1000000 u-boot.bin.ext; then go 0x1000000; fi;    if fatload mmc 1 1020000 boot.scr; then setenv devtype mmc; setenv devnum 1; autoscr 1020000; fi'

setenv try_usbdrive_bootcmd 'for usbdevnum in 0 1 2 3; do if fatload usb ${usbdevnum} 0x1000000 u-boot.bin.ext; then go 0x1000000; fi;    if fatload usb ${usbdevnum} 1020000 boot.scr; then setenv devtype usb; setenv devnum $usbdevnum; autoscr 1020000; fi; done'

setenv upgrade_step 2

saveenv
echo "U-Boot env is set successfully, restart now!"
reboot

# Restore to default env:
# setenv bootcmd 'run storeboot'
# setenv upgrade_step 2
# env delete autobootcmd
# env delete regulator_cmd
# env delete try_emmc_bootcmd
# env delete try_usbdrive_bootcmd
# saveenv
# reboot

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/aml_autoscript.cmd /boot/aml_autoscript
