---
title: "从测试中找到更好的面向对象设计(一)"
date: 2013-11-02 13:33
tags: rubyconf china, ruby, oo, test
author: roy
---


![OO](http://thumbs.dreamstime.com/z/齿轮启用-14070207.jpg)
&copy; [thumbs.dreamstime.com](http://thumbs.dreamstime.com/)

Discovering Better **Object Oriented Design** with **Test**. 我知道很多团队中不写 Test, 不是因为不会写测试，而是觉得测试写起来很麻烦、很痛苦, 不愿意写测试；我也知道很多程序员不关心设计模式，什么面向对象之类的都不在乎，只要代码能工作就好。

我从 PHP 转过来的时候就是这样的感觉，当时 PHP 也没有学好，不懂得什么叫面向对象，更不知道什么叫做测试。只是写代码，写完后在浏览器上看一下，如果可以工作，大功告成！

转到 Ruby 后，接触到了 Object Oriented Design Pattern 和 TDD，开始觉得这些我都不再乎，但是随着不断的深入以及项目复杂度的不断提升。我发现这些技能非常受用。

## Hate to write Tests.

首先我们来聊聊 Test. 一说到 Test, 第一反映就是测试可以保护我们代码的有效性。那么我们又为什么不愿意写测试呢？

* 有时候业务逻辑太复杂不知道怎么写。
* 有些时候测试写到一半的时候由于太复杂枯燥，写不下去了。

因为这两个因素导致我经常会在写测试上浪费大把大把的时间。所以我相信有很多人跟我一样会选择在写完实现代码后，再去补上我们的测试。但是 **TDD** 强调的是*测试先行*，那为什么很多人愿意忍受这样的痛苦去在测试中浪费那么多的时间和精力呢？

* 有时候业务逻辑太复杂不知道怎么写。

正因为这个问题，所以首先写测试的话会驱使我们一步一步的来思考我们的业务流程，一步一步的思考我们需要实现的功能。所以这样写出来后，测试回直接反映出我们的设计结构。

* 有些时候测试写到一半的时候由于太复杂枯燥，写不下去了。

因为我们的测试直接反映出了我们的设计结构，所以这是一个信号：*我们的设计有问题！*

**Why we need OO design**

如果程序架构设计不好的话，首先我们的代码不“干净”、其次代码可读性低、可维护性差。

那么如果我们可以尽早发现我们设计上的不合理，我就可以尽早的拜托代码带来的困恼。因为刚才我们提到*测试*可以反映出我们设计的缺陷，所以在没有开始写任何实现代码的时候，我们就可以**从测试中找到更好的面向对象设计**。

## A Tutorial of developing a real production environment application.

很多项目管理工具都会有 Email 提醒功能，当项目中创建一个任务的时候，团队中的所有成员都会收到一个提醒邮件告知用户新创建任务的详细内容。如果我们能够在看到 Email 提醒的时候不需要打开浏览器去创建留言，而只需直接回复这个 Email 创建回复来发起讨论将会非常方便。

这个[功能](https://pragmatic.ly/blog/new-feature-comment-via-email/)已经在 [Pragmatic.ly](https://pragmatic.ly) 中实现并部署上线。接下来的内容，我将会展示这个新功能应用测试驱动开发和重新设计的实现过程。


> 相关链接：[视频](http://www.infoq.com/cn/presentations/with-tests-found-a-better-object-oriented-design)
