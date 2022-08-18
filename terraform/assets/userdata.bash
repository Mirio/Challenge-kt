#!/bin/bash

# Install latest updates
apt-get update
apt-get upgrade -y

# Adding kubespray deps on kernel argument
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
update-grub2

# Reboot to apply all changes
reboot