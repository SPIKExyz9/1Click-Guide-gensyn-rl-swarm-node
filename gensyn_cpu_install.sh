#!/usr/bin/env bash
set -e

echo "🌐 GENSYN CPU NODE INSTALLER (with Cloudflare Tunnel)"
echo "====================================================="

# 1️⃣ System Update
echo "🛠 Updating packages..."
sudo apt update && sudo apt upgrade -y

# 2️⃣ Install dependencies
echo "📦 Installing base dependencies..."
sudo apt install -y curl git wget screen unzip build-essential \
  python3 python3-venv python3-pip lz4 jq pkg-config libssl-dev \
  tmux htop clang bsdmainutils libleveldb-dev ncdu libgbm1

# 3️⃣ Node.js + Yarn
echo "⚙️ Installing Node.js & Yarn..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# 4️⃣ Optional swap (16GB)
if [ ! -f /swapfile ]; then
  echo "💾 Creating 16GB swap file..."
  sudo swapoff -a || true
  sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
  echo "⚡ Swapfile already exists, skipping..."
fi

# 5️⃣ Clone RL-Swarm repo
echo "📥 Cloning Gensyn RL-Swarm..."
cd ~
rm -rf rl-swarm || true
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm

# 6️⃣ Create Python venv & install requirements
echo "🐍 Preparing Python environment..."
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip setuptools wheel

# 7️⃣ Start node in screen session
echo "🚀 Launching RL-Swarm (CPU mode)..."
screen -dmS gensyn_cpu bash -c 'source ~/.venv/bin/activate && cd ~/rl-swarm && CUDA_VISIBLE_DEVICES="" CPU_ONLY=1 bash run_rl_swarm.sh'

# 8️⃣ Cloudflare Tunnel install
echo "🌩 Installing Cloudflare Tunnel..."
if ! command -v cloudflared &> /dev/null
then
  wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  sudo dpkg -i cloudflared-linux-amd64.deb || sudo apt -f install -y
fi

# 9️⃣ Expose Gensyn UI via Cloudflare
echo "🌐 Starting Cloudflare Tunnel for port 3000..."
screen -dmS cf_tunnel bash -c "cloudflared tunnel --url http://localhost:3000"

sleep 5
echo "✅ All done!"
echo "💡 To see running sessions: screen -ls"
echo "💡 Attach to node logs: screen -r gensyn_cpu"
echo "💡 Attach to tunnel: screen -r cf_tunnel"
echo "🌍 Wait 10-20s then check your Cloudflare Tunnel screen for a public URL."
