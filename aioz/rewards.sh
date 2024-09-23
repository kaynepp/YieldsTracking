#!/bin/bash
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

if [[ "$MY_COUNTRY" == "DE" ]]; then
  MY_COUNTRY="EU"
fi

# 执行命令并捕获输出
output=$(docker exec aioz bash -c "./rewards.sh" 2>/dev/null)

# 检查命令是否执行成功
if [ $? -ne 0 ]; then
    echo "Command execution failed."
    exit 1
fi

# 使用jq工具解析JSON输出并获取balance的第一个元素的amount值
# 确保系统已安装jq工具
amount=$(echo $output | jq -r '.balance[0].amount // empty')
# 检查balance数组是否为空
if [ -z "$amount" ]; then
    echo "Balance array is empty."
    
    exit 1
else
    echo "The amount of the first element in balance is: $amount"
fi

# 写入到 /root/metrics/aioz.prom 文件
cat <<EOF > /root/metrics/aioz.prom
# TYPE point_total counter
point_total{depin="aioz",ip="$MY_IP",country="$MY_COUNTRY"} $amount
EOF

echo "Balance $amount written to /root/metrics/aioz.prom"
