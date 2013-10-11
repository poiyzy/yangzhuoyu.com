---
title: "同时同步到heroku和github"
date: 2011-10-18 13:48
author: roy
---


现在使用的 *Octopress* ，在写完文章和做修改后，想要同时 *push* 到 **Github** 和 **Heroku** 。它们两个是同一个 *Repo* ，想要在一条命令中完成。

一次完成多线程 *push* ,需要用到 `git remote set-url` 命令。

``` bash
$ git remote add all git@github.com:username/app-name.git
$ git remote set-url --add all  git@herku.com:username.git
```

在 **.git/config** 文件中将会产生下面的代码：

``` bash .git/config
[remote "all"]
url = git@github.com:username/app-name.git
url = git@herku.com:username.git
```

然后运行命令：

``` bash
$ git push all
```

如果你的 *repos* 只有你一个人可写操作，你就只需要在一次 *push* 中更新。

> 参考自 [Stack Overflow](http://stackoverflow.com/questions/6013362/github-and-heroku-repos-how-to-read-push-pull-and-generally-keep-them-synced)
