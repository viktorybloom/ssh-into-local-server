#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
read -sp "Enter your server password: " PASSWORD
echo  # Move to a new line after password input

# Step 1: Remove SSH Handshake from /etc/ssh/ssh_config 
echo "Removing SSH handshake from /etc/ssh/ssh_$USERNAME@$HOSTNAME..."
ssh "$USERNAME@$HOSTNAME" "sudo sed -i '/$USERNAME@$HOSTNAME/d' /etc/ssh/ssh_config"
echo "SSH handshake removed from /etc/ssh/ssh_$USERNAME@$HOSTNAME on the server."

# Step 2: Remove config from ~/.ssh/ on local machine
echo "Removing SSH $USERNAME setup from local .ssh directory" 
rm ~/.ssh/$USERNAME@$HOSTNAME_conifg
echo "Removed SSH $USERNAME from config"

# Step 3: Remove authorized keys for the user
echo "Removing authorized keys for $USERNAME on $HOSTNAME..."
ssh "$USERNAME@$HOSTNAME" "echo > ~/.ssh/authorized_keys"
echo "Authorized keys removed for $USERNAME on $HOSTNAME."

# Step 4: Restart SSH Service
echo "Restarting SSH service on the server..."
ssh "$USERNAME@$HOSTNAME" "sudo systemctl restart ssh"
echo "SSH service restarted on the server."

