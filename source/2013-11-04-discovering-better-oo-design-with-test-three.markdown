---
title: "从测试中找到更好的面向对象设计(三)"
date: 2013-11-04 19:43
tags: rubyconf china, ruby, oo, test
author: roy
---

<aside class="aside-block">
  <blockquote>
    <p>这是在 RubyConf China 2013 上分享的一个 Talk, 很多同学给我了一些 Feedback 而且在现场有一些不足，所以我重新整理后以 blog 的形式再次分享出来和大家共同讨论。</p>
  </blockquote>
</aside>

到目前为止我们还没有写任何一行代码，但是 test 让我们望而却步无法继续。很多时候大家讨厌写 test ，或者放弃决定不做 test 都是从此时开始。一开始说过，测试将会反映出我们的设计模式，那么此时我们从测试中可以发现些什么呢？

## Test reflect the design.

我们严格按照业务逻辑写完的 specs ，在这里每一个 *context* 都意味着在我们的实现代码中会产生一个 if statement ，每一个嵌套的 *context* 也就意味着 if statement 的嵌套。

每一个在描述中提到的 object 就将是我们实现代码中需要与之交互作用的。

所以经过我们按照我们目前想像的业务逻辑可以画出这样一张图:

![test-reflect-design](/images/test-reflect-design.png)

在这里我们把所有的业务都交给 **EmailRepliesController#create** 来做，所以就会有这样的结果。具体的问题大致如下：

* Structural Coupling!
* Controller 做了太多太多的事情。
* Controller 知道了太多太多的细节。

发现问题，解决问题。越早的发现问题，我们就会越少的面临难题。在我们还没有写任何一行实现代码的时候就开始重构(Structural Refactoring)，或者我更愿意称之为重新设计(Re-Design)。

在我们开始下一步的重新设计之前，我想先设想一下如果我们坚持把那个复杂的版本做完后会怎么样？当然我还记得那个时候我没有勇气去完成 test，那么如果不写 Test 直接写实现代码会怎么呢？

![havenot-refactoring](/images/havenot-refactoring.png)

看到这样的代码，我想我更没有勇气去做重构了。所以越早的发现问题，就能够越早的避免难题。

## Re-Design From the Test.


> 相关链接
