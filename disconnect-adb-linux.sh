#/bin/bash

## 取消手机的转发 
host=$1
echo ">>>>>>>> 正在取消与 $1 的连接"
ssh -p 22 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h -R5037:127.0.0.1:5037 -O cancel $host
echo ">>>>>>>> 与 $1 的连接已断开"
ssh -p 22 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h $host "pkill -9 adb"
echo ">>>>>>>> 与 $1 的 adb 服务已终止"
echo ">>>>>>>>  $1 中 adb 连接的手机实例如下："
ssh -p 22 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h $host "adb devices"