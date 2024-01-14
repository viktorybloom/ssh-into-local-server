#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
read -sp "Enter your server password: " PASSWORD
echo  # Move to a new line after password input

# Specify the directory for SSH keys
SSH_DIR="$HOME/.ssh"

# Step 1: Create SSH Key Pair in the specified directory
ssh-keygen -t rsa -f "$SSH_DIR/$USERNAME@$HOSTNAME"

# Step 2: Copy Public Key to server
sshpass -p "$PASSWORD" ssh-copy-id "$USERNAME@$HOSTNAME"

# Step 3: SSH Configuration
echo -e "HostName $HOSTNAME\n  User $USERNAME" >> "$SSH_DIR/config"

# Step 4: SSH Without Specifying IP or Username
echo -e "\nNow you can use 'ssh $USERNAME' to connect to your server."

# Step 5 (Optional): Disable Password Authentication for Local Machine
read -p "Do you want to disable password authentication on the server for connections from this machine? (y/n): " choice
if [ "$choice" == "y" ]; then
    echo "Disabling password authentication for connections from this machine..."
    ssh "$USERNAME@$HOSTNAME" "echo -e '\n# Disable password authentication for local machine\nMatch Address $(hostname -I | awk '{print $1}')\n  PasswordAuthentication no' | sudo tee -a /etc/ssh/sshd_config"
    ssh "$USERNAME@$HOSTNAME" "sudo systemctl restart ssh"
    echo "Password authentication disabled for connections from this machine on the server."
fi

