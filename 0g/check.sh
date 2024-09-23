#!/bin/bash
connectedPeers=$(curl -s -X POST http://localhost:5678 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}' | jq ".result.connectedPeers")
echo "($connectedPeers)"
if [ "$connectedPeers" -eq 0 ]; then
  # if check.sh output 1.node == 0 or 2.synchronize less than 300000 blocks or 3.file oversize then run restart the process in 0g docker container
  docker restart 0g && docker exec -it 0g bash -c "./start.sh"
fi
echo "0g program is running normally"
# 写入到 /root/metrics/0g.prom 文件
cat <<EOF > /root/metrics/0g.prom
# TYPE point_total counter
point_total{depin="0g",ip="158.220.122.71",country="EU"} $connectedPeers 
EOF
  echo "Number of the connectedPeers: ($connectedPeers) has been written to /root/metrics/0g.prom"

block_number=$(curl -X POST http://localhost:5678 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}' | jq '.result.logSyncHeight')

if [ "$block_number" -le 0 ]; then
  echo "block_number:($block_number) less or equal than 0"
  exit 1
fi

