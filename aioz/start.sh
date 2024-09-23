#!/bin/bash
docker pull sleeply/0er:0919

docker run -itd --name aioz sleeply/0er:0919

# docker exec -it aioz bash -c "./start.sh"
