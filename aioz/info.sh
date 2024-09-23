#!/bin/bash

# 获取IP地址
IP=$(curl -s ipinfo.io | jq -r '.ip')

# 获取国家信息
COUNTRY=$(curl -s ipinfo.io | jq -r '.country')

# Use sed to modify rewards.sh with actual IP and COUNTRY values
sed -i "s/,ip=\"\",country=\"\"}/,ip=\"$IP\",country=\"$COUNTRY\"}/" rewards.sh

echo "Updated rewards.sh with IP: $IP and Country: $COUNTRY"
