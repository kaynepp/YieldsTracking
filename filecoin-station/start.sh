#!/bin/bash
echo "=============== start filecoin-station by docker ==============="
mkdir -p ./filecoin-station
cd filecoin-station
docker rm -f filecoin-station
docker run -id --restart=always --name filecoin-station pingpongbuild/station:20240628
nohup docker exec -i filecoin-station bash -c "./start.sh 0xDba1d9181ff7fB3D2F7234C335c13bB6F8b6EC44" &
