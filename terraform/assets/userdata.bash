#!/bin/bash

# Install latest updates
apt-get update
apt-get install -y jq
apt-get upgrade -y

# Changing the hostname
export AWS_IMDS_TOKEN=$(curl -s -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" "http://169.254.169.254/latest/api/token" )
export AWS_DEFAULT_REGION=$(curl -s -H "X-aws-ec2-metadata-token: ${AWS_IMDS_TOKEN}" "http://169.254.169.254/latest/dynamic/instance-identity/document" |jq -r ".region")
export INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${AWS_IMDS_TOKEN}" "http://169.254.169.254/latest/dynamic/instance-identity/document" |jq -r ".instanceId")
# Default hostname in case of missing tag hostname
export NEW_HOSTNAME="challengekt"

for TAG in $(aws ec2 describe-instances --instance-ids "${INSTANCE_ID}" --query "Reservations[0].Instances[0].Tags"  |jq -c ".[]"); do
    if [[ "${TAG}" == '{"Key":"Name",'* ]]; then
        export NEW_HOSTNAME=$(echo "${TAG}" |cut -d'"' -f8)
    fi
done

sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
hostnamectl set-hostname --static "${NEW_HOSTNAME}"
echo -e "hostname: ${NEW_HOSTNAME}\nfqdn: ${NEW_HOSTNAME}.localdomain" >> /etc/cloud/cloud.cfg

# Adding kubespray deps on kernel argument
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
update-grub2

# Reboot to apply all changes
reboot