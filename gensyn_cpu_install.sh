#!/usr/bin/env bash
# ============================================
# 🧠 GENSYN CPU NODE - 1 CLICK INSTALL SCRIPT
# ============================================

set -e

echo "🚀 Starting Gensyn CPU Node setup..."
sleep 2

# ---- Update system ----
echo "🛠 Updating packages..."
sudo apt update && sudo apt upgrade -y

# ---- Install dependencies ----
echo "📦 Installing required dependencies..."
sudo apt install -y curl git wget screen unzip build-essential \
  python3 python3-venv python3-pip lz4 jq pkg-config libssl-dev \
  tmux htop clang bsdmainutils libleveldb-dev ncdu libgbm1 \
  automake autoconf libffi-dev ufw

# ---- Setup Firewall ----
echo "🧱 Configuring UFW Firewall..."
sudo ufw allow 22
sudo ufw allow 3000/tcp
sudo ufw --force enable
sudo ufw status

# ---- Install Node.js + Yarn ----
echo "📦 Installing Node.js & Yarn..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# ---- Clone Gensyn RL-Swarm ----
echo "📂 Cloning Gensyn RL-Swarm..."
cd ~
rm -rf rl-swarm || true
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm

# ---- Create Python venv ----
echo "🐍 Setting up Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# ---- Run Node in CPU-Only mode ----
echo "⚙️ Launching Gensyn CPU Node in screen session..."
screen -dmS gensyn_cpu bash -c "CUDA_VISIBLE_DEVICES='' CPU_ONLY=1 bash run_rl_swarm.sh"

# ---- Install Cloudflare Tunnel ----
echo "🌐 Installing Cloudflare Tunnel (cloudflared)..."
curl -fsSL https://pkg.cloudflare.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloudflare.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare.gpg] https://pkg.cloudflare.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare.list
sudo apt update
sudo apt install -y cloudflared

# ---- Start Cloudflare tunnel on port 3000 ----
echo "☁️ Starting Cloudflare Tunnel..."
screen -dmS cf_tunnel cloudflared tunnel --url http://localhost:3000

echo ""
echo "✅ Installation complete!"
echo "🎯 Run 'screen -r gensyn_cpu' to check node logs."
echo "🌐 Run 'screen -r cf_tunnel' to see your Cloudflare public URL."
echo "💾 PEM and identity files will be in ~/rl-swarm/"
echo ""

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
