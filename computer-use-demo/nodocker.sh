#!/bin/bash
#
set -e

# Set environment variables
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=high

# Update and install packages
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install \
    xvfb xterm xdotool scrot imagemagick sudo mutter x11vnc \
    build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev net-tools netcat \
    software-properties-common

# Add PPA and install userland apps
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt-get install -y --no-install-recommends \
    libreoffice firefox-esr x11-apps xpdf gedit xpaint tint2 galculator \
    pcmanfm unzip
sudo apt-get clean

# Install noVNC
sudo git clone --branch v1.5.0 https://github.com/novnc/noVNC.git /opt/noVNC
sudo git clone --branch v0.12.0 https://github.com/novnc/websockify /opt/noVNC/utils/websockify
sudo ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# set up pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src
echo 'export PYENV_ROOT="\$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="\$PYENV_ROOT/bin:\$PATH"' >> ~/.bashrc
echo 'eval "\$(pyenv init -)"' >> ~/.bashrc

# Setup Python and install dependencies
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv install 3.11.6
pyenv global 3.11.6
python -m pip install --upgrade pip==23.1.2 setuptools==58.0.4 wheel==0.40.0
python -m pip config set global.disable-pip-version-check true

python -m pip install -r $HOME/computer-use-demo/computer_use_demo/requirements.txt

# Create the dir for system prompt
mkdir ~/.anthrophic

# copy the dot files (start with '.' but skip '.' and '..')
cp -r computer-use-demo/image/.??* ~
echo 'edit ~/.config/tint2/tint2rc to change from "computeruse" to your user name"
