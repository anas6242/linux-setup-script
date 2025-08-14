#!/usr/bin/env bash
set -euo pipefail

echo "==> Personal Linux Setup Script (Day 3 - AlmaLinux)"
echo "Started at: $(date)"

# Detect shell rc file
SHELL_NAME=$(basename "${SHELL:-/bin/bash}")
if [[ "$SHELL_NAME" == "zsh" ]]; then
  RC="$HOME/.zshrc"
else
  RC="$HOME/.bashrc"
fi

# Ensure EPEL
if ! rpm -q epel-release >/dev/null 2>&1; then
  echo "==> Installing epel-release ..."
  sudo dnf -y install epel-release
fi

# Update & install essentials
echo "==> Updating system ..."
sudo dnf -y upgrade --refresh
echo "==> Installing packages ..."
sudo dnf -y install git curl vim htop tree

# Aliases & prompt (Day 2 logic)
START="# >>> anas-setup start >>>"
END="# <<< anas-setup end <<<"
if ! grep -qF "$START" "$RC" 2>/dev/null; then
  echo "==> Adding aliases & prompt ..."
  {
    echo "$START"
    echo "alias ll='ls -lah --color=auto'"
    echo "alias la='ls -A'"
    echo "alias gs='git status'"
    echo "alias update=\"sudo dnf -y upgrade --refresh\""
    echo "mkcd() { mkdir -p \"\$1\" && cd \"\$1\"; }"
    echo "export PS1='\\[\\e[1;32m\\]\\u@\\h \\[\\e[1;36m\\]\\W\\[\\e[0m\\] \\$ '"
    echo "$END"
  } >> "$RC"
fi

# Git config
if command -v git >/dev/null 2>&1; then
  if ! git config --global user.name >/dev/null 2>&1; then
    read -rp "Set global git user.name (leave blank to skip): " GNAME
    [[ -n "${GNAME}" ]] && git config --global user.name "$GNAME"
  fi
  if ! git config --global user.email >/dev/null 2>&1; then
    read -rp "Set global git user.email (leave blank to skip): " GMAIL
    [[ -n "${GMAIL}" ]] && git config --global user.email "$GMAIL"
  fi
fi

# ====== Day 3 Additions ======
echo "==> Creating default folders ..."
mkdir -p "$HOME/Projects" "$HOME/Scripts" "$HOME/Backups"

echo "==> Cleaning up system ..."
sudo dnf -y autoremove
sudo dnf clean all

# Optional: Simple backup function
BACKUP_FILE="$HOME/Backups/home-backup-$(date +%F).tar.gz"
echo "==> Creating a home directory backup at: $BACKUP_FILE"
tar --exclude="HOME/Backups" -czf "$BACKUP_FILE" "$HOME"

echo "==> Day 3 complete."
echo "==> Reload shell: source \"$RC\""
