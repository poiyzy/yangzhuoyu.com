---
title: "使用pow运行sinatra"
date: 2011-12-05 13:26
author: roy
---
今天想拿 *[Sinatra](http://www.sinatrarb.com/intro)* 这个轻量级的 *web* 框架练练手，写个小程序，可是使用 `ruby myapp.rb` 运行非常的麻烦。所以想到用 *Rails* 推荐的 *[Pow](http://pow.cx/)* 来跑。

在 *[Sinatra](http://www.sinatrarb.com/intro)* 建立的 *app* 文件根目录下建立 *config.ru* 。

```sh config.ru
require "rubygems" #必须要写，不然pow报错
require "./myapp" #要运行的文件，相当于index，这里是myapp.rb

run Sinatra::Application
```

>参考：[传送门](https://github.com/37signals/pow/issues/38)
