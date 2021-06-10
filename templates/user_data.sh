#!/bin/bash
OS='${operating_system}'

function invalid_os {
    echo "This OS is not supported yet" > /root/invalid_os.txt
}

if [ "$${OS:0:6}" = "centos" ] || [ "$${OS:0:4}" = "rhel" ]; then
    dnf install jq -y
else
    invalid_os
fi