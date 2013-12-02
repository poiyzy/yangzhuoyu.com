---
title: "从测试中找到更好的面向对象设计(四)"
date: 2013-12-01 12:02
tags: rubyconf china, ruby, oo, test
author: roy
---

<aside class="aside-block">
  <blockquote>
    <p>这是在 RubyConf China 2013 上分享的一个 Talk, 很多同学给我了一些 Feedback 而且在现场有一些不足，所以我重新整理后以 blog 的形式再次分享出来和大家共同讨论。</p>
  </blockquote>
</aside>

继续前一篇文章，我们实现了 *EmailRepliesController* ，但是我们抽取了一个新的类 *EmailHandler*。接下来，我们来完成这个新的类。

![#handle-test](/images/handle-test.png)

和刚才的思路一样，我们不在乎它是如何做 validation 的，我们只需要知道有效的时候会创建 comment，无效的时候不会创建 comment。

READMORE

接下来需要具体完成这个test：

![handle-test-2](/images/handle-test-2.png)

在这里，我们不关心什么是 valid email 或者什么是 invalid email 。我们只关心有一个方法叫做 *valid_email?* 当email 有效时返回 true ，无效时返回 false。所以这里我们只关心方法名和结果，我们暂时不关心这个方法的实现，所以这里我们用一个 *stub* 。

![email-handler](/images/email-handler.png)

我们现在来看一下我们的结构：

![now-we-get](/images/now-we-get.png)

##Mock is brittle.

现在所有的 test 全部 pass，结构清晰，那我们的工作做完了么？还没有，我想大家一定听说过 **Mock is brittle** 吧。

我们再来看一下我们的设计结构，目前他们都是完全独立（Controller, EmailHandler)。再来回想一下我们的 test，我们只有一个 should_receive 的测试。如果这是在我们 EmailHandler 里 handle 方法名称发生改变。那我们的 Test 依然通过，就是为什么说 *Mock is brittle.*。所以对于测试来说，我们还缺少一个 *Integrate Test* 来把这些所有独立的 Object 统一起来，以真实的请求做一次测试。

未完待续...

> 相关链接
