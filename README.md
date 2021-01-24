# 修改配置
修改config文件后构建镜像，或者使用已有的镜像创建容器后，再更改设置
已有的镜像：dockerhub  karthrand/svn:1.0

# 构建镜像命令
docker build -t [自定义镜像名] .
# 启动容器命令
docker run --restart always --name svn -d -v /home/data/svn:/var/opt/svn --network=host [自定义镜像名] 
注：
- /home/data/svn是本地存储svn数据的地址
- --network=host表示网络使用主机网络，及IP容器内和外部宿主机一致

# 更改设置
在第一次启动后，在本地的数据存放地址，如/home/data/svn下会自动创建config文件
修改其中的用户名、密码、anon_access_set可以更改原容器配置
如更改密码后，重启svn容器即可修改svn的密码
重启svn命令
docker restart svn