#!/bin/bash
# 使用curl发送请求并使用jq解析响应
#response=$(curl -s ipinfo.io)

# 使用jq提取IP和country信息并保存到变量中


# 检查并获取ip环境变量
#if [ -z "$EQUIP_IP" ]; then
#    echo "IP环境变量为空，重新获取..."
#    ip=$(echo "$response" | jq -r '.ip')
#    sed -i 's/^export EQUIP_IP=""/export EQUIP_IP="'"$ip"'"/' ~/.bashrc
#    source ~/.bashrc
#fi

# 检查并获取country环境变量
#if [ -z "$EQUIP_COUNTRY" ]; then
#    echo "Country环境变量为空，重新获取..."
#    export EQUIP_COUNTRY=$(echo "$response" | jq -r '.country')
#fi



echo "============ get rewards and try again  if 0.0 ============"
#docker exec -it filecoin-station bash -c "tail -n 5000 station-daemon.log | grep participantAddress | tail -n 1 | awk -F'\"' '{print \$2}'"
#docker exec -it filecoin-station bash -c "tail -n 500 station-daemon.log | grep \"rewardsScheduledForAddress\" | tail -n 1 | awk -F'\"' '{print \$4}'"
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


counter=0

while [ $counter -lt 5 ]
do
    # 使用命令替换将命令的输出保存到变量中
    address=$(docker logs --tail 500 filecoin-station | grep participantAddress | tail -n 1 | awk -F'"' '{print $2}')
    balance=$(docker logs --tail 500 filecoin-station | grep \"rewardsScheduledForAddress\" | tail -n 1 | awk -F'"' '{print $4}')

    # check balance
    if [ "$balance" != "0.0" ]
    then
        break
    fi
    counter=$((counter+1))
    if [ $counter -eq 5 ]
    then
        break
    fi
    sleep 1
done
paid_json=$(curl -s -m 5 "https://filfox.info/api/v1/address/$address/balance-stats?duration=24h&samples=1" || echo "00.00")

# 检查 curl 是否成功获取数据
if [ $? -ne 0 ]; then
    echo "Failed to fetch data from the API."
    exit 1
fi

# 尝试将返回结果序列化为指定的 JSON 格式
echo "$paid_json" | jq '.[] | {"height": .height, "timestamp": .timestamp, "balance": .balance}' > /dev/null 2>&1

# 检查 jq 解析是否成功
if [ $? -ne 0 ]; then
    echo "Failed to parse the response as JSON."
    echo "# TYPE point_total counter" > /root/metrics/filecoin-station.prom
    echo "point_total{depin=\"filecoin-station\",ip=\"$MY_IP\",country=\"$MY_COUNTRY\"} $balance" >> /root/metrics/filecoin-station.prom
    exit 1
fi



# paid_json=$(echo $paid_json | sed 's/"/\\"/g') > /dev/null

echo "{\"address\":\"$address\",\"unpaid\":\"$balance\",\"paid\":$paid_json}"
paid_data="{\"address\":\"$address\",\"unpaid\":\"$balance\",\"paid\":$paid_json}"
# 使用jq解析JSON并处理数据
unpaid=$(echo $paid_data | jq -r '.unpaid')
paid_balance=$(echo $paid_data | jq -r '.paid[0].balance')
if [ "$paid_json" == "00.00" ]
then
    echo "Paid JSON is 0.0. Exiting."
    exit 0
fi
# 将unpaid缩小18个零
paid_scaled=$(echo "scale=18; $paid_balance / 10^18" | bc)

# 将扩大后的unpaid和paid.balance相加
total=$(echo "$unpaid + $paid_scaled" | bc)

# 输出结果
printf "Total Earnings: %.18f\n" $total

formatted_total=$(printf "%.18f" $total)
#current_ip=$(echo $EQUIP_IP)
echo -e "# TYPE point_total counter\npoint_total{depin=\"filecoin-station\",ip=\"$MY_IP\",country=\"$MY_COUNTRY\"} $formatted_total" | sudo tee /root/metrics/filecoin-station.prom
