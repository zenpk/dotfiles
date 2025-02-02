#!/bin/bash

export windows_ip=$(ip route | grep default | awk '{print $3}')
export https_proxy=http://$windows_ip:1080
export http_proxy=http://$windows_ip:1080
# add user
read -p "Enter username: " username
read -s -p "Enter password: " password
echo
useradd -m "$username" # -m flag creates the user's home directory
echo "$username:$password" | chpasswd
usermod -aG sudo "$username"
echo "$username ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/$username"
echo "AllowUsers $username" | tee -a /etc/ssh/sshd_config
echo "done"
