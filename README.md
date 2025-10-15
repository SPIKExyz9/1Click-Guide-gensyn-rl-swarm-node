#  RL-Swarm node guide🐝

•The easiest guide for the Gensyn RL-swarm CPU node🐝 — no coding required, anyone can easily run the node.💎

# install the node 

```bash
curl -s https://raw.githubusercontent.com/SPIKExyz9/1Click-Guide-gensyn-rl-swarm-node/main/gensyn_cpu_install.sh | bash
 
# next step📝

1• all error solution cmd

```bash
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
pip install --force-reinstall transformers==4.51.3 trl==0.19.1
pip freeze
