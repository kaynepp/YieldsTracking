#!/bin/bash

docker pull sleeply/esan:0919

docker run -itd --name blockmesh sleeply/esan:0919

./setup.sh 1570007740@qq.com MTIzNTZhYmNA # 12356abc@
./start.sh 1570007740@qq.com MTIzNTZhYmNA # Login failed