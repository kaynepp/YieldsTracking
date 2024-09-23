#!/bin/bash

# 检查容器 quili 是否在运行
if ! docker inspect -f '{{.State.Running}}' quili 2>/dev/null | grep -q 'true'; then
    echo "Container quili is not running."
    # 删除容器并重新启动
    docker rm -f quili
    docker run --cpus=4 --name quili -m 2048m -v /root/tracking/quili/config:/root/ceremonyclient/node/.config -itd sleeply/ee:0919
    docker exec quili bash -c "./start.sh 4"
else
    # 检查最近的 30 行日志是否包含 "parent process not found"
    if docker logs --tail 30 quili 2>&1 | grep -q "parent process not found"; then
        echo "Found 'parent process not found' in logs."
        # 删除容器并重新启动
        docker rm -f quili
        docker run --cpus=4 --name quili -m 2048m -v /root/tracking/quili/config:/root/ceremonyclient/node/.config -itd sleeply/ee:0919
        docker exec quili bash -c "./start.sh 4"
    else
        echo "Container quili is running and logs are clean."
    fi
fi

