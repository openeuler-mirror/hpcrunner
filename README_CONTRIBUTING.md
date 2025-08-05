# 贾维斯项目欢迎您的专业技能和热情参与！

小的改进或修复总是值得赞赏的；先从文档开始可能是一个很好的起点。如果您正在考虑做出更大贡献，请提交一个issue或者在hpc.openeuler.org进行讨论。

编写代码并不是为贾维斯做出贡献的唯一方法。您还可以：

- 贡献安装脚本
- 帮助我们测试新的HPC应用
- 开发教程、演示
- 为我们宣传
- 帮助新的贡献者加入



## 贾维斯项目特色
![贾维斯功能概览](./images/jarvis.png)
- 支持ARM/X86,一键部署，采用业界权威依赖目录结构管理海量依赖，自动生成module file
- 根据HPC配置实现一键编译运行、一键CPU/GPU性能采集、一键Benchmark.
- 所有配置仅用一个文件记录，HPC应用部署到不同的机器仅需修改配置文件.
- 日志管理系统自动记录HPC应用部署过程中的所有信息.
- 软件本身无需编译开箱即用，仅依赖Python环境.
- HPC应用容器化-目前QE已经实现，参考container目录.
- (未来) 集成HPC领域常用性能调优手段、核心算法.
- (未来) 集群性能分析工具.
- (未来) 智能调优.

## 贾维斯开发规划

![RoadMap](./images/roadmap.png)

# **代码合入指导**

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


## **FAQ**

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


# HPCRunner 开发者注意事项
## 1、使用安装HPCKIT的方式替代单独安装HMPI、BISHENG以及数学库
建议使用如下方式安装并使能hpckit
```
./jarvis -install package/hpckit/24.0.0/ any
module use software/utils/hpckit/224.0.0/HPCKit/24.0.0/modulefiles
module purge
module load bisheng/compiler4.1.0/bishengmodule bisheng/hmpi2.4.3/hmpi
```
不建议使用如下方式
```
./jarvis -install hmpi/1.1.1 clang
module use software/moduledeps/bisheng2.1.0
module load hmpi/1.1.1
```
## 2、开发模板路径禁止使用绝对路径
如不建议使用如下方式
```
export JARVIS_ROOT=/hpcrunner
```






# 技术文章

揭开HPC应用的神秘面纱：https://zhuanlan.zhihu.com/p/489828346

我和容器有个约会：https://zhuanlan.zhihu.com/p/499544308

贾维斯：完美而凛然HPC应用管家 https://zhuanlan.zhihu.com/p/518460349

更多信息请添加openEuler HPC SIG微信群了解更多HPC部署调优知识
![微信群](./images/wechat-group-qr.png)
