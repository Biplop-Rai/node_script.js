#!/bin/bash

# Function to print error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Update package list
echo "Updating package list..."
sudo apt-get update || error_exit "Failed to update package list."

# Install dependencies (curl if not installed)
echo "Installing dependencies (curl)..."
sudo apt-get install -y curl || error_exit "Failed to install curl."

# Download and install nvm
echo "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash || error_exit "Failed to install NVM."

# Source nvm script in the current shell session
echo "Sourcing NVM script..."
\. "$HOME/.nvm/nvm.sh" || error_exit "Failed to source NVM script."

# Install Node.js version 22
echo "Installing Node.js version 22..."
nvm install 22 || error_exit "Failed to install Node.js version 22."

# Verify Node.js version
echo "Verifying Node.js version..."
node_version=$(node -v)
if [ "$node_version" == "v22.14.0" ]; then
    echo "Node.js version $node_version installed successfully."
else
    error_exit "Node.js version installation failed. Expected v22.14.0 but got $node_version."
fi

# Verify the current Node.js version managed by nvm
echo "Verifying nvm current version..."
nvm_current=$(nvm current)
if [ "$nvm_current" == "v22.14.0" ]; then
    echo "nvm is using Node.js version $nvm_current."
else
    error_exit "nvm did not use the expected Node.js version. Expected v22.14.0 but got $nvm_current."
fi

# Verify npm version
echo "Verifying npm version..."
npm_version=$(npm -v)
if [ "$npm_version" == "10.9.2" ]; then
    echo "npm version $npm_version installed successfully."
else
    error_exit "npm installation failed. Expected version 10.9.2 but got $npm_version."
fi

# End of script
echo "NVM, Node.js, and npm have been installed and verified successfully."
