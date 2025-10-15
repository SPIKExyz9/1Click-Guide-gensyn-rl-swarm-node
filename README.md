#  RL-Swarm node guide🐝

•The easiest guide for the Gensyn RL-swarm CPU node🐝 — no coding required, anyone can easily run the node.💎

# install the node 
```
curl -s https://raw.githubusercontent.com/SPIKExyz9/1Click-Guide-gensyn-rl-swarm-node/main/gensyn_cpu_install.sh | bash
```


# Next step 📝

**•Run the node by following these steps** 🏃‍♂️


1️⃣ **open a sessionn**

```
screenn -S Gensynai
```


2️⃣ **paste this error solution cmd***

```
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
pip install --force-reinstall transformers==4.51.3 trl==0.19.1
pip freeze
./run_rl_swarm.sh
```

3️⃣**Testnet login**

•local PC users:
http://localhost:3000/ 

📝Open this  link in your browser, paste your email enter the code and click login.

📝 Go back to the old tab

•VPS usrs: 
open  a new tab than paste this cmd
```
cloudflared tunnel --url http://localhost:3000
```
Then you will see a link like that 👇


📝 Open this  link in your browser, paste your email enter the code and click login.

