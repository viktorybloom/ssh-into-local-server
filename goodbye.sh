#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
read -sp "Enter your server password: " PASSWORD
echo  # Move to a new line after password input

# Step 1: Remove SSH Handshake from /etc/ssh/sshd_config
echo "Removing SSH handshake from /etc/ssh/ssh_$USERNAME@$HOSTNAME..."
ssh "$USERNAME@$HOSTNAME" "sudo sed -i '/$USERNAME@$HOSTNAME/d' /etc/ssh/ssh_config"
echo "SSH handshake removed from /etc/ssh/ssh_$USERNAME@$HOSTNAME on the server."

# Step 2: Restart SSH Service
echo "Restarting SSH service on the server..."
ssh "$USERNAME@$HOSTNAME" "sudo systemctl restart ssh"
echo "SSH service restarted on the server."

