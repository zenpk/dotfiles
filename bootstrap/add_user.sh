#!/bin/bash

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
