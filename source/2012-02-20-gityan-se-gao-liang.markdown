---
title: "Git颜色高亮"
date: 2012-02-20 09:51
author: roy
---
在 *Terminal* 中使用 `git status` 和 `git diff` 时，没有高亮，非常费眼，效率低。

可以在 *git* 中设置颜色高亮来解决这个问题。输入如下命令：

```sh
$ git config --global color.ui true
```

运行 `git status` 效果：

![git_highlight](http://i.imgur.com/EuQZo.png)

另外，关于git的学习，非常推荐的资源 [*ProGit 中文*](http://progit.org/book/zh/)

> 参考：[*ProGit*](http://progit.org/book/zh/ch1-5.html)
