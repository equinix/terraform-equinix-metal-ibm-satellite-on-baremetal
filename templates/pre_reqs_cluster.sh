#!/bin/bash

echo "Pre-reqs cluster script"

OS='${operating_system}'
RHEL_USER='${rhel_username}'
RHEL_PWD='${rhel_password}'

function rhel_pre_reqs {
    # Disable Firewalld
    systemctl disable firewalld
    systemctl stop firewalld
    # Disable SELinux
    setenforce 0

    echo "Register and subscribe system to the Red Hat Subscription Manager"
    max_iterations=10
    wait_seconds=20
    iterations=0
    while true
    do
      ((++iterations))
      sleep $wait_seconds
      echo "subscription-manager register and auto attach. Try $iterations ..."
      subscription-manager register --username=$RHEL_USER --password=$RHEL_PWD --auto-attach --force
      if [ $? -eq 0 ]; then
        echo "Yay - you're subscribed!"
        break
      fi

      if [ "$iterations" -ge "$max_iterations" ]; then
        echo "Error trying to register and subscribe system to the Red Hat Subscription Manager"
        exit 1
      fi
    done

    echo "Refresh local certificates on the client system"
    subscription-manager refresh

    echo "Clean yum repo"
    rm -fr /var/cache/yum/*
    yum clean all

    echo "Enable required subscription manager repos"
    subscription-manager repos --enable="rhel-server-rhscl-7-rpms" \
        --enable="rhel-7-server-optional-rpms" \
        --enable="rhel-7-server-rh-common-rpms" \
        --enable="rhel-ha-for-rhel-7-server-rpms" \
        --enable="rhel-rs-for-rhel-7-server-rpms" \
        --enable="rhel-7-server-rpms" \
        --enable="rhel-7-server-supplementary-rpms" \
        --enable="rhel-7-server-extras-rpms"
    echo "Install deltarpm"
    yum install -y deltarpm
    echo "Update packages"
    yum update -y
    echo "Update and upgrade packages"
    yum upgrade -y
    echo "Install utils"
    yum install -y yum-utils bind-utils
    echo "Installation has been successfully completed"
}

function invalid_os {
    echo "This OS is not supported yet"
}

echo "init"
if [ "$${OS:0:6}" = "centos" ] || [ "$${OS:0:4}" = "rhel" ]; then
    rhel_pre_reqs
else
    invalid_os
fi