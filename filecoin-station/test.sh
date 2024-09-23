#!/bin/bash

# JSON数据
json_data='{"address":"0x0f866b082ab2d440c289e82f33397b492e78fc83","unpaid":"0.070813473973666842","paid":[{"height":4035514,"timestamp":1719371820,"balance":"355663004947715616"}]}'

# 使用jq解析JSON并处理数据
unpaid=$(echo $json_data | jq -r '.unpaid')
paid_balance=$(echo $json_data | jq -r '.paid[0].balance')

# 将unpaid扩大18个零
unpaid_expanded=$(echo "scale=0; $unpaid * 10^18" | bc)

# 将扩大后的unpaid和paid.balance相加
total=$(echo "$unpaid_expanded + $paid_balance" | bc)

# 输出结果
echo "Total: $total"

