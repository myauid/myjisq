
# 高级命令行计算器，支持10次运算
    read -p "请输入循环运行几次: " a




# 循环10次
for ((i=1;i<=a;i++))
do
    echo "运算 $i:"

    # 提示用户输入第一个数字
    read -p "请输入第一个数字: " num1

    # 提示用户输入运算符
    read -p "请输入运算符 (+, -, *, /): " op

    # 提示用户输入第二个数字
    read -p "请输入第二个数字: " num2

    # 检查输入的数字是否为有效的数字
    if ! [[ "$num1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        echo "错误: '$num1' 不是一个有效的数字."
        continue
    fi

    if ! [[ "$num2" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        echo "错误: '$num2' 不是一个有效的数字."
        continue
    fi

    # 根据运算符执行相应的操作
    case $op in
        +)
            result=$(echo "$num1 + $num2" | bc)
            ;;
        -)
            result=$(echo "$num1 - $num2" | bc)
            ;;
        \*)
            result=$(echo "$num1 * $num2" | bc)
            ;;
        /)
            # 检查除数是否为零
            if [ "$num2" == "0" ]; then
                echo "错误: 除数不能为零."
                continue
            fi
            result=$(echo "scale=10; $num1 / $num2" | bc)
            ;;
        *)
            echo "错误: 无效的运算符."
            continue
            ;;
    esac

    # 输出结果
    echo "结果: $result"
    echo "-------------------------"
done

echo "所有运算已完成。"