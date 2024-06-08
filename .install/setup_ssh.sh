#!/usr/bin/env bash

echo "===== Setting up SSH keys ====="

echo "GitHub docs: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"
echo "Bitbucket docs: https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-macos/"

echo "Enter email:"
read email
if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address."
    exit 1
fi

echo "Enter name for the keys:"
read key_name
if [[ -z "$key_name" ]]; then
    echo "Key name cannot be empty. Exiting."
    exit 1
fi

cd $HOME || exit
mkdir -p .ssh
chmod 700 $HOME/.ssh

private_key_path="$HOME/.ssh/$key_name"
ssh-keygen -t ed25519 -C "$email" -f "$private_key_path" -N "" || { echo "SSH key generation failed. Exiting."; exit 1; }
chmod 600 $private_key_path

echo "Starting up SSH Agent"
eval "$(ssh-agent -s)" || true

# Output SSH config
ssh_config="$HOME/.ssh/config"
{
    echo "Host github.com"
    echo "  HostName github.com"
    echo "  User git"
    echo "  IdentityFile $private_key_path"
    echo "  AddKeysToAgent yes"
} >> "$ssh_config"
chmod 600 "$ssh_config"

public_key_path="$HOME/.ssh/$key_name.pub"
echo -e "\nInstructions on how to add your public key ($public_key_path) to GitHub:"
echo "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
echo -e "\nPublic Key:\n$(cat "$public_key_path")"
