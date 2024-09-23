#!/bin/bash

# 执行 ./quili 命令并提取余额信息
output=$(docker exec quili bash -c "./quili -balance")
balance=$(echo "$output" | grep "Unclaimed balance" | awk '{print $3}')

# 检查环境变量是否存在 IP 和国家信息
if [ -z "$MY_IP" ] || [ -z "$MY_COUNTRY" ]; then
	  # 调用 ipinfo.io 接口并获取返回的 JSON 数
 response=$(curl -s ipinfo.io)

    # 从 JSON 数据中提取 IP 和国家信
 ip=$(echo $response | jq -r '.ip')
 country=$(echo $response | jq -r '.country')

 export MY_IP=$ip  
 export MY_COUNTRY=$country
else
 # 使用环境变量中的 IP 和国家信息  
 ip=$MY_IP
 country=$MY_COUNTRY
fi

# 写入到 /root/metrics/quili.prom 文件
# 将信息写入 quili.prom 文件

if [[ "$MY_COUNTRY" == "DE" ]]; then
  MY_COUNTRY="EU"
fi

cat <<EOF > /root/metrics/quili.prom
# TYPE point_total counter
point_total{depin="quili",ip="$MY_IP",country="$MY_COUNTRY"} $balance
EOF


echo "Balance $balance written to /root/metrics/quili.prom"
