# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers
# Mosimchah for BlackScreen Kernel

properties() {
do.devicecheck=1
do.injection=1
do.cleanup=1
do.cleanuponabort=1
device.name1=le_zl1
device.name2=zl1
device.name3=pro3
device.name4=ZL1_CN
device.name5=ZL1_NA
}

block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
is_permissive=1;

. /tmp/anykernel/tools/ak2-core.sh;

chmod -R 755 $ramdisk

dump_boot;

ui_print "Modifying ramdisk contents...";

backup_file init.qcom.rc;
insert_line init.qcom.rc "blackscreen" after "import init.qcom.factory.rc" "import init.blackscreen.rc";

backup_file init.target.rc;
remove_line init.target.rc "wait /dev/block/bootdevice/by-name/cache";
remove_line init.target.rc "mount ext4 /dev/block/bootdevice/by-name/cache /cache nosuid nodev barrier=1";

backup_file fstab.qcom;
replace_file fstab.qcom "0640" fstab.patch;

write_boot;
