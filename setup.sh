#!/bin/bash
# this script is for setup the user and should be run by root

# add user
read -p "Enter username: " username
read -s -p "Enter password: " password
echo
useradd -m "$username" # -m flag creates the user's home directory
echo "$username:$password" | chpasswd
usermod -aG sudo "$username"
echo "$username ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/$username"
echo "AllowUsers $username" | tee -a /etc/ssh/sshd_config

# apt
apt update
apt install -y zsh
apt install -y tmux
apt install -y htop
apt install -y net-tools
apt install -y aria2c

echo "done. now login as the user and run user.sh"
