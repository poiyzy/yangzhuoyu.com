---
title: "oh-my-zsh中无法切换RVM版本"
date: 2012-02-19 16:27
author: roy
---
**最近将 *Mac OS* 自带的 *bash* 换成了目前比较流行的 [*Oh-my-zsh*](https://github.com/robbyrussell/oh-my-zsh)，但是在使用了一些主题以后，发现 *RVM* 无法切换版本。**

解决方法如下：

在 `.zshrc` 最后加上如下代码：

```sh .zshrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
```

> 参考：[RVM is not working in ZSH](http://stackoverflow.com/questions/4755538/rvm-is-not-working-in-zsh)
