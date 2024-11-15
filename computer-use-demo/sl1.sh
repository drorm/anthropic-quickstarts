#!/bin/bash
set -e

export WIDTH=1024
export HEIGHT=768
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

STREAMLIT_SERVER_PORT=8510 python3 -m streamlit run computer_use_demo/streamlit.py 
