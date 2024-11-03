#!/bin/bash

echo "第一位输入"+""

# 初始化变量
result=0
operation=""

# 无限循环，直到用户选择退出
while true; do
    # 显示当前结果
    echo "上一次的计算结果为: $result"
    
    # 提示用户输入操作
    echo "请输入运算符号 (+, -, *, /) 或者 '退出':"
    read operation
    
    # 检查用户是否想退出
    if [ "$operation" == "退出" ]; then
        echo "Exiting calculator..."
        break
    fi
    
    # 检查用户输入的操作是否合法
    if [[ "$operation" != "+" && "$operation" != "-" && "$operation" != "*" && "$operation" != "/" ]]; then
        echo "Invalid operation. Please enter +, -, *, or /."
        continue
    fi
    
    # 提示用户输入数字
    echo "输入计算数字:"
    read number
    
    # 检查输入是否为有效的数字
    if ! [[ "$number" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo "该数字无效"
        continue
    fi
    
    # 执行相应的操作
    case $operation in
        "+") result=$(echo "$result + $number" | bc) ;;
        "-") result=$(echo "$result - $number" | bc) ;;
        "*") result=$(echo "$result * $number" | bc) ;;
        "/") 
            # 检查除数是否为零
            if [ "$number" == "0" ]; then
                echo "除数不能为0."
                continue
            fi
            result=$(echo "scale=10; $result / $number" | bc) ;;
    esac
    
    # 显示结果
    echo "结果: $result"
    echo "-------------------------"
done