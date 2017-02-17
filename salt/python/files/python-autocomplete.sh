#!/usr/bin/env bash

# if you are in python3.X env, you should run
sudo apt-get -y install python3-dev libevent-dev libncurses5-dev
# if you are in python2.x env, then sudo apt-get install python-dev

# install readline
pip install readline

# config $HOME/.bashrc
echo "export PYTHONSTARTUP='$HOME/.pythonstartup'" >> $HOME/.bashrc

# config .pythonstartup
cat > $HOME/.pythonstartup << EOF
import os
import readline
import rlcompleter
import atexit


#tab completion
readline.parse_and_bind("tab: complete")


#history file
history_file = os.path.join(os.environ["HOME"],".pythonhistory")
try:
    readline.read_history_file(history_file)
except IOError:
    pass
atexit.register(readline.write_history_file,history_file)


del os,history_file,readline,rlcompleter
EOF