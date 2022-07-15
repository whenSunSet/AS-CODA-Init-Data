#/bin/bash

## 将当前计算机上连接的手机，通过 ssh 转发到 AS 容器里
echo ">>>>>>>> 正在连接$1"
host=$1
echo ">>>>>>>> 重启本地 adb 服务"
pkill -9 adb
adb start-server
echo ">>>>>>>> 关闭 $1 中的 adb 服务"
ssh -p 2222 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h $host "pkill -9 adb"
echo ">>>>>>>> 转发本地 adb 服务到 $1 中"
ssh -p 2222 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h -R5037:127.0.0.1:5037 -O forward $host
echo ">>>>>>>>  $1 中 adb 连接的手机实例如下："
ssh -p 2222 -q -o ControlMaster=auto -o ControlPath=/tmp/%r@%h-adb -o ControlPersist=2h $host "adb devices"