#!/bin/bash

TMPBIN=tmp.bin
BIN=MokSBStateSet.efi
TARBIN=/boot/efi/EFI/ubuntu/MokSBStateSet.efi

if [ "$(id -u)" -ne 0 ]; then
  echo "Need root privilege."
  exit 1
fi

if [ ! -f $BIN ]; then
	echo "Cannot find $BIN"
	exit 1
fi

cp -f $BIN $TARBIN || exit $?

# Check and delete if disable_shim_valid set already
BOOTNUM=`efibootmgr -v | grep 'disable_shim_valid' | cut -d ' ' -f1 | tr -d [BootOOT*]`
if [ "$BOOTNUM" != "" ]; then
	echo "delete existing disable_shim_valid path"
	efibootmgr -B $BOOTNUM -b $BOOTNUM
fi

BOOTORDER=`efibootmgr -v | grep 'BootOrder' | cut -d ' ' -f2`

if [ "${1}" != "" ]; then
	echo "set boot path with device ${1}"
	efibootmgr -c -d ${1} -L disable_shim_valid -l "\EFI\Ubuntu\MokSBStateSet.efi" > /dev/null 2>&1
else
	efibootmgr -c -L disable_shim_valid -l "\EFI\Ubuntu\MokSBStateSet.efi" > /dev/null 2>&1
fi

efibootmgr -o $BOOTORDER

# Check and set bootnext
BOOTNUM=`efibootmgr -v | grep 'disable_shim_valid' | cut -d ' ' -f1 | tr -d [BootOOT*]`

efibootmgr -n $BOOTNUM | grep "BootNext: $BOOTNUM" > /dev/null 2>&1 || exit $?

#echo $BOOTNUM

#reboot
