#!/bin/bash

docker pull sleeply/ee:0919

docker run --cpus=4 --name quili -m 2048m -v ./config:/root/ceremonyclient/node/.config -id sleeply/ee:0919

nohup docker exec -i quili bash -c "./setup.sh && ./start.sh 4" &