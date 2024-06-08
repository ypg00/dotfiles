#!/usr/bin/env bash

echo "===== Setting up SSH keys ====="

echo "GitHub docs: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"
echo "Bitbucket docs: https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-macos/"

echo "Enter an email address for the keys:"
read email
if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address, try again."
    exit 1
fi

echo "Enter a name for the keys (e.g. github-personal or bitbucket-work):"
read key_name
if [[ -z "$key_name" ]]; then
    echo "Key name cannot be empty. Exiting."
    exit 1
fi


cd $HOME || exit
mkdir -p .ssh
chmod 700 $HOME/.ssh

local private_key_path="$HOME/.ssh/$key_name"
ssh-keygen -t ed25519 -C "$email" -f "$private_key_path" -N "" || exit
chmod 600 $private_key_path

echo "Starting up SSH Agent"
eval "$(ssh-agent -s)" || true

# Output SSH config
local ssh_config="$HOME/.ssh/config"
{
    echo "Host github.com"
    echo "  HostName $key_name"
    echo "  User git"
    echo "  IdentityFile $private_key_path"
    echo "  AddKeysToAgent yes"
} >> "$ssh_config"
chmod 600 $ssh_config

echo "Intructions on how to add you public key ($key_name.pub) to GitHub:"
echo "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
echo \n"Public Key: $private_key_path.pub"
