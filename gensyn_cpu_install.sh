#!/bin/bash
# ========================================================
# 🧠 Gensyn CPU Node 1-Click Installer
# Author: your_name_here
# ========================================================

set -e

echo "🔧 Starting Gensyn CPU Node installation..."
sleep 2

# --- Update & Install dependencies ---
echo "📦 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "📥 Installing dependencies..."
sudo apt install -y curl git wget screen unzip build-essential \
python3 python3-venv python3-pip lz4 jq pkg-config libssl-dev \
tmux htop clang bsdmainutils libleveldb-dev ncdu libgbm1

# --- Node.js & Yarn ---
echo "⚙️ Installing Node.js and Yarn..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# --- Optional swap setup (16 GB) ---
echo "🧊 Adding 16GB swap for stability..."
sudo swapoff -a || true
sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# --- Clone RL Swarm repo ---
echo "📂 Downloading Gensyn RL Swarm..."
cd ~
if [ -d rl-swarm ]; then rm -rf rl-swarm; fi
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm

# --- Start in CPU-only mode ---
echo "🚀 Launching CPU-only node (in background screen)..."
screen -dmS gensyn_cpu bash -c "
python3 -m venv .venv && \
source .venv/bin/activate && \
CUDA_VISIBLE_DEVICES='' CPU_ONLY=1 bash run_rl_swarm.sh
"

echo ""
echo "✅ Installation finished!"
echo "👉 To view node logs, run:  screen -r gensyn_cpu"
echo "👉 To detach from screen:   Ctrl + A, then D"
echo "🌐 When login link appears, open it in browser and authenticate your node."
echo ""
