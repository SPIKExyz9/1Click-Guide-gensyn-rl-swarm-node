#  RL-Swarm node guide🐝

•The easiest guide for the Gensyn RL-swarm CPU node🐝 — no coding required, anyone can easily run the node.💎

.🖥️**hardware requirement**.

.system ubuntu 24.04 LTS

•minimum 24 GB ram, recommended 32 GB ram

•minimum 4 core 

•minimum 50 gb storage

# install the node 
```
curl -s https://raw.githubusercontent.com/SPIKExyz9/1Click-Guide-gensyn-rl-swarm-node/main/gensyn_cpu_install.sh | bash
```


# Next step 📝

**•Run the node by following these steps🏃‍♂️**


1️⃣ **open a sessionn**

```
screenn -S Gensynai
```


2️⃣ **Run and error solution cmd**

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


📝  Copy and open this  link in your browser, paste your email enter the code and click login.

📝Go back to the terminal tab and close new cloudflare tab.



4️⃣ **Final step**

•Would you like to push models you train in the RL swarm to the Hugging Face Hub? [y/N] **N**

•Enter the name of the model you want to use in huggingface repo/name format, or press [Enter] to use the default model. (press Enter and get defalut model). **Simple click enter button**

•Would you like your model to participate in the AI Prediction Market? [Y/n] Enter **Y**


**congratulations now your node setup is successfully complete**



5️⃣ **Extra tips**

📝•You can save the name and peer ID.

•If you are running it on an VPS do this👇 
ctrl a + d


• If you want to see the logs, do this👇

```
screen -r gensynai
```
or
```
 screen -r
```

# Do you want to rerun the node?

•**follow step by step**👍

detectory:
```
 cd rl-swarm
```
Run cmd :
```
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
```
next login step :
• Open a new tab or terminal 
than Run the cloudflare  tunnel cmd
and login your gensyn testnet account.


