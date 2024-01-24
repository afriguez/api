#!/usr/bin/bash

set -e

dotfiles_repo="git@github.com:afriguez/dotfiles"
work_tree="$HOME"
dotfiles_dir="$work_tree/dotfiles"
ssh_dir="$work_tree/.ssh"
ssh_key="$work_tree/.ssh/id_ed25519"
email="afriguez@gmail.com"

sudo pacman -S --needed openssh github-cli --noconfirm

# Create SSH dir if it does not exist
mkdir -p $ssh_dir

# Generate SSH key
ssh-keygen -t ed25519 -C $email -f $ssh_key

# Start SSH Agent & add key
eval "$(ssh-agent -s)"
ssh-add $ssh_key

# GitHub
echo "Enter your GitHub API Auth Token"
echo -n "Token: "
read -s gh_token

GH_TOKEN=$gh_token $(command -v gh) ssh-key add $ssh_key.pub -t "Linux Ins"

# Clone dotfiles
git clone $dotfiles_repo --bare $dotfiles_dir

c_git () {
	$(command -v git) \
		--git-dir=$dotfiles_dir \
		--work-tree=$work_tree \
		"$@"
}

# Restore dotfiles
c_git restore --staged .
c_git restore .

echo "Dotfiles bootstrap completed successfully."

echo "Starting Dotfiles installation..."
source $work_tree/install.sh
