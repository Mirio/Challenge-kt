#!/bin/bash

# Check if inventory exists
if [[ ! -f "inventory/kubernetes-challengekt/hosts.ini" ]]; then
    echo "ERROR Host inventory missing"
    exit 1
fi

# Check if ssh private key exists
if [[ ! -f "../terraform/out/sshkey" ]]; then
    echo "ERROR SSH key missing, please deploy terraform first"
    exit 1
fi

# Check if Python3 exists
if ! which python3 > /dev/null; then
    echo "ERROR Python3 missing."
    exit 1
fi

# Check if virtualenv exists
if [[ -d "venv" ]]; then
    source ./venv/bin/activate
else
    python3 -m venv venv
    source ./venv/bin/activate
    pip install -r "kubespray/requirements.txt"
    # Fix https://github.com/kubernetes-sigs/kubespray/pull/8621
    sed -i 's/maximal_ansible_version: 2.13.0/maximal_ansible_version: 2.13.3/g' kubespray/ansible_version.yml
fi

ansible-playbook --become -i "inventory/kubernetes-challengekt/hosts.ini" "kubespray/upgrade-cluster.yml" |tee ansible_run.txt
ansible-playbook --become -i "inventory/kubernetes-challengekt/hosts.ini" "custom/custom.yml" |tee custom_run.txt