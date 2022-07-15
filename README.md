# 一次配置，处处开发(Configure Once Develop Anywhere)——AndroidStudio篇

> 一次配置，处处开发。十分钟一键部署 Android + AndroidStudio 开发环境，将你的 Android 开发环境云端化，妈妈再也不用担心我因为电脑坏掉而重新部署开发环境了。

- [一次配置，处处开发(Configure Once Develop Anywhere)——VScode篇](https://juejin.cn/post/7052671346546835493)

![图1：使用](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/使用.gif)

## 一、问题

**日常开发过程中我们可能会因为各种各样的原因丢失开发环境。**
- 电脑坏掉了。
- 电脑在公司没带回家，有紧急 bug 要在家解决。
- 团建临时使用其他同学的电脑。

**又或者是某个开发环境在自己的电脑上安装不上，在别人的电脑上却可以安装，然后花费大量的时间去找问题。**
- python2、python3 因为路径问题而冲突
- node、yarn、npm 版本不匹配。
- FFmpeg 依赖的 debug 环境太过复杂，很难安装上

**那么，有没有一个东西能让我们做到：** 
## 一次配置，处处开发(Configure Once Develop Anywhere) ？

**非常幸运的是 Docker 能实现我们的愿望，只要我们的一切开发环境都部署在Docker上。**

**理想很丰满，现实很骨感。虽然python、node 这些东西都能通过命令行安装和使用，但是大部分程序员都是使用 IDE 来进行代码开发，典型的 IDE 有下面这些：**
- JetBrains 全家桶： IntelliJ IDEA(Java)、Android Studio(Android)、WebStorm(前端)、PyCharm(python)、Gogland(go) 等等
- VSCode：大前端、python、c/c++
- Vim：c/c++、go
- Eclipes：Java
- Visual Studio：c/c++、c# 等等
- Xcode：iOS、iPad、Mac

**上面这些 IDE 里面：JetBrains全家桶、VSCode、Vim、Eclipse 都能被部署到 Docker 镜像里，然后通过浏览器访问，可以说已经能够满足 70%的程序员了。**
- **JetBrains 全家桶**可以通过 [Projector](https://github.com/JetBrains/projector-docker) 来云端化。
- **VSCode**可以通过 [Code-Server](https://github.com/coder/code-server) 来云端化。
- **Vim**不用说了，直接使用远程命令行就行，也可以结合 Code-Server 使用。
- **Eclipse**可以通过 [Eclipse Che](https://github.com/eclipse/che) 来云端化。

**今天这篇文章我将通过一次性配置 Android + AndroidStudio 环境来介绍 Android 开发环境的云端化，你需要做的工作非常少，跟我一起来看看吧!**

## 二、快速使用起来

> 下面两个部署小节，可以根据你的计算机系统选择性阅读。

![图2：部署](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/部署.gif)

### 1.Mac系统快速部署

第一步：[安装Docker](https://zhuanlan.zhihu.com/p/91116621)，非常简单我就不重复了。**注意 Mac 下的 Docker 默认给予的资源是不太够的，需要大家手动将内存设置到最少8g，不然会出现 AS 启动不了的情况。**

第二步：执行 `git clone git@github.com:whenSunSet/AS-CODA-Init-Data.git ~/as-dev-env-init`，随便放在一个位置，例如 ～/as-dev-env-init。**注意后面的部署目录不要放在这个目录里，否则会报错。**

第三步：因为我们后面的命令依赖 **gsed**，所以这里我们通过 brew 来安装。可以执行 `brew install gnu-sed` 来进行安装。

第四步：执行 `cd ~/as-dev-env-init && sh run-mac.sh`，然后输入你期望部署的路径，例如我们输入 **default** 将部署的目录设置为 ～/as-dev-env，接下来就是等待了。
**注意这一步可能会花费比较长的时间，因为我们的镜像比较大，大家需要耐心等待，如果下载速度过慢建议使用国内的 docker 镜像加速。**

第五步：最后当我们的容器启动之后，我们在容器内执行 `cat nohup.out` 可以发现输出了一些提示，我们依照提示访问例如：https://localhost:7642/?token=20220119.test.Androidstudio ，此时就能看见 AS 的页面了。

### 2.Linux系统快速部署

第一步：安装 Docker 非常简单我就不重复了。

第二步：执行 `git clone git@github.com:whenSunSet/AS-CODA-Init-Data.git ~/as-dev-env`，随便放在一个位置，例如 ～/as-dev-env。

第三步：执行 `cd ~/as-dev-env && bash run-linux.sh`，然后输入你期望部署的路径，例如我们输入 **default** 将部署的目录设置为 ～/as-dev-env，接下来就是等待了。
**注意这一步可能会花费比较长的时间，因为我们的镜像比较大，大家需要耐心等待，如果下载速度过慢建议使用国内的 docker 镜像加速。**

第四步：最后当我们的容器启动之后，我们在容器内执行 `cat nohup.out` 可以发现输出了一些提示，我们依照提示访问例如：https://localhost:7642/?token=20220119.test.Androidstudio ，此时就能看见 AS 的页面了。

## 三、远程 Android 开发工作流

> 远程部署了 Android Studio 之后，我们的开发只能算是勉强能用，但是要达到好用的程度，还需要经过下面的一系列配置。也不麻烦，大家可以跟着我来做一下。

### 1.解决浏览器的适配问题

**虽然我们可以在Chrome Safari 等等浏览器上访问远程部署的 AS，但是因为浏览器的各种各样的问题例如 https安全、快捷键冲突等等问题，要想要达到本地的效果，我们还需要下载一个适配了远程 AS 的客户端。**

客户端可以在[这里](https://github.com/JetBrains/projector-client/releases)下载。

**当然如果你不在乎快捷键之类的问题，你也完全可以在浏览器上面进行远程 AS 的访问。这个客户端也就几十MB，只是封装了一下 electron，解决了一些浏览器的问题。**

### 2.远程 adb 调试——容器部署在Mac上

**如果你的 AS 容器就部署在本机上，且你直接在本机连接了手机，然后期望在容器中的 AS 上用 adb 调试手机，只需要执行下面四个步骤：**

第一步：执行 `sh login-as-container.sh` 登录容器，然后在容器中执行 `vi /etc/ssh/sshd_config`, 将 **PermitRootLogin** 改为 yes。

第二步：在容器中执行 `service ssh restart`, 重启 ssh。

第三步：在容器中执行 `cd ~/.ssh` 让后将本机的 ~/.ssh/id_rsa.pub 中的内容，写入容器中的 ~/.ssh/authorized_keys(如果文件不存在就创建一个)。

第四步：执行 `exit` 退出容器，然后在本机上执行 `sh connect-adb-mac.sh root@localhost`，此时你就能在 AS 上看见你的手机了。

**如果你想要取消 adb 的连接，可以执行 `sh disconnect-adb-mac.sh whensunset@172.29.77.121`**

**如果你的 AS 容器部署在本机上，但是手机连接在了其他计算机上，然后期望在容器中的 AS 上使用 adb 调试手机。因为 Mac 的限制，这种场景目前不好建连，建议将容器部署在 Linux 上，然后看下面一节。**

### 3.远程 adb 调试——容器部署在Linux上

**如果你的 AS 容器就部署在本机上，且你直接在本机连接了手机，然后期望在容器中的 AS 上用 adb 调试手机，不需要进行任何操作，就能直接调试了。**

**如果你的 AS 容器部署在本机上，但是手机连接在了其他计算机上，然后期望在容器中的 AS 上使用 adb 调试手机，只需要执行下面两个步骤。**

第一步：获取 AS 容器部署的 Linux 机器的 **用户名@ip**，例如 **whensunset@172.29.77.121**。

第二步：确认你当前的计算机能够 ssh 链接到 AS 容器部署的 Linux 机器上后。在当前计算机上执行 `sh connect-adb-linux.sh whensunset@172.29.77.121`，此时你就能在 AS 上看见你的手机了。

**如果你想要取消 adb 的连接，可以执行 `sh disconnect-adb-linux.sh whensunset@172.29.77.121`**

### 4.异常情况处理
- 网络情况不好，部署时间过长或者总是失败：**针对这种情况，我提供了百度云下载镜像的方式，让你绕过 Docker Hub**
    ```shell
    ## 1.通过百度云盘，下载下面的镜像
    链接: https://pan.baidu.com/s/1ctabVZyom0deyQBuMiZjEg  密码: 37vt

    ## 2.导入下载好的镜像
    docker load --input as-image-v5.zip 
    ```
- 本机上的 adb 版本需要与容器中的 adb 版本一致，不然会报错。容器中的 adb 使用的是 **1.0.39**，可以通过 adb --version 来确认 adb 版本。
    ``` shell
    ## Mac 如何安装 adb 1.0.39
    wget https://dl.google.com/android/repository/platform-tools_r26.0.1-darwin.zip
    unzip platform-tools_r26.0.1-darwin.zip >/dev/null
    cd platform-tools
    ./adb --version|head -1
    Android Debug Bridge version 1.0.39
    ```
- 如果执行 `sh connect-adb.sh root@localhost` 后，容器里执行 `adb devices` 出现 **Connect reset by peer**, 那么表示本机 adb server 没有启动成功，需要 pkill 然后重新启动。

## 四、原理简介

### 1.基础原理
![图3：原理简介](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/原理简介.png)

如图3，我们接下来从顶部开始简单介绍本文技术的原理。

- 用户可以使用**实体计算机1**，运行浏览器或者远程 AS 的客户端 Projector Client。
- **实体计算机2**是远程 AS 容器的宿主计算机，其暴露了两个端口 8080 和 7642。处于同一局域网的其他计算机可以通过这两个端口分别访问 Code Server(远程 VSCode) 和 AndroidStudio。
- 当然**实体计算机2**也可以安装浏览器或者 Projector Client，这样一来也可以访问 localhost:8080 或者 localhost:7642 以分别访问 Code Server  和  AndroidStudio
- AS 容器是通过 Docker 基于**实体计算机2**虚拟出来的 Linux 系统，所以里面可以安装各种程序，其内部也有各种目录。我们这里主要关注我们需要使用的程序和目录
  - 程序：
    - Code Server 和 AndroidStudio 我们前面说过了，是对外暴露的两个应用程序。
    - git、ssh、adb 这些是 Android 开发需要用到的基本功能，这里也提前安装了。
    - Projector Server 就是将 AndroidStudio 云端化的程序，这个是由 JetBrains 开源的，可以云端化 JetBrains 所有的 IDE。
    - Python3 是 Projector Server 的依赖。
  - 目录：因为容器内部的目录和宿主的目录是不互通的，所以 Docker 提供了挂载 Volume 的方式将宿主的目录挂载到容器内部。这样一来，我们的个人数据就能放在这个目录里，而不会随着容器的删除而消失。这里挂载的目录，就是前面部署章节让你输入的目录，例如 ~/as-dev-env，这个是宿主目录的路径。在容器内部的路径则是 ~/data。接下来我们介绍的目录，都在这里面。
    - envconfig:
      - envconfig/config/alias-ws-config：里面存放着 alias，如果你想添加一些自己的命令，可以往 alias-enter.zsh 里面加。
      - envconfig/config/person-ws-config/.ssh：需要将你本地的 ~/.ssh 复制进来，这样才能将代码 push 到 gitlab 上，或者登陆其他的主机。
      - envconfig/config/person-ws-config/.git/.gitconfig：需要改为你的名字和邮箱，这样你写的代码的 blame 才正确。
      - envconfig/config/vim-ws-config：里面是 vim 的配置，**没有非常强烈的需求不建议更改**。
      - envconfig/config/vscode-ws-config：里面是 vscode 的配置和快捷键，可以在文件里改，也可以通过 VSCode 修改。
      - envconfig/config/jetbrains-ws-config：里面是 AS 的各种配置，建议通过 AS 修改。
      - envconfig/config/zsh-ws-config：里面是初始化的配置，**没有非常强烈的需求不建议更改**。
      - envconfig/data：里面放着一些我们不需要修改但是 vscode 依赖的数据，**强烈不建议更改**。
    - AndroidStudioProjects：我们的 Android 项目目录，里面默认有一个 TestApplication 作为测试项目。
    - Android、jdk1.8：android sdk  和 java sdk 的目录
    - .gradle：gradle 的数据目录，我们下载的库都在里面
    - .android：android 开发的数据目录
- 只要你的计算机硬件强大，那么你可以在一台电脑上通过 docker 虚拟出很多的容器，所以继续往下我们可以看见除了 AS 容器，还可能有 IDEA 容器，VSCode 容器。当然这些容器这次的文章没有提到，VSCode 容器我在[这篇文章](https://juejin.cn/post/7052671346546835493)中介绍了，有兴趣的同学可以去看看。至于 IDEA 容器则会放在下一期来介绍。
- 最后就是我们的基础系统了，三大主流操作系统都支持 Docker，所以我们可以把 AS 容器部署在这些系统之上。本篇文章前面两章就介绍了 Mac OS 和 Linux 的快速部署方式。

### 2.远程 adb 原理

我们上一章节介绍了三种远程 adb 的调试方式，所以这一小节，我们来介绍一下这三种远程 adb 调试方式的原理。\
要了解远程 adb 的原理，我们先得知道一个事情那就是：adb 是 C/S 架构，也即使 adb 整体存在 adb server 和 adb client。\
adb server 负责和手机通信，adb client 则是我们经常使用的命令，可以和 adb server 通信，将我们的命令发送给 adb server，然后 adb server 来执行这个命令。\
所以如果有两台计算机在同一个局域网中，我们可以在计算机1上运行 adb server，然后在计算机2上通过 adb client 来访问计算机1上的 adb server

#### (1).部署在 Linux 上，手机连接在其他计算机
![图4：远程adb原理-linux-1](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/远程adb原理-linux-1.png)


如图4，在这种场景，整个连接方式是这样的：
- Android 手机通过数据线连接着**实体计算机1**，这个计算机可以是任意系统只要其能运行 adb server。
- **实体计算机1**启动了 adb server，其暴露的端口是 5037，我们可以通过访问这个端口从而访问 adb server。也启动了 ssh 以备后续转发使用。
- **实体计算机2**是 Linux 系统，Docker 使用了 Host 模式，使得容器可以直接使用宿主机的端口，所以这里容器使用了宿主机的 5037端口。
- 接下来，我们通过 ssh 将**实体计算机1**的5037端口转发到**实体计算机2**的5037端口上，此时 AS 容器内部的 adb client 就能通过访问 AS 容器的 5037 端口来访问到**实体计算机1**的 adb server。
- 最终 AS 容器内部的 AndroidStudio 就能通过识别 adb client 访问到的 adb server 来展示**实体计算机1**上连接的 Android 手机了。

#### (2).部署在 Linux 上，手机连接在当前 Linux
![图5：远程adb原理-linux-2](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/远程adb原理-linux-2.png)

如图5，这种场景比较简单，因为 Linux 下 Docker 的 Host 模式，所以 AS 容器的 adb client 能直接访问到宿主机的 adb server，我们啥也不需要做。

#### (3).部署在 Mac 上，手机连接在当前 Mac 
![图6：远程adb原理-mac-2](https://cdn.jsdelivr.net/gh/whenSunSet/image-lib/远程adb原理-mac-2.png)

如图6，因为 Mac 不支持 Host 模式，所以虽然这个场景和场景2类似，但是我们只能走场景1的逻辑。

## 五、一些技巧和知识

- 访问 http://localhost:8080，输入密码： **20211215.test.vscode**，可以看见 VSCode 的界面，对容器内部目录进行管理，也可以通过 VSCode 的 Terminal 来在容器内部运行命令。
- 如果你想要在其他机器重新部署服务的话，非常简单。将 **~/as-dev-env** 目录拷贝到你需要的机器上(注意里面的 cache 目录不需要拷贝)，安装好 Docker 之后，重新走一遍部署流程，就能无缝迁移。如果你嫌 **~/as-dev-env** 目录太大，可以将里面的目录都删除，只留下 envconfig 和 AndroidStudioProjects，这样一来虽然部署后需要重新下载依赖，但是可用的数据都不会丢失。

## 六、后续展望

**本篇文章是《一次配置，处处开发》系列文章的第二篇，后续还会分享更多不同的 IDE 云端化、容器化的构建方式，例如我目前已经投入生产环境的 IDEA。**

**最后你都看到这里了，不来点赞收藏一波吗？你们的喜欢是我写作的最大动力，我们下篇文章见！**