#!/bin/bash

docker pull sleeply/ling8:0919

docker run -itd -p1234:1234 -p5678:5678 --name 0g sleeply/ling8:0919

docker exec -i 0g bash -c "echo "664f335cd1a06d3e23bc4789b4b2e1550d29869d289899b39b1f4a2c10830de2" | ./setup.sh"

nohup docker exec -i 0g bash -c "./start.sh" &

echo "setup succeed"
echo "start 0g"