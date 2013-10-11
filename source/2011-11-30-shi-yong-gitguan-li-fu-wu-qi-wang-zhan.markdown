---
title: "使用Git管理服务器网站"
date: 2011-11-30 10:36
author: roy
---
**摘要：*push* 到一个拥有分离的 *work tree* 和 一个运行 `git checkout -f` 的 *post-receive hook* 的远程代码库。**

####建立本地代码库

从零开始架设：

```sh
$ mkdir website && cd website
$ git init
Initialized empty Git repository in /home/ams/website/.git/
$ echo 'Hello, world!' > index.html
$ git add index.html
$ git commit -q -m "The humble beginnings of my web site."
```

到此拥有了一个想要上传网站的代码库。

####配置远程代码库

首先我们需要远程服务器有 *SSH* 通道，并且可以不用输入密码连接 *SSH* （通过 *keys*）。

在服务器上，我们创建一个新的代码库来镜像本地代码库。

```sh
$ mkdir website.git && cd website.git
$ git init --bare
Initialized empty Git repository in /home/ams/website.git/
```

然后我们用一个 *post-receive hook* 来 *check out* 最后的版本树到服务器网页目录（这个目录需要手动添加）：

```sh
$ mkdir /var/www/www.example.org
$ cat > hooks/post-receive
!/bin/sh
GIT_WORK_TREE=/var/www/www.example.org git checkout -f
$ chmod +x hooks/post-receive
```

**回到本地工作** 

建立一个远程镜像的名字，然后给它作镜像，新建一个新的 "*master*" 分支。

```sh
$ git remote add web ssh://server.example.org/home/ams/website.git
$ git push web +master:refs/heads/master
```

在服务器上，`/var/www/www.example.org` 现在应该包含一份文件的拷贝，以及所有独立的 `.git` 元数据。

####更新

在本地代码库运行

```sh
$ git push web
```

这将会传送所有新的 *commits* 到远程代码库，而且 *post-receive hook* 会立即更新根目录。

####小结

首先，工作树需要有可写权限。

另外，你也可以 *push* 到更多的远程代码库，在 `.git/config` 中加入代码。

```sh
[remote "web"]
url = ssh://server.example.org/home/ams/website.git
url = ssh://other.exaple.org/home/foo/website.git
```

> 参考：[Using Git to manage a web site](http://toroid.org/ams/git-website-howto)
