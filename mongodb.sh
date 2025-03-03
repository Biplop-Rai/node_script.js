#!/bin/bash

# Function to print error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Check for root user
if [ "$(id -u)" -ne 0 ]; then
    error_exit "This script must be run as root (use sudo)."
fi

# Install dependencies
echo "Installing dependencies (gnupg, curl)..."
sudo apt-get update && sudo apt-get install -y gnupg curl || error_exit "Failed to install dependencies."

# Import MongoDB GPG key
echo "Importing MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor || error_exit "Failed to import MongoDB GPG key."

# Create MongoDB sources list for Ubuntu 24.04 (Noble)
echo "Creating MongoDB repository list..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list || error_exit "Failed to create MongoDB repository list."

# Update package database
echo "Updating package database..."
sudo apt-get update || error_exit "Failed to update package database."

# Install MongoDB Community Edition
echo "Installing MongoDB Community Edition..."
sudo apt-get install -y mongodb-org || error_exit "Failed to install MongoDB."

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod || error_exit "Failed to start MongoDB."

# Verify MongoDB is running
echo "Verifying MongoDB status..."
sudo systemctl status mongod || error_exit "MongoDB did not start successfully."

# Enable MongoDB to start on boot
echo "Enabling MongoDB to start on boot..."
sudo systemctl enable mongod || error_exit "Failed to enable MongoDB on boot."

# Output instructions for using MongoDB
echo "MongoDB 8.0 Community Edition has been installed and is running."
echo "To connect to MongoDB, run the following command:"
echo "mongosh"

# End of script
