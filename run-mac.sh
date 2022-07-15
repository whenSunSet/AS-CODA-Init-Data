#/bin/bash

main() {
    echo ">>>>>>>> 此脚本用于 Mac 系统，请确认系统的正确，如果确认则忽略本提示。"
    echo ">>>>>>>> 输入期望部署的路径(输入 default 表示使用默认路径：~/as-dev-env): "
    read path 
    if [ $path == "default" ]
    then
        path="$HOME/as-dev-env" 
        echo ">>>>>>>> 部署路径设置为默认的：$path，如果部署出现异常请删除该目录，然后重新执行部署流程。"
    else
        echo ">>>>>>>> 部署路径设置为：$path，如果部署出现异常请删除该目录，然后重新执行部署流程。" 
    fi
    gsed -i "15d" docker-compose-mac.yml
    gsed -i "14a - $path:/root/data" docker-compose-mac.yml
    gsed -i "15s/^/            /" docker-compose-mac.yml
    echo ">>>>>>>> 配置已完成，请勿修改 docker-compose-mac.yml 文件"
}

runAS() {
    echo ">>>>>>>> 删除已存在的容器：test-as-vscode"
    docker stop test-as-vscode && docker rm test-as-vscode
    echo ">>>>>>>> 开始运行新的容器：test-as-vscode，依照网络情况的不同，部署时间可能会超过1小时，请耐心等待。"
    sudo docker-compose -f docker-compose-mac.yml up -d
    echo ">>>>>>>> 容器运行完毕，进入初始化，请在初始化完毕之后，执行 exit 进行退出。"
    docker exec -it test-as-vscode /bin/zsh
}

main
runAS