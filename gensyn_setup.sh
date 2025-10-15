#!/bin/bash
echo "🔧 Installing Gensyn node setup..."
sudo apt update -y
sudo apt install curl git -y

# Example setup
git clone https://github.com/yourusername/gensyn-node.git
cd gensyn-node
bash start.sh

echo "✅ Gensyn setup complete!"
