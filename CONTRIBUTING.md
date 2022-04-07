## **GITEE前提工作**

​    **1.Fork主仓库，克隆个人分支(以iotwins为例，以实际的为主)**

​    git clone git@gitee.com:iotwins/hpcrunner.git

​    **2.建立和远程主仓库的联系**

git remote add upstream git@gitee.com:openeuler/hpcrunner.git

​    **3.设置SSH**

​    cd ~/.ssh

​    ssh-keygen

​    cat id_rsa.pub

​    复制内容到Gitee的SSH Key里面

​    **4.设置用户名和密码**

​    \#忽略文件模式变化

   git config core.fileMode false

​    git config --global user.name "XXX"

​    git config --global user.email "XXX"

## **社区提交代码流程**

**1.先切回master分支，拉取最新社区代码**

git checkout master

git pull upstream master

**2.新建需求分支（分支名自定义），并切换到新分支**

git checkout -b new_branch

**3.修改代码**

**4.提交修改的代码**

git add .

git commit --no-verif -m "Add XXX function"

git push origin new_branch

**5.在gitee创建PR**

https://gitee.com/iotwins/hpcrunner
