#!/usr/bin/env bash

echo "===== Setting up SSH keys ====="
cd "$HOME" || exit

# Prompt user to choose between GitHub and Bitbucket
while true; do
    echo "Choose remote, github [gh] or bitbucket [bb]:"
    read -r remote
    if [[ "$remote" == "gh" || "$remote" == "github" ]]; then
        full_remote="github"
        echo "GitHub docs: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"
        break
    elif [[ "$remote" == "bb" || "$remote" == "bitbucket" ]]; then
        full_remote="bitbucket"
        echo "Bitbucket docs: https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-macos/"
        break
    else
        echo "Invalid option. Please enter 'gh' or 'bb':"
    fi
done

echo "Enter email:"
read -r email
if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address."
    exit 1
fi

echo "Enter name for the keys:"
read -r key_name
if [[ -z "$key_name" ]]; then
    echo "Key name cannot be empty. Exiting."
    exit 1
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

private_key_path="$HOME/.ssh/$key_name"
ssh-keygen -t ed25519 -C "$email" -f "$private_key_path" -N "" || { echo "SSH key generation failed. Exiting."; exit 1; }
chmod 600 "$private_key_path"

echo "Starting up SSH Agent"
eval "$(ssh-agent -s)" || true

# Output SSH config
ssh_config="$HOME/.ssh/config"
{
    echo "Host $full_remote.com"
    echo "  HostName $full_remote.com"
    echo "  User git"
    echo "  IdentityFile $private_key_path"
    echo "  AddKeysToAgent yes"
} >> "$ssh_config"
chmod 600 "$ssh_config"

public_key_path="$HOME/.ssh/$key_name.pub"
echo -e "\nInstructions on how to add your public key ($public_key_path) to $full_remote:"
if [[ "$full_remote" == "github" ]]; then
    echo "https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
elif [[ "$full_remote" == "bitbucket" ]]; then
    echo "https://support.atlassian.com/bitbucket-cloud/docs/set-up-personal-ssh-keys-on-macos/"
fi
echo -e "\nPublic Key:\n$(cat "$public_key_path")"
pbcopy < "$public_key_path"
echo "Public key copied to clipboard"

echo "Would you like to setup another SSH key? [y/n]"
read -r run_again
if [[ "$run_again" == "y" ]]; then
    "$HOME/dotfiles/.install/setup_ssh.sh"
else
    echo "===== Finish creating SSH key(s) ====="
    exit 0
fi
