echo "欢迎使用HC独家计算器"

if ! [ -e "rc4" ]; then
    echo "rc4文件缺失"
    exit 1
fi
chmod 777 rc4

#配置区
w58076d6605487b718796df7170196b1b_wyUrl="http://wy.llua.cn/api/" #API接口(一般不用改)
w58076d6605487b718796df7170196b1b_wyAppid="75896" #APPID(应用ID)
w58076d6605487b718796df7170196b1b_wyAppkey="KAzkkyaMAMKIymKX" #APPKEY(应用秘钥)
w58076d6605487b718796df7170196b1b_wyRc4key="246a6f5676c5f1032c43e7ec7b244cee" #Rc4KEY(Rc4秘钥)

#函数区
parse_json() {
  json=$1
  query=$2
  value=$(echo "$json" | grep -o "\"$query\":[^ }]*" | sed 's/"[^"]*":\([^,}]*\).*/\1/' | head -n 1)
  value="${value#\"}"
  value="${value%\"}"
  echo "$value"
}

#公告区
notice=`curl -s "${w58076d6605487b718796df7170196b1b_wyUrl}?id=notice&app=${w58076d6605487b718796df7170196b1b_wyAppid}"`
deNotice=`./rc4 $notice $w58076d6605487b718796df7170196b1b_wyRc4key "de"`
Notices=`parse_json "$deNotice" "app_gg"`
echo "系统公告:${Notices}"


#验证区
echo "请输入卡密：(点击屏幕右下角lm弹窗键盘)"
read kami
timer=`date +%s`
android_id=`settings get secure android_id`
fingerprint=`getprop ro.build.fingerprint`
imei=`echo -n "${android_id}.${fingerprint}" | md5sum | awk '{print $1}'`
value="$RANDOM${timer}"
sign=`echo -n "kami=${kami}&markcode=${imei}&t=${timer}&${w58076d6605487b718796df7170196b1b_wyAppkey}" | md5sum | awk '{print $1}'`
data=`./rc4 "kami=${kami}&markcode=${imei}&t=${timer}&sign=${sign}&value=${value}&${w58076d6605487b718796df7170196b1b_wyAppkey}" $w58076d6605487b718796df7170196b1b_wyRc4key "en"`
logon=`curl -s "${w58076d6605487b718796df7170196b1b_wyUrl}?id=kmlogin&app=${w58076d6605487b718796df7170196b1b_wyAppid}&data=${data}"`
deLogon=`./rc4 $logon $w58076d6605487b718796df7170196b1b_wyRc4key "de"`
w58076d6605487b718796df7170196b1b_wy_Code=`parse_json "$deLogon" "ued3bbed73f9c79e6ba7e1369024f5cc7"`
if  [ "$w58076d6605487b718796df7170196b1b_wy_Code" -eq 14550 ]; then
    kamid=`parse_json "$deLogon" "u32e8875f8ee9c5ae5196fc6ae560a68a"`
    timec=`parse_json "$deLogon" "m22c26425c4db25e96e348b6feb2077cd"`
    check=`echo -n  "${timec}${w58076d6605487b718796df7170196b1b_wyAppkey}${value}" | md5sum | awk '{print $1}'`
    checks=`parse_json "$deLogon" "m5c434205a08100585d0889e7f6156bbd"`
    if  [ "$check" == "$checks" ]; then
        vip=`parse_json "$deLogon" "n8d606bbbe34f8e0fcd857d61f35f3494"`
        vips=`date -d @$vip +"%Y-%m-%d %H:%M:%S"`
        clear
        echo "登录成功，到期时间：${vips}"
    else
        echo "校验失败"
        exit
    fi
else
    parse_json "$deLogon" "n51fa80bff21fe5751a749f941a5e3b07"
    exit
fi




echo "验证成功后程序开始执行..."
# 主菜单函数
function show_menu {
    echo "请输入您的选择:"
    echo "1. 运行单独计算器<仅可运行2位数算法>"
    echo "2. 运行连续计算器"
    echo "3. 退出"
}

# 主循环
while true; do
    show_menu
    read choice
    case $choice in
        1)
            # 运行计算器脚本
            ./计算器1.sh
            ;;
        2)
            # 运行另一个脚本
            ./计算器.sh
            ;;
        3)
            # 退出程序
            echo "Exiting..."
            break
            ;;
        *)
            # 无效选项
            echo "输入无效请重新输入."
            ;;
    esac
done