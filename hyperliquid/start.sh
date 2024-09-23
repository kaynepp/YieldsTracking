#!/bin/bash

docker pull sleeply/e7:0919 --platform=amd64

docker run -itd --name hld sleeply/e7:0919

docker exec -it hld bash -c "./start.sh"

# GLIBC 2.38 is needed, only support amd64 architecture