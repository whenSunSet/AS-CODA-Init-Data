#/bin/bash

runAS() {
    echo ">>>>>>>> 删除已存在的容器：test-as-vscode"
    docker stop test-as-vscode && docker rm test-as-vscode
    echo ">>>>>>>> 加载镜像中，请耐心等待."
    docker docker load --input as-vscode-dev-env-v7.tar 
    echo ">>>>>>>> 开始运行新的容器：test-as-vscode。"
    sudo docker-compose -f docker-compose-mac.yml up -d
    echo ">>>>>>>> 容器运行完毕，进入初始化，请在初始化完毕之后，执行 exit 进行退出。"
    docker exec -it test-as-vscode /bin/zsh
}

runAS