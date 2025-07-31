## **GITEE提交前提工作**

**1.设置SSH**

​    cd ~/.ssh

​    ssh-keygen

​    cat id_rsa.pub

​    复制内容到Gitee-设置-SSH Key里面

**2.设置用户名和密码**

​    \#忽略文件模式变化

   git config core.fileMode false

​    git config --global user.name "XXX"

​    git config --global user.email "XXX"

**3.Fork主仓库，克隆个人分支(以iotwins为例，以实际的为主)**

​    git clone git@gitee.com:iotwins/hpcrunner.git

**4.建立个人仓库和远程主仓库的联系**

git remote add upstream git@gitee.com:openeuler/hpcrunner.git



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

**FAQ**

**1.某次commit的信息提交错误怎么办？**

**1.1 git stash**

Git提供了一个git stash命令, 其将当前未提交的修改(即工作区的修改和暂存区的修改)先暂时储藏起来，这样工作区干净了后，就可以完成线上bug的修复，之后通过git stash pop命令将之前储藏的修改取出来，继续进行新功能的开发工作

**1.2 git rebase**

git rebase -i {commitID} // 例如 git rebase -i sd98dsf89sdf
执行 rebase 命令后，会出现 reabse 的编辑窗口，窗口底下会有提示怎么操作。
这里把需要修改的 commit 最前面的 pick 改为 edit，可以一条或者多条。
根据提示，接下来使用 --amend 进行修改
只修改注释信息:  git commit --amend
只修改作者、邮箱: git commit --amend --author="zhangsan <hello.gmail>" --no-edit 
同时修改注释信息、作者、邮箱: git commit --amend --author="zhangsan <hello.gmail>"
修改完成后，继续执行下面命令
git rebase --continue 
直到出现以下提示，说明全部修改已经完成。
Successfully rebased and updated xxx

**1.3 git push**

提交到远程仓库：
git push --force origin master 