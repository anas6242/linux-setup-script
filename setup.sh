#!/usr/bin/env bash
set -e

# ===== Pretty colors =====
GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; BLUE="\033[1;34m"; NC="\033[0m"
banner() { printf "\n${BLUE}======================================${NC}\n$1\n${BLUE}======================================${NC}\n"; }
step()   { printf "${YELLOW}[..] $1${NC}\n"; }
ok()     { printf "${GREEN}[✔] $1${NC}\n"; }
fail()   { printf "${RED}[✖] $1${NC}\n"; }

trap 'fail "Something went wrong. Check the logs above."' ERR

banner "🚀 Starting Linux Setup Script (AlmaLinux)"
step "Updating system packages…"
sudo dnf -y update
ok "System updated."

step "Installing essential packages (git, curl, vim, wget, unzip, tree)…"
sudo dnf -y install git curl vim wget unzip tree
ok "Essential packages installed."

step "Configuring environment (default editor = vim)…"
if ! grep -q "export EDITOR=vim" ~/.bashrc; then
  echo 'export EDITOR=vim' >> ~/.bashrc
fi
ok "Environment configured."

banner "🎉 Setup completed successfully!"
