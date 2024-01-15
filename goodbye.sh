#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
echo #newline

# Step 1: Remove authorized keys for the user
echo "Removing authorized keys for $USERNAME on $HOSTNAME..."
ssh "$USERNAME" "
  echo > ~/.ssh/authorized_keys
  sudo sed -i '/$USERNAME@$HOSTNAME/d' /etc/ssh/ssh_config
  sudo systemctl restart ssh
"
echo "Authorized keys removed for $USERNAME on $HOSTNAME."

# Step 2: Remove config from ~/.ssh/ on local machine
echo "Removing SSH $USERNAME setup from local .ssh directory" 
sed -i "/Host $USERNAME/,/IdentityFile ~\/\.ssh\/$USERNAME@$HOSTNAME/d" ~/.ssh/config
echo "Removed SSH $USERNAME from config"

# Step 3: Remove SSH keys from local machine
echo "Removing SSH keys for $USERNAME@$HOSTNAME from local machine..."
rm ~/.ssh/"$USERNAME@$HOSTNAME"*
echo "SSH keys removed for $USERNAME@$HOSTNAME from local machine."

#Step 4: Remove unallocated SSH keys on local machine
echo "Removing unallocated SSH keys on local machine..."
ssh-add -D \ sudo systemctl restart ssh
echo "Removed unallovated SSH keys from local machine."

