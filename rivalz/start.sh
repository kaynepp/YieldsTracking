#!/bin/bash

docker pull sleeply/ewu:0919

docker run -itd --name rivalz sleeply/ewu:0919

# ./tar.sh

# 退出容器重新进
# source ~/.nvm/nvm.sh

# ./start.exp 0x36Fb7eFD55170a92327E73970D72a025c405f58F