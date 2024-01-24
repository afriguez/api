#!/usr/bin/bash

set -e

dotfiles_repo="git@github.com:afriguez/dotfiles"
work_tree="$HOME"
dotfiles_dir="$work_tree/dotfiles"
ssh_dir="$work_tree/.ssh"
ssh_key="$work_tree/.ssh/id_ed25519"
email="afriguez@gmail.com"

clone_dotfiles () {
	git clone $dotfiles_repo --bare $dotfiles_dir > /dev/null 2>&1 &
	local pid=$!
	spin='-\|/'
	i=0
	while kill -0 $pid 2>/dev/null
	do
		i=$(( (i+1) %4 ))
		printf "\r${spin:$i:1} Cloning dotfiles repository..."
		sleep .1
	done
}

c_git () {
	$(command -v git) \
		--git-dir=$dotfiles_dir \
		--work-tree=$work_tree \
		"$@"
}

sudo pacman -S --needed openssh github-cli --noconfirm > /dev/null 2>&1

# Create SSH dir if it does not exist
mkdir -p $ssh_dir

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C $email -f $ssh_key > /dev/null 2>&1

# Start SSH Agent & add key
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add $ssh_key > /dev/null 2>&1

# GitHub
echo "Enter your GitHub API Auth Token"
echo -n "Token: "
read -s gh_token

echo -e "\033c"
GH_TOKEN=$gh_token $(command -v gh) ssh-key add $ssh_key.pub -t "Linux Ins"

# hide cursor
echo -e "\e[?25l"
clone_dotfiles
echo -e "\r\033[32m✓\033[0m Repository cloned successfully."

# show cursor
echo -e "\e[?25h"

# Restore dotfiles
c_git restore --staged .
c_git restore .

sleep 1
echo -e "\r\033[32m✓\033[0m Dotfiles bootstrap completed successfully.\n"

printf "\033[33mRunning Dotfiles Installation...\033[0m"
$work_tree/install.sh > /dev/null 2>&1
echo -e "\r\033[32m✓\033[0m Dotfiles installation finished successfully."
