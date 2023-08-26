#!/bin/bash

read -p "Enter username: " username
echo
usermod -aG sudo "$username"
echo "$username ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/$username"
echo "AllowUsers $username" | tee -a /etc/ssh/sshd_config
