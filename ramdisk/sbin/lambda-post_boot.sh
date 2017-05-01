#!/system/bin/sh
#
# Copyright - Ícaro Hoff <icarohoff@gmail.com>
#
#              \
#              /\
#             /  \
#            /    \
#
# Lambda Kernel Tuning - "lkt"
#
# NOTE: Change the post-boot to be binary based for zsh/bash.
# TODO: Use 'source' to indicate a global configuration that
# can have the 'global tunables'.
# Add arguments to allow changing those tunables from the binary
# itself. E.g.: 'lkt fine' will come up with the main options for tuning.

# Global tunables for customization.
char=λ
iosched=cfq
readahead=256
gpupwrlvl=7

# Message the kmsg device to indicate this script has run.
echo "[$char] Entering speed-space dimension..." | tee /dev/kmsg

# Show we'll be doing something pretty neat.
echo "[$char] Fine tuning Kernel parameters..."

# Set the read-ahead value for all MMC blocks.
for block_device in /sys/block/*
do
	echo "$readahead" > $block_device/queue/read_ahead_kb
done

# Switch the I/O scheduler for all MMC blocks.
echo "$iosched" > /sys/block/sda/queue/scheduler
echo "$iosched" > /sys/block/sde/queue/scheduler

# If encrypted, switch the DM blocks' I/O scheduler as well.
if [ "$(getprop ro.crypto.state)" = "encrypted" ]; then
	echo "$iosched" > /sys/block/dm-0/queue/scheduler
	echo "$iosched" > /sys/block/dm-1/queue/scheduler
fi;

# Notify the system property that we changed the I/O scheduler.
setprop sys.io.scheduler $iosched

# Set the proper idle GPU frequency.
echo "$gpupwrlvl" > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
