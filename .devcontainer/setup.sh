# zshのインストール
sudo apt-get -y install zsh

# oh-my-zshのインストール
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# zshをデフォルトに設定
chsh -s /usr/bin/zsh

# pecoのインストール
cd
sudo wget https://github.com/peco/peco/releases/download/v0.5.10/peco_linux_amd64.tar.gz
sudo tar xzvf peco_linux_amd64.tar.gz
sudo rm peco_linux_amd64.tar.gz

cd peco_linux_amd64
sudo chmod +x peco
sudo cp peco /usr/bin

cd
sudo rm -r peco_linux_amd64/

# bashファイルの作成
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> /root/.bash_profile
echo 'export LD_LIBRARY_PATH=/usr/lib64-nvidia' >> /root/.bash_profile
echo 'export PROMPT_COMMAND="history -a"' >> /root/.bash_profile
echo 'export HISTFILE=/root/.zsh-history' >> /root/.bash_profile
echo 'export HISTSIZE=10000' >> /root/.bash_profile
echo 'export SAVEHIST=10000' >> /root/.bash_profile
echo 'export PYTHONDONTWRITEBYTECODE=1' >> /root/.bash_profile
echo 'export TF_CPP_MIN_LOG_LEVEL=2' >> /root/.bash_profile
