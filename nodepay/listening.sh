#!/bin/bash

# 检查容器 nodepay 是否在运行
if ! docker inspect -f '{{.State.Running}}' nodepay 2>/dev/null | grep -q 'true'; then
    echo "Container nodepay is not running."
    # 删除容器并重新启动
    docker rm -f nodepay
    bash /root/tracking/nodepay/start.sh
fi
