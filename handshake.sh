#!/bin/bash

# Prompt for user input
read -p "Enter your server username: " USERNAME
read -p "Enter your server hostname or IP address: " HOSTNAME
read -sp "Enter your server password: " PASSWORD
echo  # Move to a new line after password input

# Specify the directory for SSH keys
SSH_DIR="$HOME/.ssh"

# Step 1: Create SSH Key Pair in the specified directory
ssh-keygen -t rsa -f "$SSH_DIR/$USERNAME@$HOSTNAME" -C "$USERNAME@$HOSTNAME" -N ""

# Step 2: Copy Public Key to server
sshpass -p "$PASSWORD" ssh-copy-id "$USERNAME@$HOSTNAME"

# Step 3: SSH Configuration
echo -e "Host $USERNAME\n  HostName $HOSTNAME\n  User $USERNAME\n  IdentityFile $SSH_DIR/'$USERNAME@$HOSTNAME'" >> ~/.ssh/config

# Step 4: SSH Without Specifying IP or Username
echo -e "\nNow you can use 'ssh $USERNAME' to connect to your server."

# Step 5 (Optional): Disable Password Authentication for Local Machine
read -p "Do you want to disable password authentication on the server for connections from this machine? (y/n): " choice
if [ "$choice" == "y" ]; then

    # Get the local IP address of the machine
    local_ip=$(hostname -I | awk '{print $1}')
    echo "Disabling password authentication for connections from this machine..."
    
    # Create a configuration snippet for the specified user
    ssh_config_snippet="PasswordAuthentication no"
    
    # Transfer the configuration snippet to the server
    echo -e "$ssh_config_snippet" | ssh "$USERNAME@$HOSTNAME" "sudo tee /etc/ssh/ssh_config.d/$USERNAME@$HOSTNAME-local.conf > /dev/null"
    
    # Restart the SSH service
    ssh "$USERNAME@$HOSTNAME" "sudo systemctl restart ssh"
    echo "Password authentication disabled for connections from this machine on the server."
fi

