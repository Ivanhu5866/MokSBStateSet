MokSBStateset 
An UEFI application for disable shim validation by setting two UEFI variables MokSBState and MokSBStateRT

shim_dis_validation
for helping to run MokSBStateset automatically
1.disable secureboot on bios menu, because MokSBStateSet has been signed.
2.put the script and uefi application together
3.run the script with root privilge
  for example,
  # sudo ./shim_dis_validation /dev/sdb
4.after reboot, you could enable secureboot
