---
title: "Ruby 1.9.2中文不支持UTF8报错invalid multibyte char (US-ASCII)"
date: 2012-02-20 12:14
author: roy
---
在 *ruby* 程序中写入中文，执行报错：

```sh
invalid multibyte char (US-ASCII)
```

最后发现是 *locale* 设置问题。

主要问题发生于 *Ruby 1.9* 中（上一篇文章中也有提到这个通用问题），*Ruby 1.9* 与之前版本相比较对于编码处理的差异很大，如写中文必须要在文件首行加入 `# encoding: UTF-8` ，例如：

```ruby test.rb
# encoding: UTF-8
@test = "这是一个测试"
puts @test
```

> 参考：[安裝Rails開發環境](http://ihower.tw/rails3/installation.html)
