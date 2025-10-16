#!/bin/bash
# ========================================================
# 🧠 Gensyn CPU Node 1-Click Installer (with Cloudflare)
# Author: your_name_here
# ========================================================

set -e

echo "🔧 Starting Gensyn CPU Node installation..."
sleep 2

# --- Update & Install dependencies ---
echo "📦 Updating system packages..."
# Automatically keep existing configs during upgrade
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confold"

echo "📥 Installing dependencies..."
sudo apt install -y curl git wget screen unzip build-essential \
python3 python3-venv python3-pip lz4 jq pkg-config libssl-dev \
tmux htop clang bsdmainutils libleveldb-dev ncdu libgbm1 ufw

# --- Configure firewall (UFW) ---
echo "🧱 Configuring firewall..."
sudo ufw allow 22
sudo ufw allow 3000/tcp
sudo ufw --force enable

# --- Node.js & Yarn ---
echo "⚙️ Installing Node.js and Yarn..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# --- Install Cloudflared ---
echo "☁️ Installing Cloudflared..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
echo "✅ Cloudflared version:"
cloudflared --version

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

# --- Start Cloudflare Tunnel ---
echo "🌐 Starting Cloudflare tunnel for port 3000..."
screen -dmS cloudflared cloudflared tunnel --url http://localhost:3000

echo ""
echo "✅ Installation complete!"
