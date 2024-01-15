#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
echo #newline

# Step 1: Remove authorized keys for the user
echo "Removing authorized keys for $USERNAME on $HOSTNAME..."
ssh "$USERNAME@$HOSTNAME" "echo > ~/.ssh/authorized_keys"
echo "Authorized keys removed for $USERNAME on $HOSTNAME."

# Step 2: Remove SSH Handshake from /etc/ssh/ssh_config 
echo "Removing SSH handshake from /etc/ssh/ssh_$USERNAME@$HOSTNAME..."
ssh "$USERNAME@$HOSTNAME" "sudo sed -i '/$USERNAME@$HOSTNAME/d' /etc/ssh/ssh_config"
echo "SSH handshake removed from /etc/ssh/ssh_$USERNAME@$HOSTNAME on the server."

# Step 3: Remove config from ~/.ssh/ on local machine
echo "Removing SSH $USERNAME setup from local .ssh directory" 
sed -i "/Host $USERNAME/,/IdentityFile ~\/\.ssh\/$USERNAME@$HOSTNAME/d" ~/.ssh/config
echo "Removed SSH $USERNAME from config"

# Step 4: Remove SSH keys from local machine
echo "Removing SSH keys for $USERNAME@$HOSTNAME from local machine..."
rm ~/.ssh/"$USERNAME@$HOSTNAME"*
echo "SSH keys removed for $USERNAME@$HOSTNAME from local machine."

# Step 5: Restart SSH Service
echo "Restarting SSH service on the server..."
ssh "$USERNAME@$HOSTNAME" "sudo systemctl restart ssh"
echo "SSH service restarted on the server."

