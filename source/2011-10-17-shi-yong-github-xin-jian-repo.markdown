---
title: "使用github－新建repo"
date: 2011-10-17 22:07
author: roy
---


#### 首先： 新建一个库

每次你使用 *Git* 提交（commit）的时候，它都会被存储进一个库（简称为"repo"）。想要把你的项目放到 *Github* 上，你需要一个 *Github* 库来储存代码。

##### 1.创建一个新的库

点击 **New Repository**.

![](http://help.github.com/images/bootcamp/bootcamp_2_newrepo.jpg)

填写表中的信息。写完后，点击 “**Create Repository**.”

![](http://help.github.com/images/bootcamp/bootcamp_2_repoinfo.jpg)

恭喜！你成功的创建了你的第一个库！

#### 接下来：为你的库创建一个 *README*

当然 *README* 不是 *Github* 库必须要求使用的的，但是最好有一个。 *README* 可以很好描述你的项目，或者增加一些文档，比如说告诉别人如何去安装和使用你的项目。

##### 1. 创建一个 *README* 文件。

在命令行，输入下面的代码：

```	sh
$ mkdir ~/Hello-World
$ cd ~/Hello-World
$ git init
Initialized empty Git repository in /Users/your_user_diretory/Hello-World/.git/
$ touch README
```

用一个文档编辑器，打开刚刚在 *Hello-World* 文件夹里新建的 *README* 文档。在里面录入 “Hello World!”，然后保存。

##### 2. 提交 *README*

现在你已经生成了 *README* ，该提交了。提交本质上是你的项目中所有文件在一个特定时间点快照。 在命令行，输入下面的代码：

```sh
$ git add README
$ git commit -m 'first commit'
```

上面的代码只是在本地执行动作，意味着你现在仍然没有在 *GitHub* 上做任何事情。把你本地库和 *GitHub* 账号连接，你还需要为你的库设置一个远程链接并且把你的提交结果推送上去：

```sh
$ git remote add origin git@github.com:username/Hello-World.git
$ git push origin master
```

现在你可以看一下你在 *GitHub* 上的库，*README* 已经被添加上去了。

![](http://help.github.com/images/bootcamp/bootcamp_2_updatedreadme.jpg)

#### 最后：庆祝一下

现在，你已经在 *GitHub* 上创建了一个库，创建了一个 *README* ，提交并推送到了 *GitHub* 。

> 参考自 [github说明文档](http://help.github.com/create-a-repo/)。
