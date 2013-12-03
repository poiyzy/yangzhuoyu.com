---
title: "从测试中找到更好的面向对象设计(二)"
date: 2013-11-02 15:11
tags: rubyconf china, ruby, oo, test
author: roy
---

<aside class="aside-block">
  <blockquote>
    <p>这是在 RubyConf China 2013 上分享的一个 Talk, 很多同学给我了一些 Feedback 而且在现场有一些不足，所以我重新整理后以 blog 的形式再次分享出来和大家共同讨论。</p>
  </blockquote>
</aside>

## Working Flow of the new feature of pragmatic.ly

![working-flow](/images/working-flow.png)

* 在 Pragmatic.ly 项目中当有一个 Comment 被创建后，我们的 Web Server 会告诉 [SendCloud](http://sendcloud.sohu.com) (第三方 Email 服务，类似于 [Mailgun](http://www.mailgun.com)) 给我们的用户发送提醒邮件。
* 当用户回复这封提醒邮件的时候，首先这封邮件会被 SendCloud parse 后，发送一个 post request 到 Pragmatic.ly 设置好的 Callback url.
* Pragmatic.ly 接收到这个 Pull request 后会做一些 verification 和 validation ，然后在 Web Server 上创建一个 Comment records 。

我们 TDD 开发主要是在第三步，当 Web Server 接收到 pull request 后的业务逻辑。那么当一个 pull request 被发送到 Web Server 后，我们需要什么样的业务逻辑呢？

**1. Verification 首先我们需要判定，这个 pull request 是来自与 SendCloud 。**

**2. Validation 当我们知道这个 pull request 来源有效后，我们需要判定这封邮件内容是否有效。**

这里我们将会得到几个数据：

* 首先我们设置了邮件回复地址为 ticket+*PROJECT_UID*+*TICKET_UID*@info.pragmatic.ly ，并且我们还有得到用户的邮件地址。
* 在这里我们需要判断用户的 Email 时候在 Pragmatic.ly 注册过？这个项目是否存在？他是否又权限访问这个项目？这个 Ticket 是否存在？

**3. 当所有的这些验证通过后， WebServer 会以邮件内容创建一个相应项目中的回复**

## Implementation

按照我们的业务逻辑，在这里我们需要一个 callback url 所以在这里我需要一个 EmailRepliesController 并且在这里需要一个 create action 来接收 post request 请求。

```ruby
class EmailRepliesController < ApplicationController
  def create
  end
end
```

接下来完完全全按照业务逻辑一步一步来完成我们的 test，这里我们只写描述而不去考虑具体的 test assertion 和 prepariong data。

```
describe EmailRepliesController do
  describe "POST create" do
    context "when the post request is a valid request" do
      it "returns status 200"

      context "when the project uid is valid" do
        context "when the user uid is valid" do
          context "when the user has the right to access this project" do
            context "when the ticket uid is valid" do
              it "creates the comment for iteration"
            end

            context "when the ticket uid is invalid" do
              it "doesn't create the comment"
            end
          end

          context "when the user has no right to access this project" do
            it "doesn't create the comment"
          end
        end

        context "when the user uid is invalid" do
          it "doesn't create the comment"
        end
      end

      context "when the project uid is invalid" do
        it "doesn't create the comment"
      end
    end

    context "when the project uid is invalid" do
      it "doesn't create the comment"
    end
  end
end
```

在这里光是关于每一个 test example 的描述就写了如此之多。我们很直接的按照业务逻辑来写 specs ，不过在这里我已经没有勇气再继续写测试的 assertions 和 preparing test data 。那么在我们还没有写任何一行实现代码的时候，我们从 tests 中发现了什么呢？

> 相关链接：

> [RubyConf China 2013 演讲视频](http://www.infoq.com/cn/presentations/with-tests-found-a-better-object-oriented-design)

> [从测试中找到更好的面向对象设计(一)](/discovering-better-oo-design-with-test)

> [从测试中找到更好的面向对象设计(三)](/discovering-better-oo-design-with-test-three)

> [从测试中找到更好的面向对象设计(四)](/discovering-better-oo-design-with-test)
